//
//  NetworkEnums.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import Foundation

enum  RequestMethod: String {
    case get, post
}

enum ResponseStatus: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServer = 500
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case unhandled = -1
    
    init(code: Int) {
        self = ResponseStatus(rawValue: code) ?? .unhandled
    }
}
