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
    
    static func managedObject (callback:(context:NSManagedObjectContext, user:Users)->()) {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let en = NSEntityDescription.entityForName(Const.MODEL_USERS, inManagedObjectContext: context)
        callback(context: context, user: Users(entity: en!, insertIntoManagedObjectContext: context))
    }
    
    static func saveUser (view:UIViewController? = nil, authUser:JSON, token:String? = nil, callback: (error: NSError?)->()) {
        Helpers.currentUser = authUser;
        fetch(Const.MODEL_USERS) { context, result, error in
            if error == nil && result != nil {
                let user = result!.first
                if authUser[Const.KEY_OAUTH_TOKEN].isExists() {
                    user?.setValue(authUser[Const.KEY_OAUTH_TOKEN].stringValue, forKey: Const.KEY_OAUTH_TOKEN)
                }
                
                if authUser[Const.KEY_OAUTH_TOKEN_SECRET].isExists() {
                    user?.setValue(authUser[Const.KEY_OAUTH_TOKEN_SECRET].stringValue, forKey: Const.KEY_OAUTH_TOKEN_SECRET)
                }
                
                user?.setValue(authUser[Const.KEY_USERNAME].stringValue, forKey: Const.KEY_USERNAME)
                user?.setValue(authUser[Const.KEY_NAME].stringValue, forKey: Const.KEY_NAME)
                user?.setValue(authUser[Const.KEY_EMAIL].stringValue, forKey: Const.KEY_EMAIL)
                user?.setValue(authUser[Const.KEY_DESCRIPTION].stringValue, forKey: Const.KEY_DESCRIPTION)
                Helpers.saveManagedContext(view!, context: context, callback: callback)
            } else {
                managedObject({ context, user in
                    user.name = authUser[Const.KEY_NAME].stringValue
                    user.desc = authUser[Const.KEY_DESCRIPTION].stringValue
                    user.oauth_token = authUser[Const.KEY_OAUTH_TOKEN].stringValue
                    user.oauth_token_secret = authUser[Const.KEY_OAUTH_TOKEN_SECRET].stringValue
                    user.email = authUser[Const.KEY_EMAIL].stringValue
                    user.user_id = authUser[Const.KEY_USER_ID].stringValue
                    user.username = authUser[Const.KEY_USERNAME].stringValue
                    user.img = authUser[Const.KEY_IMG].stringValue
                    user.bg_img = authUser[Const.KEY_BG_IMG].stringValue
                    user.platform = authUser[Const.KEY_PLATFORM].stringValue
                    Helpers.saveManagedContext(view, context: context, callback: callback)
                })
            }
        }
    }
    
    static func deleteData (limit:Int = 0, callback: ((count:Int, error:NSError?) -> ())? = nil) {
        fetch(Const.MODEL_USERS, sortBy: "user_id", sortAsc: true) { (context, result, error) -> () in
            var count:Int = 0
            if result != nil {
                for managedObject in result! {
                    if count == limit && limit != 0 {
                        break
                    }
                    
                    context.deleteObject(managedObject)
                    count++
                }
                
                Helpers.saveManagedContext(context: context) {
                    errror in
                    if callback != nil {
                        callback!(count: count,error: error)
                    }
                }
            }
            
            if callback != nil {
                callback!(count: count, error: nil)
            }
        }
    }
}
