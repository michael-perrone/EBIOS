//
//  BasicCalls.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/1/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation
import UIKit

struct JWTToken {
    var token: String
}

class BasicCalls {
    
    func register(urlString: String, dataToSend: [String: Any], completion: @escaping (String) -> ()) {
        let url = URL(string: urlString);
        
        var request = URLRequest(url: url!);
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend, options: []) {
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 406 || response.statusCode == 409 || response.statusCode == 405 {
                        completion(String(response.statusCode));
                    }
                }
                guard let data = data else {return}
                 do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                             data, options: [])
                    guard let token = jsonResponse as? [String: Any] else {return};
                    
                    guard let actualToken = token["token"] as? String else {return}
                    completion(actualToken)
                   } catch let parsingError {
                     print(parsingError)
                 }
               
            }
            task.resume()
        }
    }
    
    func login(credentials: [String: Any], completion: @escaping (String, String) -> ()) {
        let url = URL(string: "http://localhost:4000/api/auth/login");
        
        var request = URLRequest(url: url!);
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: credentials, options: []) {
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 400 {
                        completion("", "none");
                        return;
                    }
                guard let data = data else {return}
                 do {
                      let jsonResponse = try JSONSerialization.jsonObject(with:
                                             data, options: [])
                    guard let res = jsonResponse as? [String: Any] else {return};
                    
                    guard let actualToken = res["token"] as? String else {return}
                    
                    guard let loggingIn = res["loggingIn"] as? String else {return}
                    
                    
                    completion(actualToken, loggingIn)
                   } catch let parsingError {
                      print("Error", parsingError)
                    print(response.statusCode)
                 }
                }
            }
            task.resume()
        }
    }
}
    
