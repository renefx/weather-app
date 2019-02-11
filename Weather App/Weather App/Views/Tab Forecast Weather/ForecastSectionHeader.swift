//
//  ForecastSectionHeader.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class ForecastSectionHeader: UIView {

    var topLine: UIView!
    let lineHeight: CGFloat = 1
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addViews(toFrame: frame)
    }
    
    convenience init(frame: CGRect, title: String, hideTopLine: Bool = false){
        self.init(frame: frame)
        self.addViews(toFrame: frame, title: title, hideTopLine: hideTopLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addViews(toFrame: CGRect, title: String = General.none, hideTopLine: Bool = false) {
        
        if hideTopLine {
            let topLine = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: lineHeight))
            topLine.backgroundColor = Color.gray
            self.addSubview(topLine)
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: lineHeight, width: frame.width, height:  frame.height))
        label.backgroundColor = .white
        label.text = title
        self.addSubview(label)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: frame.height - lineHeight, width: frame.width, height: lineHeight))
        bottomLine.backgroundColor = Color.gray
        self.addSubview(bottomLine)
    }

}
