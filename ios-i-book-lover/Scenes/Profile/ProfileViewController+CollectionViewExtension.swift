//
//  ProfileViewController+CollectionViewExtension.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/18/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            switch indexPath.item {
            case 0, 1, 2:
                let vc = BookShelfCategoryViewController.instantiate()
                vc.categoryProgress = indexPath.item
                show(vc, sender: nil)
            case 3:
                let vc = EditGernesViewController.instantiate()
                let navigation = UINavigationController(rootViewController: vc)
                present(navigation, animated: true, completion: nil)
            default:
                break
            }
        } else {
            let vc = BookDetailViewController.instantiate()
            vc.bookId = readingBookList[indexPath.row].id?.text ?? ""
            show(vc, sender: nil)
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return Constants.bookCategories.count
        } else {
            return readingBookList.count > Constants.preDisplayItems ?
                Constants.preDisplayItems : readingBookList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as CategoryCell
            if !booksCountList.isEmpty {
                let booksCount = booksCountList[indexPath.item]
                cell.setContent(number: booksCount, category: Constants.bookCategories[indexPath.item])
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(for: indexPath) as BookCell
        cell.configCell(book: readingBookList[indexPath.item])
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            let height = collectionView.frame.height
            let width = collectionView.frame.width / 4
            return CGSize(width: width, height: height)
        }
        return CGSize(width: Cells.widthBookCell, height: Cells.heightBookCell)
    }
}

extension ProfileViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.profile
}
