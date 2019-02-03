//
//  ApiClient.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import Foundation

class ApiClient {
    
    func obtainData<T: Codable>(for request: URLRequest, completion: @escaping ((Result<T, Error>) -> Void)) {
        
        URLSession.shared.dataTask(with: request) {
            data, _, error in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(Result.failure(error!))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(Result.success(decoded))
                } catch {
                    completion(Result.failure(error))
                }
            }
        }.resume()
    }
}
