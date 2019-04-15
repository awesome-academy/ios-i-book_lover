//
//  BooksListViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/9/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import Then

final class BooksListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let bookRepository: BookRepository = BookRepositoryImpl(api: APIService.share)
    var genre = ""
    var isGenresList = false
    var bookList = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isGenresList == false {
            view.activityStopAnimating()
        } else {
            fetchData()
        }
    }
    
    private func prepareUI() {
        view.activityStartAnimating(activityColor: .mainColor)
        tableView.do {
            $0.separatorColor = .mainColor
            $0.tableFooterView = UIView()
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: BookListCell.self)
        }
    }
    
    private func fetchData() {
        bookRepository.searchBooksByGenre(genre: genre) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let reponse):
                if let results = reponse?.books {
                    for book in results {
                        self.bookList.append(book)
                    }
                }
                self.tableView.reloadData()
                self.view.activityStopAnimating()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
}

extension BooksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookDetailViewController.instantiate()
        vc.bookId = bookList[indexPath.row].id?.text ?? ""
        show(vc, sender: nil)
    }
}

extension BooksListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as BookListCell
        cell.setContent(book: bookList[indexPath.row])
        return cell
    }
}

extension BooksListViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}
