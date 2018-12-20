//
//  File.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import Foundation

class CountryAPIService: APIClient{
    
    static let countryAPIServiceShared = CountryAPIService()
    
    private init() {}
    
    lazy var baseUrlComponents: URLComponents = {
        var comp = URLComponents()
        comp.host = host
        comp.scheme = scheme
        comp.path = path
        return comp
    }()
    
    var session = URLSession.shared
    
    let host: String = "restcountries.eu"
    let path: String = "/rest/v2/"
    let scheme: String = "https"
}

struct FetchCountry: APIRequest{
    
    typealias Response = Country
    
    let isoCode: String
    
    init(isoCode: String) {
        self.isoCode = isoCode
    }

    var httpMethod: RequestMethod = .get
    
    var path: String {
        return "alpha/\(isoCode)"
    }

    var headers: [String : String]?
    
    var httpBody: Data?
    
    var queryItems: [URLQueryItem]?
    
    var apiKey: String?
    
    // Handle custom error for this fetch
    func localizedErrorDescription(statusCode: ResponseStatus) -> String? {
        return nil
    }
}
