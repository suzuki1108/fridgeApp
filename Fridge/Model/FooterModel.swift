//
//  FooterModel.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/25.
//

class FooterModel: Identifiable {
    var title: Title
    var icon: String
    var const: FooterConst
    
    init(title: Title, icon: String, const: FooterConst) {
        self.title = title
        self.icon = icon
        self.const = const
    }
    
    enum Title: String {
        case signUp = "ユーザー登録"
        case signIn = "ログイン"
        case accountUpdate = "Eメール・パスワード変更"
        case main = "冷蔵庫の中身"
        case setting = "設定"
    }
    
    enum FooterConst {
        case main
        case setting
    }
}
