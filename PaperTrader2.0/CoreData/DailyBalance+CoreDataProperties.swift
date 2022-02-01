//
//  DailyBalance+CoreDataProperties.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 1/23/22.
//
//

import Foundation
import CoreData


extension DailyBalance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyBalance> {
        return NSFetchRequest<DailyBalance>(entityName: "DailyBalance")
    }

    @NSManaged public var balanceAmount: String?
    @NSManaged public var date: Date?
    @NSManaged public var dateString: String?

}

extension DailyBalance : Identifiable {

}
