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
    private let bookRepository: BookRepository = BookRepositoryImpl(api: APIService.share)
    private let isbnRepository: IsbnRepository = IsbnRepositoryImpl(api: APIService.share)
    
    override func viewDidLoad() {
        super.viewDidLoad()
            prepareUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOwnGenres()
        fetchIsbnPopularBook()
        fetchIsbnNewBook()
    }
    
    private func prepareUI() {
        genreCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        popularCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: BookCell.self)
        }
        newCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: BookCell.self)
        }
    }
    
    private func fetchOwnGenres() {
        genresList.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
                    
                    if  list.count == counting {
                        break
                    }
                }
            }
            genreCollectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func fetchPopularBook(isbn: String) {
        bookRepository.searchBooks(isbn: isbn) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let reponse):
                if let books = reponse?.books {
                    for i in books {
                        self.popularBooksList.append(i)
                    }
                }
                self.popularCollectionView.reloadData()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    private func fetchNewBook(isbn: String) {
        bookRepository.searchBooks(isbn: isbn) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let reponse):
                if let books = reponse?.books {
                    for i in books {
                        self.newBooksList.append(i)
                    }
                }
                self.newCollectionView.reloadData()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    private func fetchIsbnPopularBook() {
        view.activityStartAnimating(activityColor: .mainColor)
        isbnRepository.searchIsbn(publishedDate: Date().getHalfYearAgo().toString()) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let reponse):
                if let results = reponse?.resultList {
                    for list in results {
                        if let list = list.ISBNList {
                            for i in list {
                                self.fetchPopularBook(isbn: i.ISBN)
                            }
                        }
                    }
                }
                self.newCollectionView.reloadData()
                self.view.activityStopAnimating()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    private func fetchIsbnNewBook() {
        view.activityStartAnimating(activityColor: .mainColor)
        isbnRepository.searchIsbn(publishedDate: Date().toString()) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let reponse):
                if let results = reponse?.resultList {
                    for list in results {
                        if let list = list.ISBNList {
                            for i in list {
                                self.fetchNewBook(isbn: i.ISBN)
                            }
                        }
                    }
                }
                self.newCollectionView.reloadData()
                self.view.activityStopAnimating()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    @IBAction private func moreGenreAction(_ sender: UIButton) {
        let vc = GenresListViewController.instantiate()
        vc.genresList = genresList
        show(vc, sender: nil)
    }
    
    @IBAction private func morePopularAction(_ sender: UIButton) {
        let vc = BooksListViewController.instantiate()
        vc.bookList = popularBooksList
        show(vc, sender: nil)
    }
    
    @IBAction private func moreNewAction(_ sender: UIButton) {
        let vc = BooksListViewController.instantiate()
        vc.bookList = newBooksList
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
            vc.bookId = popularBooksList[indexPath.item].id?.text ?? ""
            show(vc, sender: nil)
        default:
            let vc = BookDetailViewController.instantiate()
            vc.bookId = newBooksList[indexPath.item].id?.text ?? ""
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
        switch collectionView {
        case popularCollectionView:
            let cell = popularCollectionView.dequeueReusableCell(for: indexPath) as BookCell
            cell.configCell(book: popularBooksList[indexPath.item])
            return cell
        case newCollectionView:
            let cell = newCollectionView.dequeueReusableCell(for: indexPath) as BookCell
            cell.configCell(book: newBooksList[indexPath.item])
            return cell
        default:
            let cell = genreCollectionView.dequeueReusableCell(for: indexPath) as GenreCell
            cell.setContent(genreTitle: genresList[indexPath.row])
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        var width: CGFloat = 0
        switch collectionView {
        case genreCollectionView:
            let title = genresList[indexPath.row]
            height = Cells.heightGenreCell
            width = title.width(withConstrainedHeight: height, font: UIFont.primary) + height / 2
        case popularCollectionView, newCollectionView:
            height = Cells.heightBookCell
            width = Cells.widthBookCell
        default:
            break
        }
        return CGSize(width: width, height: height)
    }
}
extension HomeViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}
