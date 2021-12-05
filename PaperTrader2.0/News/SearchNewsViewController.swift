//
//  SearchNewsViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/22/21.
//

import UIKit

class SearchNewsViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    var searchNewsResults = [SearchNewsResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?
    
    struct TableView {
      struct CellIdentifiers {
        static let searchResultCell = "SearchNewsResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
      }
    }
    
    
    override func viewDidLoad() {
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
      performSearch()
    }
    
    // MARK: - Helper Methods
  func newsURL(searchText: String) -> URL {
    
    //let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let encodedText2 = searchText.replacingOccurrences(of: " ", with: ",")
    let urlString = "https://stocknewsapi.com/api/v1?tickers=\(encodedText2)" + "&items=50&token=i0rpdgcnbrcgaimxbclxhztmuu6sk8jm79zcludj&fbclid=IwAR0pguARasu-pDs_Jcy4Wc4fCL_JIXCjRc_JYwsSN57xOSCnhleL3I2LDHA%22"
    let url = URL(string: urlString)
    return url!
  }
    

  func parse(data: Data) -> [SearchNewsResult] {
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(ResultArray.self, from: data)
      return result.data
        
    } catch {
      print("JSON Error: \(error)")
      return []
    }
  }

  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the news search. Please try again.", preferredStyle: .alert)

    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
    

    
}


// MARK: - Search Bar Delegate
extension SearchNewsViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()

    

  }

  func performSearch() {
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      dataTask?.cancel()
      isLoading = true
      tableView.reloadData()

      hasSearched = true
      searchNewsResults = []

      let url = newsURL(searchText: searchBar.text!)
        print(url)
    
      let session = URLSession.shared
      dataTask = session.dataTask(with: url) {data, response, error in
        // 4
        if let error = error as NSError?, error.code == -999 {
          return
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
          if let data = data {
            self.searchNewsResults = self.parse(data: data)
            DispatchQueue.main.async {
              self.isLoading = false
              self.tableView.reloadData()
            }
            return
          }
        } else {
          print("Failure! \(response!)")
        }
        DispatchQueue.main.async {
          self.hasSearched = false
          self.isLoading = false
          self.tableView.reloadData()
          self.showNetworkError()
        }
      }
      dataTask?.resume()
    }
  }

  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}

// MARK: - Table View Delegate
extension SearchNewsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isLoading {
      return 1
    } else if !hasSearched {
      return 0
    } else if searchNewsResults.count == 0 {
      return 1
    } else {
      return searchNewsResults.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if searchNewsResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchNewsResultCell
      let searchNewsResult = searchNewsResults[indexPath.row]
        cell.configure(for: searchNewsResult)
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedNews = searchNewsResults[indexPath.row]
    if let url = URL(string: selectedNews.newsURLText) {
        UIApplication.shared.open(url)
    }
    
  }

  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchNewsResults.count == 0 || isLoading {
      return nil
    } else {
      return indexPath
    }
  }
}
