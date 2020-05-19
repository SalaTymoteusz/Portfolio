//
//  StringExtension.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 05/05/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

extension String {
    
    func toDate() -> Date{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return format.date(from: self)!
    }
}
