//
//  WelcomeViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then
import CoreData
import Foundation
import Reusable

final class WelcomeViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var countingLabel: UILabel!
    var genres = Constants.genres
    var genresCount = 0
    var selectedIndexGenres = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        bottomView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.isUserInteractionEnabled = false
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomViewAction))
            $0.addGestureRecognizer(tapGesture)
        }
        collectionView.do {
            $0.register(cellType: WelcomeCell.self)
        }
    }
    
    @objc
    private func bottomViewAction() {
        save(ownGenres: selectedIndexGenres)
    }
    
    private func save(ownGenres: [Int]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
                return
        }
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(ownGenres, forKey: "genres")
        do {
            try managedContext.save()
            let vc = TabBarController.instantiate()
            show(vc, sender: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension WelcomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexGenres.append(indexPath.row)
        genresCount += 1
        countingLabel.text = "\(genresCount) selected"
        if !selectedIndexGenres.isEmpty {
            bottomView.do {
                $0.isUserInteractionEnabled = true
                $0.backgroundColor = .mainColor
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        for index in 0..<selectedIndexGenres.count where selectedIndexGenres[index] == indexPath.row {
                selectedIndexGenres.remove(at: index)
                genresCount -= 1
                countingLabel.text = "\(genresCount) selected"
                break
        }
        collectionView.reloadItems(at: [indexPath])
        if selectedIndexGenres.isEmpty {
            bottomView.do {
                $0.isUserInteractionEnabled = false
                $0.backgroundColor = .basicColor
            }
        }
    }
}

extension WelcomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as WelcomeCell
        cell.genreLabel.text = genres[indexPath.row]
        return cell
    }
}

extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = genres[indexPath.item]
        let font = UIFont.systemFont(ofSize: Constants.fontSize)
        let width = title.width(withConstrainedHeight: Constants.heightGenreWelcome, font: font)
        return CGSize(width: width + 20, height: Constants.heightGenreWelcome)
    }
}
