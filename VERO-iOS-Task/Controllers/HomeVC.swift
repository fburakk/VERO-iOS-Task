//
//  HomeVC.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let taskTableViewModel = TaskTableViewModel()
    private let realmViewModel = RealmViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let refreshControl = UIRefreshControl()
    private var taskArray = [Task]()
    private var filteredTaskArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("running")
        delegation()
        createRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showActivityIndicator()
        fetchData()
        
    }
    
    func delegation() {
        tableView.delegate = taskTableViewModel
        tableView.dataSource = taskTableViewModel
    }
    
    func fetchData() {
        
        WebManager.shared.fetchData { [self] tasks in
            realmViewModel.deleteData()
            realmViewModel.saveData(offlineTask: OfflineTask().fetchFromTaskModel(sourceArray: tasks))
            taskArray = tasks
            
            taskTableViewModel.update(with: tasks)
            hideActivityIndicator()
            refreshControl.endRefreshing()
            tableView.reloadData()
            
            
        } onFailure: { [self] error in
            print(error)
            let tasks = OfflineTask().pushToTaskModel(sourceArray: RealmViewModel().fetchedData())
            
            taskArray = tasks
            taskTableViewModel.update(with: tasks)
            hideActivityIndicator()
            refreshControl.endRefreshing()
            tableView.reloadData()
            
        }
    }
    
    func createRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("reolading")
        fetchData()
    }
}

extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {
            return
        }
        
        filteredTaskArray = taskArray.filter({ tasks in
            if let title = tasks.title, let task = tasks.task, let desc = tasks.description {
                if title.contains(text) || task.contains(text) || desc.contains(text) {
                    return true
                }
            }
            return false
        })
        
        if text.count == 0 {
            filteredTaskArray = taskArray
        }
        
        taskTableViewModel.update(with: filteredTaskArray)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}
