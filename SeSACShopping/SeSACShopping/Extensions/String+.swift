//
//  String+.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/09.
//

import Foundation

extension String {
    
    func removeTag() -> String {
        self.components(separatedBy: ["<", "/", "b", ">"]).joined()
    }
    
    func setComma() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let price = Int(self) else {
            print("숫자 변환 실패")
            return self
        }

        guard let result = numberFormatter.string(for: price) else {
            print("콤마 찍기 실패")
            return self
        }
        return result
    }
    
}
