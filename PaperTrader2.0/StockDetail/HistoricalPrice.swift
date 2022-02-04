//
//  HistoricalPrice.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 2/3/22.
//

struct HistoricalPrice: Codable {
  

    var date : String? = ""
    var open : Double? = 0.0
    var low : Double? = 0.0
    var high : Double? = 0.0
    var close : Double? = 0.0
    var volume : Double? = 0.0

}
