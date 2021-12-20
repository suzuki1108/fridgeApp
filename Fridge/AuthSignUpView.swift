//
//  AuthSignUpView.swift
//  SimpleFamilyFridge
//
//  Created by user on 2021/08/27.
//

import SwiftUI
import FirebaseAuth

struct AuthSignUpView: View {
    
    @State var view: FooterModel.FooterConst = FooterModel.FooterConst.main
    @State private var isSignedIn = false
    @State private var showSignIn = false
    
    @State private var mailAddress = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    @State var showPrivacyPolicy = false
    
    var body: some View {
        if self.isSignedIn {
            MainMenuView(isSignedIn: self.$isSignedIn, view: self.$view)
        } else if self.showSignIn {
            AuthSignInView(view: .main)
        } else {
            VStack {
                Header(title: .signUp, showEdit: .constant(true))
                VStack {
                    Text("")
                    Text("※お願い")
                    Text("このアプリケーションでは冷蔵庫の中身を保存して家族と共有するために、ユーザー登録が必要です。作成したアカウントを家族で共有して使ってください。")
                    Text("")
                }
                .background(Color.myColor(colorCode: .background))
                .cornerRadius(20)
                .padding(.top, 100)
                .padding(.bottom, 20)

                HStack {
                    Spacer().frame(width: 50)
                    VStack {
                        TextField("メールアドレス", text: $mailAddress).textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("パスワード", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("パスワード確認", text: $passwordConfirm).textFieldStyle(RoundedBorderTextFieldStyle())
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
                            } else if self.passwordConfirm.isEmpty {
                                self.errorMessage = "確認パスワードが入力されていません"
                                self.isError = true
                                self.isShowAlert = true
                            } else if self.password.compare(self.passwordConfirm) != .orderedSame {
                                self.errorMessage = "パスワードと確認パスワードが一致しません"
                                self.isError = true
                                self.isShowAlert = true
                            } else {
                                self.signUp()
                            }
                        }) {
                            Text("ユーザー登録")
                            .foregroundColor(.white)
                            .frame(maxWidth: 350, maxHeight: 50)
                            .background(Color.myColor(colorCode: .primary))
                            .cornerRadius(24)
                            .padding(.top, 10)
                        }
                        .alert(isPresented: $isShowAlert) {
                            if self.isError {
                                return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK"))
                                )
                            } else {
                                return Alert(title: Text(""), message: Text("登録されました。続いて、受信したEメールのURLにアクセスしEメール認証を行ってください。"), dismissButton: .default(Text("OK"), action: {
                                        self.isSignedIn = AuthModel.getCurrentUser()
                                    }))
                            }
                        }
                        Text("ログインはこちら")
                            .foregroundColor(.white)
                            .frame(maxWidth: 350, maxHeight: 50)
                            .background(Color.myColor(colorCode: .background))
                            .cornerRadius(24)
                            .padding(.top, 10)
                            .onTapGesture {
                                self.showSignIn = true
                            }
                        Button(action: {
                            showPrivacyPolicy = true
                        }, label: {
                            Text("利用規約・プライバシーポリシー")
                        })
                        .padding()
                        .sheet(isPresented: $showPrivacyPolicy, content: {
                            PrivacyPolicy()
                        })
                    }
                    Spacer().frame(width: 50)
                }
                Spacer()
            }.ignoresSafeArea(.all)
        }
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: self.mailAddress, password: self.password) { authResult, error in
            // 認証メールを送信する
            if let user = authResult?.user {
                user.sendEmailVerification(completion: { error in
                    if error == nil {
                        print("send mail success.")
                    }
                })
            }
            
            if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.errorMessage = "メールアドレスの形式が正しくありません"
                case .emailAlreadyInUse:
                    self.errorMessage = "このメールアドレスは既に登録されています"
                case .weakPassword:
                    self.errorMessage = "パスワードは６文字以上で入力してください"
                default:
                    self.errorMessage = error.domain
                }
                
                self.isError = true
                self.isShowAlert = true
            }
            
            if let _ = authResult?.user {
                FirebaseRealtimeDatabese().databaseInit()
                self.isError = false
                self.isShowAlert = true
            }
        }
    }
}

struct AuthSignUp_Previews: PreviewProvider {
    static var previews: some View {
        AuthSignUpView()
    }
}
