//
//  CatboardBanner.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit


class TrumpboardBanner: ExtraView {
    
    var catLabel: UILabel = UILabel()
    
    var marker = UIImageView()
    var widget = LevelWidget()
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        
        catLabel.text = "Start typing"
  
//         if we want a background, here's the deal. It looks like shit though.
//        let i = UIImageView(image: UIImage(named: "trumpbg")!)
//        self.addSubview(i)
//        i.contentMode = .ScaleAspectFit
        
        self.addSubview(widget)
        
        startListeningForLabelUpdates()
        marker.image = UIImage(named: "marker")
        
        widget.addSubview(marker)
//        self.addSubview(marker)
        
        self.updateAppearance()
    }
    
    func startListeningForLabelUpdates(){
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                       selector: #selector(updateLabelFromNotification),
                       name: "scoreUpdate",
                       object: nil)
    }
    
    func showReadabilityWidget(){
        UIView.animateWithDuration(1) {
            self.widget.frame.origin.y = -15
            self.widget.alpha = 1
        }
    }
    
    func hideReadabilityWidget(duration:NSTimeInterval = 1){
        positionIndicator(50)
        UIView.animateWithDuration(duration) {
            self.widget.frame.origin.y += 5
            self.widget.alpha = 0
        }
    }
    
    func updateLabelFromNotification(n:NSNotification){
        
        let userInfo:Dictionary<String,Float!> = n.userInfo as! Dictionary<String,Float!>
        var s = userInfo["score"]!
        
        // show the widget or hide it? 
        // if the score is zero or nan, hide it
        // else show
        
        
        if s == 0.0 {
            hideReadabilityWidget()
        } else {
            showReadabilityWidget()
        }
        
        // bracket
        if s>130 { s = 130 }
        if s<30 { s = 0 }
        
        let percent = 100 - rangeMap(whereIs: Double(s), low1: 30, low2: 0, high1: 130, high2: 100)
        positionIndicator(CGFloat(percent))
    }
    
    func rangeMap(whereIs value:Double, low1:Double, low2:Double, high1:Double, high2:Double) -> Double  {
        return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.catLabel.center = self.center
    }
    
    func positionIndicator(percent:CGFloat){
        let s = UIScreen.mainScreen().bounds.width
        let newX = (s/100) * percent
        
        marker.stopAnimating()
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.marker.center.x = newX
            }) { (done) in
                // done
        }
    }
    
    func updateAppearance() {
        marker.frame.size.width = 20
        marker.frame.size.height = 40
        widget.frame.size.width = UIScreen.mainScreen().bounds.width
        widget.center.y -= 15
        hideReadabilityWidget(0)
    }
}
