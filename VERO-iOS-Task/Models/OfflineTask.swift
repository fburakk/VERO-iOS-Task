//
//  OfflineTask.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 21.02.2023.
//

import Foundation
import RealmSwift

class OfflineTask: Object {
    @Persisted var task: String = ""
    @Persisted var title: String = ""
    @Persisted var desc: String = ""
    @Persisted var colorCode: String = ""
    
    convenience init(task: String,title: String,description: String,colorCode: String) {
        self.init()
        self.task = task
        self.title = title
        self.desc = description
        self.colorCode = colorCode
    }
    
    func fetchFromTaskModel(sourceArray: [Task]) -> [OfflineTask] {
        var result = [OfflineTask]()
        
        for source in sourceArray {
            let target = OfflineTask(task: source.task ?? "", title: source.title ?? "", description: source.description ?? "", colorCode: source.colorCode ?? "")
            result.append(target)
        }
        return result
    }
}
