//
//  GenresListViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/9/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import CoreData

final class GenresListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var genresList = [String]()
    var imagesList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOwnGenresImage()
    }
    
    private func prepareUI() {
        tableView.do {
            $0.separatorColor = .mainColor
            $0.tableFooterView = UIView()
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func fetchOwnGenresImage() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            if var list = user[0].genres {
                var counting = 0
                for index in 0..<Genres.genreImages.count where list[counting] == index {
                    imagesList.append(Genres.genreImages[index])
                    counting += 1
                    if  list.count == counting {
                        break
                    }
                }
            }
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension GenresListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BooksListViewController.instantiate()
        vc.do {
            $0.genre = genresList[indexPath.row]
            $0.isGenresList = true
        }        
        show(vc, sender: nil)
    }
}

extension GenresListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GenreDisplayCell
        cell.setContent(genreTitle: genresList[indexPath.row], genreImage: imagesList[indexPath.row])
        return cell
    }
}

extension GenresListViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}
