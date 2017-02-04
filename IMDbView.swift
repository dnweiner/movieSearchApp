//
//  IMDbView.swift
//  DannyWeiner-Lab4
//
//  Created by Danny Weiner on 10/18/16.
//  Copyright © 2016 cse438s. All rights reserved.
//

import UIKit
import WebKit

class IMDbView: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var id: String!
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = name
        let urlString = "http://www.imdb.com/title/" + id
        let url = NSURL(string: urlString)!
        webView.loadRequest(NSURLRequest(URL:url))
        
        webView.allowsBackForwardNavigationGestures = true

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
