//
//  TextInputViewController.swift
//  TextInputModalTest
//
//  Created by Jacob Melvin on 11/27/14.
//  Copyright (c) 2014 Jacob Melvin. All rights reserved.
//

import UIKit

class TextInputViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    var tableView:UITableView! = UITableView(frame: CGRectZero)
    let cellIdentifier = "Cell"
    
    @IBOutlet var userInputView: KeyboardInputView! = KeyboardInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSetup()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.tableView.registerClass(ConvoTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.scrollEnabled = true
        self.tableView.scrollsToTop = true
        self.tableView.separatorColor = UIColor.clearColor()
        
        self.userInputView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.userInputView.userContentView = self.tableView
        self.view.addSubview(self.userInputView)

        self.userInputView.setupSubViews()
        self.userInputView.setupConstraints()
        self.userInputView.backgroundColor = UIColor.whiteColor()
        self.userInputView.userContentView.backgroundColor = UIColor.clearColor()

        self.userInputView.recipientView.hidden = true
        self.userInputView.updateConstaintsAndSetActiveTo(true)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.userInputView.userContentView.contentInset.top = 5.0
        if !self.userInputView.recipientView.hidden {
            self.userInputView.recipientTextField.becomeFirstResponder()
        }

    }
    
    func navigationBarSetup() {
        let titleImageView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let convoTitleImage = UIImage(named: "generic_player_profile_300")
        let titleButton = UIButton()
        titleButton.setBackgroundImage(convoTitleImage, forState: UIControlState.Normal)
        titleButton.frame = titleImageView.frame
        titleButton.contentMode = UIViewContentMode.ScaleAspectFit
        
        titleImageView.addSubview(titleButton)

        self.navigationItem.titleView = titleImageView
        self.navigationItem.titleView?.contentMode = UIViewContentMode.ScaleAspectFit

    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.userInputView.updateConstaintsAndSetActiveTo(true)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animateAlongsideTransition({ context in
            self.userInputView.updateConstaintsAndSetActiveTo(true)
            }, completion: {_ in
                //nil
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ConvoTableViewCell
        cell.backgroundColor = UIColor.clearColor()

        if !cell.hasActiveConstraints() {
            cell.configure()
            srandom(UInt32(time(nil)))
            
        }
        
        // Randomize the sender vs reciever choice
        // Just for display purposes
        cell.messageItem.isSender = Bool((indexPath.row % 2) * (random() % 2))
        cell.messageItem.setProfile(profileImage: nil)


        //Just to look a little prettier//
        cell.layoutIfNeeded()
        cell.messageItem.messageView.layer.cornerRadius = 0.02 * cell.messageItem.messageView.bounds.size.width
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
}