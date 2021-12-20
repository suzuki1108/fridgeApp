//
//  ConfigView.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/26.
//

import SwiftUI
import FirebaseAuth

struct ConfigView: View {
    @Binding var view: FooterModel.FooterConst
    @Binding var isSignedIn: Bool
    @State var showAlert = false
    @State var showEmailChange = false
    @State var showEmailCheckAlert = false
    @State var showDeleteAccount = false
    @State var showPrivacyPolicy = false
    
    var body: some View {
        if !self.isSignedIn {
            AuthSignInView()
        } else if showEmailChange {
            AuthEmailPasswordUpdateView(view: self.$view, isSignedIn: self.$isSignedIn)
        } else {
            if view != .setting {
                MainMenuView(isSignedIn: self.$isSignedIn, view: self.$view)
            } else {
                VStack {
                    Header(title: .setting, showEdit: .constant(false))
                    List {
                        HStack {
                            Text("メールアドレス・パスワードの変更")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showEmailChange = true
                        }
                        HStack {
                            Text("パスワードを忘れた場合")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showEmailCheckAlert = true
                        }
                        .alert(isPresented: $showEmailCheckAlert, content: {
                            Alert(title:Text("確認"),
                                  message: Text("パスワード再設定用URLを登録メールアドレスに送付します。"),
                                  primaryButton: .cancel(Text("キャンセル")),
                                  secondaryButton: .default(Text("OK"), action: {
                                    AuthModel.sendPasswordResetMail()
                                  })
                            )
                        })
                        HStack {
                            Text("退会する")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showDeleteAccount = true
                        }
                        .alert(isPresented: $showDeleteAccount, content: {
                            Alert(title:Text("確認"),
                                  message: Text("退会すると、今まで保存していた全てのデータが削除されます。本当によろしいですか？"),
                                  primaryButton: .cancel(Text("キャンセル")),
                                  secondaryButton: .destructive(Text("退会"), action: {
                                    AuthModel.deleteAccount()
                                    self.isSignedIn = false
                                  })
                            )
                        })
                        HStack {
                            Text("ログアウト")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showAlert = true
                        }
                        .alert(isPresented: $showAlert, content: {
                            Alert(title:Text("確認"),
                                  message: Text("本当にログアウトしてもよろしいですか？"),
                                  primaryButton: .cancel(Text("キャンセル")),
                                  secondaryButton: .destructive(Text("ログアウト"), action: {
                                    AuthModel.signOut()
                                    self.isSignedIn = false
                                  })
                            )
                        })
                        HStack {
                            Text("利用規約・プライバシーポリシー")
                            Spacer()
                        }
                        .onTapGesture {
                            showPrivacyPolicy = true
                        }
                        .sheet(isPresented: $showPrivacyPolicy, content: {
                            PrivacyPolicy()
                        })
                    }
                    Spacer()
                    Footer(view: self.$view)
                }.ignoresSafeArea(.all)
                .onAppear {
                    self.isSignedIn = AuthModel.getCurrentUser()
                }
            }
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(view: .constant(.setting), isSignedIn: .constant(true))
    }
}
