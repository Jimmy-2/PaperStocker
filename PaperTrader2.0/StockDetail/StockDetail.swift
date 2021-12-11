//
//  StockDetail.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/21/21.
//

class StockDetail: Codable {
    /*
    var symbol: String? = ""
    var name: String? = ""
    var open: String? = ""
    var high: String? = ""
    var low: String? = ""
    var close: String? = ""
    var volume: String? = ""
    var previous_close: String? = ""
    var change: String? = ""
    var percent_change: String? = ""
 
 */
    var symbol: String? = ""
    var name: String? = ""
    var price: Double? = 0.0
    var changesPercentage: Double? = 0.0
    var change: Double? = 0.0
    var dayLow: Double? = 0.0
    var dayHigh: Double? = 0.0
    var yearHigh: Double? = 0.0
    var yearLow: Double? = 0.0
    var marketCap: Double? = 0.0
    var priceAvg50: Double? = 0.0
    var priceAvg200: Double? = 0.0
    var volume: Double? = 0.0
    var avgVolume: Double? = 0.0
    var open: Double? = 0.0
    var previousClose: Double? = 0.0
    
    
    
    
    
    
}
