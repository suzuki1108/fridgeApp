//
//  FirebaseRealtimeDatabase.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/28.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

/**
 *  FirebaseのRealtimeDatabaseとの接続
 *  及び、データの管理を行います。
 *  ※データの取得(fetch)はViewモデルで実装しています。
 */
class FirebaseRealtimeDatabese {
    
    // データベースのインスタンス
    var ref: DatabaseReference! = Database.database().reference()
    
    /**
     *  ユーザ初回登録時にユーザ固有のデータベースを作成します。
     */
    func databaseInit() -> Void {
        guard let uid = self.getUID() else {
            return
        }
        self.ref.child("stock").updateChildValues([uid: "init"])
        print("データベースの作成が完了しました。")
        return
    }
    
    /**
     *  新規追加した冷蔵庫のアイテムの情報を登録します。
     */
    func createData(data: StockModel) -> Bool {
        guard let uid = self.getUID() else {
            return false
        }
        
        self.ref.child("stock").child(uid).updateChildValues([Date().description: ["name": data.name, "count": data.count]])
        return true
    }
    
    /**
     *  アイテムの個数を更新します。
     */
    func countChange(data: StockModel){
        guard let uid = self.getUID() else {
            return
        }
        self.ref.child("stock/\(uid)/\(data.date)/count").setValue(data.count)
    }
    
    /**
     *  データの削除を実施します。
     */
    func removeData(data: StockModel) -> Void {
        guard let uid = self.getUID() else {
            return
        }
        self.ref.child("stock").child(uid).child(data.date).removeValue()
    }
    
    /**
     *  Firebase Auth のUIDを取得します。
     *  データベースのユーザ判別にはこのキーを使用します。
     */
    func getUID() -> String? {
        guard let uid: String = Auth.auth().currentUser?.uid else {
            print("uidが取得できません。")
            return nil
        }
        return uid
    }
}
