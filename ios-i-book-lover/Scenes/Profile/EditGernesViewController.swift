//
//  EditGernesViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import CoreData

final class EditGernesViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var selectedIndexGenres = [Int]()
    private var genres = Constants.genres
    private var counting = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGenres()
    }
    
    private func prepareUI() {
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.allowsMultipleSelection = true
            $0.register(cellType: WelcomeCell.self)
        }
    }
    
    private func fetchGenres() {
        view.activityStartOverlay()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            if let genres = user[0].genres {
                selectedIndexGenres = genres
            }
            collectionView.reloadData()
            view.activityStopOverlay()
        } catch {
            print(error)
        }
    }
    
    private func saveGenres(ownGenres: [Int]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            user[0].setValue(ownGenres, forKey: "genres")
            do {
                try managedContext.save()
                dismiss(animated: true, completion: nil)
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction private func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneAction(_ sender: UIBarButtonItem) {
        if !selectedIndexGenres.isEmpty {
            saveGenres(ownGenres: selectedIndexGenres)
        }
    }
}

extension EditGernesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexGenres.append(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        for index in 0..<selectedIndexGenres.count where selectedIndexGenres[index] == indexPath.row {
            selectedIndexGenres.remove(at: index)
            break
        }
        collectionView.reloadData()
    }    
}

extension EditGernesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as GenreEditCell
        let genre = genres[indexPath.item]
        for i in 0..<selectedIndexGenres.count where indexPath.item == selectedIndexGenres[i] {
            collectionView.selectItem(at: indexPath,
                                      animated: true,
                                      scrollPosition: [])
        }
        collectionView.reloadItems(at: [indexPath])
        cell.setContent(genreTitle: genre)
        return cell
    }
}

extension EditGernesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = genres[indexPath.item]
        let font = UIFont.systemFont(ofSize: Cells.fontSize)
        let width = title.width(withConstrainedHeight: Cells.heightGenreWelcome, font: font)
        return CGSize(width: width + 20, height: Cells.heightGenreWelcome)
    }
}

extension EditGernesViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.profile
}
