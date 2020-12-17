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
