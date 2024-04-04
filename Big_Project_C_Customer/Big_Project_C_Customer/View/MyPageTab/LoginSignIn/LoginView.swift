//
//  LoginView.swift
//  Big_Project_C_Customer
//
//  Created by 전준수 on 2022/12/27.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var userStore : UserStore 

    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            TextField("이메일 아이디를 입력하세요", text: $userStore.email)
                .background(RoundedRectangle(cornerRadius: 7).fill(Color.lightGray).frame(width: 330, height: 50))
                .font(.subheadline)
                .frame(width: 300, height: 50)
                .offset(x: 15)
                .padding(.bottom, 5.0) 
                .textInputAutocapitalization(.never)
      
            SecureField("비밀번호를 입력하세요", text: $userStore.password)
                .font(.subheadline)
                .background(RoundedRectangle(cornerRadius: 7).fill(Color.lightGray).frame(width: 330, height: 50))
                .frame(width: 300, height: 50)
                .offset(x: 15)
                .padding(.bottom, 5.0)
                .textInputAutocapitalization(.never)

            //HStack {
            //Circle()
                    //.strokeBorder(.black, lineWidth: 1)
                    //.frame(width: 15, height: 15)
                    
               // Text("자동로그인")
                    /// .font(.caption)
           // }
            //.padding(.bottom, 50.0)
            
            
            Button {
                userStore.login()
            } label: {
                Text("로그인 하기")
                    .frame(width: 330,height: 50)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(.black)
            }.padding(.top,133)
        
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(userStore: UserStore())
    }
}
