//
//  ImageViewController.swift
//  zenphoto2
//
//  Created by 宮本幸子 on 2015/02/17.
//  Copyright (c) 2015年 宮本幸子. All rights reserved.
//

import UIKit
import Haneke

class ImageView: UIViewController {

    var pageIndex : Int = 0
    var image : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let folder = self.image?["folder"].string!
        let filename = self.image?["name"].string!
        var URL: String! = config.stringForKey("URL")
        if !URL.hasSuffix("/") { URL = URL + "/" }
        let imageURL: NSURL = NSURL(string: URL + "albums/" + folder! + "/" + filename!)!
        
        println(imageURL)
        
        let imageView = UIImageView(frame: CGRectMake(0,0, view.frame.size.width, view.frame.size.height))
        imageView.hnk_setImageFromURL(imageURL)        
        self.view.addSubview(imageView)
        
//        let label = UILabel(frame: CGRectMake(0, 0, view.frame.width, 200))
//        label.textColor = UIColor.whiteColor()
//        label.text = titleText
//        label.textAlignment = .Center
//        view.addSubview(label)
//        
//        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        button.frame = CGRectMake(20, view.frame.height - 110, view.frame.width - 40, 50)
//        button.backgroundColor = UIColor(red: 138/255.0, green: 181/255.0, blue: 91/255.0, alpha: 1)
//        button.setTitle(titleText, forState: UIControlState.Normal)
//        button.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(button)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
