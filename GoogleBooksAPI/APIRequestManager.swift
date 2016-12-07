//
//  APIRequestManager.swift
//  GoogleBooksAPI
//
//  Created by Simone on 12/6/16.
//  Copyright © 2016 Simone. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let sharedManager = APIRequestManager()
    private init () {}
    
    func getData(APIEndpoint: String, callback: @escaping (Data?) -> Void) {
        guard let customURL = URL(string: APIEndpoint) else { return }
        let session: URLSession = URLSession(configuration: .default)
        session.dataTask(with: customURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
            print("Encoutered networking error: \(error)")
        }
        guard let validData = data else { return }
        callback(validData)
    }.resume()
    }
}
