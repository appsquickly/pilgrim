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

import Foundation
import XCTest
@testable import Pilgrim

/**
 Tests the Assembled property wrapper
 */
class AssembledTests : XCTestCase {

    /**
     Use this style when injecting by type
    */
    @Assembled(assembly: QuestAssembly.self) var knight: Knight

    /**
     * Say we have two classes that implement one protocol. In this case we can inject by key to get the desired one.
     */
    @Assembled(assembly: QuestAssembly.self) var quest: Quest

    @Assembled(key: "damselQuest", assembly: QuestAssembly.self) var anotherQuest: Quest

    func testKnightShouldBeAssembled() throws {
        XCTAssertNotNil(knight)
        XCTAssertEqual("The damsel is a comely fellow named Bruce, the knight is none other than the fearsome Fiona", knight.quest.describe())
    }

    func testQuestInjectionByType() throws {
        XCTAssertNotNil(quest)
    }

    func testQuestInjectionByKey() throws {
        XCTAssertNotNil(anotherQuest)
    }

}
