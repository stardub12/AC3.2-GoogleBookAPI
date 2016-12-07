//
//  GoogleTableViewController.swift
//  GoogleBooksAPI
//
//  Created by Simone on 12/6/16.
//  Copyright © 2016 Simone. All rights reserved.
//

import UIKit

class GoogleTableViewController: UITableViewController, UISearchBarDelegate {
    var books = [Books]()
    var searchTerm = "banana"
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    internal func loadData() {
        APIRequestManager.sharedManager.getData(APIEndpoint: "https://www.googleapis.com/books/v1/volumes?q=\(searchTerm)") { (data) in
            if data != nil {
                if let newBooks = Books.getBooks(data: data!) {
                    print("Got \(newBooks.count) book(s)!")
                    self.books = newBooks
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.title = self.searchTerm
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        
        var author = ""
        let info = books[indexPath.row]
        for name in info.author {
            author += name
        }
        cell.textLabel?.text = info.title
        cell.detailTextLabel?.text = author
        
        //Get image with API call
        APIRequestManager.sharedManager.getData(APIEndpoint: info.image) { (data) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.imageView?.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? UITableViewCell {
            if segue.identifier == "bookDetailSegue" {
                let details = segue.destination as! ViewController
                let cellPath = self.tableView.indexPath(for: selectedCell)
                let selectedBook = books[(cellPath?.row)!]
                //viewController view is equal to cell index path
                details.bookDetails = selectedBook
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText.replacingOccurrences(of: " ", with: "%20")
        loadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let allTextFieldText = searchBar.text
    self.searchTerm = (allTextFieldText?.replacingOccurrences(of: " ", with: "%20"))!
        loadData()
    }
}

