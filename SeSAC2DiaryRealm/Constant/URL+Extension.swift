//
//  URL+Extension.swift
//  CodeBaseAssignment
//
//  Created by 방선우 on 2022/08/21.
//

import Foundation

extension URL {
    static let baseURL = "https://api.unsplash.com/"
    
    static func makeEndPoint(_ endpoint: String) -> String { // endpoint끝에 붙는 요소들
        return baseURL + endpoint
    }
}

enum EndPoint {
    case photos
    
    func plusEndpointSetFullURL(query: String, page: Int) -> String {
        switch self {
        case .photos:
            return URL.makeEndPoint("search/photos?page=\(page)&query=\(query)&client_id=\(APIKEY.UNSPLASH)")
        }
    }
}
