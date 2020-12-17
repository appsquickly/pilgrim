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

protocol Quest {

    func describe() -> String

}

struct DamselInDistressQuest: Quest {

    func describe() -> String {
        "The damsel is a comely fellow named Bruce, the knight is none other than the fearsome Fiona"
    }

}

struct HolyGrailQuest: Quest {

    func describe() -> String {
        "Must be here somewhere"
    }

}