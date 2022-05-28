////////////////////////////////////////////////////////////////////////////////
//
//  SYMBIOSE
//  Copyright 2020 Symbiose Inc
//  All Rights Reserved.
//
//  NOTICE: This software is proprietary information.
//  Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation
import Pilgrim

class AnotherAssembly : PilgrimAssembly {

    func anotherQuest() -> Quest {
        shared(DamselInDistressQuest())
    }

}
