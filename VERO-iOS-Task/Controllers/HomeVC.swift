//
//  HomeVC.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import UIKit

class HomeVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    private let taskTableViewModel = TaskTableViewModel()
    private let realmViewModel = RealmViewModel()
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var taskArray = [Task]()
    private var filteredTaskArray = [Task]()
    
    @IBOutlet weak var networkStatus: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegation()
        createRefresh()
    }
    //MARK: -ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //Getting scanned text from QRScanner and search it
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: K.NotificationCenter.qrScanned), object: nil, queue: nil) { [self] notification in
            if let userInfo = notification.userInfo, let text = userInfo["text"] as? String {
                searchBar.text = text
                searchTypedText()
            }
        }
        showActivityIndicator()
        fetchData()
    }
    //MARK: -TableView delegations
    private func delegation() {
        tableView.delegate = taskTableViewModel
        tableView.dataSource = taskTableViewModel
    }
    
    //MARK: -Getting data from server
    private func fetchData() {
        
        WebManager.shared.fetchData { [self] result in
            switch result {
            case .success(let tasks):
                realmViewModel.deleteData()
                realmViewModel.saveData(offlineTask: OfflineTask().fetchFromTaskModel(sourceArray: tasks))
                taskArray = tasks
                
                taskTableViewModel.update(with: tasks)
                hideActivityIndicator()
                refreshControl.endRefreshing()
                tableView.reloadData()
                networkStatus.title = ""
                
            case .failure:
                let tasks = OfflineTask().pushToTaskModel(sourceArray: RealmViewModel().fetchedData())
                
                taskArray = tasks
                taskTableViewModel.update(with: tasks)
                hideActivityIndicator()
                refreshControl.endRefreshing()
                tableView.reloadData()
                networkStatus.title = "Offline!"
            }
        }
        
    }
    //MARK: -Pull2Refresh
    private func createRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchData()
    }
    
}

//MARK: -SearchBar Extension
extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTypedText()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func searchTypedText() {
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
    
}
