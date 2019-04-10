//
//  RatingView.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/8/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

final class RatingView: UIView {
    @IBOutlet private weak var star1: UIButton!
    @IBOutlet private weak var star2: UIButton!
    @IBOutlet private weak var star3: UIButton!
    @IBOutlet private weak var star4: UIButton!
    @IBOutlet private weak var star5: UIButton!
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        view = loadViewFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0
        ))
        addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0
        ))
        addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0
        ))
        addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0
        ))
        backgroundColor = UIColor.clear
    }
    
    func setRating(rate: Double) {
        var buttons = [UIButton]()
        buttons.append(star1)
        buttons.append(star2)
        buttons.append(star3)
        buttons.append(star4)
        buttons.append(star5)
        let number = Int(floor(rate))
        
        if rate.truncatingRemainder(dividingBy: 10) == 0 {
            for i in 0..<number {
                buttons[i].isSelected = true
            }
            for i in number..<5 {
                buttons[i].isSelected = false
            }
        } else {
            for i in 0..<number {
                buttons[i].isSelected = true
            }
            if number < 5 {
                buttons[number].setImage(UIImage(named: "ic_half_star"), for: .selected)
                buttons[number].isSelected = true
                for i in (number + 1)..<5 {
                    buttons[i].isSelected = false
                }
            }
        }
    }
}
