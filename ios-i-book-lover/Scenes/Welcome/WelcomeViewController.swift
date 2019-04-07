//
//  WelcomeViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then

final class WelcomeViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var countingLabel: UILabel!
    let genres = Constants.genres
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    private func prepareUI() {
        bottomView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.allowsMultipleSelection = true
        }
    }
}
extension WelcomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension WelcomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeCell.className, for: indexPath)
            as? WelcomeCell else {
                return UICollectionViewCell()
        }
        cell.genreLabel.text = genres[indexPath.row]
        return cell
    }
}
extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = genres[indexPath.item]
        let font = UIFont.systemFont(ofSize: 20)
        let width = title.width(withConstrainedHeight: 32, font: font)
        return CGSize(width: width + 20, height: 32)
    }
}
