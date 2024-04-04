//
//  SeminarView.swift
//  Big_Project_C_Customer
//
//  Created by BOMBSGIE on 2022/12/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct SeminarView: View {
    
    var seminar : Seminar
    @Binding var selectedTab: Int
    @ObservedObject var userStore: UserStore
    var body: some View {
        NavigationLink(destination: DetailView(selectedTab: $selectedTab, userStore: userStore, seminar: seminar)) {
            VStack (alignment:.leading){
                
                WebImage(url: URL(string: seminar.image.first ?? "https://techit.education/img/techit_ogImage.png"))
                    .resizable()
                        .frame(width: 350, height: 210)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                        .overlay {
                            if seminar.category == "프론트" {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.front)
                                        .cornerRadius(10)
                                        .frame(width: 62, height: 17)
                                    Text("\(seminar.category)엔드")
                                        .modifier(LabelText())
                    
                                }
                                .offset(x: -138, y: -90)
                                
                            } else if seminar.category == "백엔드" {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.back)
                                        .cornerRadius(10)
                                        .frame(width: 62, height: 17)
                                    Text(seminar.category)
                                        .modifier(LabelText())
                                        .kerning(1)
                                }
                                .offset(x: -138, y: -90)
                                
                            } else if seminar.category == "디자인" {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.design)
                                        .cornerRadius(10)
                                        .frame(width: 62, height: 17)
                                    Text(seminar.category)
                                        .modifier(LabelText())
                                        .kerning(1)
                                }
                                .offset(x: -138, y: -90)
                                
                            } else if seminar.category == "블록체인" {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.blockChain)
                                        .cornerRadius(10)
                                        .frame(width: 62, height: 17)
                                    Text(seminar.category)
                                        .modifier(LabelText())
                                        .kerning(1)
                                }
                                .offset(x: -138, y: -90)
                                
                            } else {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.yellow)
                                        .cornerRadius(10)
                                        .frame(width:62, height: 17)
                                    Text(seminar.category)
                                        .modifier(LabelText())
                                        .kerning(1)
                                }
                                .offset(x: -138, y: -90)
                                
                            }
                        }
                

                // 텍스트 부분
                
                VStack (alignment: .leading){
                    HStack{
                        Text(seminar.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top,5)
                            .padding(.bottom,5)
                            .lineLimit(1)
                        Spacer()
                        
                    }
                    .frame(maxWidth: 330)
                    HStack {
                        Image(systemName: "calendar")
                            .frame(width: 15,height: 15)
//                            .padding(.trailing,-5)
                        Text(seminar.createdDate)
                            .padding(.leading, -5)
                        
                    }
                    .font(.footnote)
                    .foregroundColor(.mediumGray)
                    .padding(.vertical, -2)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .frame(width: 15,height: 15)
//                        Link("참석 장소 바로가기", destination: (URL(string: seminar.location) ?? URL(string: "www.naver.com")!))

                        Text(seminar.location)
                            .padding(.leading, -5)
                        
                    }
                    .font(.footnote)
                    .foregroundColor(.mediumGray)
                }
                .padding(.horizontal, 7)
                
            } .padding(.bottom,40)

        }.toolbarBackground(Color.white, for: .tabBar)
//        .frame(height:250)
    }
}

struct SeminarView_Previews: PreviewProvider {
    static var previews: some View {
        SeminarView(seminar: Seminar(id: "", image: ["https://techit.education/img/techit_ogImage.png"], name: "테스트 세미나1", date: Date(), startingTime: "", endingTime: "", category: "백엔드", location: "광화문", locationUrl: "", hostName: "", hostImage: "", hostIntroduction: "", seminarDescription: "", seminarCurriculum: ""), selectedTab: .constant(3), userStore: UserStore())
    }
}


struct LabelText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.caption2)
            .fontWeight(.heavy)
    }
}
