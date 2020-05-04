//
//  NetworkError.swift
//  KursyWalutNBP
//
//  Created by xxx on 23/04/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case dataError = "No data available"
    case invalidRequestError = "Invalid Request"
    case limitHasBeenExceededError = "Limit of 93 days has been exceeded"
    case unknownError = "Unknown Error"
    case jsonDecodingError = "JSON Decoding Error"
}
