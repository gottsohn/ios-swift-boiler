//
//  UserViewController.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserViewController: UIViewController {
    
    @IBOutlet weak var activeUserView: UIView!
    @IBOutlet weak var inactiveUserView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userBackgroundView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var musicTableView: UIView!
    @IBOutlet weak var headerView: TextHeadingView!
    
    let notificationCenter = NSNotificationCenter.defaultCenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(loginStatusChange(_:)), name: Const.NOTIFICATION_USER_AUTH, object: nil)
        
        populate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Helpers.async({
            self.getUser()
        }) {
            self.processLaunch()
        }
    }
    
    func getUser() {
        Users.fetch(Const.MODEL_USERS) { context, result, error in
            if error == nil && result != nil {
                let user = result![0]
                var userJSON:JSON = JSON([:])
                userJSON[Const.KEY_PLATFORM].stringValue = user.valueForKey(Const.KEY_PLATFORM) as! String
                userJSON[Const.KEY_USER_ID].stringValue = user.valueForKey(Const.KEY_USER_ID) as! String
                userJSON[Const.KEY_USERNAME].stringValue = user.valueForKey(Const.KEY_USERNAME) as! String
                userJSON[Const.KEY_IMG].stringValue = user.valueForKey(Const.KEY_IMG) as! String
                userJSON[Const.KEY_BG_IMG].stringValue = user.valueForKey(Const.KEY_BG_IMG) as! String
                userJSON[Const.KEY_OAUTH_TOKEN].stringValue = user.valueForKey(Const.KEY_OAUTH_TOKEN) as! String
                userJSON[Const.KEY_OAUTH_TOKEN_SECRET].stringValue = user.valueForKey(Const.KEY_OAUTH_TOKEN_SECRET) as! String
                userJSON[Const.KEY_EMAIL].stringValue = user.valueForKey(Const.KEY_EMAIL) as! String
                userJSON[Const.KEY_DESCRIPTION].stringValue = user.valueForKey(Const.KEY_DESCRIPTION) as! String
                userJSON[Const.KEY_NAME].stringValue = user.valueForKey(Const.KEY_NAME) as! String
                Helpers.currentUser = userJSON
                Helpers.async {
                    NSNotificationCenter.defaultCenter().postNotificationName(Const.NOTIFICATION_USER_AUTH, object: self, userInfo: [:])
                }
            }
        }
    }

    
    func processLaunch() {
        if Helpers.launchActions != nil {
            if Helpers.launchActions[Const.ACTION_LOGIN] != nil {
                performSegueWithIdentifier(Const.SEGUE_LOGIN_VIEW, sender: self)
                Helpers.launchActions = nil
            } else if Helpers.launchActions[Const.ACTION_SETTINGS] != nil {
                performSegueWithIdentifier(Const.SEGUE_SETTINGS_VIEW, sender: self)
                Helpers.launchActions = nil
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func showLogin(sender: UIButton) {
    
    }
    
    func loginStatusChange(notification: NSNotification) {
        populate()
    }
    
    func populate() {
        if Helpers.currentUser != nil {
            activeUserView.hidden = false
            inactiveUserView.hidden = true
            usernameLabel.text = Helpers.currentUser[Const.KEY_USERNAME].stringValue
            fullnameLabel.text = Helpers.currentUser[Const.KEY_NAME].stringValue
            descriptionLabel.text = Helpers.currentUser[Const.KEY_DESCRIPTION].stringValue
            profileImageView.layer.cornerRadius = profileImageView.bounds.height / CGFloat(2)
            Helpers.setImage(profileImageView, url: Helpers.currentUser[Const.KEY_IMG].stringValue)
            Helpers.setImage(userBackgroundView, url: Helpers.currentUser[Const.KEY_BG_IMG].stringValue)
        } else {
            activeUserView.hidden = true
            inactiveUserView.hidden = false
        }
    }
}
