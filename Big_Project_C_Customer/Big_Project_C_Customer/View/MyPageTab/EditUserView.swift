//
//  EditUserView.swift
//  Big_Project_C_Customer
//
//  Created by 전준수 on 2022/12/28.
//

import SwiftUI

struct EditUserView: View {
    @ObservedObject var userStore : UserStore
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var showPassword1: Bool = false
    @State private var showPassword2: Bool = false
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text("회원 정보 수정하기")
                    .font(.title2)
                    .bold()
                    
                
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
            } //타이틀
            .padding(.bottom, 45.0)
            .padding(.horizontal,20)
            .padding(.top,20)
            
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("이름 변경")
                        .font(.body)
                        .bold()
                        .padding(.bottom,15)
                    
                    TextField("닉네임을 입력해주세요", text: $userStore.nickname)
                            .font(.footnote)
                            .frame(width: 245)
                            .padding(.leading, 15.0)
                            .padding(.bottom, 5.0)
                    
                        Divider()
                        .frame(width: 275)
                        .background(Color.darkGray)
                        
                }
                
                Spacer()
                
                Button {
                    if !userStore.nickname.isEmpty {
                        userStore.updateNickName()
                        dismiss()
                        self.userStore.nickname = ""
                    }
                } label: {
                    Text("변경하기")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(10)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(10)
                        
                }

            } //이름변경
            .padding(.bottom, 25)
            .padding(.horizontal,20)
            
            VStack(alignment: .leading) {
                
                Text("비밀번호 변경")
                    .font(.body)
                    .bold()
                    .padding(.bottom,15)
                
                VStack{
                    
                    if showPassword1 {
                        ZStack {
                            TextField("비밀번호를 입력해주세요", text: $userStore.updatePw1)
                                .font(.footnote)
                                .frame(width: 245, height: 15)
                            
                            Button {
                                self.showPassword1.toggle()
                            } label: {
                                Image(systemName: self.showPassword1 ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 13, weight: .regular))
                            }
                            .foregroundColor(Color("Darkgray"))
                            .offset(x: 125)
                        }
                        .padding(.bottom, 5.0)
                    } else {
                        ZStack {
                            SecureField("비밀번호를 입력해주세요", text: $userStore.updatePw1)
                                .font(.footnote)
                                .frame(width: 245, height: 15)
                            
                            Button {
                                self.showPassword1.toggle()
                            } label: {
                                Image(systemName: self.showPassword1 ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 13, weight: .regular))
                            }
                            .foregroundColor(Color("Darkgray"))
                            .offset(x: 125)
                        }
                        .padding(.bottom, 5.0)
                    }
                     
                        
                        
                    Divider()
                        .frame(width: 275)
                        .background(Color.darkGray)
                        .padding(.bottom, 20)
                    
                } //비밀번호 입력해주세요
                
                HStack {
                    
                    VStack{
                        if showPassword2 {
                            ZStack {
                                TextField("비밀번호를 다시 한번 입력해주세요", text: $userStore.updatePw2)
                                    .font(.footnote)
                                    .frame(width: 245, height: 15)
                                
                                Button {
                                    self.showPassword2.toggle()
                                } label: {
                                    Image(systemName: self.showPassword2 ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 13, weight: .regular))
                                }
                                .foregroundColor(Color("Darkgray"))
                                .offset(x: 125)
                            }
                            .padding(.bottom, 5.0)
                        } else {
                            ZStack {
                                SecureField("비밀번호를 다시 한번 입력해주세요", text: $userStore.updatePw2)
                                    .font(.footnote)
                                    .frame(width: 245, height: 15)
                                
                                Button {
                                    self.showPassword2.toggle()
                                } label: {
                                    Image(systemName: self.showPassword2 ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 13, weight: .regular))
                                }
                                .foregroundColor(Color("Darkgray"))
                                .offset(x: 125)
                            }
                            .padding(.bottom, 5.0)
                        }
                        
                        Divider()
                            .frame(width: 275)
                            .background(Color.darkGray)
                        
                        
                        
                    } //비밀번호 다시 입력해주세요
                    
                    Spacer()
                    
                    Button {
                        if userStore.updatePw1 == userStore.updatePw2 {
                            if !userStore.updatePw1.isEmpty {
                                if !userStore.updatePw2.isEmpty {
                                    userStore.updatePassword()
                                    dismiss()
                                    self.userStore.updatePw1 = ""
                                    self.userStore.updatePw2 = ""
                                }
                            }
                        }
                        
                    } label: {
                        Text("변경하기")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(10)
                            
                    }.padding(.top,-10)
                } //비밀번호 다시 입력 + 바꾸기 버튼
                
            } //비밀번호 변경
            .padding(.horizontal,20)
            
           
            
            VStack{
                
                Divider()
                    .padding(.top, 50)
                    .padding(.bottom,10)

                    Button {
                        showingAlert1 = true
                    } label: {
                        HStack {
                            Text("로그아웃 하기")
                                .font(.callout)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.mediumGray)
                        }
                    }.padding(.horizontal,20)
                    .alert("로그아웃", isPresented: $showingAlert1) {
                        Button("취소") {}
                        Button("로그아웃") { userStore.logout()}
                           } message: {
                               Text("로그아웃를 하시겠습니까?")
                           }
           
                Divider()
                    .padding(.vertical, 10)
                
                Button {
                    showingAlert2 = true
                } label: {
                    HStack {
                        Text("회원탈퇴")
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.mediumGray)
                    }
                   
                }.padding(.horizontal,20)
                    .alert("회원탈퇴", isPresented: $showingAlert2) {
                        Button("취소") {}
                        Button("회원탈퇴") {userStore.deleteUser()}
                           } message: {
                               Text("회원탈퇴를 하시겠습니까?")
                           }
                
                
            } //로그아웃, 회원탈퇴
            
            Spacer()
            
        }
        
     
    }
}

struct EditUserView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserView(userStore: UserStore())
    }
}
