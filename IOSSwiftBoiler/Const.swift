//
//  Const.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

class Const {
    // Facebook JSON Keys
    static let KEY_FB_COVER_IMG:String = "cover"
    static let KEY_FB_ABOUT:String = "about"
    static let KEY_FB_BIO:String = "bio"
    
    // Twitter JSON Keys
    static let KEY_TWITTER_HANDLE:String = "screen_name"
    static let KEY_TWITTER_DESCRIPTION:String = "description"
    static let KEY_TWITTER_IMG:String = "profile_image_url"
    static let KEY_TWITTER_BG_IMG:String = "profile_background_image_url"
    static let KEY_TWITTER_ID:String = "id_str"
    
    // Ubiquituous JSON Keys
    static let KEY_NAME:String = "name"
    static let KEY_STATUS_CODE:String = "status_code"
    static let KEY_USER:String = "user"
    static let KEY_ID:String = "id"
    static let KEY_SECRET:String = "secret"
    static let KEY_TOKEN:String = "token"
    static let KEY_OAUTH_TOKEN:String = "oauth_token"
    static let KEY_SOURCE:String = "source"
    static let KEY_ACCESS_TOKEN:String = "access_token"
    static let KEY_OAUTH_TOKEN_SECRET:String = "oauth_token_secret"
    static let KEY_OAUTH_SIGNATURE:String = "oauth_signature"
    static let KEY_CREATED_AT:String = "created_at"
    static let KEY_IMG:String = "img"
    static let KEY_DESCRIPTION:String = "desc"
    static let KEY_ERROR:String = "error"
    static let KEY_CODE:String = "code"
    static let KEY_MESSAGE:String = "message"
    
    
    // User JSON Keys
    static let KEY_USER_ID:String = "user_id"
    static let KEY_USERNAME:String = "username"
    static let KEY_EMAIL:String = "email"
    static let KEY_BG_IMG:String = "bg_img"
    static let KEY_PLATFORM:String = "platform"
    
    // Login Platforms
    enum Platforms:String {
        case Facebook = "facebook"
        case Twitter = "twitter"
    }
    
    // TWITTER APP SECRET
    static let TWITTER_KEY:String = "UNCDambMvAgmJ4u8cB8GmuxKA"
    static let TWITTER_SECRET:String = "sBaC5cUwbO8fVtjuXbFquldXXZ0NGmTn6KJxNNjXiLHxYbcnJH"
    
    // MODEL NAMES
    static let MODEL_USERS:String = "Users"
    
    // SEGUE TITLES
    static let SEGUE_USER_VIEW:String = "UserView"
    static let SEGUE_LOGIN_VIEW:String = "LoginView"
    static let SEGUE_SETTINGS_VIEW:String = "SettingsView"
    static let SEGUE_WEB_VIEW:String = "WebView"
    
    // NOTIFICATIONS
    static let NOTIFICATION_USER_AUTH:String = "com.gottsohn.ios-swift-boiler.NC_USER_AUTH"
    
    // Storyboard Identifies
    static let ID_USER_VIEW_CONTROLLER:String = "UserViewController"
    static let ID_WEB_VIEW_CONTROLLER:String = "WebViewController"
    
    // LAUNCH ACTION
    static let ACTION_LOGIN:String = "LOGIN"
    static let ACTION_HOME:String = "HOME"
    static let ACTION_SETTINGS:String = "SETTINGS"
}
