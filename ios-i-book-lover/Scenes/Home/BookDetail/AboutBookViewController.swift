//
//  AboutBookViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/12/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Reusable
import Then
import Kingfisher
import WebKit

final class AboutBookViewController: UIViewController {
    @IBOutlet private weak var numberOfPagesLabel: UILabel!
    @IBOutlet private weak var publicationDateLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var authorImageView: UIImageView!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var authorRatingView: RatingView!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var knowMoreButton: UIButton!
    @IBOutlet private weak var purchaseButton: UIButton!
    
    private let similiarBookRepository: SimiliarBookRepository = SimiliarBookRepositoryImpl(api: APIService.share)
    private var similiarBook = [Book]()
    var bookDetail = BookDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        setData()
    }
    
    private func prepareUI() {        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: BookCell.self)
        }
        purchaseButton.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 18
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        knowMoreButton.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 12
        }
    }
    
    private func setData() {
        numberOfPagesLabel.text = bookDetail.numOfPages
        publicationDateLabel.text = "\(bookDetail.publishDay)/\(bookDetail.publishMonth)/\(bookDetail.publishYear)"
        publisherLabel.text = bookDetail.publisher
        webView.loadHTMLString(bookDetail.descriptions, baseURL: nil)
        
        if let author = bookDetail.author,
            let imageUrl = author.imageURL?.text,
            let url = URL(string: imageUrl) {
            let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
            authorImageView.kf.setImage(with: resource)
            authorNameLabel.text = author.name
            authorRatingView.setRating(rate: Double(author.averageRating) ?? 0.0)
            ratingCountLabel.text = author.ratingCount
            fetchData(authorName: author.name)
        }
    }
    
    private func fetchData(authorName: String) {
        similiarBookRepository.searchBooks(authorName: authorName) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let reponse):
                if let books = reponse?.books {
                    for i in books {
                        self.similiarBook.append(i)
                    }
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    @IBAction private func knowMoreAction(_ sender: UIButton) {
        guard let link = bookDetail.author?.link, let url = URL(string: link) else { return }
        UIApplication.shared.open(url, options: [:]) { (_) in
        }
    }
    
    @IBAction private func purchaseAction(_ sender: UIButton) {
        guard let url = URL(string: "\(Configuration.purchaseUrl)\(bookDetail.id)") else { return }
        UIApplication.shared.open(url, options: [:]) { (_) in
        }
    }
}

extension AboutBookViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = BooksListViewController.instantiate()
        show(vc, sender: nil)
    }
}

extension AboutBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.preDisplayItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as BookCell
        
        if !similiarBook.isEmpty {
            cell.configCell(book: similiarBook[indexPath.item])
        }
        return cell
    }
}

extension AboutBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Cells.weightBookCell, height: Cells.heightBookCell)
    }
}

extension AboutBookViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: IndicatorChild.about)
    }        
}

extension AboutBookViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}
