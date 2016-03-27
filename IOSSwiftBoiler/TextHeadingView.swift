//
//  TextHeadingView.swift
//  Replay
//
//  Created by Godson Ukpere on 3/15/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit

class TextHeadingView: UIView {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBInspectable var messageText: String? {
        get {
            return textLabel.text
        }
        
        set(text) {
            textLabel.text = text
            textLabel.numberOfLines = 1
            textLabel.sizeToFit()
        }
    }
    
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
    
    func tapAction(sender: AnyObject) {
        callback()
    }
    
    var callback:()->() = {
        print("Du auswahlen das Anzeige")
    }

    func setup() {
        if let view = NSBundle.mainBundle().loadNibNamed("TextHeadingView", owner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            addSubview(view)
            textLabel = textLabel ?? view.subviews[0] as! UILabel
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
}
