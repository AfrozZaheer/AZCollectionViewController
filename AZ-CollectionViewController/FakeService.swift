//
//  FakeService.swift
//  AZTableView
//
//  Created by Muhammad Afroz on 2/28/12.
//  Copyright © 2012 AfrozZaheer. All rights reserved.
//


import UIKit

class FakeService {
    
    class func getData (offset: Int = 0, completion: @escaping ((Error?, [String]?) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let fakeData = self.fakeData()
            
            var pageSize = 20
            
            if((offset + pageSize) >= fakeData.count) {
                pageSize = fakeData.count - offset
            }
            
            var results = [String]()
            for i in offset..<(offset + pageSize) {
                results.append(fakeData[i])
            } 
            
            completion(nil, results)
        }
    }
    
    private class func fakeData () -> [String] {
        return ["1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6","1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6","1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6","1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6","1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6","1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6","1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6","1", "2", "3", "4", "5", "6", "2", "1","3","4","5","1","2","6"]
    }
}

