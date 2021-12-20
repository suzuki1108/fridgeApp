//
//  Footer.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/25.
//

import SwiftUI

struct Footer: View {
    var items: [FooterModel] = [
        FooterModel(title: .main, icon: "house.fill", const: .main),
        FooterModel(title: .setting, icon: "gearshape.fill", const: .setting)
    ]
    
    @Binding var view: FooterModel.FooterConst
    
    var body: some View {
        HStack {
            ForEach(items) { item in
                Spacer()
                VStack {
                    Image(systemName: item.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(item.title.rawValue)
                        .font(.footnote)
                        .bold()
                }.foregroundColor(item.const == self.view ? Color.myColor(colorCode: .primary) : .gray)
                .onTapGesture {
                    self.view = item.const
                }
                Spacer()
            }
        }.frame(maxWidth: .infinity)
        .padding(.top, 5.0)
        .padding(.bottom, 15.0)
        .background(Color.myColor(colorCode: .background))
    }
}

struct Footer_Previews: PreviewProvider {
    static var previews: some View {
        Footer(view: .constant(.main))
    }
}
