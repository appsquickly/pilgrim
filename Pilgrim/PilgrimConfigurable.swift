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

public protocol PilgrimConfigurable {

    func configure(assembly: PilgrimAssembly)

}

extension PilgrimConfigurable {

    func configure(assembly: PilgrimAssembly) {}

}
