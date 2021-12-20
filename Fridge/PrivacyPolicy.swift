//
//  PrivacyPolicy.swift
//  SimpleFamilyFridge
//
//  Created by 鈴木翔太 on 2021/09/02.
//

import SwiftUI
import WebKit

struct PrivacyPolicy: UIViewRepresentable {
    var url: String = "https://techkinoko.com/app_privacypolicy/"
        
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
     
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.load(URLRequest(url: URL(string: url)!))
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}
