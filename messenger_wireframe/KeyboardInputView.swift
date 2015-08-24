//
//  KeyboardInputView.swift
//  TextInputModalTest
//
//  Created by Jacob Melvin on 11/30/14.
//  Copyright (c) 2014 Jacob Melvin. All rights reserved.
//

import UIKit

class KeyboardInputView: UIView, UITextViewDelegate {
    let KEYBOARD_INPUT_VIEW_MARGIN_VERTICAL:Float = 3.0
    let KEYBOARD_INPUT_VIEW_MARGIN_HORIZONTAL:Float = 8.0
    let KEYBOARD_INPUT_VIEW_MARGIN_BUTTONS_VERTICAL:Float = 7.0
    
    var inputToolBar:UIToolbar! = UIToolbar()
    var inputTextView:UITextView! = UITextView()
    var leftButton:UIButton! = UIButton()
    var rightButton:UIButton! = UIButton()
    var userContentView:UIScrollView! = UIScrollView()
    var controlView:UIView! = UIView()
    var recipientView:UIView! = UIView()
    var toLabel:UILabel! = UILabel()
    var recipientTextField:UITextField! = UITextField()
    var recipientToolBar:UIToolbar! = UIToolbar()
    var recipientAddButton:UIButton! = UIButton.buttonWithType(UIButtonType.ContactAdd) as! UIButton
    var currentTextHeight:CGFloat = 0.0
    var keyboardHeight:CGFloat? = nil
    
