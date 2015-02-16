//
//  AlbumListViewCell.swift
//  zenphoto2
//
//  Created by 宮本幸子 on 2015/02/16.
//  Copyright (c) 2015年 宮本幸子. All rights reserved.
//

import UIKit
import Haneke

class AlbumListViewCell: UITableViewCell {

    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumThumb: UIImageView!
    
    var albumInfo: JSON? {
        didSet {
            self.setupAlbumList()
        }
    }
    
    func setupAlbumList() {
        var webpath = self.albumInfo?["thumbnail"].string
        var albumFolder = self.albumInfo?["folder"].string
        var id = self.albumInfo?["id"].string
        
        var albumThumb = webpath!.substringFromIndex(advance(webpath!.startIndex, 1))
        var URL: String! = config.stringForKey("URL")
        if !URL.hasSuffix("/") {
        URL = URL + "/"
        }
        
        var albumThumbURL: String = String(format: URL + String(albumThumb))
        var imageURL: NSURL = NSURL(string:albumThumbURL)!
        
        self.albumName.text = albumFolder
        self.albumThumb.hnk_setImageFromURL(imageURL)

    }
}
