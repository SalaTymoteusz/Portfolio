//
//  Currency.swift
//  KursyWalutNBP
//
//  Created by xxx on 12/01/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation


struct Table: Decodable {
    let table: String
    let no: String
    let effectiveDate: String
    let rates: [Rate]
}

struct Rate: Decodable {
    let currency: String
    let code: String
    let mid: Double
}

struct Currency: Decodable {
    let table: String
    let currency: String
    let code: String
    let rates: [IndividualRate]
    
    var min: Double {
         return rates.min(by: {$0.mid < $1.mid})!.mid
    }
    
    var max: Double {
        return rates.max(by: {$0.mid < $1.mid})!.mid
    }
    
    var changeInPercent: Double {
        return (rates.last!.mid - rates.first!.mid) / rates.first!.mid
    }
}

struct IndividualRate: Decodable {
    let no: String
    let effectiveDate: String
    let mid: Double
}






