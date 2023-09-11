//
//  NetworkError.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/11.
//

import Foundation

enum NetworkError: Error {
    case failedComponents
    case invalidStatusCode
    case emptyData
    case failedDecoding
    
    var description: String {
        switch self {
        case .failedComponents: return "urlComponents 생성에 실패했습니다."
        case .invalidStatusCode: return "status code가 200~500을 벗어났습니다."
        case .emptyData: return "data가 비어있습니다."
        case .failedDecoding: return "decoding을 실패했습니다."
        }
    }
}
