//
//  RealmViewModel.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 21.02.2023.
//

import Foundation
import RealmSwift

struct RealmViewModel {
    //Save downloaded data from API
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
    //Get saved data from database
    func fetchedData() -> [OfflineTask]{
        let realm = try! Realm()
        let offline = realm.objects(OfflineTask.self)
        
        return Array(offline)
    }
    
    // Delete all datas from database
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
