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
        
        var albumThumbFileName = webpath!.substringFromIndex(advance(webpath!.startIndex, 8))
        var ext = webpath!.pathExtension.lowercaseString
        var albumThumbNameWOExt = albumThumbFileName.stringByDeletingPathExtension
        
        var URL: String! = config.stringForKey("URL")
        if !URL.hasSuffix("/") { URL = URL + "/" }
        var cachePath = URL + "cache/"
        
        var albumThumbURL: String = String(format: cachePath + String(albumThumbNameWOExt) + "_300_cw300_ch300_thumb." + ext)
        //println(albumThumbURL)
        
        var imageURL: NSURL = NSURL(string:albumThumbURL)!
        
        self.albumName.text = albumFolder
        
        let cache = Shared.imageCache
        
        let iconFormat = Format<UIImage>(name: "icons", diskCapacity: 3 * 1024 * 1024) { image in
            let resizer = ImageResizer(size: CGSizeMake(150,150), scaleMode: .AspectFill)
            return resizer.resizeImage(image)
        }
        cache.addFormat(iconFormat)
        
        //let iURL = NSURL(string: "http://haneke.io/icon.png")!
        var image = cache.fetch(URL: imageURL, formatName: "icons").onSuccess { image in
            // image will be a nice rounded icon
            
            //var cropped = image.resizeSquare(100)
            self.albumThumb.image = image
        }
        
        //self.albumThumb.hnk_setImageFromURL(imageURL)


    }
    
}
