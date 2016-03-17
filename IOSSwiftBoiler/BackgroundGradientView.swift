//
//  BackgroundGradientView.swift
//  ios-swift-boiler
//
//  Created by Godson Ukpere on 3/15/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit

class BackgroundGradientView: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.subviews.count == 0 {
            setup()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.subviews.count == 0 {
            setup()
        }
    }
    
    func setup() {
        if let backgroundImage = UIImage(named: "gradient") {
            self.backgroundColor = UIColor(patternImage: backgroundImage);
        }
    }
}
