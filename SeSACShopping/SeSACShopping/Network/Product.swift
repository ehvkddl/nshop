//
//  Product.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/08.
//

import Foundation

struct ProductData: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Product]
}

struct Product: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productId: String
    let productType: String
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
}
