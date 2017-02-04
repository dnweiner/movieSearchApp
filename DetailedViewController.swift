//
//  DetailView.swift
//  DannyWeiner-Lab4
//
//  Created by Danny Weiner on 10/4/16.
//  Copyright © 2016 cse438s. All rights reserved.
//

import UIKit
import WebKit

class DetailedViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    var image: UIImage!
    var name: String!
    var year: Int!
    var score: Int!
    var rating: String!
    var id: String!
    
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var metascore: UILabel!
    @IBOutlet weak var rated: UILabel!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBAction func addToFavorites(sender: UIButton) {
        if var favoritesKeyStringArray = favoriteData.arrayForKey("favorites") as? [String] {
            if !favoritesKeyStringArray.contains(name) {
                favoritesKeyStringArray.append(name)
                favoriteData.setObject(favoritesKeyStringArray, forKey: "favorites")
                favoriteData.synchronize()
            }
        } else {
            favoriteData.setObject([name], forKey: "favorites")
            favoriteData.synchronize()
        }
    }
    
    @IBAction func viewIMDb(sender: AnyObject) {
//        let urlString = "http://www.imdb.com/title/" + id
//        let url = NSURL(string: urlString)!
//        webView.loadRequest(NSURLRequest(URL:url))
//        
//        webView.allowsBackForwardNavigationGestures = true
        let IMDbVC = IMDbView(nibName: "IMDbView", bundle: nil)
        
        // IMDbVC
        IMDbVC.name = name
        IMDbVC.id = id
        
        self.navigationController?.pushViewController(IMDbVC, animated: true) 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = name
        //nameField.text = name
        
        posterImage.image = image
        released.text = "Released: " + String(year)
        metascore.text = "Score: " + String(score) + " / 100"
        rated.text = "Rated: " + String(rating)
        // Do any additional setup after loading the view.
       // webView = WKWebView()
        //webView.navigationDelegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}







