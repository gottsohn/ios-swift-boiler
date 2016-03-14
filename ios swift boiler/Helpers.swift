//
//  Helpers.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit
import CoreData
class Helpers {

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
    
    static func fetch (model:String, sortBy:String? = nil, sortAsc:Bool = false, format:String? = nil, args:String? = nil, callback:(context:NSManagedObjectContext, result:[NSManagedObject]?, error: NSError?)->()) {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: model)
        if format != nil && args != nil {
            fetchRequest.predicate = NSPredicate(format: format!, args!)
        }
        
        if sortBy != nil {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: sortAsc)]
        }
        
        do {
            let result:[NSManagedObject] = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            if result.count != 0 {
                callback(context: context, result: result, error: nil)
            } else {
                callback(context: context, result: nil, error: nil)
            }
        } catch let error as NSError {
            callback(context: context, result: nil, error: error)
        }
    }
}
