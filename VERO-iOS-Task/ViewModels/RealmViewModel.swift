//
//  RealmViewModel.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 21.02.2023.
//

import Foundation
import RealmSwift

struct RealmViewModel {
    
    func saveData(offlineTask:[OfflineTask]) {
        let realm = try! Realm()
        
        do {
            try realm.write({
                realm.add(offlineTask)
            })
        }catch let error as NSError{
            print(error)
        }
    }
    
    func fetchedData() -> [OfflineTask]{
        let realm = try! Realm()
        let offline = realm.objects(OfflineTask.self)
        
        return Array(offline)
    }
    
    // Delete game data
    func deleteData() {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(fetchedData())
            }
        }catch let error as NSError {
            print(error)
        }
    }
}
