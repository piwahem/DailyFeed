//
//  PaginationExecutor.swift
//  DailyFeed
//
//  Created by Admin on 12/27/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

class PaginationExecutor<T: Codable> {
    var data: [T]?
    var batchSize: Int = 20
    
    private func getTrunkData() -> [[T]]{
        guard let data = data else {
            return [[T]]()
        }
        
        let trunkData = Array(data).chunked(into: batchSize)
        return trunkData
    }
    
    func onNext(page: Int) -> [T]{
        let trunkData = getTrunkData()
        let size = trunkData.count
        if (page <= size){
            print("trunk onNext page (\(page)) \(trunkData.count)")
            return trunkData[page - 1]
        } else {
            return [T]()
        }
    }
    
    func getDataToPage(page:Int) -> [T]{
        var result = [T]()
        for index in 1...page{
            result.append(contentsOf: onNext(page: index))
        }
        print("trunk getDataToPage \(result.count)")
        return result
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
