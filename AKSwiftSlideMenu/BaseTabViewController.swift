//
//  BaseTabViewController.swift
//  WaveInsure
//
//  Created by Amr Abd El Wahab on 12/14/15.
//  Copyright © 2015 ITGSolutions. All rights reserved.
//


import UIKit

class BaseTabViewController: UITabBarController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        //Looks for single or multiple taps.
        
        /* let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)*/
        
        
    }
    func setNavigationTitle(title:String){
        self.navigationItem.title = title
    }
    func hideBackButton(){
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    //Calls this function when the tap is recognized.
    /* func DismissKeyboard(){
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
    }*/
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe Left")
            /*   var labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 50.0, self.swipeLabel.frame.origin.y);
            swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height)*/
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            self.onSlideMenuButtonPressed(btnShowMenu)
            /*  var labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 50.0, self.swipeLabel.frame.origin.y);
            swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height)*/
        }
    }
    
    let MenuMain = 0 , MenuTabController = 1 ,MenuLogout = 2
    
    var isOpened = false;
    
    func slideMenuItemSelectedAtIndex(index: Int) {
        //        let topViewController : UIViewController = self.navigationController!.topViewController!
        var viewController:UIViewController!
        switch(index){
        case MenuMain:
            viewController =  self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            break
        case MenuTabController:
            viewController =  self.storyboard!.instantiateViewControllerWithIdentifier("TabViewController") as! TabViewController
            break
        case MenuLogout:
            let alertController = UIAlertController(title: "Logout", message: "Do you want to logout", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Yes", style: .Default) {
                (action:UIAlertAction!) in
                viewController =  self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                self.navigationController!.setViewControllers([viewController], animated: true)
            }
            let cancelAction = UIAlertAction(title: "No", style: .Cancel)
                { (action:UIAlertAction!) in }
            
            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion:nil)
            
            
            //TODO:clear data on logout
            break
        default:
            print("default\n")
        }
        if viewController != nil {
            //self.navigationController?.presentViewController(viewController, animated: true, completion: nil)
            //self.navigationController?.popToViewController(viewController, animated: true)
            //self.navigationController?.pushViewController(viewController, animated: true)
            self.navigationController!.setViewControllers([viewController], animated: true)
        }
        
    }
    
    var btnShowMenu:UIButton!
    func addSlideMenuButton(direction:String){
        btnShowMenu = UIButton(type: UIButtonType.System)
        btnShowMenu.setImage(UIImage(named: MenuViewController.menuIcon), forState: UIControlState.Normal)
        btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
        btnShowMenu.addTarget(self, action: "onSlideMenuButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        
        if direction == "left" {
            self.navigationItem.leftBarButtonItem = customBarItem;
        }else if direction == "right"{
            self.navigationItem.rightBarButtonItem = customBarItem;
        }
    }
    
    func addBackButton(title:String,action:Selector){
        self.navigationItem.backBarButtonItem = nil
        let backArrowBarButton = UIBarButtonItem(image: UIImage(named: "back_arrow"), style:.Done, target: self, action: action)
        backArrowBarButton.imageInsets = UIEdgeInsetsMake(0.0, -20, 0, -60);
        let backBarButton = UIBarButtonItem(title: title,style:.Done, target: self, action: action)
        self.navigationItem.leftBarButtonItems = [backArrowBarButton , backBarButton]
    }

    func onSlideMenuButtonPressed(sender : UIButton){
        if sender.tag == 0 {
            UIView.animateWithDuration(3, animations: { () -> Void in
                self.btnShowMenu.setImage(UIImage(named: MenuViewController.menuBackIcon), forState: UIControlState.Normal)
                }, completion: { (finished) -> Void in
                    //  viewMenuBack.removeFromSuperview()
            })
        }else {
            UIView.animateWithDuration(3, animations: { () -> Void in
                self.btnShowMenu.setImage(UIImage(named: MenuViewController.menuIcon), forState: UIControlState.Normal)
                }, completion: { (finished) -> Void in
                    //  viewMenuBack.removeFromSuperview()
            })
        }
        
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clearColor()
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.enabled = false
        sender.tag = 10
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let menuVC : MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        //shadow
        menuVC.view.layer.shadowColor = UIColor.grayColor().CGColor;
        menuVC.view.layer.shadowOffset = CGSizeMake(2, 2);
        menuVC.view.layer.shadowOpacity = 0.7;
        menuVC.view.layer.shadowRadius = 1.0;
        
        
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            menuVC.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
            sender.enabled = true
            }, completion:nil)
    }
}
