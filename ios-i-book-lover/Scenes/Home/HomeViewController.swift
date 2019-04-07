//
//  HomeViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/4/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Alamofire
import XMLMapper
import Then

final class HomeViewController: UIViewController {
    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var popularCollectionView: UICollectionView!
    @IBOutlet private weak var newCollectionView: UICollectionView!
    private var genresList = [String]()
    private var popularBooksList = [Book]()
    private var newBooksList = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            prepareUI()
        }
    
    private func prepareUI() {
        genreCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        popularCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(BookCell.nib, forCellWithReuseIdentifier: BookCell.className)
        }
        newCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(BookCell.nib, forCellWithReuseIdentifier: BookCell.className)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genresList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.className, for: indexPath)
            as? GenreCell else {
                return UICollectionViewCell()
        }
        cell.genreLabel.text = genresList[indexPath.row]
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case genreCollectionView:
            break
        case popularCollectionView:
            break
        case popularCollectionView:
            break
        default:
            break
        }
        return CGSize(width: 0, height: 0)
    }
}
