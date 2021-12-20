//
//  AuthModel.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/28.
//

import FirebaseAuth

/**
    Auth関連のUtilクラス
    ログインなどのViewステートと深く関わる物はそれぞれの画面で実装
 */
class AuthModel {
    
    // ユーザが現在ログイン中かを返却する。
    static func getCurrentUser() -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    // パスワード再設定用メールの送付
    static func sendPasswordResetMail() -> Void {
        Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser!.email!) { error in }
    }
    
    // ログアウトする。
    static func signOut() -> Void{
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("SignOut Error: %@", signOutError)
        }
    }
    
    // アカウントを削除する。
    static func deleteAccount() -> Void {
        Auth.auth().currentUser?.delete() { error in
            return
        }
    }
}

