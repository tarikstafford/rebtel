//
//  File.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import Foundation

struct CountryAPIService: APIClient{
    var baseUrlComponents: URLComponents
    
    var session: URLSession
    
    var baseUrl: String = "https://restcountries.eu/rest/v2"
}

struct FetchCountry: APIRequest{
    
    // Handle custom error for this fetch
    func localizedErrorDescription(statusCode: ResponseStatus) -> String? {
        return nil
    }

    let isoCode: String
    
    init(isoCode: String) {
        self.isoCode = isoCode
    }
    
    typealias Response = Country
    
    var httpMethod: RequestMethod = .get
    
    var path: String = {
        "/alpha/code/\(isoCode)"
    }

    var headers: [String : String]?
    
    var httpBody: Data?
    
    var queryItems: [URLQueryItem]?
    
    var apiKey: String?
    
}
