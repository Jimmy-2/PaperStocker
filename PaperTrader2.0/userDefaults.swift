//
//  userDefaults.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/28/21.
//

import Foundation

// MARK: - USER DEFAULTS

class userDefaults {
    static let defaults = userDefaults()
    
    init() {
        registerDefaults()
    }
    
    var startingBalance: String!
    
    func isNew() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNew")
    }
    func setNotNew() {
        UserDefaults.standard.set(true, forKey: "isNew")
    }
    
    func registerDefaults() {
        let defaultss = UserDefaults.standard
        defaultss.set("100000", forKey: "ifNil")
        
    }
    
    func handleFirstTime(balanceAmount: String) {
        startingBalance = balanceAmount
        
        //make sure if user has nil in the textfield it doesnt work. also make sure its all numbers...
    }
    
}



