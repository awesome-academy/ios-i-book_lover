//
//  ProfileViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/4/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import CoreData

final class ProfileViewController: UIViewController {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var readingCollectionView: UICollectionView!
    @IBOutlet private weak var goalView: UIView!
    @IBOutlet private weak var seeMoreLabel: UILabel!
    @IBOutlet private weak var reminderBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var settingBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var trackingGoalLabel: UILabel!
    
    private let bookRepository: BookRepository = BookRepositoryImpl(api: APIService.share)
    var readingISBNList = [String]()
    private let shapeLayer = CAShapeLayer()
    private var userGoal = 0
    private var userProgress = 0
    private var percentage = 0
    private let percentageLabel = UILabel()
    var booksCountList = [Int]()
    var readingBookList = [Book]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        configGoalCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategories()
        configTrackingGoal()
    }
    
    private func prepareUI() {
        readingCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: BookCell.self)
        }
        categoriesCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: CategoryCell.self)
        }
        reminderBarButtonItem.image = UIImage(named: "ic_reminder")?.withRenderingMode(.alwaysOriginal)
        settingBarButtonItem.image = UIImage(named: "ic_settings")?.withRenderingMode(.alwaysOriginal)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreAction))
        seeMoreLabel.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(gesture)
        }
        percentageLabel.do {
            $0.text = "start"
            $0.textAlignment = .right
            $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            $0.font = UIFont.boldSystemFont(ofSize: LabelFont.percentageCircle)
            $0.center = CGPoint(x: goalView.bounds.midX - (goalView.bounds.width / 4), y: goalView.bounds.midY)
        }
        goalView.do {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setGoalAction)))
        }
    }
    
    private func configTrackingGoal() {
        userProgress = defaults.integer(forKey: DefaultKeys.progress)
        userGoal = defaults.integer(forKey: DefaultKeys.goal)
        trackingGoalLabel.text = "\(userProgress)/\(userGoal) books"
        progressChange(progress: userProgress, goal: userGoal)
    }
    
    private func progressChange(progress: Int, goal: Int) {
        userProgress = progress
        userGoal = goal
        trackingGoalLabel.text = "\(userProgress)/\(userGoal) books"
        if userGoal != 0 {
            percentage = Int((Double(userProgress) / Double(userGoal)) * 100)
            percentageLabel.text = "\(percentage) %"
            shapeLayer.strokeEnd = CGFloat(Double(percentage) / 100.0)
        } else {
            percentageLabel.text = "\(0) %"
            shapeLayer.strokeEnd = 0
        }
    }
    
    @objc
    private func setGoalAction() {
        if userGoal == 0 {
            showAlertSetGoal()
        } else if userProgress < userGoal {
            showAlertAdjustGoal()
        } else {
            showAlertFinish()
        }
    }
    
    private func showAlertSetGoal() {
        showAlertWithTextField(inputPlaceholder: "",
                               inputKeyboardType: UIKeyboardType.numberPad,
                               cancelHandler: nil) { (text) in
                                guard let inputText = text else { return }
                                    self.defaults.do {
                                        $0.set(Int(inputText) ?? 0, forKey: DefaultKeys.goal)
                                        $0.set(0, forKey: DefaultKeys.progress)
                                    }
                                    self.progressChange(progress: 0, goal: Int(inputText) ?? 0)
        }
    }
    
    private func showAlertAdjustGoal() {
        showAlert(title: Alerts.adjustTitle,
                  message: Alerts.adjustMessage,
                  actionTitle: Alerts.addAction,
                  cancelHandler: nil,
                  adjustHandler: { (_) in
                    self.showAlertSetGoal()
                }, actionHandler: { (_) in
                    self.userProgress += 1
                    self.defaults.set(self.userProgress, forKey: DefaultKeys.progress)
                    self.progressChange(progress: self.userProgress, goal: self.userGoal)                    
        })
    }

    private func showAlertFinish() {
        showAlert(title: Alerts.doneTitle,
                  message: Alerts.doneMessage,
                  adjustTitle: nil,
                  cancelHandler: nil,
                  adjustHandler: nil,
                  actionHandler: { (_) in
                    self.showAlertSetGoal()
                    self.trackingGoalLabel.text = "\(self.userProgress)/\(self.userGoal) books"
        })
    }
    
    @objc
    private func seeMoreAction() {
        let vc = BooksListViewController.instantiate()
        vc.bookList = readingBookList
        show(vc, sender: nil)
    }
    
    private func fetchCategories() {
        view.activityStartOverlay()
        booksCountList = Array(repeating: 0, count: 4)
        readingBookList.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            if let books = user[0].books, let genres = user[0].genres {
                let bookEnities = books as? Set<BookEntity> ?? Set()
                for book in bookEnities {
                    switch Int(book.progress) {
                    case 0, 1, 2:
                        booksCountList[Int(book.progress)] += 1
                        if Int(book.progress) == 1 {
                            fetchReadingBook(ISBN: book.isbn ?? "")
                        }
                    default:
                        break
                    }
                }
                booksCountList[3] = genres.count
            }
            categoriesCollectionView.reloadData()
            view.activityStopOverlay()
        } catch {
            print(error)
        }
    }
    
    private func fetchReadingBook(ISBN: String) {
        bookRepository.searchBooks(isbn: ISBN) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let books = response?.books else { return }
                
                for i in books {
                    self.readingBookList.append(i)
                }
                self.readingCollectionView.reloadData()
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    private func configGoalCircle() {
        let center = CGPoint(x: goalView.bounds.midX - (goalView.bounds.width / 4), y: goalView.bounds.midY)
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: CGFloat(Constants.radiusCircle),
                                        startAngle: 0,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        let trackLayer = CAShapeLayer().then {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.superLightColor.cgColor
            $0.lineWidth = 10
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = CAShapeLayerLineCap.round
            $0.position = center
        }
        
        shapeLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.mainColor.cgColor
            $0.lineWidth = 10
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = CAShapeLayerLineCap.round
            $0.strokeEnd = 0
            $0.position = center
            $0.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        }

        goalView.do {
            $0.layer.addSublayer(trackLayer)
            $0.layer.addSublayer(shapeLayer)
            $0.addSubview(percentageLabel)
        }
    }
    
    private func animateCircle() {
        let animation = CABasicAnimation(keyPath: "strokeEnd").then {
            $0.toValue = 1
            $0.duration = 2
            $0.fillMode = CAMediaTimingFillMode.forwards
            $0.isRemovedOnCompletion = false
        }
        shapeLayer.add(animation, forKey: "animation")
    }
    
    @IBAction private func settingAction(_ sender: UIBarButtonItem) {
        let vc = SettingViewController.instantiate()        
        show(vc, sender: nil)
    }
}
