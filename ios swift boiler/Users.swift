//
//  Users.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import CoreData
import SwiftyJSON

@objc(Users)
class Users: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var platform: String
    @NSManaged var email: String
    @NSManaged var user_id: String
    @NSManaged var img: String
    @NSManaged var oauth_token: String
    @NSManaged var oauth_token_secret: String
    @NSManaged var bg_img: String
    @NSManaged var username: String
    @NSManaged var desc: String
    
    static func fetch (model:String, sortBy:String? = nil, sortAsc:Bool = false, format:String? = nil, args:String? = nil, callback:(context:NSManagedObjectContext, result:[NSManagedObject]?, error: NSError?)->()) {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: model)
        if format != nil && args != nil {
            fetchRequest.predicate = NSPredicate(format: format!, args!)
        }
        
        // If sort query parameter {sortBy} is set
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
