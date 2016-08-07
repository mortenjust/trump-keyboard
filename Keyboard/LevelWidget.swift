//
//  LevelWidget.swift
//  LevelWidget
//
//  Created by Morten Just Petersen on 7/24/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit

@IBDesignable class LevelWidget: UIView {
      var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    

    func xibSetup() {
        view = loadViewFromNib()
        
//        
//        // use bounds not frame or it'll be offset
      view.frame = bounds
//        
//        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
//        // Adding custom subview on top of our view (over any custom drawing > see note below)
//
        addSubview(view)
//
//        self.indicator.translatesAutoresizingMaskIntoConstraints = true
//        
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LevelWidget", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}
