//
//  ImageViewController.swift
//  zenphoto2
//
//  Created by 宮本幸子 on 2015/02/17.
//  Copyright (c) 2015年 宮本幸子. All rights reserved.
//

import UIKit
import Alamofire

class ImagesViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController : UIPageViewController?
    var albumInfo: JSON?
    var images: [JSON]? = []
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        var albumId: String = self.albumInfo?["id"].stringValue as String!
        self.getImageList(albumId)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageList(id: String) {
        
        let method = "zenphoto.album.getImages"
        var d = encode64(userDatainit(id: id))!.stringByReplacingOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var param = [method: d]
        
        Alamofire.request(.POST, URLinit(), parameters: param).responseJSON { request, response, json, error in
            
            if json != nil {
                var jsonObj = JSON(json!)
                if let results = jsonObj.arrayValue as [JSON]? {
                    self.images = results
                    self.setupView()
                }
            }
        }
    }
    
    func setupView() {
        let startingViewController: ImageView = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)

    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as ImageView).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as ImageView).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.images?.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> ImageView? {
        if self.images?.count == 0 || index >= self.images?.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = ImageView()
        println(images?[index])
        
        pageContentViewController.image = images?[index]
        //pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.images?.count ?? 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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
