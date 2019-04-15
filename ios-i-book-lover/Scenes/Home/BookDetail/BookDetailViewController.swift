//
//  BookDetailViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/10/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import XLPagerTabStrip
import Then
import Kingfisher
import CoreData

final class BookDetailViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    @IBOutlet private weak var wantToReadView: UIView!
    @IBOutlet private weak var wantToReadLabel: UILabel!
    @IBOutlet private weak var wantToReadImageView: UIImageView!
    
    private let bookDetailRepository: BookDetailRepository = BookDetailRepositoryImpl(api: APIService.share)
    var bookId = ""
    var bookISBN = ""
    var bookDetail = BookDetail()
    
    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        loadData()
        setProgress(progress: -1)
    }
    
    private func prepareUI() {
        wantToReadView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10
            $0.isUserInteractionEnabled = true
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addToBookShelf))
        wantToReadView.addGestureRecognizer(gesture)
    }
    
    @objc
    private func addToBookShelf() {
        let vc = BookShelfViewController.instantiate()
        vc.bookId = bookId
        let navigation = UINavigationController(rootViewController: vc)
        present(navigation, animated: true, completion: nil)
    }
    
    private func loadData() {
        view.activityStartOverlay()
        
        bookDetailRepository.searchBookDetail(id: bookId) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let bookDetail = response?.book else { return }
                
                self.do {
                    $0.bookDetail = bookDetail
                    $0.bookISBN = bookDetail.isbn
                    $0.setContent(book: bookDetail)
                    $0.reloadPagerTabStripView()
                    $0.checkProgress(bookId: bookDetail.id)
                    $0.view.activityStopOverlay()
                }
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    private func checkProgress(bookId: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchBookRequest = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        do {
            let book = try managedContext.fetch(fetchBookRequest)
            for i in book where i.id == bookId {
                setProgress(progress: Int(i.progress))
            }
        } catch {
            print(error)
        }
    }
    
    private func setProgress(progress: Int) {
        if progress != -1 {
            wantToReadView.do {
                $0.layer.backgroundColor = UIColor.white.cgColor
                $0.layer.borderColor = UIColor.mainColor.cgColor
                $0.layer.borderWidth = 1
            }
            wantToReadLabel.do {
                $0.textColor = .mainColor
                $0.text = Constants.progresses[progress]
            }
            wantToReadImageView.image = UIImage(named: "ic_down_2")
        } else {
            wantToReadLabel.do {
                $0.text = Constants.defaultProgress
                $0.textColor = .white
            }
            wantToReadView.do {
                $0.layer.backgroundColor = UIColor.mainColor.cgColor
                $0.layer.borderColor = UIColor.white.cgColor
                $0.layer.borderWidth = 1
            }
            wantToReadImageView.image = UIImage(named: "ic_down")
        }
    }
    
    private func setContent(book: BookDetail) {
        guard let url = URL(string: book.imageUrl) else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: book.imageUrl)
        bookImageView.kf.setImage(with: resource)
        titleLabel.text = book.title
        authorLabel.text = book.author?.name
        ratingView.setRating(rate: Double(book.averageRating) ?? 0.0)
        ratingCountLabel.text = book.ratingsCount
    }
    
    private func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .gray
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .mainColor
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?,
            newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat,
            changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .mainColor
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = AboutBookViewController.instantiate()
        child1.bookDetail = bookDetail
        
        let child2 = ReviewBookViewController.instantiate()
        child2.bookISBN = bookISBN
        
        return [child1, child2]
    }
}
    
extension BookDetailViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}
