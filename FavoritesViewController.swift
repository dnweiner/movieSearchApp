//
//  FavoritesViewController.swift
//  DannyWeiner-Lab4
//
//  Created by Danny Weiner on 10/2/16.
//  Copyright © 2016 cse438s. All rights reserved.
//

//
// MODELED AFTER:
//  ViewController.swift
//  TableViewStuff
//
//  Created by Todd Sproull on 9/28/16.
//  Copyright © 2016 Todd Sproull. All rights reserved.
//

import UIKit
import Foundation

class FavoritesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    let error_msg = "ERROR: NO FAVORITES AVAILABLE"
    
    var myArray = [String]()
    //var myArray = ["test1", "test2", "test3"]
    
    @IBOutlet weak var favorites: UITableView!
    
    var clearTable = false
    
//    @IBAction func deleteAllBtn(sender: UIBarButtonItem) {
//        let ac = UIAlertController(title: "Delete All Favorites?", message: nil, preferredStyle: .ActionSheet)
//        ac.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: deleteAll))
//        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
//        
//    }
    
    @IBAction func sortBtn(sender: UIBarButtonItem) {
        myArray.sortInPlace({$0 < $1})
        favorites.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (clearTable) {
            return 0
        } else {
            return myArray.count
        }
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //print("in cellForRow at \(indexPath)")
        
        let myCell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        myCell.textLabel!.text = myArray[indexPath.row]
        
        return myCell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete  && !myArray.contains(error_msg)) {
            favorites.beginUpdates()
            favorites.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if var favoritesKeyStringArray = favoriteData.arrayForKey("favorites") as? [String] {
                favoritesKeyStringArray.removeAtIndex(indexPath.row) //remove from NSUserDefaults data
                favoriteData.setObject(favoritesKeyStringArray, forKey: "favorites") //regenerate superglobal array with the deleted item now removed
                favoriteData.synchronize()
            }
            myArray.removeAtIndex(indexPath.row) //remove from local array
            favorites.reloadData()
            favorites.endUpdates()
        }
    }
    
    func refreshFavorites() {
        favoriteData.synchronize()
        
        guard let favoritesArray = favoriteData.stringArrayForKey("favorites") else {
            //negative case
            print("ERROR")
            myArray.append(error_msg)
            return
        }
        
        if myArray.contains(error_msg) {
            myArray.removeAtIndex(myArray.indexOf(error_msg)!)
        }
        
        for item in favoritesArray {
            if !myArray.contains(item) {
                myArray.append(item)
            }
        }
        
        if myArray.isEmpty {
            print("ERROR")
            myArray.append(error_msg)
        } else {
            navigationItem.rightBarButtonItem?.enabled = true
            //navigationItem.leftBarButtonItem?.enabled = true
        }
        
        //print(favoritesArray.last)
        
        self.favorites.reloadData()
        
    }
    
//    func deleteAll(action: UIAlertAction!) {
//        favorites.beginUpdates()
//        clearTable = true
//        if var favoritesKeyStringArray = favoriteData.arrayForKey("favorites") as? [String] {
//            favoritesKeyStringArray.removeAll() //remove from NSUserDefaults data
//            favoriteData.setObject(favoritesKeyStringArray, forKey: "favorites") //regenerate superglobal array with the deleted items now removed
//            favoriteData.synchronize()
//        }
//        refreshFavorites()
//        //myArray.removeAll() //remove from local array
//        //myArray.append(error_msg)
//        favorites.reloadData()
//        clearTable = false
//        favorites.endUpdates()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.favorites.dataSource = self
        self.favorites.delegate = self
        
        //refreshFavorites()
        
        navigationItem.rightBarButtonItem?.enabled = false
        //navigationItem.leftBarButtonItem?.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshFavorites()
        print("REFRESHING FAVORITES")
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

