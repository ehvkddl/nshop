//
//  WishList.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/10.
//

import Foundation
import RealmSwift

class WishList: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    
    convenience init(
        title: String,
        link: String,
        image: String,
        lprice: String,
        mallName: String
    ) {
        self.init()
        
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
    }
    
}
