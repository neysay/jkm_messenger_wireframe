//
//  ConvoTableViewCell.swift
//  TextInputModalTest
//
//  Created by Jacob Melvin on 1/25/15.
//  Copyright (c) 2015 Jacob Melvin. All rights reserved.
//

import UIKit

class ConvoTableViewCell: UITableViewCell {

    let KEYBOARD_INPUT_VIEW_MARGIN_VERTICAL:Float = 3.0
    let KEYBOARD_INPUT_VIEW_MARGIN_HORIZONTAL:Float = 8.0
    let KEYBOARD_INPUT_VIEW_MARGIN_BUTTONS_VERTICAL:Float = 7.0
    
    var messageItem:MessageUIView! = MessageUIView(frame: CGRectZero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configure()
    {
        self.addSubview(self.messageItem)
        self.setupConstraints()
        self.messageItem.configure()
    }
    
    func hasActiveConstraints() -> Bool {
        if self.messageItem.hasActiveConstraints() || (self.constraints().count > 0) {
            return true
        }
        else {
            return false
        }
    }
    
    func setupConstraints() {
        self.messageItem.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints:NSArray? = nil
        var visualFormat:NSString? = nil
        
        var views:NSDictionary = [ "messageItem": self.messageItem]
        
        var metrics:NSDictionary = ["hor": KEYBOARD_INPUT_VIEW_MARGIN_HORIZONTAL,
            "ver": KEYBOARD_INPUT_VIEW_MARGIN_VERTICAL]
        
        visualFormat = "V:|[messageItem]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat! as String, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.addConstraints(constraints! as [AnyObject])
        
       
        visualFormat = "H:|[messageItem]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat! as String, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.addConstraints(constraints! as [AnyObject])
    }

}
