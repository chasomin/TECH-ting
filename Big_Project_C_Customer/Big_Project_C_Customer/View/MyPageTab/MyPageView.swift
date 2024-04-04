//
//  MyPageView.swift
//  Big_Project_C_Customer
//
//  Created by Yooj on 2022/12/27.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var userStore : UserStore
    @StateObject var seminarStore = SeminarStore()
    @State var showModal = false
    
    var body: some View {
        
        NavigationStack{
            
            VStack(alignment: .leading) {
                
                
                
                Text("안녕하세요")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top,40)
                
                
                
                HStack {
                    Text("\(userStore.currentUserData?.nickname ?? "")님!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        self.showModal.toggle()
                    } label: {
                        Text("회원정보 수정하기")
                            .padding(4)
                            .padding(.horizontal,10)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(.black), lineWidth: 1)
                            )
                    }.buttonStyle(.plain)
                        .fullScreenCover(isPresented: $showModal) {
                            EditUserView(userStore: userStore)
                        }
                }
                .padding(.bottom, 20.0)
                
                Divider()
                
                HStack {
                    Image(systemName: "qrcode")
                    
                    Text("나의 테킷!")
                        .font(.title2)
                        .bold()
                }.padding(.vertical,10)
            }
            .padding(.horizontal, 30)
            
            
            List {
                ForEach(userStore.currentUserSeminars) { seminar in
                    NavigationLink {
                        TicketView(seminar: seminar, userStore: userStore).toolbar(.hidden, for: .tabBar)
                    } label: {
                        HStack {
                            VStack(alignment: .leading,spacing: 2) {
                                ZStack {
                                    if seminar.category == "프론트" {
                                        Rectangle()
                                            .foregroundColor(Color("Front"))
                                            .cornerRadius(10)
                                            .frame(width:52, height: 17)
                                    } else if seminar.category == "백엔드" {
                                        Rectangle()
                                            .foregroundColor(Color("Back"))
                                            .cornerRadius(10)
                                            .frame(width:52, height: 17)
                                    } else if seminar.category == "디자인" {
                                        Rectangle()
                                            .foregroundColor(Color("Design"))
                                            .cornerRadius(10)
                                            .frame(width:52, height: 17)
                                    } else if seminar.category == "블록체인" {
                                        Rectangle()
                                            .foregroundColor(Color("Blockchain"))
                                            .cornerRadius(10)
                                            .frame(width:52, height: 17)
                                    } else {
                                        Rectangle()
                                            .foregroundColor(.yellow)
                                            .cornerRadius(10)
                                            .frame(width:52, height: 17)
                                    }
                                    
                                    // 카테고리
                                    if seminar.category == "프론트" {
                                        Text("프론트엔드")
                                            .foregroundColor(.white)
                                            .font(.system(size: 9, weight: .bold))
                                            .bold()
                                    } else {
                                        Text(seminar.category)
                                            .foregroundColor(.white)
                                            .font(.system(size: 9, weight: .bold))
                                            .bold()
                                    }
                                }
                                Text(seminar.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(seminar.createdDate)
                                    .font(.subheadline)
                                    .foregroundColor(.mediumGray)
                                Text(seminar.location)
                                    .font(.subheadline)
                                    .foregroundColor(.mediumGray)
                            }
                        }
                    }
                    .padding(.vertical, 10.0)
                }
            }
            .listStyle(.plain)
            .padding(.horizontal, 10)
        }
        .onAppear {
            userStore.fetchCurrentUser{
                seminarStore.fetchSeminarEscaping {
                    userStore.currentUserSeminars = []
                    guard let currentUser = userStore.currentUserData else { return }
                    for seminar in seminarStore.seminarList {
                        if currentUser.goSemId.contains(seminar.id) {
                            userStore.currentUserSeminars.append(seminar)
                        }
                    }
                }
            }
        }
    }
}





struct MyPageView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            MyPageView(userStore: UserStore())
        }
    }
}
