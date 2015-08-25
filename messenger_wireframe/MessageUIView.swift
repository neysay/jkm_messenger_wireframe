//
//  MessageUIView.swift
//
//  Created by Jacob Melvin on 1/30/15.
//  Copyright (c) 2015 Jacob Melvin. All rights reserved.
//

import UIKit

class MessageUIView: UIView {
    
    let profileSize:CGFloat = 30.0
    let footerSize:CGFloat = 15.0
    let messageBubbleWidth:CGFloat = 10.0
    let defaultProfileImage:UIImage! = UIImage(named: "generic_player_profile_300")
    let senderColor:UIColor! = UIColor(red: 0.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
    let recieverColor:UIColor! = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
    
    var isSender:Bool = false
    var infoView:UIView! = UIView()
    var senderView:UIView! = UIView()
    var senderImageView:UIImageView! = UIImageView()
    var senderCushion:UIView! = UIView()
    var recieverView:UIView! = UIView()
    var recieverImageView:UIImageView! = UIImageView()
    var recieverCushion:UIView! = UIView()
    var footerView:UILabel! = UILabel()
    var messageView:UIView! = UIView()
    var senderBubbleView:UIView! = UIView()
    var senderBubbleCushion:UIView! = UIView()
    var senderDrawView:UIImageView! = UIImageView()
    var recieverBubbleView:UIView! = UIView()
    var recieverBubbleCushion:UIView! = UIView()
    var recieverDrawView:UIImageView! = UIImageView()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure() {
        self.layoutMargins.top = 0.0
        self.layoutMargins.bottom = 0.0
        self.preservesSuperviewLayoutMargins = false
        
        self.setupViews()
        self.setupConstraints()
        self.footerView.textAlignment = NSTextAlignment.Center
        self.footerView.textColor = UIColor.lightGrayColor()
        self.footerView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        
        self.messageView.preservesSuperviewLayoutMargins = false
        self.messageView.layoutMargins.top = 0.0
        self.messageView.layoutMargins.bottom = 0.0

        //For debugging only
        //self.setClearColorForViews()
        //self.setUniqueColorForViews()
    }
    
    
    func setupViews() {
        
        self.recieverImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.senderImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.senderView.addSubview(self.senderImageView)
        self.senderView.addSubview(self.senderCushion)
        self.senderView.addSubview(self.senderBubbleView)
        
        self.recieverView.addSubview(self.recieverImageView)
        self.recieverView.addSubview(self.recieverCushion)
        self.recieverView.addSubview(self.recieverBubbleView)
        
        self.infoView.addSubview(self.messageView)
        self.infoView.addSubview(self.footerView)
        
        self.addSubview(self.senderView)
        self.addSubview(self.recieverView)
        self.addSubview(self.infoView)
    }
    
    func setupConstraints() {
        self.infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.senderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recieverView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.messageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.footerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints:[AnyObject] = []
        var visualFormat:String? = nil
        
        let views:NSDictionary = ["senderSpace": self.senderView,
            "recieverSpace": self.recieverView,
            "info": self.infoView,
            "message": self.messageView,
            "footer": self.footerView]
        
        
        visualFormat = "V:|-[senderSpace]-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.addConstraints(constraints)
        
        visualFormat = "V:|-[recieverSpace]-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.addConstraints(constraints)
        
        visualFormat = "V:|-[info]-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.addConstraints(constraints)
        
        
        visualFormat = "H:|[footer]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.infoView.addConstraints(constraints)
        
        visualFormat = "H:|[message]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.infoView.addConstraints(constraints)
        
        visualFormat = "V:|[message][footer(\(self.footerSize))]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        
    
        for constraint in constraints as! [NSLayoutConstraint]{
            if constraint.constant == self.footerSize {
                constraint.identifier = "footerHeight"
            }

        }
        self.infoView.addConstraints(constraints)
        
        visualFormat = "H:|-[recieverSpace(<=\(self.profileSize + self.messageBubbleWidth))][info][senderSpace(<=\(self.profileSize + self.messageBubbleWidth))]-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.addConstraints(constraints)
        
        self.setupMessageConstraints()

        
    }
    
    func setupMessageConstraints() {
        self.senderImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.senderCushion.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recieverImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recieverCushion.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.senderBubbleView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recieverBubbleView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints:[AnyObject] = []
        var visualFormat:String? = nil
        let views:NSDictionary = ["senderImage":self.senderImageView,
            "senderCushion": self.senderCushion,
            "senderBubble": self.senderBubbleView,
            "recieverImage":self.recieverImageView,
            "recieverCushion": self.recieverCushion,
            "recieverBubble": self.recieverBubbleView,
        ]
        
        
        visualFormat = "H:|[senderBubble(<=\(self.messageBubbleWidth))][senderImage(<=\(self.profileSize))]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.senderView.addConstraints(constraints)
        
        visualFormat = "H:|[senderCushion]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.senderView.addConstraints(constraints)
        
        visualFormat = "H:|[recieverImage(<=\(self.profileSize))][recieverBubble(<=\(self.messageBubbleWidth))]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.recieverView.addConstraints(constraints)
        
        visualFormat = "H:|[recieverCushion]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.recieverView.addConstraints(constraints)
        
        visualFormat = "V:|[recieverImage(\(self.profileSize))][recieverCushion]-\(self.footerSize)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.recieverView.addConstraints(constraints)
        
        visualFormat = "V:|[recieverBubble]-\(self.footerSize)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.recieverView.addConstraints(constraints)
        
        visualFormat = "V:|[senderCushion][senderImage(\(self.profileSize))]-\(self.footerSize)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.senderView.addConstraints(constraints)
        
        visualFormat = "V:|[senderBubble]-\(self.footerSize)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.senderView.addConstraints(constraints)
    
    }
    
    func adjustFooterSize(heightDelta:CGFloat?) {
        //compacts message size by delta
        for constraint in self.infoView.constraints() as! [NSLayoutConstraint]{
            if constraint.identifier == "footerHeight" {
                if let changeHeightTo = heightDelta where changeHeightTo <= self.footerSize {
                    constraint.constant = changeHeightTo
                }
                else if !constraint.constant.isZero {
                    constraint.constant = 0.0
                }
            }
        }
    }
    
    func revertFooterSize(heightDelta:CGFloat) {
        for constraint in self.infoView.constraints() as! [NSLayoutConstraint]{
            if constraint.identifier == "footerHeight" {
                constraint.constant = self.footerSize
            }
        }

    }
    
    func hasActiveConstraints() -> Bool {
        return self.constraints().count > 0 ? true : false
    }
    
    func setFooterData(content:String) {
        if self.isSender {
            self.footerView.textAlignment = NSTextAlignment.Right
        }
        else {
            self.footerView.textAlignment = NSTextAlignment.Left
        }
        
        self.footerView.text = content
    }
    
    func setProfile(profileImage:UIImage?=nil) {
        //Hide sender only if message not coming from user
        self.senderView.hidden = !self.isSender
        //Hide reciever only if message is coming from user
        self.recieverView.hidden = self.isSender
        
        if self.isSender {
            self._setProfileImage(self.senderImageView, sourceImage: profileImage)
            if self.messageView.backgroundColor != self.senderColor {
                self.messageView.backgroundColor = self.senderColor
            }
            
        }
        else {
            self._setProfileImage(self.recieverImageView, sourceImage: profileImage)
            if self.messageView.backgroundColor != self.recieverColor {
                self.messageView.backgroundColor = self.recieverColor
            }
        }

    }
    
    final private func _setProfileImage(destImageView:UIImageView!, sourceImage:UIImage?){
        if let currentImageView = destImageView.image, let image = sourceImage where !currentImageView.isEqual(image) {
            destImageView.image = sourceImage
        }
        else if let currentImageView = destImageView.image where sourceImage == nil && !currentImageView.isEqual(self.defaultProfileImage) {
            destImageView.image = self.defaultProfileImage
        }
        else if let image = sourceImage where destImageView.image == nil {
            destImageView.image = sourceImage
        }
        else if destImageView.image == nil && sourceImage == nil {
            destImageView.image = self.defaultProfileImage
        }
    }
    
    //-----Debug Purposes Only------//
    private func setUniqueColorForViews(){
        //Strictly for debugging purposes to visualize view layouts//
        self.infoView.backgroundColor = UIColor.orangeColor()
        
        self.senderView.backgroundColor = UIColor.yellowColor()
        self.senderImageView.backgroundColor = UIColor.grayColor()
        self.senderCushion.backgroundColor = UIColor(red: 1.0, green: 169/255, blue: 209/255, alpha: 1.0)
        
        self.recieverView.backgroundColor = UIColor.yellowColor()
        self.recieverImageView.backgroundColor = UIColor.grayColor()
        self.recieverCushion.backgroundColor = UIColor(red: 1.0, green: 169/255, blue: 209/255, alpha: 1.0)
        
        self.footerView.backgroundColor = UIColor(red: 94/255.0, green: 88/255.0, blue: 153/255.0, alpha: 1.0)
        self.messageView.backgroundColor = UIColor(red: 94/255.0, green: 223/255.0, blue: 124/255.0, alpha: 1.0)
        
        self.senderBubbleView.backgroundColor = UIColor.greenColor()
        self.recieverBubbleView.backgroundColor = UIColor.greenColor()
        
        self.senderDrawView.backgroundColor = UIColor.redColor()
        self.recieverDrawView.backgroundColor = UIColor.redColor()
        
        self.senderBubbleCushion.backgroundColor = UIColor.blackColor()
        self.recieverBubbleCushion.backgroundColor = UIColor.blackColor()
    }
    
    private func setClearColorForViews(){
        self.infoView.backgroundColor = UIColor.clearColor()
        
        self.senderView.backgroundColor = UIColor.clearColor()
        self.senderImageView.backgroundColor = UIColor.clearColor()
        self.senderCushion.backgroundColor = UIColor.clearColor()
        
        self.recieverView.backgroundColor = UIColor.clearColor()
        self.recieverImageView.backgroundColor = UIColor.clearColor()
        self.recieverCushion.backgroundColor = UIColor.clearColor()
        
        self.footerView.backgroundColor = UIColor.clearColor()
        self.messageView.backgroundColor = UIColor.clearColor()
        self.senderBubbleView.backgroundColor = UIColor.clearColor()
        self.recieverBubbleView.backgroundColor = UIColor.clearColor()
    }
    
    
}
