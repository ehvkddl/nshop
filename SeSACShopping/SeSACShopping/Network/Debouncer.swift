//
//  Debouncer.swift
//  SeSACShopping
//
//  Created by do hee kim on 2024/02/17.
//

import Foundation

class Debouncer {
    
    private var workItem: DispatchWorkItem?
    private let seconds: Int
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    func run(_ closure: @escaping () -> ()) {
        self.workItem?.cancel()
        
        let newWork = DispatchWorkItem(block: closure)
        workItem = newWork
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: newWork)
    }
    
}
