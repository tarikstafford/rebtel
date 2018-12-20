//
//  ErrorHandler.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import Foundation

enum APIErrorHandler<T: APIRequest>: Error {
    case invalidUrl
    case client
    case decoding(reason: String?)
    case network(client: T, statusCode: ResponseStatus)
    case unreachable
    case noData
}

extension APIErrorHandler: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .client:
            return NSLocalizedString("Client Error", comment: "Something went wrong with the client.")
        case .invalidUrl:
            return NSLocalizedString("Invalid URL", comment: "Please update the URL")
        case .decoding(let reason):
            return NSLocalizedString("Decoding Error", comment: "\(reason)")
        case .network(let request, let status):
            if let requestErrorDescription = request.localizedErrorDescription(statusCode: status) {
                return requestErrorDescription
            }
        case .unreachable:
            return NSLocalizedString("Unreachable", comment: "Please check your network connection.")
        case .noData:
            return NSLocalizedString("No Data", comment: "There was no data for this source.")
        default:
            return nil
        }
        
        return nil
    }
}
