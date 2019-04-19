//
//  KeyWordCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class KeyWordCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var keyWordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(keyword: String) {
        keyWordLabel.text = keyword
    }
}
