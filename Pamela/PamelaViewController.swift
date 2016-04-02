//
//  PamelaViewController.swift
//  Pamela
//
//  Created by Bond Wong on 6/9/15.
//  Copyright (c) 2015 Bond Wong. All rights reserved.
//

import UIKit

let protocal = "http"
let domain = "localhost"
let port = "8080"

let systemThumbnailHeight = 450.0
let systemThumbnailWidth = 600.0

class PamelaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        self.view = view
        
        let titleView = UIButton(type: UIButtonType.Custom)
        titleView.frame = CGRectMake(0, 0, 32, 32)
        titleView.setTitle("Pamela", forState: UIControlState.Normal)
        titleView.setTitleColor(UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1), forState: .Normal)
        titleView.addTarget(self, action: "showProjectPamelaInfo", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleView
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    func showProjectPamelaInfo() {
        
    }

}
