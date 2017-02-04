//
//  SearchViewController.swift
//  DannyWeiner-Lab4
//
//  Created by Danny Weiner on 10/2/16.
//  Copyright © 2016 cse438s. All rights reserved.
//

import UIKit
import Foundation

let favoriteData = NSUserDefaults.standardUserDefaults()
//var favoritesKeyStringArray = [String]()

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var theData: [Movie] = []
    var theImageCache: [UIImage] = []
    var tableView: UITableView!
    
    
    //let favoriteData = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searched:String = ""
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func sortByYear(sender: UIBarButtonItem) {
        theData.sortInPlace({$0.year < $1.year})
        collection.reloadData()
    }
    
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Movies"
        self.searchBar.delegate = self
        self.collection.dataSource = self
        self.collection.delegate = self
        self.collection.backgroundColor = UIColor.clearColor()
        self.collection.allowsSelection = true
        //favoriteData.removeObjectForKey("favorites")
       navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.enabled = false
    }

    private func getJSON(url: String) -> JSON {
        
        if let nsurl = NSURL(string: url){
            if let data = NSData(contentsOfURL: nsurl) {
                let json = JSON(data: data)
                return json
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    
    func fetchData(url: String) {
        
        let jsonData = getJSON(url)
        
        //print(jsonData)
        //print(jsonData.arrayValue)
        
        for result in jsonData["Search"].arrayValue {
            let title = result["Title"].stringValue
            let plot = result["Plot"].stringValue
            let year = result["Year"].intValue
            let id = result["imdbID"].stringValue
            //let score = result["Metascore"].intValue
            //let rating = result["Rated"].stringValue
            
            
            guard let posterURL = NSURL(string: result["Poster"].stringValue) else {
                //negative case
                return
            }
            guard let imageData = NSData(contentsOfURL: posterURL) else {
                //negative case
                return
            }
            guard let poster = UIImage(data: imageData) else {
                //negative case
                theData.append(Movie(title: title, poster: UIImage(named: "default.png")!, plot: plot, year: year, id: id))
                return
            }
            
            theData.append(Movie(title: title, poster: poster, plot: plot, year: year, id: id))
        }
        print(theData)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        spinner.bringSubviewToFront(self.spinner)
        spinner.startAnimating()
        theData.removeAll()
        
        //collection.deleteSections(NSIndexSet(index: 0))
        let searched = String(searchBar.text!)
        let queryTerms = searched.componentsSeparatedByString(" ")
        
        var theURL = "http://www.omdbapi.com/?s="
        let page1 = "&y=&plot=short&r=json&page=1"
        let page2 = "&y=&plot=short&r=json&page=2"
        for term in queryTerms {
            if (term != queryTerms.last) {
                theURL += term + "+"
            } else {
                theURL += term
            }
        }
        
        let theURLp2 = theURL + page2
        theURL += page1
        
        //spinner.startAnimating()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)){
            self.fetchData(theURL)
            self.fetchData(theURLp2)
            //self.cacheImages()
            
            dispatch_async(dispatch_get_main_queue()){
                self.collection.reloadData()
            }
        }
        //spinner.stopAnimating()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       //print ("in cell for item at row \(indexPath.row) and section \(indexPath.section) ")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mycell", forIndexPath: indexPath) as! myCollectionViewCell
        cell.myLabel.text = theData[indexPath.row].title
        cell.backgroundView = UIImageView(image:theData[indexPath.row].poster)
        
        navigationItem.rightBarButtonItem?.enabled = true
        spinner.stopAnimating()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        
        let detailedVC = DetailedViewController(nibName: "DetailedViewController", bundle: nil)
        
        // detailedVC
        detailedVC.name = theData[indexPath.row].title
        detailedVC.image = theData[indexPath.row].poster
        //spinner.startAnimating()
        let theURL = "http://www.omdbapi.com/?i=" + theData[indexPath.row].id + "&plot=short&r=json"
        let jsonData = getJSON(theURL)
        detailedVC.score = jsonData["Metascore"].intValue
        detailedVC.rating = jsonData["Rated"].stringValue
        detailedVC.year = theData[indexPath.row].year
        detailedVC.id = theData[indexPath.row].id
        //spinner.stopAnimating()
        
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
    

    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
     }
    


}
