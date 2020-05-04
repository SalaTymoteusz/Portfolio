//
//  Extension.swift
//  KursyWalutNBP
//
//  Created by xxx on 26/04/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

extension Date {

    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
            formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dayAgo() -> Date {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return weekAgo!
    }
    
    func weekAgo() -> Date {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: self)
        return weekAgo!
    }
    
    func monthAgo() -> Date {
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: self)
        return monthAgo!
    }
    
    func ninetyDaysAgo() -> Date {
        let ninetyDaysAgo = Calendar.current.date(byAdding: .day, value: -90, to: self)
        return ninetyDaysAgo!
    }
}
