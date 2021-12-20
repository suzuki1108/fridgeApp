//
//  AuthEmailPasswordUpdateView.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/28.
//

import SwiftUI
import FirebaseAuth

struct AuthEmailPasswordUpdateView: View {
    
    @Binding var view: FooterModel.FooterConst
    @Binding var isSignedIn: Bool
    @State var viewBack = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    
    @State private var isShowEmailUpdateAlert = false
    @State private var isShowPasswordUpdateAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    var body: some View {
        if !isSignedIn {
            AuthSignInView()
        } else if viewBack {
            ConfigView(view: self.$view, isSignedIn: self.$isSignedIn)
        } else {
            VStack {
                Header(title: .accountUpdate, showEdit: .constant(true))
                HStack {
                    HStack {
                        Image(systemName: "return")
                        Text("設定画面に戻る")
                    }.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        self.viewBack = true
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer().frame(width: 50)
                    VStack {
                        Text("新しいメールアドレス")
                        TextField("mail@example.com", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            if self.email.isEmpty {
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "メールアドレスが入力されていません"
                            } else {
                                Auth.auth().currentUser?.updateEmail(to: self.email) { error in
                                    self.isShowEmailUpdateAlert = true
                                    if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                                        switch errorCode {
                                        case .invalidEmail:
                                            self.errorMessage = "メールアドレスの形式が正しくありません"
                                        case .requiresRecentLogin:
                                            self.errorMessage = "ログインしてください"
                                        default:
                                            self.errorMessage = error.localizedDescription
                                        }
                                        self.isError = true
                                    } else {
                                        self.isError = false
                                    }
                                }
                            }
                        }) {
                            Text("メールアドレス変更")
                                .foregroundColor(.white)
                                .frame(maxWidth: 350, maxHeight: 50)
                                .background(Color.myColor(colorCode: .background))
                                .cornerRadius(24)
                                .padding(.top, 10)
                        }
                        .alert(isPresented: $isShowEmailUpdateAlert) {
                            if self.isError {
                                return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK")))
                            } else {
                                return Alert(title: Text(""), message: Text("メールアドレスが更新されました。続いて、受信したEメールのURLにアクセスしEメール認証を行ってください。"), dismissButton: .default(Text("OK")))
                            }
                        }
                        Spacer().frame(height: 50)
                        Text("新しいパスワード")
                        SecureField("半角英数字", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("パスワード確認")
                        SecureField("半角英数字", text: $confirm).textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            if self.password.isEmpty {
                                self.isShowPasswordUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "パスワードが入力されていません"
                            } else if self.confirm.isEmpty {
                                self.isShowPasswordUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "確認パスワードが入力されていません"
                            } else if self.password.compare(self.confirm) != .orderedSame {
                                self.isShowPasswordUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "パスワードと確認パスワードが一致しません"
                            } else {
                                Auth.auth().currentUser?.updatePassword(to: self.password) { error in
                                    self.isShowPasswordUpdateAlert = true
                                    if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                                        switch errorCode {
                                        case .weakPassword:
                                            self.errorMessage = "パスワードは６文字以上で入力してください"
                                        case .requiresRecentLogin:
                                            self.errorMessage = "ログインしてください"
                                        default:
                                            self.errorMessage = error.localizedDescription
                                        }
                                        self.isError = true
                                    } else {
                                        self.isError = false
                                    }
                                }
                            }
                        }) {
                            Text("パスワード変更")
                                .foregroundColor(.white)
                                .frame(maxWidth: 350, maxHeight: 50)
                                .background(Color.myColor(colorCode: .background))
                                .cornerRadius(24)
                                .padding(.top, 10)
                        }
                        .alert(isPresented: $isShowPasswordUpdateAlert) {
                            if self.isError {
                                return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK")))
                            } else {
                                return Alert(title: Text(""), message: Text("パスワードが更新されました"), dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                    Spacer().frame(width: 50)
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

struct AuthEmailPasswordUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        AuthEmailPasswordUpdateView(view: .constant(.setting), isSignedIn: .constant(true))
    }
}
