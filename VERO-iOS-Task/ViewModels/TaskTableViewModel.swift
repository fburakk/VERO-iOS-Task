//
//  TaskTableView.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import Foundation
import UIKit


protocol TaskTableViewModelDelegate {
    func update(with task:[Task]?)
}

class TaskTableViewModel: NSObject {
    
    var tasks: [Task]?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TaskTableView.cellID) as! TaskCell
        cell.taskLabel.text = tasks?[indexPath.row].task
        cell.titleLabel.text = tasks?[indexPath.row].title
        cell.descLabel.text = tasks?[indexPath.row].description
        
        cell.backgroundColor =  UIColor(hexString: tasks?[indexPath.row].colorCode ?? "#FFFFFF")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
}

extension TaskTableViewModel: UITableViewDelegate,UITableViewDataSource {}

extension TaskTableViewModel: TaskTableViewModelDelegate {
    
    func update(with task: [Task]?) {
        tasks = task
    }
}
