//
//  PostRequest.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/6/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation

class API {
    func post(url: String, headerToSend: String? = nil, dataToSend: [String: Any], completion: @escaping([String:Any]) -> ()) {
        guard let url = URL(string: url) else { print("No URL"); return};
        
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        
        if let value = headerToSend {
                  request.setValue(value, forHTTPHeaderField: "x-auth-token");
              }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend, options: []) {
           
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error = error {
                    print(error)
                    print("there was an error");
                    return
                }
                
                guard let data = data else {return}
                if let response = response as? HTTPURLResponse {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [] )
                    guard var res = jsonResponse as? [String: Any] else {return};
                    res["statusCode"] = response.statusCode;
                    completion(res);
                }
                catch let error {
                    print(error)
                    print("error hit")
                    if response.statusCode == 200 {
                        completion(["statusCode": response.statusCode])
                    }
                    else {
                        print(response.statusCode)
                        completion(["fail": true, "statusCode": response.statusCode]);
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func get(url: String, headerToSend: String? = nil, completion: @escaping ([String: Any]) -> ()) {
        let url = URL(string: url);
        guard let guardedUrl = url else {return}
        var request = URLRequest(url: guardedUrl);
        request.httpMethod = "GET";
        if let value = headerToSend {
            request.setValue(value, forHTTPHeaderField: "x-auth-token");
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return
            }
            if let response = response as? HTTPURLResponse {
                guard let data = data else {print("no data"); return}
                do {
                    let mydata = String(data: data, encoding: .utf8);
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []);
                    guard var res = jsonResponse as? [String: Any] else {return}
                    res["statusCode"] = response.statusCode
                    completion(res);
                }
                catch let parsingEror{
                    print(parsingEror)
                    completion(["fail": true, "statusCode": response.statusCode])
                }
            }
        }
        task.resume()
    }
}
