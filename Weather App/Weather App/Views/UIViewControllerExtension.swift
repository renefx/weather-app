//
//  UIViewControllerExtension.swift
//  Weather App
//
//  Created by Renê Xavier on 09/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var topbarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0.0
    }
    
    var topbarWidth: CGFloat {
        return self.navigationController?.navigationBar.frame.width ?? 0.0
    }
}
