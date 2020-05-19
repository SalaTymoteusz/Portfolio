//
//  DateExtension.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 05/05/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

extension Date {

    func toString(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    // Check if user have to wait to enter password
    func compareDates() -> Bool {
        return (Date() >= self) ? true : false
    }
    
//    func dayAgo() -> Date {
//        let weekAgo = Calendar.current.date(byAdding: .day, value: -1, to: self)
//        return weekAgo!
//    }
}
