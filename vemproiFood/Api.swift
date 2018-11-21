//
//  network.swift
//  vemproiFood
//
//  Created by Adriano Paladini on 21/11/18.
//  Copyright © 2018 Adriano Paladini. All rights reserved.
//

import UIKit

class API {
    let domain = "http://api.openweathermap.org/"
    let pathURI = "data/2.5/"

    // LOGIN //
    func weather(debug: Bool = false,
               completion: @escaping (weather?) -> Void) {

        doApiCall(method: "GET",
                  action: "forecast",
                  params: ["q": "Campinas,br", "appid": "a67ef818d8c8e3945f7eee5f541c47e5"],
                  body: nil, debug: debug) { res in
                    if res == nil { completion(nil); return }
                    if let tmp = try? JSONDecoder().decode(weather.self, from: res!) {
                        completion(tmp)
                    } else {
                        completion(nil)
                    }
        }
    }
    // LOGIN //

}


extension API {

    func urlWithParams(url: String, params: [String: String]) -> URL {
        var urlObj = URLComponents(string: url)!
        urlObj.queryItems = []
        for (key, value) in params {
            let item = URLQueryItem(name: key, value: value)
            urlObj.queryItems?.append(item)
        }
        return urlObj.url!
    }

    // REST //
    func doApiCall(method: String,
                   action: String,
                   params: [String: String],
                   body: Data?,
                   debug: Bool = false,
                   completion: @escaping (Data?) -> Void) {
        let pathURI = action.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = urlWithParams(url: "\(domain)\(pathURI ?? "")", params: params)
        if debug {
            print("############################ START #############################\nURL: \(url.absoluteString)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        request.timeoutInterval = 5

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, err in
            if err == nil {
                if debug {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    print(responseJSON ?? "")
                    print("############################ END #############################")
                }
                if let response = response as? HTTPURLResponse {
                    if debug {
                        print("RESPONSE STATUS: \(response.statusCode)")
                    }
                    switch response.statusCode {
                    case 200..<300:
                        DispatchQueue.main.async { completion(data) }
                    default:
                        DispatchQueue.main.async { completion(nil) }
                    }
                } else {
                    DispatchQueue.main.async { completion(nil) }
                }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    // REST //

}
