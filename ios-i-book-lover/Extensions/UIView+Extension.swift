//
//  UIView+Extension.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then

extension UIView {
    public static var nib: UINib {
        return className.nib
    }
    
    public static var className: String {
        return String(describing: self)
    }
    
    public func loadViewFromNib() -> UIView {
        let typeOfSelf = type(of: self)
        let bundle = Bundle(for: typeOfSelf)
        let nib = UINib(nibName: String(describing: typeOfSelf), bundle: bundle)
        guard let mNib = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }
         return mNib
    }
    
    func activityStartAnimating(activityColor: UIColor) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)).then {
            $0.center = center
            $0.hidesWhenStopped = true
            $0.style = .gray
            $0.color = activityColor
            $0.startAnimating()
            $0.tag = Constants.indicatorTag
            isUserInteractionEnabled = false
        }
        addSubview(activityIndicator)
    }
    
    func activityStopAnimating() {
        if let indicator = viewWithTag(Constants.indicatorTag) {
            indicator.removeFromSuperview()
        }
        isUserInteractionEnabled = true
    }
    
    func activityStartOverlay() {
        let overlay = UIView(frame: frame).then {
            $0.backgroundColor = .white
            $0.alpha = 0.9
            $0.tag = Constants.indicatorTag
        }
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)).then {
            $0.center = center
            $0.hidesWhenStopped = true
            $0.style = .gray
            $0.color = .mainColor
            $0.startAnimating()
            $0.tag = Constants.indicatorTag
            isUserInteractionEnabled = false
        }
        
        overlay.addSubview(activityIndicator)
        addSubview(overlay)
    }
    
    func activityStopOverlay() {
        if let indicator = viewWithTag(Constants.indicatorTag) {
            indicator.removeFromSuperview()
        }
        isUserInteractionEnabled = true
    }
}
