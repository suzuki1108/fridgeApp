//
//  Header.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/25.
//

import SwiftUI

struct Header: View {
    let title: FooterModel.Title
    @Binding var showEdit: Bool
    var body: some View {
        ZStack {
            Text(title.rawValue)
                .font(.title3)
            // 在庫画面時並べ替え用Iconボタンを表示
            if title == FooterModel.Title.main {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showEdit.toggle()
                    }, label: {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.trailing)
                            .foregroundColor(Color.myColor(colorCode: .primary))
                    })
                }
            }
        }.padding(.top, 50.0)
        .padding(.bottom, 10.0)
        .frame(maxWidth: .infinity)
        .background(Color.myColor(colorCode: .background))
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(title: .main, showEdit: .constant(false))
    }
}
