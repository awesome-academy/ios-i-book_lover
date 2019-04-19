//
//  SettingViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/19/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class SettingViewController: UIViewController {
    @IBOutlet private weak var termLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        termLabel.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termAction)))
        }
    }
    
    @objc
    private func termAction() {
        let vc = TermViewController.instantiate()
        let navigation = UINavigationController(rootViewController: vc)
        present(navigation, animated: true, completion: nil)
    }
}

extension SettingViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.profile
}
