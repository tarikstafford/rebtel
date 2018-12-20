//
//  APIClient.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import Foundation

protocol APIClient {
    var baseUrlComponents: URLComponents { get }
    
    var session: URLSession { get }
    
    func buildRequest<T: APIRequest>(for request: T) -> URLRequest?
    
    func buildUrl<T: APIRequest>(for request: T) -> URL?
    
    func send<T: APIRequest>( _ request: T, completion: @escaping (ResultType<T>) -> Void) -> URLSessionDataTask?
}

extension APIClient {
    
    // Construct the URL then the API Request
    func buildRequest<T: APIRequest>(for request: T) -> URLRequest? {
        guard let url = buildUrl(for: request) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.httpBody
        
        request.headers?.forEach({ urlRequest.setValue($1, forHTTPHeaderField: $0) })
        
        return urlRequest
    }
    
    func buildUrl<T: APIRequest>(for request: T) -> URL? {
        guard   let baseUrl = baseUrlComponents.url,
                var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
            else {
                return nil
        }
        
        components.path = baseUrlComponents.path.appending(request.path)
        components.queryItems = request.queryItems
        
        return components.url
    }
    
    func send<T: APIRequest>(_ request: T, completion: @escaping (ResultType<T>) -> Void) -> URLSessionDataTask? {
        
        let errorCallback: (APIErrorHandler<T>) -> Void = {
            completion(.failure(error: $0))
        }
        
        guard let urlRequest = buildRequest(for: request) else {
            errorCallback(APIErrorHandler.client)
            return nil
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            print(response)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            let statusCode = ResponseStatus.init(code: httpResponse.statusCode)
            
            guard statusCode == .ok else {
                errorCallback(APIErrorHandler.network(client: request, statusCode: statusCode))
                return
            }
            
            guard let data = data else {
                errorCallback(APIErrorHandler.noData)
                return
            }
            
            do {
                completion(.success(result: try  JSONDecoder().decode(T.Response.self, from: data)))
            } catch let error {
                errorCallback(APIErrorHandler.decoding(reason: error.localizedDescription))
            }
        }
        
        defer { task.resume() }
        
        return task
    }
}
