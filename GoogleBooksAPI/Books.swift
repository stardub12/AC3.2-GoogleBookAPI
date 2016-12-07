//
//  Books.swift
//  GoogleBooksAPI
//
//  Created by Simone on 12/6/16.
//  Copyright © 2016 Simone. All rights reserved.
//

import Foundation

class Books {
    let title: String
    let subtitle: String
    let author: [String]
    let publisher: String
    let publishedDate: String
    let image: String
    init(title: String, subtitle: String, author: [String], publisher: String, publishedDate: String, image: String) {
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.image = image
    }
    
    convenience init?(dict: [String:AnyObject]) {
        guard let volumeInfo = dict["volumeInfo"] as? [String:AnyObject] else { return nil }
        guard let title = volumeInfo["title"] as? String else { return nil }
        guard let subtitle = volumeInfo["subtitle"] as? String else { return nil }
        guard let author = volumeInfo["authors"] as? [String] else { return nil }
        guard let publisher = volumeInfo["publisher"] as? String else { return nil }
        guard let publishedDate = volumeInfo["publishedDate"] as? String else { return nil }
        guard let images = volumeInfo["imageLinks"] as? [String:Any],
        let image = images["smallThumbnail"] as? String else { return nil }
        
        
        self.init(title: title, subtitle: subtitle, author: author, publisher: publisher, publishedDate: publishedDate, image: image) 
    }
    
    static func getBooks(data: Data) -> [Books]? {
        var book = [Books]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let validJSON = json as? [String:AnyObject] else { return nil }
            guard let items = validJSON["items"] as? [[String:AnyObject]] else { return nil }
            
            for dictionary in items {
                if let bookDict = Books(dict: dictionary) {
                    book.append(bookDict)
                }
            }
            
        }
        catch {
           print(error)
        }
        return book
    }
   
}
