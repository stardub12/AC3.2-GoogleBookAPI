//
//  ViewController.swift
//  GoogleBooksAPI
//
//  Created by Simone on 12/6/16.
//  Copyright © 2016 Simone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var bookDetails: Books?
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLabels() {
        titleLabel.text = bookDetails?.title
        subtitleLabel.text = bookDetails?.subtitle
        var authorText = ""
        for author in (bookDetails?.author)! {
           authorText += author
        }
        authorLabel.text = authorText
        //Get image
        APIRequestManager.sharedManager.getData(APIEndpoint: (bookDetails?.image)!) { (data) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    self.bookImage.image = validImage
                    self.bookImage.setNeedsLayout()
                }
            }
        }

    }


}

