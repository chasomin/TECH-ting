//
//  DetailView.swift
//  Big_Project_C_Customer
//
//  Created by Yooj on 2022/12/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    
    @State private var apply : Bool = false
    @State private var like : Bool = false
    @State private var isShowingSafari: Bool = false
    @State private var isShowingAlert: Bool = false
    
    @Binding var selectedTab: Int
    @ObservedObject var userStore: UserStore
    var seminar: Seminar
    var body: some View {
        
        // let images = ["detailImage1", "detailImage2", "detailImage3"]
        
        
        VStack{
            ScrollView{
                VStack{
                    ZStack{
                        
                        TabView {
                            ForEach(seminar.image, id: \.self) { image in
                                
                                WebImage(url: URL(string: image))
                                    .resizable()
                                    .frame(width: 400, height: 240)
                                    .aspectRatio(contentMode: .fill)
                                
                            }
                        } //이미지 영억
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 250)
                        
                        
                        if apply{
                            DetailViewApplyRibbonView()
                                .offset(x: 163,y:-91)
                        }
                        
                        
                        
                    }
                    
                    VStack(alignment:.leading,spacing: 25){
                        
                        VStack(alignment:.leading){
                            HStack{
                                VStack(alignment: .leading){
                                    Text("\(seminar.category)") //세미나 카테고리
                                        .fontWeight(.heavy)
                                        //.padding(.trailing,-5)
                                    Text("\(seminar.hostName) 강사님") //세미나 호스트
                        
                                } //카테고리, 강사 이름
                                .font(.footnote).fontWeight(.semibold).foregroundColor(.mediumGray)
                                
                                Spacer()
                                
                                // 추후 좋아요 예정
//                                Button {
//                                    like.toggle()
//                                    //좋아용
//                                } label: {
//                                    Image(systemName: like == true ? "heart.fill" : "heart")
//                                        .font(.body)
//
//                                }
                            } //카테고리, 호스트, 좋아요 버튼
                            
                            
                            Text("\(seminar.name)") //세미나 타이틀
                                .font(.title2) .fontWeight(.bold)
                                .padding(.vertical,1)
                            
                            VStack(alignment: .leading,spacing:5){
                                HStack{
                                    Image(systemName: "calendar")
                                        .frame(width: 15,height: 15)
                                    Text("\(seminar.createdDate) | \(seminar.startingTime) ~ \(seminar.endingTime)")
                                        .padding(.leading, -5)
                                    
                                } //날짜
                                .padding(.top, 5)
                                HStack{
                                    Image(systemName: "mappin.and.ellipse")
                                        .frame(width: 15,height: 15)
                                    Button(action: {
                                        isShowingSafari.toggle()
                                    }) {
                                        Text("\(seminar.location) | 참석 장소 바로 가기")
                                    }
                                    .sheet(isPresented: $isShowingSafari, content: {
                                        SafariView(url: URL(string: seminar.locationUrl) ?? URL(string: "www.naver.com")!)
                                    })
                                    //Link("참석 장소 바로가기", destination: (URL(string: seminar.locationUrl) ?? URL(string: "www.naver.com")!))
                                    .padding(.leading, -5)
                                } //장소
                            } //세미나 날짜, 장소 정보
                            .font(.caption)
                            
                            VStack(alignment:.leading){
                                Text("\(seminar.seminarDescription)")
                            } //강의 상세 내용 - 설명
                            .font(.footnote).lineSpacing(10).kerning(-0.3)
                            .padding(.vertical,10)
                            
                            
                            VStack(alignment:.leading){
                                Text("세미나 커리큘럼")
                                    .font(.headline) .fontWeight(.semibold)
                                    .padding(.top,10)
                                Divider()
                                //                                .padding(.bottom,10)
                                
                                Text("\(seminar.seminarCurriculum)")
                                    .font(.footnote).kerning(-0.3).lineSpacing(10)
                            } //세미나 내용
                            .padding(.vertical,10)
                            
                            
                            
                            VStack(alignment:.leading){
                                Text("호스트 소개")
                                    .font(.headline) .fontWeight(.semibold)
                                    .padding(.top,10)
                                
                                Divider()
                                    .padding(.bottom,5)
                                
                                HStack{
                                    
                                    VStack(alignment:.leading){
                                        Text("안녕하세요.\n개발자 \(seminar.hostName) 입니다. ")
                                            .fontWeight(.semibold)
                                            .padding(.bottom,2)
                                        
                                        Text("\(seminar.hostIntroduction)")
                                            .font(.footnote)
                                    }
                                    
                                    Spacer()
                                    
                                    WebImage(url: URL(string: seminar.hostImage))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.lightGray)
                                        .cornerRadius(50)
                                }
                                
                                
                            } //호스트 소개
                            
                            
                            
                            
                            VStack{
                                Button {
                                    
                                    if apply{
//                                        apply=false
                                        isShowingAlert.toggle()
                                    }else{
                                        //신청하기
                                        if userStore.currentUser == nil {
                                            selectedTab = 3
//                                            apply = false
                                        } else {
                                            apply.toggle()
                                            userStore.updateGoSemId(seminar: seminar)
                                        }
                                        
                                    }
                                    
                                } label: {
                                    Text(apply == true ? "취소하기" : "신청하기")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(apply == true ? Color(.lightGray) : .main)
                                    
                                    
                                }

                                .alert(isPresented: $isShowingAlert) {
                                    Alert(title: Text("세미나 참석 취소"),
                                          message: Text("참석 취소 하시겠습니까?"),
                                          primaryButton:.destructive(Text("네"), action: {
                                        apply = false
                                        userStore.deleteGoSemId(seminar: seminar)
                                        isShowingAlert = false
                                    }), secondaryButton: .cancel(Text("아니요"))
                                    )
                                }

                                
                            } //신청하기 버튼
                            .padding(.vertical,18)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal,25)
                        
                    }
                }
                
                
            }
            .onAppear {
                userStore.fetchCurrentUser {
                    guard let currentUser = userStore.currentUserData else { return }
                    if currentUser.goSemId.contains(seminar.id) {
                        apply = true
                    }
                }
            }
            
            
            

        }
    }
    
    
    struct DetailView_Previews: PreviewProvider {
        static var previews: some View {
            DetailView(selectedTab: .constant(3), userStore: UserStore(), seminar: Seminar(id: "", image: ["https://images.unsplash.com/photo-1542831371-29b0f74f9713?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8aGFja2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"], name: "유지보수하기 어렵게 코딩하는 방법", date: Date(), startingTime: "13시", endingTime: "17시", category: "프론트", location: "광화문 D타워", locationUrl: "", hostName: "박종욱", hostImage: "https://images.unsplash.com/photo-1542831371-29b0f74f9713?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8aGFja2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60", hostIntroduction: "안녕하세요", seminarDescription: "개발자로 평생 먹고 살수 있다.\n프로그래머들은 언제나 남들이 코드를 쉽게 이해할 수 있도록 작성하기 위해 노력한다. 하지만 남들이 쉽게 이해할 수 있는 코드만 작성한다면 자신의 가치를 높일 수 있을까?", seminarCurriculum: "1장. 일반규칙\n2장. 이름 짓기\n3장. 위장술\n4장. 문서화\n5장. 프로그램 디자인\n6장. 코드 혼잡화\n7장. 테스트\n8장. 언어 선택"))
        }
    }
}

