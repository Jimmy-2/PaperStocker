//
//  StockRecords+CoreDataProperties.swift
//  
//
//  Created by Jimmy  on 2/9/22.
//
//

import Foundation
import CoreData


extension StockRecords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockRecords> {
        return NSFetchRequest<StockRecords>(entityName: "StockRecords")
    }

    @NSManaged public var stockSymbol: String?
    @NSManaged public var totalProfits: Double
    @NSManaged public var totalProfitsPercentage: String?

}
