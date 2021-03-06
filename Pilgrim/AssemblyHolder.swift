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

public class AssemblyHolder<T : PilgrimAssembly> {

    public static var defaultAssemblyType: PilgrimAssembly.Type {
        get {
            AssemblyHolderInternal.defaultAssemblyType
        }
        set {
            AssemblyHolderInternal.defaultAssemblyType = newValue
        }

    }

    public static var instances: Dictionary<String, PilgrimAssembly> {
        AssemblyHolderInternal.instances
    }

    public static func shared(_ assembly: T.Type) -> T {
        AssemblyHolderInternal.shared(assembly) as! T
    }
}

class AssemblyHolderInternal {

    /**

     Set the default factory to be used by the Assembled property wrapper, when the application is bootstrapped.
     */
    public static var defaultAssemblyType: PilgrimAssembly.Type = PilgrimAssembly.self;

    public static var instances: Dictionary<String, PilgrimAssembly> = [:]

    /**
     Returns a shared assembly matching the specified type. 
     - Parameter type:
     - Returns:
     */
    public static func shared(_ assembly: PilgrimAssembly.Type = defaultAssemblyType) -> PilgrimAssembly {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        let key = String(describing: assembly)
        if instances[key] == nil {
            instances[key] = (assembly).init()
        }
        return instances[key]!;
    }
}
