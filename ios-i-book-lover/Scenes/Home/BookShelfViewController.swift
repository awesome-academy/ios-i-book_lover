//
//  BookShelfViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import Then
import CoreData

final class BookShelfViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var removeButton: UIButton!
    
    private var selectedItem = -1
    private var isUpdatable = false
    var bookId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchProgress()
    }
    
    private func prepareUI() {
        tableView.do {
            $0.separatorColor = .mainColor
            $0.tableFooterView = UIView()
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: ProgressCell.self)
        }
        removeButton.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    private func fetchProgress() {
        view.activityStartOverlay()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            if let books = user[0].books {
                let bookEnities = books as? Set<BookEntity> ?? Set()
                for i in bookEnities where i.id == bookId {
                    selectedItem = Int(i.progress)
                    isUpdatable = true
                    break
                }
            }
            tableView.reloadData()
            view.activityStopOverlay()
        } catch {
            print(error)
        }
    }
    
    private func saveProgress() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "BookEntity", in: managedContext) else { return }
        let book = NSManagedObject(entity: entity, insertInto: managedContext).then {
            $0.setValue(bookId, forKey: "id")
            $0.setValue(Int16(selectedItem), forKey: "progress")
        }
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        do {
            let user = try managedContext.fetch(fetchRequest)
            user[0].addToBooks(book as? BookEntity ?? BookEntity())
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    private func updateProgress() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchBookRequest = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        do {
            let book = try managedContext.fetch(fetchBookRequest)
            for i in 0..<book.count where book[i].id == bookId {
                let objectUpdated = book[i] as NSManagedObject
                objectUpdated.setValue(selectedItem, forKey: "progress")
            }
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    private func removeProgress() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchBookRequest = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        do {
            let book = try managedContext.fetch(fetchBookRequest)
            for i in 0..<book.count where book[i].id == bookId {
                let objectUpdated = book[i] as NSManagedObject
                objectUpdated.setValue(Int16(-1), forKey: "progress")
                do {
                    try managedContext.save()
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction private func doneAction(_ sender: UIBarButtonItem) {
        if (selectedItem != -1) && (isUpdatable == false) {
            saveProgress()
            dismiss(animated: true, completion: nil)
        } else if (selectedItem != -1) && (isUpdatable == true) {
            updateProgress()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func removeBookAction(_ sender: UIButton) {
        if (selectedItem != -1) && (isUpdatable == true) {
            removeProgress()
            dismiss(animated: true, completion: nil)
        }
    }
}

extension BookShelfViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension BookShelfViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.progresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProgressCell
        cell.do {
            $0.delegate = self
            $0.setContent(progress: Constants.progresses[indexPath.row], indexPath: indexPath)
        }
        if selectedItem == indexPath.row {
            cell.selectButton(isSelected: true)
        }
        return cell
    }
}

extension BookShelfViewController: ProgressCellDelegate {
    func didDeSelect(indexPath: IndexPath) {
        guard let indexPaths = tableView.indexPathsForVisibleRows else { return }
        selectedItem = indexPath.row
        for i in indexPaths {
            if i.row != indexPath.row && i.section == indexPath.section {
                guard let cell = tableView.cellForRow(at: IndexPath(row: i.row, section: i.section))
                    as? ProgressCell else
                {
                    return
                }
                cell.selectButton(isSelected: false)
            }
        }
    }
    
    func didSelect(indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))
            as? ProgressCell else { return }
        cell.selectButton(isSelected: true)
    }
}

extension BookShelfViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}
