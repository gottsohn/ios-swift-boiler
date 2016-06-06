# IOS Swift Boiler Plate with Authentication

A boiler plate written in Swift 2.1 with _Facebook_ and _Twitter_ Authentication.

[![Build Status](https://travis-ci.org/gottsohn/ios-swift-boiler.svg?branch=master)](https://travis-ci.org/gottsohn/ios-swift-boiler) [![Coverage Status](https://coveralls.io/repos/github/gottsohn/ios-swift-boiler/badge.svg?branch=master)](https://coveralls.io/github/gottsohn/ios-swift-boiler?branch=master)


### Package Manager
The packages are staged as recommended to avoid framework support deprecation.
 - [CocoaPods](https://cocoapods.org)

### Frameworks used
 - [CocoaPods](./Podfile)
    - [Alamofire 3.0](https://github.com/Alamofire/Alamofire)
    - [OAuthSwift 0.5.0](https://github.com/OAuthSwift/OAuthSwift)
    - [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
 - Facebook SDK (Core and Login)

### Localization
English :us: and German are supported by the application, in _Localizable.strings_ and in the Storyboard's language files.

### CoreData Entities
 - Users
    - _name_: String
    - _platform_: String
    - _email_: String
    - _user_id_: String
    - _img_: String
    - _oauth_token_: String
    - _oauth_token_secret_: String
    - _bg_img_: String
    - _username_: String
    - _desc_: String

### Twitter and Facebook API keys
The Twitter keys and secrets `TWITTER_KEY` and `TWITTER_SECRET` are found in lines _49_ and _50_ of [Const.swift](./IOSSwiftBoiler/Const.swift).

The Facebook _APP_ID_ can be found in [Info.plist](./IOSSwiftBoiler/Info.plst) as `FacebookAppID` key.

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
