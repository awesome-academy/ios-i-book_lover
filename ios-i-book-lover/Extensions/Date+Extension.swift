//
//  Date.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

extension Date {
    func getHalfYearAgo() -> Date {
        let earlyYear = Calendar.current.date(
            byAdding: .month,
            value: -6,
            to: self)
        return earlyYear ?? Date()
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: self)
        return myString
    }
}
