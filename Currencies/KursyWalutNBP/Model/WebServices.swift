//
//  WebServices.swift
//  KursyWalutNBP
//
//  Created by xxx on 29/04/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

class WebServices {
    
    typealias eventResult = (Result<Event, NetworkError>) -> Void
    typealias currencyResult = (Result<[Currency], NetworkError>) -> Void

    
    static func loadData(completion: @escaping eventResult) {
        let urlA = URL(string: "https://api.nbp.pl/api/exchangerates/tables/A")!
        let urlB = URL(string: "https://api.nbp.pl/api/exchangerates/tables/B")!
        JSONParser.fetchData(decodeOption: 1, of: Table.self, from: urlA) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let currenciesA):
                JSONParser.fetchData(decodeOption: 1, of: Table.self, from: urlB) { (result) in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let currenciesB):
                        let event = Event()
                        event.currenciesA = currenciesA
                        event.currenciesB = currenciesB
                        completion(.success(event))
                    }
                }
            }
        }
    }
        
    static func loadDataWithDate(table: String, code: String, fromDate: String, startDate: String, completion: @escaping currencyResult) {
        let url = URL(string: "https://api.nbp.pl/api/exchangerates/rates/\(table)/\(code)/\(fromDate)/\(startDate)")!
        JSONParser.fetchData(decodeOption: 2, of: Currency.self, from: url) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data))
            }
        }
    }
}

