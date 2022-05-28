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

import XCTest
@testable import Pilgrim

final class PilgrimAssemblyTests: XCTestCase {
    var testFactory: TestAssembly!

    override func setUp() {
        super.setUp()

        testFactory = TestAssembly()
        TestInstance.clearInitCounts()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testShared() {
        // Once instance per factory instance (effectively a singleton), useful for NSFormatter instances.
        // If needed by multiple threads make an instance of the factory per thread so that each thread can
        // get its own distinct instance of the object.
        let instanceA1 = testFactory.sharedA1()
        let instanceA2 = testFactory.sharedA2()
        let instanceB1 = testFactory.sharedB1()
        let instanceB2 = testFactory.sharedB2()

        XCTAssertEqual(instanceA1.name, "A1")
        XCTAssertEqual(instanceA2.name, "A2")
        XCTAssertEqual(instanceB1.name, "B1")
        XCTAssertEqual(instanceB2.name, "B2")

        XCTAssertEqual(instanceA1.initCount, 1)
        XCTAssertEqual(instanceA2.initCount, 1)
        XCTAssertEqual(instanceB1.initCount, 1)
        XCTAssertEqual(instanceB2.initCount, 1)

        XCTAssertTrue(instanceA1.dependency! === instanceA2)
        XCTAssertNil(instanceA1.delegate)
        XCTAssertNil(instanceA2.dependency)
        XCTAssertTrue(instanceA2.delegate! === instanceA1)
        XCTAssertNil(instanceB1.dependency)
        XCTAssertNil(instanceB1.delegate)
        XCTAssertTrue(instanceB2.dependency! === instanceB1)
        XCTAssertTrue(instanceB2.delegate! === instanceA1)
    }

    func testUnshared() {
        // New instance every time
        let instanceA1 = testFactory.unsharedA1()
        let instanceA2 = testFactory.unsharedA2()

        XCTAssertEqual(instanceA1.name, "A1")
        XCTAssertEqual(instanceA2.name, "A2")

        XCTAssertEqual(instanceA1.initCount, 1)
        XCTAssertEqual(instanceA2.initCount, 2)

        XCTAssertTrue(instanceA1.dependency! !== instanceA2)
        XCTAssertNil(instanceA1.delegate)
        XCTAssertNil(instanceA2.dependency)
        XCTAssertNil(instanceA2.delegate)
    }

    func testScoped() {
        // Same instance returned only if in the same dependency request, otherwise makes a new instance
        // Useful for creating instances of view controllers that will be assigned as the delegate of a view
        //                                          REQ# A1  A2  A3
        let instanceA1 = testFactory.scopedA1() //  1     Y   Y   Y (one A3 for both A1 and A2 for this dependency fulfilling request)
        let instanceA2 = testFactory.scopedA2() //  2     N   Y   Y (a different A3 for this second instance of A2 since this is a different request)
        let instanceA3 = testFactory.scopedA3() //  3     N   N   Y (a third instance of A3)

        XCTAssertEqual(instanceA1.name, "A1")
        XCTAssertEqual(instanceA2.name, "A2")
        XCTAssertEqual(instanceA3.name, "A3")

        XCTAssertEqual(instanceA1.initCount, 1)
        XCTAssertEqual(instanceA2.initCount, 2)
        XCTAssertEqual(instanceA3.initCount, 3)

        XCTAssertTrue(instanceA1.dependency?.delegate === instanceA1.delegate)
        XCTAssertTrue(instanceA1.delegate !== instanceA2.delegate)
    }

    func testWeakShared() {
        // Same as shared, but if no other objects retain the instance then it will be
        // released and free up memory (the factory doesn't retain it)
        var instanceA1: TestInstance? = testFactory.weakSharedA1()

        XCTAssertEqual(instanceA1?.name, "A1")
        XCTAssertEqual(instanceA1?.initCount, 1)

        instanceA1 = nil
        XCTAssertEqual(TestInstance.countForName("A1"), 0)

        instanceA1 = testFactory.weakSharedA1()
        XCTAssertEqual(instanceA1?.name, "A1")
        XCTAssertEqual(instanceA1?.initCount, 1)
    }

}

