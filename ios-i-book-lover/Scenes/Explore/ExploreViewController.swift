//
//  ExploreViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/4/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import Then

final class ExploreViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var topTableViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pageLabel: UILabel!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    private let bookRepository: BookRepository = BookRepositoryImpl(api: APIService.share)
    private var booksList = [Book]()
    private var searchedKeyWords = [String]()
    private var isKeyWord = true
    private var totalResults = 0.0
    private var numberOfPages = 0
    private var currentPage = 1
    private var isNewSearch = true
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadKeyWords()
    }
    
    private func prepareUI() {
        tableView.do {
            $0.separatorColor = .mainColor
            $0.tableFooterView = UIView()
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: BookListCell.self)
            $0.register(cellType: KeyWordCell.self)
        }
        searchBar.delegate = self
        loadKeyWords()
        toggleView(isKeyword: isKeyWord)
    }
    
    private func loadKeyWords() {
        searchedKeyWords = defaults.stringArray(forKey: DefaultKeys.keyWord) ?? [String]()
    }
    
    private func saveKeyWords(newKeyWord: String) {
        if !newKeyWord.isEmpty {
            searchedKeyWords.append(newKeyWord)
            defaults.set(searchedKeyWords, forKey: DefaultKeys.keyWord)
        }
    }
    
    private func toggleView(isKeyword: Bool) {
        if isKeyword == true {
            pageLabel.isHidden = true
            previousButton.isHidden = true
            nextButton.isHidden = true
            clearButton.isHidden = false
            topTableViewLayoutConstraint.constant = 20
        } else {
            pageLabel.isHidden = false
            previousButton.isHidden = false
            nextButton.isHidden = false
            clearButton.isHidden = true
            topTableViewLayoutConstraint.constant = 0
        }
    }
    
    private func fetchData(query: String, page: String) {
        view.activityStartAnimating(activityColor: .mainColor)
        isKeyWord = false
        loadKeyWords()
        booksList.removeAll()
        tableView.reloadData()
        var newPage = ""
        if isNewSearch {
            newPage = "1"
            currentPage = 1
            pageLabel.text = newPage
        } else {
            newPage = page
        }
        
        bookRepository.searchAllBooks(query: query, page: newPage) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let books = response?.books, let total = response?.totalResults {
                    for i in books {
                        self.booksList.append(i)
                    }
                    self.totalResults = Double(total) ?? 0
                    self.numberOfPages = self.caculateNumberOfPages(totalResults: self.totalResults)
                } else {
                    self.numberOfPages = 1
                }
                self.tableView.reloadData()
                self.view.activityStopAnimating()
                query.isEmpty ? self.toggleView(isKeyword: true) : self.toggleView(isKeyword: false)
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    private func caculateNumberOfPages(totalResults: Double) -> Int {
        if totalResults < 20 {
            isNewSearch = true
            return 1
        }
        var number = 0
        let tempResult = Double(totalResults / 20)
        number = Int(tempResult)
        let numberAfterDecimal = tempResult.truncatingRemainder(dividingBy: 1)
        let roundedNumber = (round(numberAfterDecimal * 1_000) / 1_000)
        number += Int(roundedNumber * 20)
        return number
    }
    
    @IBAction private func previousAction(_ sender: UIButton) {
        isNewSearch = false
        if currentPage > 1 {
            currentPage -= 1
            pageLabel.text = String(currentPage)
            fetchData(query: searchBar.text ?? "", page: String(currentPage))
        }
    }
    
    @IBAction private func nextAction(_ sender: UIButton) {
        isNewSearch = false
        if currentPage < numberOfPages {
            currentPage += 1
            pageLabel.text = String(currentPage)
            fetchData(query: searchBar.text ?? "", page: String(currentPage))
        }
    }
    
    @IBAction private func clearKeyWordAction(_ sender: UIButton) {
        defaults.do {
            $0.removeObject(forKey: DefaultKeys.keyWord)
            $0.synchronize()
        }
        searchedKeyWords.removeAll()
        tableView.reloadData()
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.isEmpty ?? false {
            isKeyWord = true
            toggleView(isKeyword: isKeyWord)
            tableView.reloadData()
        } else {
            saveKeyWords(newKeyWord: searchBar.text ?? "")
            fetchData(query: searchBar.text ?? "", page: String(currentPage))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isKeyWord = true
            isNewSearch = true
            toggleView(isKeyword: isKeyWord)
            tableView.reloadData()
        }
    }
}

extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isKeyWord == true {
            let reversedList: [String] = Array(searchedKeyWords.reversed())
            searchBar.text = reversedList[indexPath.row]
        } else {
            let vc = BookDetailViewController.instantiate()
            vc.bookId = booksList[indexPath.row].id?.text ?? ""
            show(vc, sender: nil)
        }
    }
}

extension ExploreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isKeyWord ? searchedKeyWords.count : booksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isKeyWord == true {
            let reversedList: [String] = Array(searchedKeyWords.reversed())
            let cell = tableView.dequeueReusableCell(for: indexPath) as KeyWordCell
            cell.setContent(keyword: reversedList[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath) as BookListCell
        cell.setContent(book: booksList[indexPath.row])
        return cell
    }
}

extension ExploreViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.explore
}
