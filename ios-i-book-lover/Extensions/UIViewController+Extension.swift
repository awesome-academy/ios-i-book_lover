//
//  UIViewController+Extension.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public static var className: String {
        return String(describing: self)
    }
}

