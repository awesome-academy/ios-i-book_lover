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
import CoreData
import Reusable

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchOwnGenres()
    }
    private func prepareUI() {
        genreCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        popularCollectionView.do {
            $0.register(cellType: BookCell.self)
        }
        newCollectionView.do {
            $0.register(cellType: BookCell.self)
        }
    }
    
    private func fetchOwnGenres() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            if var list = user[0].genres {
                var counting = 0
                for index in 0..<Constants.genres.count where list[counting] == index {
                    genresList.append(Constants.genres[index])
                    counting += 1
                }
            }
            genreCollectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction private func moreGenreAction(_ sender: Any) {
        let vc = GenresListViewController.instantiate()
        show(vc, sender: nil)
    }
    @IBAction private func morePopularAction(_ sender: Any) {
        let vc = BooksListViewController.instantiate()
        show(vc, sender: nil)
    }
    @IBAction private func moreNewAction(_ sender: Any) {
        let vc = BooksListViewController.instantiate()
        show(vc, sender: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case genreCollectionView:
            let vc = BooksListViewController.instantiate()
            show(vc, sender: nil)
        case popularCollectionView:
            let vc = BookDetailViewController.instantiate()
            show(vc, sender: nil)
        default:
            let vc = BookDetailViewController.instantiate()
            show(vc, sender: nil)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularCollectionView:
            return popularBooksList.count > Constants.preDisplayItems ?
                Constants.preDisplayItems : popularBooksList.count
        case newCollectionView:
            return newBooksList.count > Constants.preDisplayItems ?
                Constants.preDisplayItems : newBooksList.count
        default:
            return genresList.count > Constants.preDisplayItems ?
                Constants.preDisplayItems : genresList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularCollectionView, collectionView == newCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as BookCell
            return cell
        }
        
        let cell = genreCollectionView.dequeueReusableCell(for: indexPath) as GenreCell
        cell.genreLabel.text = genresList[indexPath.row]
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        var width: CGFloat = 0
        switch collectionView {
        case genreCollectionView:
            let font = UIFont.systemFont(ofSize: Constants.fontSize)
            let title = genresList[indexPath.row]
            height = Constants.heightGenreCell
            width = title.width(withConstrainedHeight: height, font: font) + height / 2
        case popularCollectionView, popularCollectionView:
            height = Constants.heightBookCell
            width = Constants.weightBookCell
        default:
            break
        }
        return CGSize(width: width, height: height)
    }
}
extension HomeViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}
