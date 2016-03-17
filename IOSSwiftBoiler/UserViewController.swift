//
//  UserViewController.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit

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
        notificationCenter.addObserver(self, selector: "loginStatusUpdated:", name: Const.NOTIFICATION_USER_AUTH, object: nil)
        
        populate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func loginStatusUpdated(notification: NSNotification) {
        populate()
    }
    
    @IBAction func showLogin(sender: UIButton) {
        performSegueWithIdentifier(Const.SEGUE_LOGIN_VIEW, sender: sender)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Const.SEGUE_LOGIN_VIEW {
            segue.destinationViewController.modalPresentationStyle = .OverCurrentContext
        }
    }
}
