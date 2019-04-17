//
//  ProgressCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

protocol ProgressCellDelegate: class {
    func didSelect(indexPath: IndexPath)
    func didDeSelect(indexPath: IndexPath)
}

final class ProgressCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var radioButton: UIButton!
    
    weak var delegate: ProgressCellDelegate?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(progress: String, indexPath: IndexPath) {
        progressLabel.text = progress
        self.indexPath = indexPath
    }

    func selectButton(isSelected: Bool) {
        radioButton.isSelected = isSelected
    }
    
    @IBAction private func selectAction(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        let isSelected = !radioButton.isSelected
        radioButton.isSelected = isSelected
        if isSelected {
            delegate?.didDeSelect(indexPath: indexPath)
        } else {
            delegate?.didSelect(indexPath: indexPath)
        }
    }
}
