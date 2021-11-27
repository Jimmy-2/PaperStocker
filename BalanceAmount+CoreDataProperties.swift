//
//  BalanceAmount+CoreDataProperties.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/26/21.
//
//

import Foundation
import CoreData


extension BalanceAmount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BalanceAmount> {
        return NSFetchRequest<BalanceAmount>(entityName: "BalanceAmount")
    }

    @NSManaged public var amount: String?

}

extension BalanceAmount : Identifiable {

}
