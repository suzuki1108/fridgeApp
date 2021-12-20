//
//  ColorExtension.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/25.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    // 16進数のカラーコードで色指定できるようにするイニシャライザを追加
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}

extension Color {
    
    enum AppColor: String {
        // ラベンダー
        case background = "cab8d9"
        // プライマリ(濃いめの紫)
        case primary = "8b2bd9"
        // 黄緑系の色
        case lightGreen = "c7d9b8"
    }
    
    static func myColor(colorCode :Color.AppColor) -> Color {
        return Color(UIColor(hex: colorCode.rawValue))
    }
}
