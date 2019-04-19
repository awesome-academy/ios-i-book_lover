//
//  TermViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/19/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class TermViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension TermViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.profile
}
