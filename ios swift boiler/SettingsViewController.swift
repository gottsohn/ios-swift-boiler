//
//  SettingsViewController.swift
//  ios-swift-boiler
//
//  Created by Godson Ukpere on 3/15/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//


import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {
    
    let SONG_COUNT:Int = 30
    var songs:[NSManagedObject]!
    var url:String!
    var labelText:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if Helpers.currentUser != nil, let loginCell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) {
            (loginCell.viewWithTag(1) as! UILabel).text = NSLocalizedString("LOGOUT", comment: "Logout")
            (loginCell.viewWithTag(2) as! UILabel).text = Helpers.currentUser[Const.KEY_USERNAME].stringValue
        }
        
        if let versionCell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) {
            (versionCell.viewWithTag(1) as! UILabel).text = Helpers.appVersion
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController:WebViewController = segue.destinationViewController as? WebViewController {
            viewController.url = url
            viewController.labelText = labelText
        }
    }
    
    @IBAction func close (sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertMessage:String = NSLocalizedString("ARE_YOU_SURE", comment: "Are you sure")
        let alertTitle:String = NSLocalizedString("CONFIRM", comment: "Confirm")
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if Helpers.currentUser != nil {
                    Helpers.showDialog(self, message: alertMessage, title: alertTitle, callbackOk: {
                        action in
                        Helpers.currentUser = nil
                        Users.deleteData()
                        NSNotificationCenter.defaultCenter().postNotificationName(Const.NOTIFICATION_USER_AUTH, object: nil)
                        self.close(tableView)
                    })
                } else {
                    print("Close")
                    close(tableView)
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 1:
                url = "http://blog.godson.com.ng/404"
                labelText =  NSLocalizedString("TNC", comment: "TNC")
                performSegueWithIdentifier(Const.SEGUE_WEB_VIEW, sender: self)
            case 2:
                Helpers.showDialog(self, message: "About this app goes in here", title: "IOS Swift Boiler")
            default:
                break
            }
        default:
            break
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
