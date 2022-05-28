/*
 The MIT License (MIT)

 Copyright (c) 2016-2020 The Contributors

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all`
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

@testable import Pilgrim

class TestAssembly: PilgrimAssembly {
    public func sharedA1() -> TestInstance {
        shared(TestInstance(name: "A1", dependency: sharedA2()))
    }

    public func sharedA2() -> TestInstance {
        shared(TestInstance(name: "A2")) { (instance) in
            instance.delegate = self.sharedA1()
        }
    }

    public func sharedB1() -> TestInstance {
        shared(
                factory: { () -> TestInstance in
                    // Only use this form if you need to configure an instance that will be passed into
                    // another objects initializer. The configure block only gets called after all init
                    // methods have been called and is useful for setting properties that would cause
                    // dependency cycles like delegates.
                    let instance = TestInstance(name: "B1")
                    instance.requiredDuringInit = true
                    return instance
                }
        )
    }

    public func sharedB2() -> TestInstance {
        shared(
                factory: { () -> TestInstance in
                    // Only use this form if you need to configure an instance that will be passed into
                    // another object's initializer. The configure block only gets called after all init
                    // methods have been called and is useful for setting properties that would cause
                    // dependency cycles like delegates.
                    precondition(sharedB1().requiredDuringInit, "Fake a situation where bad program behavior would occur if property is not set before now")
                    let instance = TestInstance(name: "B2", dependency: sharedB1())
                    return instance
                },
                configure: { (instance) in
                    instance.delegate = self.sharedA1()
                }
        )
    }

    public func unsharedA1() -> TestInstance {
        unshared(TestInstance(name: "A1", dependency: unsharedA2()))
    }

    public func unsharedA2() -> TestInstance {
        unshared(TestInstance(name: "A2"))
    }

    public func scopedA1() -> TestInstance {
        objectGraph(TestInstance(name: "A1", dependency: scopedA2())) { (instance) in
            instance.delegate = self.scopedA3()
        }
    }

    public func scopedA2() -> TestInstance {
        objectGraph(TestInstance(name: "A2")) { (instance) in
            instance.dependency = self.scopedA3() // A bit of a hack to keep A3 alive long enough to assert with
            instance.delegate = self.scopedA3()
        }
    }

    public func scopedA3() -> TestInstance {
        objectGraph(TestInstance(name: "A3"))
    }

    public func weakSharedA1() -> TestInstance {
        weakShared(TestInstance(name: "A1"))
    }

}
