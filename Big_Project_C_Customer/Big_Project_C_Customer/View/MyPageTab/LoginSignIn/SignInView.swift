//
//  SignInView.swift
//  Big_Project_C_Customer
//
//  Created by Yooj on 2022/12/27.
//

import SwiftUI


struct SignInView: View {
    @ObservedObject var userStore : UserStore
    @State private var showPassword: Bool = false
    @State private var showingAlert: Bool = false
    @State private var showModal: Bool = false
    @State private var checkConditions: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            TextField("이름을 입력해주세요.", text: $userStore.nickname)
                .font(.subheadline)
                .background(RoundedRectangle(cornerRadius: 7).fill(Color.lightGray).frame(width: 330, height: 50))
                .frame(width: 300, height: 50)
                .offset(x: 15)
                .textInputAutocapitalization(.never)
                .padding(.bottom, 5.0)
            
            TextField("이메일 아이디를 등록하세요", text: $userStore.signUpEmail)
                .font(.subheadline)
                .background(RoundedRectangle(cornerRadius: 7).fill(Color.lightGray).frame(width: 330, height: 50))
                .frame(width: 300, height: 50)
                .offset(x: 15)
                .padding(.bottom, 12.0)
                .textInputAutocapitalization(.never)
            
            if showPassword {
                ZStack {
                    TextField("비밀번호를 등록하세요", text: $userStore.signUpPw)
                        .font(.subheadline)
                        .background(RoundedRectangle(cornerRadius: 7).fill(Color.lightGray).frame(width: 330, height: 50))
                        .frame(width: 300, height: 50)
                        .offset(x: 15)
                        .padding(.bottom, 5.0)
                        .textInputAutocapitalization(.never)
                    
                    Button {
                        self.showPassword.toggle()
                    } label: {
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 13, weight: .regular))
                    }
                    .foregroundColor(Color("Darkgray"))
                    .offset(x: 160, y: -3)
                }
            } else {
                ZStack {
                    SecureField("비밀번호를 등록하세요", text: $userStore.signUpPw)
                        .font(.subheadline)
                        .background(RoundedRectangle(cornerRadius: 7).fill(Color.lightGray).frame(width: 330, height: 50))
                        .frame(width: 300, height: 50)
                        .offset(x: 15)
                        .padding(.bottom, 5.0)
                        .textInputAutocapitalization(.never)
                    
                    Button {
                        self.showPassword.toggle()
                    } label: {
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 13, weight: .regular))
                    }
                    .foregroundColor(Color("Darkgray"))
                    .offset(x: 160, y: -3)
                }
            }
            
            
            
            
            
            if !userStore.signUpPw.isEmpty && !(userStore.signUpPw.range(of: ".{6,50}$", options: .regularExpression) != nil) {
                Text("6자리 이상 비밀번호를 입력해주세요")
                    .font(.caption)
                    .foregroundColor(.red)
            } else if !userStore.signUpPw.isEmpty && (userStore.signUpPw.range(of: ".{6,50}$", options: .regularExpression) != nil) {
                Text("사용 가능한 비밀번호입니다")
                    .font(.caption)
                    .foregroundColor(.black)
            } else if userStore.signUpPw.isEmpty{
                Text(" ").font(.caption)
                
            }
            
            HStack {
                if checkConditions {
                    Button {
                        self.checkConditions.toggle()
                    } label: {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(Color.pointMain)
                    }
                } else {
                    Button {
                        self.checkConditions.toggle()
                    } label: {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(Color.lightGray)
                    }
                }
                
                Button {
                    self.showModal = true
                } label: {
                    ZStack {
                        Text("회원가입 이용약관")
                            .font(.footnote)
                            .foregroundColor(Color.front)
                            .bold()
                        
                        Divider()
                            .frame(width: 95, height: 1)
                            .background(Color.front)
                            .offset(y: 5.5)
                    }
                }
                .sheet(isPresented: self.$showModal) {
                    ModalView()
                }
                .padding(.trailing, -8)
        
                
                Text("에 동의합니다.")
                    .font(.footnote)
                    .foregroundColor(Color.darkGray)
                    .bold()
            }
            
            
            Button {
                showingAlert = true
            } label: {
                Text("회원가입 하기")
                    .frame(width: 330,height: 50)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(.black)
                
            }.padding(.top,30)
                .alert("회원가입", isPresented: $showingAlert) {
                    
                    if userStore.nickname.isEmpty {
                        Button {
                            
                        } label: {
                            Text("확인")
                        }
                    } else if userStore.signUpEmail.isEmpty {
                        Button {
                            
                        } label: {
                            Text("확인")
                        }
                    } else if userStore.signUpPw.isEmpty {
                        Button {
                            
                        } label: {
                            Text("확인")
                        }
                    } else if !userStore.signUpPw.isEmpty && !(userStore.signUpPw.range(of: ".{6,50}$", options: .regularExpression) != nil) {
                        Button {
                            
                        } label: {
                            Text("확인")
                        }
                    } else if !checkConditions {
                        Button {
                            
                        } label: {
                            Text("확인")
                        }
                    } else {
                  
                        Button {
                            userStore.createNewAccount()
                        } label: {
                            Text("확인")
                        }
                    }
                    
                } message: {
                    if userStore.nickname.isEmpty {
                        Text("이름을 입력해주세요")
                    } else if userStore.signUpEmail.isEmpty {
                        Text("이메일 아이디를 등록하세요")
                    } else if userStore.signUpPw.isEmpty {
                        Text("비밀번호를 등록하세요")
                        
                    } else if !userStore.signUpPw.isEmpty && !(userStore.signUpPw.range(of: ".{6,50}$", options: .regularExpression) != nil) {
                        Text("6자리 이상 비밀번호를 입력해주세요")
                    } else if !checkConditions {
                        Text("회원가입 이용약관을 체크하세요")
                    } else {
                        Text("회원가입을 완료되었습니다.")
                    }
                }
            
            
        }
    }
    
    
}

struct ModalView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        
        List {
     
                Text("회원가입 이용약관")
                    .font(.body)
                    .bold()
                
 
                
                Text("""
Tech!Ting 회원가입 시, 전반적인 세미나 선택 경험을 향상 시키고 각종 서비스와 정보를 전달하기 위해 이메일 및 기타 개인정보 수집 및 이용에 동의한 것으로 간주합니다. 또한 고객님의 동의에 따라 타사 검색엔진 및 SNS 플랫폼을 사용해 다용한 소식, 프로모션 및 알림을 제공할 수 있습니다. 고객님께서는 이에 대한 동의를 거부하실 수 있으며, 다만 동의하지 않으시는 경우 서비스에 제한이 있을 수 있습니다. 보다 자세한 사항은 개인정보 보호정책 및 이용약관의 고지사항을 참조하시기 바랍니다.
""")
                .font(.subheadline)
                
        
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("확인하기")
                    .font(.subheadline)
                  
            }
            .offset(x: 155)
            
        }
        .listStyle(PlainListStyle())
        .offset(x: -10)
            
            
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(userStore: UserStore())
    }
}
