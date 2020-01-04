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
    
    var page: Int = 0
    var dataOfPage: [T]?
    var currentData: [T]?
    
    func getTrunkData() -> [[T]]{
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
    
    func getDataOfPage(page: Int) -> [T] {
        var result = [T]()
        result.append(contentsOf: onNext(page: page))
        print("trunk getDataOfPage \(result.count)")
        return result
    }
    
    func getDataPagination() -> [T] {
        if (isLastPage()){
            return [T]()
        }
        return getDataOfPage(page: page)
    }
    
    func doLoadPage(){
        if (!isLastPage()){
            page+=1
        }
    }
    
    func isLastPage() -> Bool{
        let trunkData = getTrunkData()
        return trunkData.count == page
    }
    
    func getLastPage() -> Int {
        return getTrunkData().count
    }
    
    func getFirstPage() -> Int {
        return getTrunkData().count == 0 ? 0 : 1
    }
    
    func getCurrentPage() -> Int{
        return page
    }
    
    func resetPage(){
        page = 0
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
