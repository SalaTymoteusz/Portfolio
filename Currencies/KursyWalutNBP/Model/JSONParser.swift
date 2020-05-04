//
//  RateRequest.swift
//  KursyWalutNBP
//
//  Created by xxx on 19/04/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation


class JSONParser {
    
    typealias result<T> = (Result<[T], NetworkError>) -> Void
    
    static func fetchData<T: Decodable>(decodeOption: Int, of type: T.Type, from url: URL, completion: @escaping result<T>) {

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
            
            if statusCode != 200 {
                completion(.failure(.invalidRequestError))
              return
            }

            guard let jsonData = data else {
                let err = NetworkError.dataError
                completion(.failure(err))
                return
            }
            
            do {
                switch decodeOption {
                case 1:
                    let obj: [T] = try JSONDecoder().decode([T].self, from: jsonData)
                    completion(.success(obj))
                default:
                    let obj: T = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success([obj]))
                }
            }catch {
                let err = NetworkError.jsonDecodingError
                completion(.failure(err))
            }
        }
        dataTask.resume()
    }
}
