//
//  LoginViewController.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit
import MediaPlayer
import OAuthSwift
import FBSDKLoginKit
import CoreData
import SwiftyJSON

class LoginViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var player:AVPlayer!
    var avPlayerLayer:AVPlayerLayer!
    var isTrackingPanLocation = false
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var panGestureRecognizer : UIPanGestureRecognizer!
    
    @IBOutlet weak var controlView:UIView!
    @IBOutlet weak var loadingIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        playBgVideo()
        
        // Add Swipe to close to View
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panRecognized:")
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        player?.pause()
        dismissViewControllerAnimated(false, completion: nil)
        notificationCenter.removeObserver(self)
    }
    
    // Swipe to close processor
    func panRecognized(recognizer:UIPanGestureRecognizer) {
        view.frame.origin.y = recognizer.translationInView(view).y
        if recognizer.state == .Began {
            recognizer.setTranslation(CGPointZero, inView : view)
            isTrackingPanLocation = true
        } else if recognizer.state == .Ended || recognizer.state == .Cancelled && isTrackingPanLocation {
            if abs(recognizer.translationInView(view).y) > 150 {
                recognizer.enabled = false
                return dismissViewControllerAnimated(true, completion: nil)
            } else {
                isTrackingPanLocation = false
            }
            
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations:{ () -> Void in
                self.view.frame.origin.y = 0
                }, completion: nil)
        } else {
            isTrackingPanLocation = false
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer : UIGestureRecognizer)->Bool {
        return true
    }
    
    // Loading indicator that displays during loading
    private func loading(isLoading:Bool = true) {
        controlView.hidden = isLoading
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    // Action from button to login with Facebook
    @IBAction func facebookAuth (sender: UIButton) {
        
    }
    
    // Close View
    @IBAction func goHome (sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Action from button to login with Twitter
    @IBAction func twitterAuth (sender: UIButton) {
        let oauthswift = OAuth1Swift(
            // They keys are stored in the `Const` class
            consumerKey:    Const.TWITTER_KEY,
            consumerSecret: Const.TWITTER_SECRET,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        
        // Show the loading indicator
        loading()
        oauthswift.authorizeWithCallbackURL(
            NSURL(string: "ios-swift-boiler://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                oauthswift.client.get("https://api.twitter.com/1.1/account/verify_credentials.json", parameters: [:], headers: nil, success: { data, response in
                    var params:[String:String] = [:]
                    let result:JSON = JSON(data: data)
                    params[Const.KEY_IMG] = result[Const.KEY_TWITTER_IMG].stringValue
                    params[Const.KEY_BG_IMG] = result[Const.KEY_TWITTER_BG_IMG].stringValue
                    params[Const.KEY_NAME] = result[Const.KEY_NAME].stringValue
                    params[Const.KEY_EMAIL] = ""
                    params[Const.KEY_USER_ID] = result[Const.KEY_TWITTER_ID].stringValue
                    params[Const.KEY_OAUTH_TOKEN] = credential.oauth_token
                    params[Const.KEY_OAUTH_TOKEN_SECRET] = credential.oauth_token_secret
                    params[Const.KEY_PLATFORM] = Const.Platforms.Twitter.rawValue
                    params[Const.KEY_DESCRIPTION] = result[Const.KEY_TWITTER_DESCRIPTION].stringValue
                    params[Const.KEY_USERNAME] = result[Const.KEY_TWITTER_HANDLE].stringValue
                    self.saveUser(params)
                    }, failure: { error in
                        Helpers.showError(self, error: error)
                        self.loading(false)
                })
            },
            
            failure: { error in
                print(error)
                Helpers.showError(self, error: error)
                self.loading(false)
            }
        )
    }
    
    func saveUser(user:[String:String]) {
        Users.saveUser(authUser: JSON(user)) { error in
            if error == nil {
                // Send a broadcast to inform concerning listeners that the user object as changed
                self.notificationCenter.postNotificationName(Const.NOTIFICATION_USER_AUTH, object: nil)
                // Close the view
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                Helpers.showError(self, error: error)
            }
        }
    }
    
    func playBgVideo() {
        let path = NSBundle.mainBundle().pathForResource("Assets/background", ofType:"mp4")
        let url:NSURL = NSURL.fileURLWithPath(path!)
        player = AVPlayer(URL: url)
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = view.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(avPlayerLayer)
        notificationCenter.addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: player?.currentItem)
        
        player.volume = 0
        player.play()
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        player.seekToTime(kCMTimeZero)
        player.volume = 0.002
        player.play()
    }
}
