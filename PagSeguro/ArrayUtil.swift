//
//  ArrayUtil.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import Foundation

extension Array {
    
    func itemFor(index: IndexPath) -> Element? {
        if index.row < self.count {
            return self[index.row]
        }
        return nil
    }
    
    func itemFor(index: Int) -> Element? {
        if index < self.count {
            return self[index]
        }
        return nil
    }
    
}

