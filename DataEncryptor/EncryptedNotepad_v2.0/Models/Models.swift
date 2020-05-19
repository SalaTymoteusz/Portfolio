//
//  Models.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 05/05/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

struct PassCodeKeyData {
    var passCodeKeyData : [PassCodeKeyStruct] =
    [PassCodeKeyStruct(status: 0, title: "1", value: "1"),
    PassCodeKeyStruct(status: 0, title: "2", value: "2"),
    PassCodeKeyStruct(status: 0, title: "3", value: "3"),
    PassCodeKeyStruct(status: 0, title: "4", value: "4"),
    PassCodeKeyStruct(status: 0, title: "5", value: "5"),
    PassCodeKeyStruct(status: 0, title: "6", value: "6"),
    PassCodeKeyStruct(status: 0, title: "7", value: "7"),
    PassCodeKeyStruct(status: 0, title: "8", value: "8"),
    PassCodeKeyStruct(status: 0, title: "9", value: "9"),
    PassCodeKeyStruct(status: 1, title: "Clear", value: ""),
    PassCodeKeyStruct(status: 0, title: "0", value: "0"),
    PassCodeKeyStruct(status: 2, title: "Edit", value: "")]
}

struct PassCodeKeyStruct {
    var status: Int
    var title: String
    var value: String
}

struct User {
    var counterOfWrongAnswers = 8
    var delay = 0
    var code  = false
    var allowToCreateNewCode = false
    
    mutating func incrementCounter() -> Bool {
        counterOfWrongAnswers += 1
        if counterOfWrongAnswers % 5 == 0 {
            print(counterOfWrongAnswers % 5)
            addDelay(time: 10)
            return true
        }
        return false
    }
    
    mutating func addDelay(time: Int) {
        delay = delay + time
    }
}
