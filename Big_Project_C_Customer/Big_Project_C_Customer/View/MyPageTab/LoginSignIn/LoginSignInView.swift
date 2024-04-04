//
//  LoginSignInView.swift
//  Big_Project_C_Customer
//
//  Created by 전준수 on 2022/12/27.
//

import SwiftUI

enum LoginSignView: String {
    case login = "로그인"
    case signIn = "회원가입"
}

struct LoginSignInView: View {
    @ObservedObject var userStore : UserStore 
    @State var showMenu: Bool = false
    @State var loginSignInView: LoginSignView = .login
    
    var loginSignInArray: [LoginSignView] = [.login, .signIn]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading,spacing: 6) {
               
                Text("안녕하세요. \nTECH!Ting 에 오신 것을")
                        .font(.title2)
                        .bold()
                
                Text("환영합니다!")
                    .font(.title)
                    .bold()
                
                Text("테킷팅에서 코딩의 시작을 경험해보세요")
                    .font(.body)
            }
            
            Divider()
                .padding(.vertical,10)
               
            
            HStack() {
                ForEach(loginSignInArray, id: \.self) { select in
                    ZStack {
                        Button {
                            loginSignInView = select
                        } label: {
                            Text(select.rawValue)
                                .foregroundColor(loginSignInView == select ? Color(.black) : Color(.lightGray))
                                .font(.body)
                                .fontWeight(.bold)
                        }
                        
                        
                        if loginSignInView == select {
                            Capsule()
                                .foregroundColor(.black)
                                .frame(width: 60 ,height: 2)
                                .offset(y: 17)
                        }
                    }
                }.frame(width:60)
            }
            .padding(.top,10)
            .padding(.bottom,30)
            
            switch loginSignInView {
            case .login:
                LoginView(userStore: userStore)
            case .signIn:
                SignInView(userStore: userStore)
            }
               
        }      
        .padding(.horizontal,50)

    }
}

struct LoginSignInView_Previews: PreviewProvider {
   static var previews: some View {
        LoginSignInView(userStore: UserStore())
    }
}
