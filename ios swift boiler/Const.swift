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
    static let KEY_OAUTH_TOKEN_SECRET:String = "oauth_token_secret"
    static let KEY_CREATED_AT:String = "created_at"
    static let KEY_IMG:String = "img"
    static let KEY_DESCRIPTION:String = "desc"
    
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
    static let TWITTER_SECRET = "N6t26j5RiKp1wyk55HJsK9U3nR9i08SKqNuSq4e6iqYByTFDdR"
}
