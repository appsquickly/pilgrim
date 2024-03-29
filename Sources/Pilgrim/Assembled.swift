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

@propertyWrapper public struct Assembled<Component> {

    var key: String
    var component: Component?

    public init(key: String? = nil, assembly: PilgrimAssembly.Type = AssemblyHolder.defaultAssemblyType) {
        let componentKey = String(describing: Component.self).removingOptionalWrapper()
        self.key = key != nil ? key! : componentKey
        let assembly = AssemblyHolder.shared(assembly)
        if (assembly.isActivated) {
            if let function = assembly.factoryFor(key: self.key) {
                let component = function() as! Component
                self.component = component
            } else {
                let message = "PILGRIM ERROR : There's no component defined for key: \(self.key).\n"
                    + "Did you declare this component as injectable under `importBindings`?"
                fatalError(message)
            }

        } else {
            component = nil
        }
    }

    public init(key: String) {
        self.init(key: key, assembly: AssemblyHolderInternal.defaultAssemblyType)
    }

    public init(assembly: PilgrimAssembly.Type) {
        self.init(key: nil, assembly: assembly)
    }

    public var wrappedValue: Component {
        get {
            component!
        }
        mutating set {
            component = newValue
        }
    }

}




