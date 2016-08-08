//
//  LoginViewController.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit
import MediaPlayer
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
        // Play background Video
        playBgVideo()
        
        // Add Pull up / down Swipe to close to View
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognized(_:)))
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
    
    func socialAccountAuth(identifier:String, options:
        [NSObject: AnyObject]?, sender: UIButton) {
        let account = ACAccountStore()
        let accountType =
            account.accountTypeWithAccountTypeIdentifier(identifier)
        
        account.requestAccessToAccountsWithType(accountType, options:
            options,completion: { success, error in
                
            var urlString:String = "prefs:root="
            if identifier == ACAccountTypeIdentifierTwitter {
                urlString = "\(urlString)TWITTER"
            } else {
                urlString = "\(urlString)FACEBOOK"
            }
            
            let url:NSURL! = NSURL(string : urlString)
            if success {
                let arrayOfAccounts =
                    account.accountsWithAccountType(accountType).map({
                        (account) -> ACAccount in
                        
                        return account as! ACAccount
                    })
                
                if arrayOfAccounts.count > 0 {
                    if arrayOfAccounts.count > 1 {
                        Helpers.async {
                            self.listAccounts(arrayOfAccounts, identifier:
                                identifier, sender: sender)
                        }
                    } else {
                        self.getSocialParams(arrayOfAccounts.first!,
                            identifier: identifier)
                    }
                } else {
                    UIApplication.sharedApplication().openURL(url)
                }
            } else {
                self.loading(false)
                if error.code == 6 {
                    UIApplication.sharedApplication().openURL(url)
                } else {
                    Helpers.showError(self, error: error)
                }
            }
        })
    }
    
    func getSocialParams(socialAccount: ACAccount, identifier:String) {
        loading()
        var serviceType:String = SLServiceTypeFacebook
        var urlString:String = "https://graph.facebook.com/me"
        var parameters:[String: String]? = ["fields": "email,cover,name,bio"]
        if identifier == ACAccountTypeIdentifierTwitter {
            serviceType = SLServiceTypeTwitter
            urlString =
            "https://api.twitter.com/1.1/account/verify_credentials.json"
            
            parameters = nil
        }
        
        let url:NSURL? = NSURL(string: urlString)
        let infoRequest:SLRequest = SLRequest(forServiceType:
            serviceType, requestMethod: .GET, URL: url, parameters: parameters)
        infoRequest.account = socialAccount
        infoRequest.performRequestWithHandler { data, response, error in
            var _error = error
            if error == nil {
                let result:JSON = JSON(data: data)
                let errorResult = result[Const.KEY_ERROR]
                if errorResult.isExists() {
                    _error = NSError(domain:
                        errorResult[Const.KEY_MESSAGE].stringValue, code:
                        errorResult[Const.KEY_CODE].intValue, userInfo: nil)
                } else {
                    if identifier == ACAccountTypeIdentifierTwitter {
                        self.processTwitter(result, request: infoRequest
                            .preparedURLRequest())
                    } else {
                        self.processFacebook(result, request: infoRequest
                            .preparedURLRequest())
                    }
                    
                    return
                }
                
            }
            
            Helpers.async {
                Helpers.showError(self, error: _error)
                print(_error)
                self.loading(false)
            }
        }
    }
    
    func listAccounts(accounts: [ACAccount], identifier: String, sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "\(NSLocalizedString("CHOOSE", comment: "Choose")) \(NSLocalizedString("ACCOUNT", comment: "Account"))", preferredStyle: .ActionSheet)
        
        for account in accounts {
            let title = identifier == ACAccountTypeIdentifierTwitter ?
                "@\(account.username)" : account.userFullName
            
            let action = UIAlertAction(title: title, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.getSocialParams(account, identifier: identifier)
            })
            
            optionMenu.addAction(action)
        }
        
        optionMenu.addAction(UIAlertAction(title:
            NSLocalizedString("CLOSE", comment: "Close"), style: .Cancel,
            handler: nil))
        
        let popUpPresenter = optionMenu.popoverPresentationController
        popUpPresenter?.sourceView = sender
        popUpPresenter?.sourceRect = sender.bounds
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func getToken(string:String) -> (String, String) {
        let strings = string.characters.split("=").map(String.init)
        if strings.count > 6 {
            let token = strings[5].characters.split("\"").map(String.init)[0]
            let secret = strings[6].characters.split("\"").map(String.init)[0]
            return (token, secret)
        } else {
            return ("", "")
        }
    }
    
    // Action from button to login with Facebook
    @IBAction func facebookAuth (sender: UIButton) {
        socialAccountAuth(ACAccountTypeIdentifierFacebook, options: [
            ACFacebookAppIdKey: "961478310602665",
            ACFacebookAudienceKey: ACFacebookAudienceEveryone,
            ACFacebookPermissionsKey: [
                "basic_info",
                "public_profile",
                "email"]
            ], sender: sender)
    }
    
    func processFacebook(result:JSON, request: NSURLRequest) {
        if let userId = result[Const.KEY_ID].string {
            let bio:String = result[Const.KEY_FB_BIO].string ??
            "Constantly on Replay.."
            
            let bgImg:String = result[Const.KEY_FB_COVER_IMG][Const.KEY_SOURCE].stringValue
            let name:String = result[Const.KEY_NAME].string ?? "Re-player"
            let email:String = result[Const.KEY_EMAIL].string ?? ""
            let params:[String: String] = [
                Const.KEY_NAME: name,
                Const.KEY_EMAIL: email,
                Const.KEY_IMG : "https://graph.facebook.com/\(userId)/picture?width=200&height=200",
                Const.KEY_USER_ID : userId,
                Const.KEY_BG_IMG: bgImg,
                Const.KEY_DESCRIPTION: bio,
                Const.KEY_OAUTH_TOKEN: Helpers.getQueryStringParameter(
                    request.URLString, param: Const.KEY_ACCESS_TOKEN) ?? "",
                Const.KEY_OAUTH_TOKEN_SECRET: "",
                Const.KEY_PLATFORM: Const.Platforms.FACEBOOK,
                Const.KEY_USERNAME: ""]
            
            self.saveUser(params)
        }
    }
    
    func getFBUser (accessToken:String) {
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,bio,cover"], tokenString: accessToken, version: nil, HTTPMethod: "GET")
        
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if error == nil {
                let userId = result[Const.KEY_ID] as! String;
                let cover:NSDictionary =  result[Const.KEY_FB_COVER_IMG] as! NSDictionary
                let bio: String = result[Const.KEY_FB_BIO] != nil ? result[Const.KEY_FB_BIO] as! String: "Diese ist mein Profil Beschreibung"
                
                let bg_img = cover["source"] as? String ?? ""
                let params:[String: String] = [
                    Const.KEY_NAME : result[Const.KEY_NAME] as! String,
                    Const.KEY_EMAIL : result[Const.KEY_EMAIL] as! String,
                    Const.KEY_IMG : "https://graph.facebook.com/\(userId)/picture?width=200&height=200",
                    Const.KEY_USER_ID : userId,
                    Const.KEY_BG_IMG: bg_img,
                    Const.KEY_DESCRIPTION: bio,
                    Const.KEY_OAUTH_TOKEN: accessToken,
                    Const.KEY_OAUTH_TOKEN_SECRET: "",
                    Const.KEY_PLATFORM: Const.Platforms.Facebook.rawValue,
                    Const.KEY_USERNAME: ""
                ]
                
                self.saveUser(params)
            } else {
                Helpers.showError(self, error: error)
                self.loading(false)
            }
        })
    }
    
    func loginToFacebookWithSuccess(successBlock: (accessToken:String) -> (), failureBlock: (error:NSError?) -> ()) {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            return successBlock(accessToken: FBSDKAccessToken.currentAccessToken().tokenString)
        }
        
        let facebookReadPermissions = ["public_profile", "email", "user_friends", "user_about_me"]
        FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                FBSDKLoginManager().logOut()
                failureBlock(error: error)
            } else if result.isCancelled {
                failureBlock(error: nil)
            } else {
                var allPermsGranted = true
                let grantedPermissions = result.grantedPermissions.map( {"\($0)"} )
                for permission in facebookReadPermissions {
                    if !grantedPermissions.contains(permission) {
                        allPermsGranted = false
                        break
                    }
                }
                if allPermsGranted {
                    // let fbUserID = result.token.userID
                    successBlock(accessToken: result.token.tokenString)
                } else {
                    failureBlock(error: error)
                }
            }
        })
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
        
        // Add observer to help repeat background video when it completes
        notificationCenter.addObserver(self,
            selector: #selector(playerItemDidReachEnd(_:)),
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: player?.currentItem)
        
        player.volume = 1.0
        player.play()
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        player.seekToTime(kCMTimeZero)
        player.volume = 0.5
        player.play()
    }
}