    //Set this if you want to lock text input height after a threshold
    //Update for vertical vs horizontal display
    // nil -> infinite max height
    var maxInputTextHeight:CGFloat? = 100.0
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.controlView.backgroundColor = UIColor.clearColor()
        self.userContentView = UIScrollView(frame: CGRectZero)
        self.registerNotifications()
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.setupSubViews()
    }

    deinit{
        self.unregisterNotifications()
    }
    
    func registerNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unregisterNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func setupSubViews(){
        
        self.inputToolBar.translucent = true
        self.recipientToolBar.translucent = true
        self.recipientView.backgroundColor = UIColor.clearColor()
        
        //self.inputToolBar.backgroundColor = UIColor.blackColor()
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleTopMargin
        self.controlView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.userContentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.recipientView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        self.setupTextView()
        self.setupLeftButton()
        self.setupRightButton()
        self.setupToLabel()
        self.setupRecipientTextField()
        self.setupRecipientAddButton()
        
        self.controlView.addSubview(self.inputToolBar)
        self.controlView.addSubview(self.inputTextView)
        self.controlView.addSubview(self.leftButton)
        self.controlView.addSubview(self.rightButton)
        
        self.recipientView.addSubview(self.recipientToolBar)
        self.recipientView.addSubview(self.toLabel)
        self.recipientView.addSubview(self.recipientTextField)
        self.recipientView.addSubview(self.recipientAddButton)
   
        self.addSubview(self.userContentView)
        self.addSubview(self.recipientView)
        self.addSubview(self.controlView)
        
    }
    
    func setupTextView(){
        self.inputTextView.font = UIFont.systemFontOfSize(14.0)
        self.inputTextView.layer.cornerRadius = 5.0
        self.inputTextView.layer.borderWidth = 1.0
        self.inputTextView.layer.borderColor = UIColor.blackColor().CGColor
        self.inputTextView.delegate = self
        self.inputTextView.scrollsToTop = false
    }
    
    func setupLeftButton(){
        self.leftButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        self.leftButton.setTitle("Options", forState: UIControlState.Normal)
        self.leftButton.setTitleColor(UIColor.purpleColor(), forState: UIControlState.Normal)
        self.leftButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Highlighted)
    }
    
    func setupRightButton(){
        self.rightButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        self.rightButton.setTitle("Send", forState: UIControlState.Normal)
        self.rightButton.setTitleColor(UIColor.purpleColor(), forState: UIControlState.Normal)
        self.rightButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled)
        self.rightButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Highlighted)
        self.rightButton.enabled = false

    }
    
    func setupToLabel() {
        self.toLabel.text = "To: "
        self.toLabel.textAlignment = NSTextAlignment.Left
        self.toLabel.numberOfLines = 1
        self.toLabel.font = UIFont.systemFontOfSize(15.0)
    }
    
    func setupRecipientTextField(){
        self.recipientTextField.textAlignment = NSTextAlignment.Left
        self.recipientTextField.font = UIFont.systemFontOfSize(15.0)
    }

    func setupRecipientAddButton(){
        self.recipientAddButton.backgroundColor = UIColor.clearColor()
        //Add button management code here//
    }
    
    func getInputViewHeight() -> CGFloat{
        var newInputHeight = self.getTextViewHeight(self.inputTextView)
        newInputHeight = newInputHeight + (2 * CGFloat(KEYBOARD_INPUT_VIEW_MARGIN_VERTICAL))
        newInputHeight = ceil(newInputHeight)

        return self.maxInputTextHeight != nil ? floor(min(newInputHeight,self.maxInputTextHeight!)) : newInputHeight
        
    }
    
    func getTextViewHeight(textView:UITextView) -> CGFloat{
        let textContainer = textView.textContainer
        let textRect = textView.layoutManager.usedRectForTextContainer(textContainer)
        let textViewHeight:CGFloat = textRect.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom
        
        return textViewHeight
    }
    
    func getRecipientHeight() -> CGFloat {
        //var height:CGFloat = 0.0
        //if self.recipientView.hidden {
        //    height = 0.0
        //}
        //else{
        //    height = 35.0 // default
        //}

        //return height
        return self.recipientView.hidden ? 0.0 : 35.0
    }
    
    func setupConstraints(){
        let textViewHeight = self.getInputViewHeight()
        self.leftButton.sizeToFit()
        self.rightButton.sizeToFit()
        self.toLabel.sizeToFit()
        self.recipientAddButton.sizeToFit()
        
        let leftButtonHR = round(textViewHeight - self.leftButton.frame.height)
        let leftButtonMargin = leftButtonHR / 2.0
        
        let rightButtonHR = round(textViewHeight - self.rightButton.frame.height)
        let rightButtonMargin = rightButtonHR / 2.0

        self.recipientView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.userContentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.controlView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints:[AnyObject] = []
        var visualFormat:String? = nil
        let views:NSDictionary = [ "content": self.userContentView,
            "control": self.controlView,
            "recipient" :self.recipientView]
        
        let metrics:NSDictionary = ["hor": KEYBOARD_INPUT_VIEW_MARGIN_HORIZONTAL,
            "ver": KEYBOARD_INPUT_VIEW_MARGIN_VERTICAL ,
            "leftButtonMargin": leftButtonMargin,
            "rightButtonMargin": rightButtonMargin]
        
        self.setupControlViewConstraints()
        self.setupRecipientViewConstraints()
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[content]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[control]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[recipient]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        self.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[recipient(\(self.getRecipientHeight()))][content][control(\(self.getInputViewHeight()))]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views as [NSObject : AnyObject])
        
        //tag a few constraints with unique identifiers
        // to allow for later modifications
        for constraint in constraints as! [NSLayoutConstraint]{
            if constraint.constant == self.getInputViewHeight() {
                constraint.identifier = "controlViewHeight"
                //println(constraint.firstItem)
            }
            else if constraint.constant == self.getRecipientHeight() {
                constraint.identifier = "recipientViewHeight"
            }
        }
        self.addConstraints(constraints)
        
    }
    
    func setupControlViewConstraints(){
        let textViewHeight = self.getInputViewHeight()
        self.leftButton.sizeToFit()
        self.rightButton.sizeToFit()

        let leftButtonHR = round(textViewHeight - self.leftButton.frame.height)
        let leftButtonMargin = leftButtonHR / 2.0
        
        let rightButtonHR = round(textViewHeight - self.rightButton.frame.height)
        let rightButtonMargin = rightButtonHR / 2.0
        
        self.inputToolBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.inputTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.rightButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints:[AnyObject] = []
        var visualFormat:String? = nil
        let views:NSDictionary = [
            "control": self.controlView,
            "leftButton": self.leftButton,
            "rightButton": self.rightButton ,
            "textView": self.inputTextView,
            "toolbar": self.inputToolBar]
        
        let metrics:NSDictionary = ["hor": KEYBOARD_INPUT_VIEW_MARGIN_HORIZONTAL,
            "ver": KEYBOARD_INPUT_VIEW_MARGIN_VERTICAL ,
            "leftButtonMargin": leftButtonMargin,
            "rightButtonMargin": rightButtonMargin]
        
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[toolbar]|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.controlView.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[toolbar]|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.controlView.addConstraints(constraints)
        
        visualFormat = "H:|-(==hor)-[leftButton]-(==hor)-[textView]-(==hor)-[rightButton]-(==hor)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.controlView.addConstraints(constraints)
        
        visualFormat = "V:|-(>=leftButtonMargin)-[leftButton]-(==leftButtonMargin)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.controlView.addConstraints(constraints)
        
        
        visualFormat = "V:|-(>=rightButtonMargin)-[rightButton]-(==rightButtonMargin)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.controlView.addConstraints(constraints)
        
        visualFormat = "V:|-(==ver)-[textView]-(==ver)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.controlView.addConstraints(constraints)
        
    }
    
    func setupRecipientViewConstraints(){
        let rViewHeight = self.getRecipientHeight()
        
        let leftButtonHR = round(rViewHeight - self.toLabel.frame.height)
        let leftButtonMargin = leftButtonHR / 2.0
        let rightButtonHR = round(rViewHeight - self.recipientAddButton.frame.height)
        let rightButtonMargin = rightButtonHR / 2.0
        
        self.toLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recipientTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recipientToolBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recipientAddButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints:[AnyObject] = []
        var visualFormat:String? = nil
        let views:NSDictionary = ["recipient" :self.recipientView,
            "toLabel": self.toLabel,
            "recipientText": self.recipientTextField,
            "recipientAdd": self.recipientAddButton,
            "recipientToolbar": self.recipientToolBar]
        
        let metrics:NSDictionary = ["hor": KEYBOARD_INPUT_VIEW_MARGIN_HORIZONTAL,
            "ver": KEYBOARD_INPUT_VIEW_MARGIN_VERTICAL ,
            "leftButtonMargin": leftButtonMargin,
            "rightButtonMargin": rightButtonMargin]
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[recipientToolbar]|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.recipientView.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[recipientToolbar]|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.recipientView.addConstraints(constraints)

        visualFormat = "H:|-(==hor)-[toLabel(25)]-(==hor)-[recipientText]-(==hor)-[recipientAdd]-(==hor)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.recipientView.addConstraints(constraints)
        
        
        visualFormat = "V:|-(<=leftButtonMargin)-[toLabel]-(==leftButtonMargin)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.recipientView.addConstraints(constraints)
        
        visualFormat = "V:|-(<=rightButtonMargin)-[recipientText]-(==rightButtonMargin)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.recipientView.addConstraints(constraints)
        
        
        visualFormat = "V:|-(<=rightButtonMargin)-[recipientAdd]-(==rightButtonMargin)-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat!, options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject])
        self.recipientView.addConstraints(constraints)
    }
    
    func textViewDidChange(textView: UITextView) {
        let textViewH = self.getInputViewHeight()
        
        // turn on/off ability to send text messages
        self.rightButton.enabled = !textView.text.isEmpty
        
        if textViewH != self.currentTextHeight {
            self.updateConstaintsAndSetActiveTo(true)
            self.layoutIfNeeded()
            self.currentTextHeight = textViewH
            self.scrollToBottomOfContent(false)
            
            //Guaruntee that the scroll bar is positioned 
            //at the top of the textview
            let textLength = (self.inputTextView.text as NSString).length
            self.inputTextView.scrollRangeToVisible(NSRange(location:0,length:(textLength)))
            
        }
    }

    func updateConstaintsAndSetActiveTo(enable:Bool){
        for constraint:NSLayoutConstraint in self.constraints() as! [NSLayoutConstraint]{
            if constraint.identifier == "controlViewHeight"{
                constraint.constant = self.getInputViewHeight()
            }
            if constraint.identifier == "recipientViewHeight"{
                constraint.constant = self.getRecipientHeight()
            }
            constraint.active = enable
        }
    }
    
    func scrollToBottomOfContent(animated:Bool, offset:CGFloat = 0.0){
        //Scroll to the bottom
        let viewRect = CGRect(x: 0, y: self.userContentView.contentSize.height - self.userContentView.frame.height, width: self.userContentView.frame.width, height: self.userContentView.frame.height)

        //Offset allows for consideration of keyboard displayed, typing indicators, etc...
        if (self.userContentView.contentSize.height + offset) >= self.userContentView.frame.height {
            //println("scrolling to bottom activated")
            self.userContentView.scrollRectToVisible(viewRect, animated: animated)
        }
        
    }
    
    func keyboardWillShow(notification : NSNotification){
        //println("keyboard show")
        let info:NSDictionary = notification.userInfo as NSDictionary!
        let currKbSize:CGSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size as CGSize!
        let kbDuration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        let currKbEndSize = info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size as CGSize!
        
        self.scrollToBottomOfContent(true, offset:currKbEndSize.height)
        UIView.animateWithDuration(kbDuration, animations: {
            self.controlView.transform = CGAffineTransformMakeTranslation(0,-currKbEndSize.height)
            self.userContentView.contentInset.bottom =  currKbEndSize.height
            self.scrollToBottomOfContent(false,offset: currKbEndSize.height)
            }, completion: { _ in
                self.keyboardHeight = currKbEndSize.height
        })

    }
    
    func keyboardWillHide(notification: NSNotification){
        let info:NSDictionary = notification.userInfo as NSDictionary!
        let kbDuration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        UIView.animateWithDuration(kbDuration, animations: {
            self.controlView.transform = CGAffineTransformMakeTranslation(0,0)
            self.userContentView.contentInset.bottom = 0.0
            //self.contentView.frame.size.height = self.controlView.frame.origin.y
            }, completion: { _ in
                self.keyboardHeight = nil
        })
    }


}
