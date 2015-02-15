//
//  Functions.swift
//  zenphoto2
//
//  Created by 宮本幸子 on 2015/02/15.
//  Copyright (c) 2015年 宮本幸子. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

let config = NSUserDefaults.standardUserDefaults()
let alertView: UIAlertView = UIAlertView()

func userDatainit(id: String = "1") -> Dictionary<String, AnyObject> {
    var userData = Dictionary<String, AnyObject>()
    userData["loginUsername"] = config.objectForKey("loginUsername")
    userData["loginPassword"] = config.objectForKey("loginPassword")
    userData["loglevel"] = "debug"
    
    //println(userData)
    userData["id"] = id
    return userData
}

func encode64(userData: Dictionary<String, AnyObject>) -> String? {
    
    var json = JSONStringify(userData)
    //println(json)
    
    var utf8str = json.dataUsingEncoding(NSUTF8StringEncoding)
    var base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
    
    return base64Encoded
}

func URLinit() -> NSURL {
    var URL: String! = config.stringForKey("URL")
    if !URL.hasSuffix("/") {
        URL = URL + "/"
    }
    let ZenRPC_URL: NSURL = NSURL(string: URL + "plugins/ZenPublisher/ZenRPC.php")!
    //println(ZenRPC_URL)
    
    return ZenRPC_URL
    
}

//func makeRequest(body:String) -> NSMutableURLRequest {
//    
//    var request = NSMutableURLRequest(URL: URLinit())
//    
//    var bodydata = body.dataUsingEncoding(NSUTF8StringEncoding)
//    
//    request.HTTPMethod = "POST"
//    request.HTTPBody = bodydata
//    request.allHTTPHeaderFields = ["User-Agent":"Lightroom Zenphoto Publisher Plugin/4.5.0.20130529"]
//    
//    return request
//}

var chkcnct = false
func checkConnection() -> Bool {
    
    if config.stringForKey("URL") == "http://" || config.stringForKey("loginUsername") == "" || config.stringForKey("loginPassword") == "" {
        return false
    }
    
    let method = "zenphoto.login"
//    var body = method + "=" + encode64(userDatainit())!
//    var request = makeRequest(body)
//    
//    var req = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil) as NSData!
//    var responseStr: NSString = NSString(data:req, encoding:NSUTF8StringEncoding)!
//    
    var d = encode64(userDatainit())!.stringByReplacingOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    var param = [method: d]
    
    Alamofire.request(.POST, URLinit(), parameters: param).responseSwiftyJSON { request, response, json, error in
        
        if (json["code"] == nil) {
            alertView.title = "Success!"
            alertView.message = "Login as " + String(config.stringForKey("loginUsername")!)
            alertView.addButtonWithTitle("close")
            alertView.show()
            chkcnct = true
            
        } else {
            alertView.title = "Success!"
            alertView.message = "Login as " + String(config.stringForKey("loginUsername")!)
            alertView.addButtonWithTitle("close")
            alertView.show()
            chkcnct = false
            
        }
    
    }
    
    return chkcnct
        
}

func JSONStringify(jsonObj: AnyObject) -> String {
    var e: NSError?
    let jsonData = NSJSONSerialization.dataWithJSONObject(
        jsonObj,
        options: NSJSONWritingOptions(0),
        error: &e)
    if (e != nil) {
        return ""
    } else {
        return NSString(data: jsonData!, encoding: NSUTF8StringEncoding)!
    }
}

func JSONParseArray(jsonString: String) -> Array<AnyObject> {
    var e: NSError?
    var data: NSData=jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
    var jsonObj = NSJSONSerialization.JSONObjectWithData(
        data,
        options: NSJSONReadingOptions(0),
        error: &e) as Array<AnyObject>
    if (e != nil) {
        return Array<AnyObject>()
    } else {
        return jsonObj
    }
}

func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
    var e: NSError?
    var data: NSData! = jsonString.dataUsingEncoding(
        NSUTF8StringEncoding)
    var jsonObj = NSJSONSerialization.JSONObjectWithData(
        data,
        options: NSJSONReadingOptions(0),
        error: &e) as Dictionary<String, AnyObject>
    if (e != nil) {
        return Dictionary<String, AnyObject>()
    } else {
        return jsonObj
    }
}
