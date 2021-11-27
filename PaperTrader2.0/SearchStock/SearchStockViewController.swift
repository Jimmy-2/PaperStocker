//
//  ViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/19/21.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar! = UISearchBar(frame: .zero)
    @IBOutlet var tableView: UITableView!

    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?

    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStockDetail" {
            let detailViewController = segue.destination as! StockDetailViewController
            let indexPath = sender as! IndexPath
            let searchResultss = searchResults[indexPath.row]
            detailViewController.searchResult = searchResultss
        }
    }
    
    // MARK: - Helper Methods
    func stocksURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://financialmodelingprep.com/api/v3/search?query=%@"+"&limit=100&exchange=NASDAQ,NYSE&apikey=d6d32343ce4ed4d79945c94ca7c9c383", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf:url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([SearchResult].self, from: data)
            print(result)
            return result
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func showNetworkError() {
      let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the search results. Please try again.", preferredStyle: .alert)

      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }

}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
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
            searchResults = []

            let url = stocksURL(searchText: searchBar.text!)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url) {data, response, error in
          
                if let error = error as NSError?, error.code == -999 {
                    return
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
              
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
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowStockDetail", sender: indexPath)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}
