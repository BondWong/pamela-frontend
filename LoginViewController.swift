//
//  LoginViewController.swift
//  Pamela
//
//  Created by Bond Wong on 7/27/15.
//  Copyright (c) 2015 Bond Wong. All rights reserved.
//

import UIKit

var user: [String: NSObject]!

class LoginViewController: UIViewController {
    private var nameTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    
    private let textViewFontName = "AvenirNext-Regular"
    private let buttonFontName = "AvenirNextCondensed-Bold"
    
    lazy var session: NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let s = NSURLSession(configuration: config, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        return s
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        user = NSUserDefaults.standardUserDefaults().objectForKey("user") as! [String: NSObject]!
        if user == nil {
            
            UIGraphicsBeginImageContext(UIScreen.mainScreen().bounds.size)
            UIImage(named: "LoginBackground")?.drawInRect(UIScreen.mainScreen().bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
            // NavigationBar Init Start
            let navigationBar = UINavigationBar()
            navigationBar.barStyle = UIBarStyle.Black
            navigationBar.translucent = true
            let navigationItem = UINavigationItem()
            navigationBar.items = [navigationItem]
            let navigationItemTitleView = UIButton(type: UIButtonType.Custom)
            navigationItemTitleView.frame = CGRectMake(0, 0, 32, 32)
            navigationItemTitleView.setTitle("Pamela", forState: UIControlState.Normal)
            navigationItemTitleView.setTitleColor(UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1), forState: .Normal)
            navigationItem.titleView = navigationItemTitleView
            
            self.view.addSubview(navigationBar)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            navigationBar.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width))
            self.view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem:
                self.view, attribute: .Top, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
            navigationBar.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
            // NavigationBar Init End
            
            // TextView Init Start
            let visualEffectViewForNameTextView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
            visualEffectViewForNameTextView.clipsToBounds = true
            self.view.addSubview(visualEffectViewForNameTextView)
            visualEffectViewForNameTextView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForNameTextView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForNameTextView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 2.5/3, constant: 0))
            visualEffectViewForNameTextView.addConstraint(NSLayoutConstraint(item: visualEffectViewForNameTextView, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.8 * UIScreen.mainScreen().bounds.width))
            visualEffectViewForNameTextView.addConstraint(NSLayoutConstraint(item: visualEffectViewForNameTextView, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.087 * UIScreen.mainScreen().bounds.height))
            
            nameTextField = UITextField()
            nameTextField.backgroundColor = UIColor.clearColor()
            nameTextField.textColor = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 0.6)
            nameTextField.font = UIFont(name: textViewFontName, size: 35)
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Your Name", attributes: [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 0.3)])
            self.view.addSubview(nameTextField)
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(item: nameTextField, attribute: .CenterX, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .CenterX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: nameTextField, attribute: .CenterY, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .CenterY, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: nameTextField, attribute: .Width, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .Width, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: nameTextField, attribute: .Height, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .Height, multiplier: 1, constant: 0))
            
            let visualEffectViewForPasswordTextView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
            visualEffectViewForPasswordTextView.clipsToBounds = true
            self.view.addSubview(visualEffectViewForPasswordTextView)
            visualEffectViewForPasswordTextView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForPasswordTextView, attribute: .CenterX, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .CenterX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForPasswordTextView, attribute: .Width, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .Width, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForPasswordTextView, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .Height, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForPasswordTextView, attribute: .Top, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .Bottom, multiplier: 1.03, constant: 0))
            
            passwordTextField = UITextField()
            passwordTextField.backgroundColor = UIColor.clearColor()
            passwordTextField.textColor = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 0.6)
            passwordTextField.font = UIFont(name: textViewFontName, size: 35)
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 0.3)])
            passwordTextField.secureTextEntry = true
            self.view.addSubview(passwordTextField)
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(item: passwordTextField, attribute: .CenterX, relatedBy: .Equal, toItem: visualEffectViewForPasswordTextView, attribute: .CenterX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: passwordTextField, attribute: .CenterY, relatedBy: .Equal, toItem: visualEffectViewForPasswordTextView, attribute: .CenterY, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: passwordTextField, attribute: .Width, relatedBy: .Equal, toItem: visualEffectViewForPasswordTextView, attribute: .Width, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: passwordTextField, attribute: .Height, relatedBy: .Equal, toItem: visualEffectViewForPasswordTextView, attribute: .Height, multiplier: 1, constant: 0))
            
            loginButton = UIButton(type: UIButtonType.Custom)
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: .Normal)
            loginButton.titleLabel?.font = UIFont(name: buttonFontName, size: 25)
            loginButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1)
            loginButton.addTarget(self, action: "login", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(loginButton)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .CenterX, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .CenterX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Width, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .Width, multiplier: 1/2, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Height, relatedBy: .Equal, toItem: visualEffectViewForNameTextView, attribute: .Height, multiplier: 3/4, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Top, relatedBy: .Equal, toItem: visualEffectViewForPasswordTextView, attribute: .Bottom, multiplier: 1.06, constant: 0))
            
        } else {
            var error: NSError?
            let url = protocal + "://" + domain + ":" + port + "/pamela/account/login"
            let u = NSURL(string: url)
            let request = NSMutableURLRequest(URL: u!)
            request.HTTPMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["name": user["name"]!, "password": user["password"]!, "remember-me": false], options: NSJSONWritingOptions.PrettyPrinted)
            } catch let error1 as NSError {
                error = error1
                request.HTTPBody = nil
            }
            let task = session.dataTaskWithRequest(request, completionHandler: {[unowned self]data, response, error in
                let r: NSHTTPURLResponse = response as! NSHTTPURLResponse
                if r.statusCode == 200 {
                    self.performSegueWithIdentifier("intoDiaryCategory", sender: self)
                } else {
                    let alertController = UIAlertController(title: NSLocalizedString("Name and Password are incorrect", comment: "Name and Password are incorrect"), message: NSLocalizedString("Try angin or contact your boyfriend", comment: "Try_Again"), preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Destructive, handler: {_ in
                    })
                    alertController.addAction(ok)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                })
            task.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if nameTextField != nil && nameTextField.isFirstResponder() {
            nameTextField.resignFirstResponder()
        } else if passwordTextField != nil && passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        } 
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func login() {
        loginButton.setTitle("Connecting...", forState: UIControlState.Normal)
        
        let name = nameTextField.text
        let password = passwordTextField.text
        var error: NSError?
        
        let url = protocal + "://" + domain + ":" + port + "/pamela/account/login"
        let u = NSURL(string: url)
        let request = NSMutableURLRequest(URL: u!)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["name": name, "password": password, "remember-me": false], options: NSJSONWritingOptions.PrettyPrinted)
        } catch var error1 as NSError {
            error = error1
            request.HTTPBody = nil
        }
        let task = session.dataTaskWithRequest(request, completionHandler: {[unowned self]data, response, error in
            let r: NSHTTPURLResponse = response as! NSHTTPURLResponse
            if r.statusCode == 200 {
                var e: NSError?
                user = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! [String: NSObject]
                user.removeValueForKey("originalURL")
                user.removeValueForKey("theme")
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(user, forKey: "user")
                userDefault.synchronize()
                
                self.performSegueWithIdentifier("intoDiaryCategory", sender: self)
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("Name and Password are incorrect", comment: "Name and Password are incorrect"), message: NSLocalizedString("Try angin or contact your boyfriend", comment: "Try_Again"), preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Destructive, handler: {_ in
                })
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            self.loginButton.setTitle("Login", forState: UIControlState.Normal)
            })
        task.resume()
    }
    
}
