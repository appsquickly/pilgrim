/*
 The MIT License (MIT)

 Copyright (c) 2016-2020 The Contributors

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

private struct Weak<Instance: AnyObject> {
    weak var instance: Instance?

    init(_ instance: Instance) {
        self.instance = instance
    }
}

open class PilgrimAssembly {

    enum Lifecycle {
        case shared
        case weakShared
        case objectGraph
        case unshared
    }

    struct InstanceKey: Hashable, CustomStringConvertible {
        let lifecycle: Lifecycle
        let name: String

        var description: String {
            "\(lifecycle)(\(name))"
        }

        static func ==(lhs: InstanceKey, rhs: InstanceKey) -> Bool {
            (lhs.lifecycle == rhs.lifecycle) && (lhs.name == rhs.name)
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(lifecycle)
            hasher.combine(name)
        }

    }

    var isActivated: Bool;

    private(set) var bindings: Dictionary<String, () -> Any> = [:]
    private(set) var sharedInstances: [String: Any] = [:]
    private(set) var weakSharedInstances: [String: Any] = [:]
    private(set) var scopedInstances: [String: Any] = [:]
    private var instanceStack: [InstanceKey] = []
    private var configureStack: [() -> ()] = []
    private var requestDepth = 0

    required public init() {
        isActivated = true
        makeInstanceInjectable(self)
        makeBindings()
    }

    open func makeBindings() -> Void {

    }

    public final func factoryFor(key: String) -> (() -> Any)? {
        bindings[key]
    }

    public final func shared<T>(name: String = #function, factory: () -> T, configure: ((T) -> Void)? = nil) -> T {
        shared(name: name, factory(), configure: configure)
    }

    public final func shared<T>(name: String = #function, _ factory: @autoclosure () -> T,
                                configure: ((T) -> Void)? = nil) -> T {
        if let instance = sharedInstances[name] as? T {
            return instance
        }

        return inject(
                lifecycle: .shared,
                name: name,
                factory: factory,
                configure: configure
        )
    }

    public final func weakShared<T: AnyObject>(name: String = #function, factory: () -> T,
                                               configure: ((T) -> Void)? = nil) -> T {
        weakShared(name: name, factory(), configure: configure)
    }

    public final func weakShared<T: AnyObject>(name: String = #function, _ factory: @autoclosure () -> T,
                                               configure: ((T) -> Void)? = nil) -> T {
        if let weakInstance = weakSharedInstances[name] as? Weak<T> {
            if let instance = weakInstance.instance {
                return instance
            }
        }

        var instance: T! // Keep instance alive for duration of method
        let weakInstance: Weak<T> = inject(
                lifecycle: .weakShared,
                name: name,
                factory: {
                    instance = factory()
                    return Weak(instance)
                },
                configure: { configure?($0.instance!) }
        )

        return weakInstance.instance!
    }

    public final func unshared<T>(name: String = #function, factory: () -> T, configure: ((T) -> Void)? = nil) -> T {
        unshared(name: name, factory(), configure: configure)
    }

    public final func unshared<T>(name: String = #function, _ factory: @autoclosure () -> T,
                                  configure: ((T) -> Void)? = nil) -> T {
        inject(lifecycle: .unshared,
                name: name,
                factory: factory,
                configure: configure
        )
    }

    public final func objectGraph<T>(name: String = #function, factory: () -> T, configure: ((T) -> Void)? = nil) -> T {
        objectGraph(name: name, factory(), configure: configure)
    }

    public final func objectGraph<T>(name: String = #function, _ factory: @autoclosure () -> T,
                                     configure: ((T) -> Void)? = nil) -> T {
        if let instance = scopedInstances[name] as? T {
            return instance
        }

        return inject(
                lifecycle: .objectGraph,
                name: name,
                factory: factory,
                configure: configure
        )
    }

    public final func makeInjectable(_ factory: @escaping () -> Any, byType: Any.Type) -> Void {
        let key = String(describing: byType).removingOptionalWrapper()
        return bindings[key] = factory
    }

    public final func makeInjectable(_ factory: @escaping () -> Any, byKey: String) -> Void {
        bindings[byKey] = factory
    }

    public final func makeInstanceInjectable(_ instance: AnyObject, byType: Any.Type? = nil) -> Void {
        let typeKeyForInstance = byType != nil ?
                String(describing: byType).removingOptionalWrapper() :
                String(describing: instance).components(separatedBy: ".").last!
        makeInjectable({ () -> Any in self }, byKey: typeKeyForInstance)
    }

    public final func importBindings(_ assemblies: PilgrimAssembly...) -> Void {
        assemblies.forEach { assembly in
            for (key, factory) in assembly.bindings {
                self.makeInjectable(factory, byKey: key)
            }
        }
    }

    private final func inject<T>(lifecycle: Lifecycle, name: String, factory: () -> T, configure: ((T) -> Void)?) -> T {
        let key = InstanceKey(lifecycle: lifecycle, name: name)

        if lifecycle != .unshared && instanceStack.contains(key) {
            fatalError("Circular dependency from one of \(instanceStack) to \(key) in initializer")
        }

        instanceStack.append(key)
        let instance = factory()
        instanceStack.removeLast()
        registerInstance(lifecycle: lifecycle, name: name, instance: instance)

        if let configure = configure {
            configureStack.append({ configure(instance) })
        }

        if instanceStack.count == 0 {
            // A configure call may trigger another instance stack to be generated, so must make a
            // copy of the current configure stack and clear it out for the upcoming requested
            // instances.
            let delayedConfigures = configureStack
            configureStack.removeAll(keepingCapacity: true)

            requestDepth += 1

            for delayedConfigure in delayedConfigures {
                delayedConfigure()
            }

            requestDepth -= 1

            if requestDepth == 0 {
                // This marks the end of an entire instance request tree. Must do final cleanup here.
                // Make sure scoped instances survive until the entire request is complete.
                scopedInstances.removeAll(keepingCapacity: true)
            }
        }

        return instance
    }

    private func registerInstance<T>(lifecycle: Lifecycle, name: String, instance: T) {
        switch lifecycle {
        case .shared:
            sharedInstances[name] = instance
        case .weakShared:
            weakSharedInstances[name] = instance
        case .unshared:
            break
        case .objectGraph:
            scopedInstances[name] = instance
        }
    }


}
