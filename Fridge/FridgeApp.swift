//
//  FridgeApp.swift
//  Fridge
//
//  Created by 鈴木翔太 on 2021/09/04.
//

import SwiftUI

@main
struct FridgeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AuthSignInView()
        }
    }
}
