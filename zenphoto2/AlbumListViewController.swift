//
//  AlbumListViewController.swift
//  zenphoto2
//
//  Created by 宮本幸子 on 2015/02/15.
//  Copyright (c) 2015年 宮本幸子. All rights reserved.
//

import UIKit
import Haneke
import Alamofire

class AlbumListViewController: UITableViewController {

    var albums: [JSON]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!checkConnection()) {
            if (!config.boolForKey("firstRun")) {
                config.setBool(true, forKey: "firstRun")
            }
            self.performSegueWithIdentifier("toSettingsView", sender: nil)            
        } else {
            self.getAlbumList()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAlbumList() {
        //refreshControl?.beginRefreshing()
        
        let method = "zenphoto.album.getList"
        var d = encode64(userDatainit())!.stringByReplacingOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var param = [method : d]
        
        Alamofire.request(.POST, URLinit(), parameters: param).responseJSON { request, response, json, error in
            if json != nil {
                var jsonObj = JSON(json!)
                if let results = jsonObj.arrayValue as [JSON]? {
                    self.albums = results
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.albums?.count ?? 0

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as UITableViewCell

        var albumInfo = self.albums?[indexPath.row]
        
        var webpath = albumInfo?["thumbnail"].string
        var albumFolder = albumInfo?["folder"].string
        var id = albumInfo?["id"].string

        var albumThumb = webpath!.substringFromIndex(advance(webpath!.startIndex, 1))
        var URL: String! = config.stringForKey("URL")
        if !URL.hasSuffix("/") {
            URL = URL + "/"
        }
        
        var albumThumbURL: String = String(format: URL + String(albumThumb))
        var imageURL: NSURL = NSURL(string:albumThumbURL)!
        
        cell.textLabel!.text = albumFolder
        cell.imageView?.hnk_setImageFromURL(imageURL)
//
//        var q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        var q_main: dispatch_queue_t  = dispatch_get_main_queue()
//        
//        dispatch_async(q_global, {
//            dispatch_async(q_main, {
//                
//                var imageURL: NSURL = NSURL(string:albumThumbURL)!
//                var imageData: NSData = NSData(contentsOfURL: imageURL)!
//                
//                var image: UIImage = UIImage(data: imageData)!
//                var croppedImage: UIImage = image.resizeSquare(80)
//                
//                cell.imageView!.image = croppedImage
//                cell.textLabel!.text = albumFolder
//                
//            })
//        })
        cell.layoutSubviews()

        // Configure the cell...

        return cell
    }
    
    // MARK: - Segues
    
//    override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?) {
//        if segue.identifier == "showImageList" {
//            var indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
//            let imageListViewController = segue.destinationViewController as ImageListViewController
//            let albumInfo = albums[indexPath.row]
//            imageListViewController.albumInfo = albumInfo
//        }
//    }
    
}
