//
//  ProjectInfomationViewController.swift
//  Pamela
//
//  Created by Bond Wong on 7/23/15.
//  Copyright (c) 2015 Bond Wong. All rights reserved.
//

import UIKit

class ProjectInfomationViewController: PamelaViewController, UIWebViewDelegate {
    private var aboutPage: UIWebView!
    let u = protocal + "://" + domain + ":" + port + "/about_mobile.jsp"
    
    deinit {
        aboutPage.stopLoading()
        aboutPage.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        aboutPage = UIWebView()
        aboutPage.delegate = self
        aboutPage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(aboutPage)
        self.view.addConstraint(NSLayoutConstraint(item: aboutPage, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        aboutPage.addConstraint(NSLayoutConstraint(item: aboutPage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width))
        self.view.addConstraint(NSLayoutConstraint(item: aboutPage, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        let url = NSURL(string: u)
        let request = NSMutableURLRequest(URL: url!)
        aboutPage.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController() {
            aboutPage.loadHTMLString("", baseURL: nil)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
