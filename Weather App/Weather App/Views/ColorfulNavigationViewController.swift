//
//  ColorfulNavigationViewController.swift
//  Weather App
//
//  Created by Renê Xavier on 09/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class ColorfulNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let colors: [UIColor] = [Color.pinkShadow,
                                 Color.orangeShadow,
                                 Color.greenShadow,
                                 Color.blueShadow,
                                 Color.yellowShadow,
                                 Color.redShadow]
        
        setColorsNavigationBarShadow(colors)
    }
    

    
    func setColorsNavigationBarShadow(_ colors: [UIColor]) {
        let image = UIImage()
        
        let shadowHeight: CGFloat = 2
        let shadowWidth: CGFloat = self.screenWidth / CGFloat(colors.count)
        
        UIGraphicsBeginImageContext(CGSize(width: self.screenWidth, height: shadowHeight))
        let context = UIGraphicsGetCurrentContext()!
        image.draw(at: CGPoint.zero)
        
        for (index, color) in colors.enumerated() {
            let newXPosition = shadowWidth * CGFloat(index)
            let rectangle = CGRect(x: newXPosition, y: 0, width: shadowWidth, height: shadowHeight)
            context.setFillColor(color.cgColor)
            context.addRect(rectangle)
            context.drawPath(using: .fill)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationBar.shadowImage = newImage
        
    }

}
