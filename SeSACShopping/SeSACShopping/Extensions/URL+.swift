//
//  URL+.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/08.
//

import Foundation

extension URL {
    
    static let baseURL = "https://openapi.naver.com/v1/"
    
    static func makeEndpointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
    
}
