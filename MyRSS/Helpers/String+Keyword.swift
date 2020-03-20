//
//  String+Keyword.swift
//  MyRSS
//
//  Created by 서재훈 on 2020/03/20.
//  Copyright © 2020 서재훈. All rights reserved.
//

import Foundation

extension String {
    func keyword() -> [String] {
        var keywords = [String]()
        var hashMap = [String:Int]()
        
        let words = self.components(separatedBy: " ")
        for word in words {
            if word.count < 2 { continue }
            if hashMap[word] != nil {
                hashMap[word]! += 1
            } else {
                hashMap[word] = 1
            }
        }
        
        let sortByKey = hashMap.sorted { $0.0 < $1.0 }
        let sortByValue = sortByKey.sorted { $0.1 > $1.1 }
        
        if sortByValue.count >= 3 {
            for i in 0...2 {
                keywords.append(sortByValue[i].key)
            }
        } else {
            for (key, _) in sortByValue {
                keywords.append(key)
            }
        }
        
        return keywords
    }
}
