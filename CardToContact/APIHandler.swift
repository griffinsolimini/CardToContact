//
//  APIHandler.swift
//  CardToContact
//
//  Created by Griffin Solimini on 8/8/17.
//  Copyright © 2017 Griffin Solimini. All rights reserved.
//

import Foundation

class APIHandler {
    
    func callAPI(image: Data, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let encoding = image.base64EncodedString()
        
        let headers = [
            "content-type": "application/json"
        ]
        
        guard let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyA5PFVO7HYeubgwALO0-Z9rzVzl3iQMc8k") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let json: [String: Any] = ["requests":[["image": ["content": encoding],"features": ["type": "DOCUMENT_TEXT_DETECTION"]]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: completion).resume()
        
        print("request sent to server")
    }
}
