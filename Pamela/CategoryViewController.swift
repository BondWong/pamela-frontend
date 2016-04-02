//
//  CategoryViewController.swift
//  Pamela
//
//  Created by Bond Wong on 6/3/15.
//  Copyright (c) 2015 Bond Wong. All rights reserved.
//

import UIKit

class CategoryViewController: PamelaViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDataDelegate {
    //private var backgroundTimmer: NSTimer!
    //private var backgroundNum = 1
    
    let cornerRadius = CGFloat(10)
    var contentTable: UITableView!
    
    lazy var session: NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let s = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        return s}()
    
    var data: NSMutableData = NSMutableData(length: 0)!
    var diaries: [[String: NSObject]]! = []
    var hasNext = true
    let pageSize = 10
    var startIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        UIGraphicsBeginImageContext(UIScreen.mainScreen().bounds.size)
        UIImage(named: "Background")?.drawInRect(UIScreen.mainScreen().bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        /*backgroundTimmer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "setBackground", userInfo: nil, repeats: true)
        backgroundTimmer.fire()*/
        
        let visualEffectViewForContentTable = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectViewForContentTable.layer.cornerRadius = cornerRadius
        visualEffectViewForContentTable.clipsToBounds = true
        self.view.addSubview(visualEffectViewForContentTable)
        visualEffectViewForContentTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForContentTable, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForContentTable, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 3.5/3, constant: 0))
        visualEffectViewForContentTable.addConstraint(NSLayoutConstraint(item: visualEffectViewForContentTable, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.95 * UIScreen.mainScreen().bounds.width))
        visualEffectViewForContentTable.addConstraint(NSLayoutConstraint(item: visualEffectViewForContentTable, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.6 * UIScreen.mainScreen().bounds.height))
        
        contentTable = UITableView()
        contentTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DIARYCELL")
        contentTable.layer.cornerRadius = visualEffectViewForContentTable.layer.cornerRadius
        contentTable.separatorStyle = UITableViewCellSeparatorStyle.None
        contentTable.backgroundColor = UIColor.clearColor()
        contentTable.dataSource = self
        contentTable.delegate = self
        contentTable.scrollEnabled = true
        self.view.addSubview(contentTable)
        contentTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: contentTable, attribute: .CenterX, relatedBy: .Equal, toItem: visualEffectViewForContentTable, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: contentTable, attribute: .CenterY, relatedBy: .Equal, toItem: visualEffectViewForContentTable, attribute: .CenterY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: contentTable, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: visualEffectViewForContentTable, attribute: .Width, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: contentTable, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: visualEffectViewForContentTable, attribute: .Height, multiplier: 1, constant: 0))
        
        let separator = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        separator.clipsToBounds = true
        self.view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: separator, attribute: .Bottom, relatedBy: .Equal, toItem: contentTable, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: separator, attribute: .Width, relatedBy: .Equal, toItem: contentTable, attribute: .Width, multiplier: 1, constant: 0))
        separator.addConstraint(NSLayoutConstraint(item: separator, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 1))
        self.view.addConstraint(NSLayoutConstraint(item: separator, attribute: .CenterX, relatedBy: .Equal, toItem: contentTable, attribute: .CenterX, multiplier: 1, constant: 0))
        
        let visualEffectViewForTableHeaderView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectViewForTableHeaderView.layer.cornerRadius = contentTable.layer.cornerRadius
        visualEffectViewForTableHeaderView.clipsToBounds = true
        self.view.addSubview(visualEffectViewForTableHeaderView)
        visualEffectViewForTableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForTableHeaderView, attribute: .Bottom, relatedBy: .Equal, toItem: separator, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForTableHeaderView, attribute: .Width, relatedBy: .Equal, toItem: contentTable, attribute: .Width, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForTableHeaderView, attribute: .Height, relatedBy: .Equal, toItem: contentTable, attribute: .Height, multiplier: 0.125, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectViewForTableHeaderView, attribute: .CenterX, relatedBy: .Equal, toItem: contentTable, attribute: .CenterX, multiplier: 1, constant: 0))
        
        let tableHeaderView = UIView()
        tableHeaderView.layer.cornerRadius = contentTable.layer.cornerRadius
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableHeaderView)
        self.view.addConstraint(NSLayoutConstraint(item: tableHeaderView, attribute: .CenterY, relatedBy: .Equal, toItem: visualEffectViewForTableHeaderView, attribute: .CenterY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableHeaderView, attribute: .Width, relatedBy: .Equal, toItem: visualEffectViewForTableHeaderView, attribute: .Width, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableHeaderView, attribute: .Height, relatedBy: .Equal, toItem: visualEffectViewForTableHeaderView, attribute: .Height, multiplier: 0.125, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableHeaderView, attribute: .CenterX, relatedBy: .Equal, toItem: visualEffectViewForTableHeaderView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        let diary = UIImage(named: "Diary")
        let diaryImage = UIImageView(image: diary)
        tableHeaderView.addSubview(diaryImage)
        diaryImage.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.addConstraint(NSLayoutConstraint(item: diaryImage, attribute: .CenterY, relatedBy: .Equal, toItem: tableHeaderView, attribute: .CenterY, multiplier: 1, constant: 0))
        tableHeaderView.addConstraint(NSLayoutConstraint(item: diaryImage, attribute: .Leading, relatedBy: .Equal, toItem: tableHeaderView, attribute: .Leading, multiplier: 1, constant: contentTable.bounds.width/40))
        diaryImage.addConstraint(NSLayoutConstraint(item: diaryImage, attribute: .Width, relatedBy: .Equal, toItem: diaryImage, attribute: .Height, multiplier: 1, constant: 0))
        
        let textLabel = UILabel()
        textLabel.text = "Diaries"
        textLabel.textColor = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1)
        textLabel.font = UIFont(name: textLabel.font.fontName, size: 25)
        tableHeaderView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: tableHeaderView, attribute: .CenterY, multiplier: 1, constant: 0))
        tableHeaderView.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Leading, relatedBy: .Equal, toItem: diaryImage, attribute: .Trailing, multiplier: 1, constant: contentTable.bounds.width/40))
        tableHeaderView.addConstraint(NSLayoutConstraint(item: diaryImage, attribute: .Height, relatedBy: .Equal, toItem: textLabel, attribute: .Height, multiplier: 1, constant: 0))
        
        let loverID = (user["lover"] as! [String: NSObject])["id"]
        let s = protocal + "://" + domain + ":" + port + "/pamela/diary/\(startIndex)/\(pageSize)/\(loverID!)"
        let url = NSURL(string: s)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request)
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //backgroundTimmer.invalidate()
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DIARYCELL", forIndexPath: indexPath) 
        
        let images = diaries[indexPath.row]["images"] as! [[String: NSObject]]
        let cellHeight = tableView.rectForRowAtIndexPath(indexPath).height - cell.bounds.width/40
        let imageWidth = CGFloat(systemThumbnailWidth / systemThumbnailHeight) * cellHeight
        
        // if cell is being reused
        if cell.tag != 0 && cell.tag != indexPath.row + 1 {
            cell.tag = indexPath.row + 1
            let titleLabel: UILabel = cell.contentView.viewWithTag(101) as! UILabel
            let dateLabel: UILabel = cell.contentView.viewWithTag(102) as! UILabel
            let moodLabel: UILabel = cell.contentView.viewWithTag(103) as! UILabel
            let weatherLabel: UILabel = cell.contentView.viewWithTag(104) as! UILabel
            let contentLabel: UILabel = cell.contentView.viewWithTag(106) as! UILabel
            var contentImageView: UIImageView? = cell.contentView.viewWithTag(105) as? UIImageView
            
            var title = diaries[indexPath.row]["title"] as? String
            if ((title!).characters.count > 8) {
                title = title?.substringToIndex(title!.startIndex.advancedBy(5))
                title = title! + "..."
            }
            titleLabel.text = title
            
            dateLabel.text = diaries[indexPath.row]["date"] as? String
            moodLabel.text = diaries[indexPath.row]["mood"] as? String
            weatherLabel.text = diaries[indexPath.row]["weather"] as? String
            
            var firstSentence = diaries[indexPath.row]["firstSentence"] as? String
            if firstSentence != nil && (firstSentence!).characters.count > 35 {
                firstSentence = firstSentence?.substringToIndex(firstSentence!.startIndex.advancedBy(30))
                firstSentence = firstSentence! + "..."
            }
            contentLabel.text = firstSentence
            
            if images.count < 2 {
                contentImageView?.removeFromSuperview()
            } else {
                if contentImageView == nil {
                    contentImageView = UIImageView()
                    contentImageView!.tag = 105
                    contentImageView!.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1)
                    cell.contentView.addSubview(contentImageView!)
                    contentImageView!.translatesAutoresizingMaskIntoConstraints = false
                    cell.contentView.addConstraint(NSLayoutConstraint(item: contentImageView!, attribute: .Trailing, relatedBy: .Equal, toItem: cell.contentView, attribute: .Trailing, multiplier: 1, constant: -cell.bounds.width/40))
                    
                }
                let s = protocal + "://" + domain + ":" + port + "/images/uploadedFile/" + (images[1]["link"] as! String)
                let url = NSURL(string: s)
                let request = NSMutableURLRequest(URL: url!)
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
                    let r: NSHTTPURLResponse = response as! NSHTTPURLResponse
                    if r.statusCode == 200 {
                        let thumbnailWidth = images[1]["width"] as! Int
                        let thumbnailHeight = images[1]["height"] as! Int
                        contentImageView!.image = UIImage(data: data!)
                        contentImageView!.backgroundColor = UIColor.clearColor()
                        if cellHeight < CGFloat(thumbnailHeight) {
                            cell.contentView.addConstraint(NSLayoutConstraint(item: contentImageView!, attribute: .Top, relatedBy: .Equal, toItem: cell.contentView, attribute: .Top, multiplier: 1, constant: cell.bounds.width/80))
                            contentImageView!.addConstraint(NSLayoutConstraint(item: contentImageView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: cell.bounds.height))
                            contentImageView!.addConstraint(NSLayoutConstraint(item: contentImageView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: imageWidth))
                        } else {
                            cell.contentView.addConstraint(NSLayoutConstraint(item: contentImageView!, attribute: .CenterY, relatedBy: .Equal, toItem: cell.contentView, attribute: .CenterY, multiplier: 1, constant: 0))
                            contentImageView!.addConstraint(NSLayoutConstraint(item: contentImageView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: CGFloat(thumbnailHeight)))
                            contentImageView!.addConstraint(NSLayoutConstraint(item: contentImageView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: CGFloat(thumbnailWidth)))
                        }
                    } else {
                        print(error)
                    }
                })
                task.resume()
                
            }
            
        }
        
        // if cell is new
        if (cell.tag == 0) {
            cell.tag = indexPath.row + 1
            cell.backgroundColor = UIColor.clearColor()
            
            let backgroundViewVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
            backgroundViewVisualEffectView.frame = cell.bounds
            cell.selectedBackgroundView = backgroundViewVisualEffectView
            
            let titleLabel = UILabel()
            titleLabel.tag = 101
            var title = diaries[indexPath.row]["title"] as? String
            if ((title!).characters.count > 8) {
                title = title?.substringToIndex(title!.startIndex.advancedBy(5))
                title = title! + "..."
            }
            titleLabel.text = title
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 16)
            cell.contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: cell.contentView, attribute: .Top, multiplier: 1, constant: cell.bounds.height/20))
            cell.contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: cell.contentView, attribute: .Leading, multiplier: 1, constant: cell.bounds.width/20))
            
            let dateLabel = UILabel()
            dateLabel.tag = 102
            dateLabel.textColor = UIColor.lightTextColor()
            dateLabel.text = diaries[indexPath.row]["date"] as? String
            dateLabel.font = UIFont(name: dateLabel.font.fontName, size: 13)
            cell.contentView.addSubview(dateLabel)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .Bottom, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1, constant: 0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .Leading, relatedBy: .Equal, toItem: titleLabel, attribute: .Trailing, multiplier: 1, constant: cell.bounds.width/40))
            
            let moodLabel = UILabel()
            moodLabel.tag = 103
            moodLabel.textColor = UIColor.lightTextColor()
            moodLabel.text = diaries[indexPath.row]["mood"] as? String
            moodLabel.font = UIFont(name: moodLabel.font.fontName, size: 13)
            cell.contentView.addSubview(moodLabel)
            moodLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: moodLabel, attribute: .Bottom, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1, constant: 0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: moodLabel, attribute: .Leading, relatedBy: .Equal, toItem: dateLabel, attribute: .Trailing, multiplier: 1, constant: cell.bounds.width/40))
            
            let weatherLabel = UILabel()
            weatherLabel.tag = 104
            weatherLabel.text = diaries[indexPath.row]["weather"] as? String
            weatherLabel.textColor = UIColor.lightTextColor()
            weatherLabel.font = UIFont(name: weatherLabel.font.fontName, size: 13)
            cell.contentView.addSubview(weatherLabel)
            weatherLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: weatherLabel, attribute: .Bottom, relatedBy: .Equal, toItem: moodLabel, attribute: .Bottom, multiplier: 1, constant: 0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: weatherLabel, attribute: .Leading, relatedBy: .Equal, toItem: moodLabel, attribute: .Trailing, multiplier: 1, constant: cell.bounds.width/40))
            
            if images.count >= 2 {
                //let imageView = UIImage(named: "Test")
                let contentImageView = UIImageView()
                contentImageView.tag = 105
                contentImageView.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1)
                cell.contentView.addSubview(contentImageView)
                contentImageView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addConstraint(NSLayoutConstraint(item: contentImageView, attribute: .Trailing, relatedBy: .Equal, toItem: cell.contentView, attribute: .Trailing, multiplier: 1, constant: -cell.bounds.width/40))
                
                let s = protocal + "://" + domain + ":" + port + "/images/uploadedFile/" + (images[1]["link"] as! String)
                let url = NSURL(string: s)
                let request = NSMutableURLRequest(URL: url!)
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
                    let r: NSHTTPURLResponse = response as! NSHTTPURLResponse
                    if r.statusCode == 200 {
                        let thumbnailWidth = images[1]["width"] as! Int
                        let thumbnailHeight = images[1]["height"] as! Int
                        contentImageView.image = UIImage(data: data!)
                        contentImageView.backgroundColor = UIColor.clearColor()
                        if cellHeight < CGFloat(thumbnailHeight) {
                            cell.contentView.addConstraint(NSLayoutConstraint(item: contentImageView, attribute: .Top, relatedBy: .Equal, toItem: cell.contentView, attribute: .Top, multiplier: 1, constant: cell.bounds.width/80))
                            contentImageView.addConstraint(NSLayoutConstraint(item: contentImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: cellHeight))
                            contentImageView.addConstraint(NSLayoutConstraint(item: contentImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: imageWidth))
                        } else {
                            cell.contentView.addConstraint(NSLayoutConstraint(item: contentImageView, attribute: .CenterY, relatedBy: .Equal, toItem: cell.contentView, attribute: .CenterY, multiplier: 1, constant: 0))
                            contentImageView.addConstraint(NSLayoutConstraint(item: contentImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: CGFloat(thumbnailHeight)))
                            contentImageView.addConstraint(NSLayoutConstraint(item: contentImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: CGFloat(thumbnailWidth)))
                        }
                    } else {
                        print(error)
                    }
                })
                task.resume()
            }
            
            let contentLabel = UILabel()
            contentLabel.tag = 106
            var firstSentence = diaries[indexPath.row]["firstSentence"] as? String
            if firstSentence != nil && (firstSentence!).characters.count > 35 {
                firstSentence = firstSentence?.substringToIndex(firstSentence!.startIndex.advancedBy(30))
                firstSentence = firstSentence! + "..."
            }
            
            contentLabel.textColor = UIColor.lightTextColor()
            contentLabel.text = firstSentence
            contentLabel.font = UIFont(name: contentLabel.font.fontName, size: 15)
            cell.contentView.addSubview(contentLabel)
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1, constant: 0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: .Leading, relatedBy: .Equal, toItem: cell.contentView, attribute: .Leading, multiplier: 1, constant: cell.bounds.width/20))
            
            cell.textLabel?.textColor = UIColor.lightTextColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.bounds.height / 5
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let dvc = DiaryViewController()
            let id = diaries[indexPath.row]["id"]
            let url = protocal + "://" + domain + ":" + port + "/diary_mobile.jsp?id=\(id!)"
            dvc.diaryURL = url
            self.navigationController?.pushViewController(dvc, animated: true)
        } else {
            return
        }
    }
    
    override func showProjectPamelaInfo() {
        let pivc = ProjectInfomationViewController()
        self.navigationController?.pushViewController(pivc, animated: true)
    }
    
    /*func setBackground() {
    if backgroundNum > 3 {
    backgroundNum = 1
    }
    UIGraphicsBeginImageContext(self.view.frame.size)
    UIImage(named: "Background\(backgroundNum++)")?.drawInRect(self.view.bounds)
    var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    CATransaction.begin()
    
    CATransaction.setAnimationDuration(2.0)
    
    let transition = CATransition()
    transition.type = kCATransitionFade
    /*
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromRight
    */
    self.view.layer.addAnimation(transition, forKey: kCATransition)
    self.view.backgroundColor = UIColor(patternImage: image)
    
    CATransaction.commit()
    }*/
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error == nil {
            var error: NSError?
            diaries = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as! [[String: NSObject]]!
            if diaries == nil {
                diaries = []
            } else {
                self.contentTable.reloadData()
            }
        } else {
            print(error)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        if hasNext && scrollView.contentOffset.y + 6 * ( contentTable.bounds.height / 5 ) > contentHeight {
            startIndex+=pageSize
            let loverID = (user["lover"] as! [String: NSObject])["id"]
            let s = protocal + "://" + domain + ":" + port + "/pamela/diary/\(startIndex)/\(pageSize)/\(loverID!)"
            let url = NSURL(string: s)!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            let task = session.dataTaskWithRequest(request, completionHandler: {[unowned self] data, response, error in
                let r: NSHTTPURLResponse = response as! NSHTTPURLResponse
                if r.statusCode == 200 {
                    var error: NSError?
                    let diaries = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [[String: NSObject]]!
                    if diaries.count != 0 {
                        let count = diaries.count
                        self.diaries.extend(diaries)
                        self.contentTable.reloadData()
                        if count < self.pageSize {
                            self.hasNext = false
                        }
                    } else {
                            self.hasNext = false
                    }
                } else {
                    print(error)
                }
                })
            task.resume()
        }
    }
    
}
