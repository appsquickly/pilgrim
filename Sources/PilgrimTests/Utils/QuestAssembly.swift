import Foundation
@testable import Pilgrim

class QuestAssembly: PilgrimAssembly {

    let other = AssemblyHolder<AnotherAssembly>.shared(AnotherAssembly.self)

    override func makeBindings() {
        super.makeBindings()
        makeInjectable(knight, byType: Knight.self)
        makeInjectable(holyGrailQuest, byType: Quest.self)
        makeInjectable(holyGrailQuest, byKey: "damselQuest")
        makeInjectable(castle, byType: Castle<String>.self)
    }

    func knight() -> Knight {
        objectGraph(Knight(quest: other.anotherQuest()))
    }

    /**
     HolyGrailQuest is a struct that conforms to the Quest protocol.
     */
    func holyGrailQuest() -> Quest {
        shared(HolyGrailQuest())
    }

    /**
     HolyGrailQuest is a struct that conforms to the Quest protocol.
     */
    func damselInDistressQuest() -> Quest {
        shared(DamselInDistressQuest())
    }

    func castle() -> Castle<String> {
        shared {
            Castle(name: "Tintagel", foo: "hello")
        }
    }
}
