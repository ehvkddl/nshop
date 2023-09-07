//
//  SearchEndpoint.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/08.
//

import Foundation

enum SearchEndpoint {
    case shop
    
    var requestURL: String {
        switch self {
        case .shop: return URL.makeEndpointString("search/shop.json")
        }
    }
}


