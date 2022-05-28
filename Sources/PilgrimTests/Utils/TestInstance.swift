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

class TestInstance {
    private static var initCountByName = [String : Int](minimumCapacity: 16)
    public let name: String
    public var dependency: TestInstance?
    public weak var delegate: TestInstance?
    public var requiredDuringInit = false
    public var initCount: Int {
        TestInstance.initCountByName[name] ?? 0
    }

    public init(name: String, dependency: TestInstance? = nil) {
        self.name = name
        self.dependency = dependency

        if let count = TestInstance.initCountByName[name] {
            TestInstance.initCountByName[name] = count + 1
        }
        else {
            TestInstance.initCountByName[name] = 1
        }
    }

    deinit {
        if let count = TestInstance.initCountByName[name] {
            TestInstance.initCountByName[name] = count - 1
        }
    }

    public static func countForName(_ name: String) -> Int {
        TestInstance.initCountByName[name] ?? 0
    }

    public static func clearInitCounts() {
        initCountByName.removeAll(keepingCapacity: true)
    }
}
