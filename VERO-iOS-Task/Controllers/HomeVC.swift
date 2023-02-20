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
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("running")
        delegation()
        createRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func delegation() {
        tableView.delegate = taskTableViewModel
        tableView.dataSource = taskTableViewModel
    }
    
    func fetchData() {
        WebManager.shared.fetchData { [self] tasks in
            taskTableViewModel.update(with: tasks)
            refreshControl.endRefreshing()
            tableView.reloadData()
        } onFailure: { error in
            print(error)
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
