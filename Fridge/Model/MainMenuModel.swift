//
//  MainMenuModel.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/25.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


class StockViewModel: ObservableObject {
    @Published var stockModel = [StockModel]()
    
    func fetchData(){
        guard let uid = FirebaseRealtimeDatabese().getUID() else {
            return
        }
        
        let ref: DatabaseReference! = Database.database().reference()
        
        ref.child("stock/\(uid)/").observeSingleEvent(of: .value, with: {(snapshot) in
            if let data = snapshot.value as? [String:AnyObject] {
                self.stockModel = [StockModel]()
                for key in data.keys.sorted() {
                    let item: AnyObject? = data[key]
                    self.stockModel.append(StockModel(date: key, name: item!["name"] as! String, count: item!["count"] as! Int))
                }
            }
        })
    }
}

class StockModel: Identifiable, ObservableObject {
    var date: String = ""
    @Published var name: String
    @Published var count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
    
    convenience init(date: String, name: String, count: Int) {
        self.init(name: name, count: count)
        self.date = date
    }
}
