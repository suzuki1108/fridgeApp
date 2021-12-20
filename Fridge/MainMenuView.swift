//
//  ContentView.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct MainMenuView: View {
    
    @Binding var isSignedIn: Bool
    
    @ObservedObject var stockList = StockViewModel()
    @State var showAddItems: Bool = false
    @State var showEdit: Bool = false
    @State var showAlert: Bool = false
    @State var choiseItem: StockModel? = nil
    // ビュー更新用のダミーステート
    @State var dummy: Bool = false
    @Binding var view: FooterModel.FooterConst
    
    func counter(item: StockModel, increment: Int) -> Void {
        if item.count <= 0 && increment == -1 {
            return
        }
        if item.count >= 99 && increment == 1 {
            return
        }
        item.count = item.count + increment
        // データベースの更新
        FirebaseRealtimeDatabese().countChange(data: item)
        // Viewの更新
        self.dummy.toggle()
    }
    
    func remove(item: StockModel) -> Void {
        FirebaseRealtimeDatabese().removeData(data: item)
    }
    
    var body: some View {
        if !self.isSignedIn {
            AuthSignInView()
        } else {
            if view != .main {
                ConfigView(view: self.$view, isSignedIn: self.$isSignedIn)
            } else {
                ZStack {
                    VStack {
                        Header(title: .main, showEdit: $showEdit)
                        List(stockList.stockModel) { item in
                            HStack {
                                if showEdit {
                                    Button(action: {
                                        self.choiseItem = item
                                        self.showAlert = true
                                    }, label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    })
                                    .alert(isPresented: $showAlert, content: {
                                        Alert(title:Text("確認"),
                                              message: Text("本当に削除してもよろしいですか？"),
                                              primaryButton: .cancel(Text("キャンセル"), action: {
                                                self.showEdit = false
                                              }),
                                              secondaryButton: .destructive(Text("削除"), action: {
                                                self.remove(item: self.choiseItem!)
                                                self.stockList.fetchData()
                                                self.showEdit = false
                                              })
                                    )})
                                }
                                Text(item.name)
                                Spacer()
                                Image(systemName: "minus")
                                    .padding()
                                    .foregroundColor(Color.myColor(colorCode: .background))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        self.counter(item: item, increment: -1)
                                    }
                                Text(" \(item.count) ")
                                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .light)))
                                Image(systemName: "plus")
                                    .padding()
                                    .foregroundColor(Color.myColor(colorCode: .background))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        self.counter(item: item, increment: 1)
                                    }
                            }
                        }
                        Footer(view: self.$view)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showAddItems.toggle()
                            }, label: {
                                Image(systemName: dummy ? "plus.circle.fill" : "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65, height: 65)
                                    .padding([.bottom, .trailing], 15)
                                    .foregroundColor(Color.myColor(colorCode: .primary))
                                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                            })
                            .sheet(isPresented: $showAddItems, onDismiss: {
                                self.stockList.fetchData()
                            }, content: {
                                AddItems(isShowing: $showAddItems)
                            })
                        }.padding(.bottom, 100)
                    }
                }.ignoresSafeArea(.all)
                .onAppear {
                    self.isSignedIn = AuthModel.getCurrentUser()
                    self.stockList.fetchData()
                }
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(isSignedIn: .constant(true), view: .constant(.main))
    }
}
