//
//  AddItems.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/25.
//

import SwiftUI
import Combine

struct AddItems: View {
    @Binding var isShowing: Bool
    @State var name = ""
    @State var count = 0
    @State var showResult = false
    @State var saveResult = false
    
    func save() -> Bool{
        return FirebaseRealtimeDatabese().createData(
            data: StockModel(name: self.name, count: self.count)
        )
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("食品名"), content: {
                        HStack {
                            TextField("食品名を入力してください", text: $name)
                                .onReceive(Just(name), perform: { _ in
                                    if name.count >= 20 {
                                        name = String(name.prefix(20))
                                    }
                                })
                        }
                    })
                    Section(header: Text("個数"), content: {
                        Stepper(value: $count, in: 0...99) {
                            Text("\(count)")
                        }
                    })
                }.navigationTitle("冷蔵庫に追加する")
                .navigationBarItems(trailing: Button(action: {
                    isShowing = false
                }, label: {
                    Text("閉じる")
                }))
                Button(action: {
                    self.saveResult = self.save()
                    showResult = true
                }, label: {
                    Text("保存する")
                        .foregroundColor(.white)
                        .frame(maxWidth: 350, maxHeight: 50)
                        .background(self.name.isEmpty ? .gray : Color.myColor(colorCode: .primary))
                        .cornerRadius(24)
                })
                .disabled(self.name.isEmpty)
                .alert(isPresented: self.$showResult, content: {
                    Alert(title: Text("確認") ,message: Text(self.saveResult ? "保存しました。" : "保存に失敗しました。"), dismissButton: .default(Text("OK"), action: {
                        isShowing = !self.saveResult
                    }))
                })
            }
        }.ignoresSafeArea(.all)
    }
}

struct AddItems_Previews: PreviewProvider {
    static var previews: some View {
        AddItems(isShowing: .constant(true))
    }
}
