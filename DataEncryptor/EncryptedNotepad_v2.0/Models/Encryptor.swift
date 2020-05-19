//
//  Encryptor.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 19/05/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation
import CryptoKit


class Encryptor {
    
    static func encrypt(text: String) {
        let key = SymmetricKey(size: .bits256)
        let message = text.data(using: .utf8)!
        let sealedBox = try! ChaChaPoly.seal(message, using: key)

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "sealedBox")
        defaults.set(sealedBox.combined, forKey: "sealedBox")
        
        let savedKey = key.withUnsafeBytes {Data(Array($0)).base64EncodedString()}
        Services.saveKey(key: savedKey)
    }
    
    static func decrypt() -> String {
        let savedKey = Services.getKey()
            
        if let keyData = Data(base64Encoded: savedKey) {
            let retrievedKey = SymmetricKey(data: keyData)
                
            let defaults = UserDefaults.standard
            let data = defaults.object(forKey: "sealedBox") as? Data

            let sealedBox = try! ChaChaPoly.SealedBox(combined: data!)
            let decryptedMessage = try! ChaChaPoly.open(sealedBox, using: retrievedKey)
        
            return String(data: decryptedMessage, encoding: .utf8)!
        }
        return ""
    }
}
