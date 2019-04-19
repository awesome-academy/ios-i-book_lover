//
//  UIColor+Extension.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }

    public class var mainColor: UIColor {
        return UIColor(red: 135, green: 163, blue: 242)
    }
    
    public class var basicColor: UIColor {
        return UIColor(red: 224, green: 224, blue: 224)
    }
    
    public class var lightColor: UIColor {
        return UIColor(red: 85, green: 85, blue: 85)
    }

    public class var superLightColor: UIColor {
        return UIColor(red: 239, green: 239, blue: 244)
    }
}
