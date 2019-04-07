//
//  TabBarController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/10/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TabBarController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.main
}
