////////////////////////////////////////////////////////////////////////////////
//
//  SYMBIOSE
//  Copyright 2022 Symbiose Inc
//  All Rights Reserved.
//
//  NOTICE: This software is proprietary information.
//  Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation

class Castle<T> {

    private(set) var name: String
    private(set) var foo: T

    init(name: String, foo: T) {
        self.name = name
        self.foo = foo
    }
}
