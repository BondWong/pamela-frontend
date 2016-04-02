//
//  DiaryViewController.swift
//  Pamela
//
//  Created by Bond Wong on 6/8/15.
//  Copyright (c) 2015 Bond Wong. All rights reserved.
//

import UIKit

class DiaryViewController: PamelaViewController, UIWebViewDelegate {
    var diaryView: UIWebView!
    var diaryURL: String! = ""
    
    deinit {
        self.diaryView.stopLoading()
        self.diaryView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        diaryView = UIWebView()
        diaryView.delegate = self
        self.view.addSubview(diaryView)
        diaryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: diaryView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        diaryView.addConstraint(NSLayoutConstraint(item: diaryView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width))
        self.view.addConstraint(NSLayoutConstraint(item: diaryView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        let url = NSURL(string: diaryURL)
        let request = NSMutableURLRequest(URL: url!)
        diaryView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController() {
            self.diaryView.loadHTMLString("", baseURL: nil)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
    }
    
    override func showProjectPamelaInfo() {
        let pivc = ProjectInfomationViewController()
        self.navigationController?.pushViewController(pivc, animated: true)
    }

}
