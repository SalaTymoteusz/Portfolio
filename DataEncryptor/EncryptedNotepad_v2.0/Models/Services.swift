//
//  Services.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 05/05/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import CryptoKit

class Services {
    
    
    static func saveKey(key: String) {
        KeychainWrapper.standard.set(key, forKey: "key")
    }
    
    static func getKey() -> String {
        return KeychainWrapper.standard.string(forKey: "key") ?? ""
    }

    static func createNewCode(newCode: String) -> Bool {
        return KeychainWrapper.standard.set(newCode, forKey: "code")
    }

   static func getCounterValue() -> Int {
    return KeychainWrapper.standard.integer(forKey: "counter") ?? 0
      }
    
    static func incrementCounterOfWrongAnswers() -> Void {
        var temp = KeychainWrapper.standard.integer(forKey: "counter") ?? 0
        temp += 1
        KeychainWrapper.standard.set(temp, forKey: "counter")
    }
    
    static func checkPassword(code: String) -> Bool {
        return (code == KeychainWrapper.standard.string(forKey: "code")) ? true : false
    }
    
    static func getUserData() -> User {
        let counter: Int = KeychainWrapper.standard.integer(forKey: "counter") ?? 0
        let delay: Int = KeychainWrapper.standard.integer(forKey: "delay") ?? 0
        let code: Bool = KeychainWrapper.standard.bool(forKey: "isCode") ?? false //code
        let allowToCreateNewCode: Bool = false
        
        let user = User(counterOfWrongAnswers: counter, delay: delay, code: code, allowToCreateNewCode: allowToCreateNewCode)
        
        return user
    }
    
    static func saveUserData(user: User) -> Void {
        KeychainWrapper.standard.set(user.counterOfWrongAnswers, forKey: "counter")
        KeychainWrapper.standard.set(user.code, forKey: "isCode")
        KeychainWrapper.standard.set(user.delay, forKey: "delay")
        print("savign")
    }

}

