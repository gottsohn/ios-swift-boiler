//
//  Helpers.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class Helpers {
    static var currentUser: JSON!
    static var launchActions:[String : NSSecureCoding]!
    
    static func showDialog(viewController:UIViewController, message:String, title:String, callbackOk:((action:UIAlertAction) -> Void)? = nil, callback:((action:UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: NSLocalizedString("CLOSE", comment: "Close"), style: .Default, handler: callback)
        alert.addAction(action)
        if callbackOk != nil {
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: callbackOk)
            alert.addAction(okAction)
        }
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    static var appVersion:String {
        get {
            if NSBundle.mainBundle().infoDictionary != nil,
            let appVersion:String = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String {
                    return appVersion
            }
        
            return "1.0"
        }
    }
    
    static func showError(view:UIViewController, error: NSError?, callback: ((action: UIAlertAction)-> ())? = nil) {
        var errorMessage:String?
        var errorTitle:String?
        if error != nil {
            errorMessage = error!.localizedDescription
            errorTitle = error!.localizedFailureReason
        }
        
        errorTitle = errorTitle ?? NSLocalizedString("ERROR", comment: "Error")
        errorMessage = errorMessage ?? NSLocalizedString("ERROR_MESSAGE", comment: "Error Message")
        showDialog(view, message: errorMessage!, title: errorTitle!, callback: callback)
    }
    
    static func saveManagedContext (view: UIViewController? = nil, context: NSManagedObjectContext, callback: (error: NSError?)->()) {
        do {
            try context.save()
            callback(error: nil)
        } catch let error as NSError {
            callback(error: error)
            if view != nil {
                self.showError(view!, error: error)
            }
        }
    }
    
    static func async(run:(()->())? = nil, completed:(()->())? = nil) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            if run != nil {
                run!()
            }
            
            dispatch_sync(dispatch_get_main_queue(), {
                if completed != nil {
                    completed!()
                }
            })
        })
    }
    
    internal static func getDataFromUrl(url:NSURL, completion: (data: NSData?, response: NSURLResponse?, error: NSError? ) -> ()) {
        Helpers.async({
            NSURLSession.sharedSession().dataTaskWithURL(url) {
                data, response, error in
                Helpers.async {
                    completion(data: data, response: response, error: error)
                }
            }.resume()
        })
    }
    
    // Helper function to get image from internet
    static func setImage (imageView:UIImageView? = nil, url: String, callback: ((error:NSError?, image: UIImage?)-> Void)? = nil) {
        
        let nsURL = NSURL(string: url)
        self.getDataFromUrl(nsURL!) {
            data, response, error in
            let noImage = UIImage(named: "no-image")
            guard let data = data where error == nil else {
                if imageView != nil {
                    imageView!.image = noImage
                }
                
                if callback != nil {
                    callback!(error: error, image: noImage)
                }
                
                return
            }
            
            let image = UIImage(data: data) ?? noImage
            if imageView != nil {
                imageView!.image = image
            }
            
            if callback != nil {
                callback!(error: nil, image: image)
            }            
        }
    }

}
