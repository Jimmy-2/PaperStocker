//
//  NewsSearchResult.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/25/21.
//

/*
struct SearchNewsResult: Codable {
  
    var news_url: String? = ""
    var image_url: String? = ""
    var title: String? = ""
    var text: String? = ""
    var source_name: String? = ""
    var date: String? = ""
    var sentiment: String? = ""
    var type: String? = ""
    var tickers: String? = ""

  

 



}
*/
class ResultArray: Codable {
    var data = [SearchNewsResult]()
}

struct SearchNewsResult: Codable {
    
    
    var newsURLText = ""
    var imageSmall = ""
    var titleText =  ""
    var newsBodyText = ""
    var sourceText = ""
    var dateText = ""
    var symbol = ""
    //var tickers: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case imageSmall = "image"
        case newsURLText = "url"
        case titleText = "title"
        case newsBodyText = "text"
        case sourceText = "site"
        case dateText = "publishedDate"
        case symbol = "symbol"
        
       
    }
    



  

}



