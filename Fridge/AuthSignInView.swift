//
//  AuthSignInView.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/26.
//

import SwiftUI
import FirebaseAuth

struct AuthSignInView: View {
    
    @State var view: FooterModel.FooterConst = FooterModel.FooterConst.main
    @State private var isSignedIn = false
    @State private var showSignUp = false
    
    @State private var mailAddress = ""
    @State private var password = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    @State private var isShowSignedOut = false
    @State var showPrivacyPolicy = false
    
    var body: some View {
        if self.isSignedIn {
            MainMenuView(isSignedIn: self.$isSignedIn, view: self.$view)
        } else if self.showSignUp {
            AuthSignUpView()
        } else {
            VStack {
                Header(title: .signIn, showEdit: .constant(true))
                Spacer()
                HStack {
                    Spacer().frame(width: 50)
                    VStack(spacing: 16) {
                        TextField("メールアドレス", text: $mailAddress).textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("パスワード", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            self.errorMessage = ""
                            if self.mailAddress.isEmpty {
                                self.errorMessage = "メールアドレスが入力されていません"
                                self.isError = true
                                self.isShowAlert = true
                            } else if self.password.isEmpty {
                                self.errorMessage = "パスワードが入力されていません"
                                self.isError = true
                                self.isShowAlert = true
                            } else {
                                self.signIn()
                            }
                        }) {
                            Text("ログイン")
                                .foregroundColor(.white)
                                .frame(maxWidth: 350, maxHeight: 50)
                                .background(Color.myColor(colorCode: .primary))
                                .cornerRadius(24)
                                .padding(.top, 10)
                        }
                        .alert(isPresented: $isShowAlert) {
                            if self.isError {
                                return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK"), action: {
                                    self.isSignedIn = AuthModel.getCurrentUser()
                                })
                                )
                            } else {
                                return Alert(title: Text(""), message: Text("ログアウトしました"), dismissButton: .default(Text("OK")))
                            }
                        }
                        Text("ユーザ登録はこちら")
                            .foregroundColor(.white)
                            .frame(maxWidth: 350, maxHeight: 50)
                            .background(Color.myColor(colorCode: .background))
                            .cornerRadius(24)
                            .onTapGesture {
                                self.showSignUp = true
                            }
                        Button(action: {
                            showPrivacyPolicy = true
                        }, label: {
                            Text("利用規約・プライバシーポリシー")
                        })
                        .sheet(isPresented: $showPrivacyPolicy, content: {
                            PrivacyPolicy()
                        })
                    }
                    Spacer().frame(width: 50)
                }
                .onAppear() {
                    self.isSignedIn = AuthModel.getCurrentUser()
                }
                Spacer()
            }.ignoresSafeArea(.all)
        }
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: self.mailAddress, password: self.password) { authResult, error in
            if let user = authResult?.user {
                if user.isEmailVerified {
                    self.isSignedIn = true
                    self.isShowAlert = true
                    self.isError = false
                } else {
                    self.isSignedIn = false
                    self.isShowAlert = true
                    self.isError = true
                    self.errorMessage = "メールアドレスが認証されていません。アカウント保護のために受信した認証メールのURLへアクセスしてください。"
                    if let user = authResult?.user {
                        user.sendEmailVerification(completion: { error in
                            if error == nil {
                                print("send mail success.")
                            }
                        })
                    }
                }
            } else {
                self.isSignedIn = false
                self.isShowAlert = true
                self.isError = true
                if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .invalidEmail:
                        self.errorMessage = "メールアドレスの形式が正しくありません"
                    case .userNotFound, .wrongPassword:
                        self.errorMessage = "メールアドレス、またはパスワードが間違っています"
                    case .userDisabled:
                        self.errorMessage = "このユーザーアカウントは無効化されています"
                    default:
                        self.errorMessage = error.domain
                    }
                    self.isError = true
                    self.isShowAlert = true
                }
            }
        }
    }
}

struct AuthSignIn_Previews: PreviewProvider {
    static var previews: some View {
        AuthSignInView()
    }
}
