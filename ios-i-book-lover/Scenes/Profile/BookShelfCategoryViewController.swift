//
//  BookShelfCategoryViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import CoreData

final class BookShelfCategoryViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let bookRepository: BookRepository = BookRepositoryImpl(api: APIService.share)
    private var bookList = [Book]()
    var categoryProgress = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func prepareUI() {
        tableView.do {
            $0.separatorColor = .mainColor
            $0.tableFooterView = UIView()
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: BookListCell.self)
        }
    }
    
    private func fetchData() {
        bookList.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            guard let books = user[0].books else { return }
            let bookEnities = books as? Set<BookEntity> ?? Set()
            for book in bookEnities where book.progress == Int16(categoryProgress) {
                fetchBook(ISBN: book.isbn ?? "")
            }
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    private func fetchBook(ISBN: String) {
        view.activityStartAnimating(activityColor: .mainColor)
        bookRepository.searchBooks(isbn: ISBN) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let books = response?.books else { return }
                
                for i in books {
                    self.bookList.append(i)
                }
                self.tableView.reloadData()
                self.view.activityStopAnimating()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
}

extension BookShelfCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookDetailViewController.instantiate()
        vc.bookId = bookList[indexPath.row].id?.text ?? ""
        show(vc, sender: nil)
    }
}

extension BookShelfCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as BookListCell
        cell.setContent(book: bookList[indexPath.row])
        return cell
    }
}

extension BookShelfCategoryViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.profile
}
