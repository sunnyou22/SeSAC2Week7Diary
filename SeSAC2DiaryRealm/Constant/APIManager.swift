//
//  APIManager.swift
//  CodeBaseAssignment
//
//  Created by 방선우 on 2022/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class UnsplashAPIManager {
    
    static let shared = UnsplashAPIManager()
    
    func callRequst(page: Int, query: String, completionHandler: @escaping (JSON) -> ()) {
        
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = EndPoint.photos.plusEndpointSetFullURL(query: query, page: page)
        let header: HTTPHeaders = ["Accept-Version" : "v1"]
        
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                print(url)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestUnsplashImage(json: JSON, compleHandler: @escaping ([URL]) -> ()) {
        
        var imageURLString: [URL] = []
        
        json["results"].arrayValue.forEach { json in
            imageURLString.append(json["urls"]["small"].url!)
        }
        compleHandler(imageURLString)
    }
}

