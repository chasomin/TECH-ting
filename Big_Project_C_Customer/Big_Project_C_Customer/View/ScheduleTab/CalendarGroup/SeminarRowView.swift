//
//  SeminarRowView.swift
//  Big_Project_C_Customer
//
//  Created by 정소희 on 2022/12/28.
//

import SwiftUI
import SDWebImageSwiftUI

struct SeminarRowView: View {
    var seminar : Seminar
    
    @ObservedObject var userStore: UserStore
    @Binding var selectedTab: Int
    
    var body: some View {
            VStack(alignment: .leading) {
                
                Text(seminar.createdDate)
                    .fontWeight(.bold)
                    .padding(.leading, 7)
                
                NavigationLink(destination: DetailView(selectedTab: $selectedTab, userStore: userStore, seminar: seminar)) {
                    VStack(alignment: .leading) {

                        WebImage(url: URL(string: seminar.image.first ?? "https://techit.education/img/techit_ogImage.png"))
                            .resizable()
                            .frame(width: 370, height: 230)
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
                                    .offset(x: -145, y: -100)
                                    
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
                                    .offset(x: -145, y: -100)
                                    
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
                                    .offset(x: -145, y: -100)
                                    
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
                                    .offset(x: -145, y: -100)
                                    
                                } else {
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.yellow)
                                            .cornerRadius(10)
                                            .frame(width: 62, height: 17)
                                        Text(seminar.category)
                                            .modifier(LabelText())
                                            .kerning(1)
                                    }
                                    .offset(x: -140, y: -100)
                                    
                                }
                            }
                        
                        // 텍스트 부분
                        
                        VStack (alignment: .leading){
                            HStack {
                                Text(seminar.name)
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                    .padding(.bottom, -2)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .frame(maxWidth: 350)
                            HStack {
                                Image(systemName: "calendar")
                                    .padding(.bottom, 3)
                                Text(seminar.createdDate)
                            }
                            .font(.caption)
                            .foregroundColor(.mediumGray)
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
//                                Link("참석 장소 바로가기", destination: (URL(string: seminar.location) ?? URL(string: "www.naver.com")!))
                                Text(seminar.location)
                            }
                            .font(.caption)
                            .foregroundColor(.mediumGray)
                        }
                        .padding(.leading, 7)
                    }
                }
                //        .frame(height:250)
            }
    }
}



struct SeminarRowView_Previews: PreviewProvider {
    static var previews: some View {
        SeminarRowView(seminar: Seminar(id: "", image: ["https://techit.education/img/techit_ogImage.png"], name: "아아아", date: Date(), startingTime: "", endingTime: "", category: "", location: "광화문", locationUrl: "", hostName: "", hostImage: "", hostIntroduction: "", seminarDescription: "", seminarCurriculum: ""), userStore: UserStore(), selectedTab: .constant(0))
    }
}
