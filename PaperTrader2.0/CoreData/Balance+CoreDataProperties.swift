//
//  Balance+CoreDataProperties.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/25/21.
//  Bad naming, should actually be called portfolio.
//

import Foundation
import CoreData


extension Balance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Balance> {
        return NSFetchRequest<Balance>(entityName: "Balance")
    }

    @NSManaged public var stock: String?
    @NSManaged public var quantity: String?
    @NSManaged public var price: String?
    @NSManaged public var value: String?
    @NSManaged public var stockName: String?
    @NSManaged public var avgPrice: String?

}

extension Balance : Identifiable {

}
