//
//  TomorrowSeminarListView.swift
//  Big_Project_C_Customer
//
//  Created by 정소희 on 2022/12/28.
//

import SwiftUI

struct TomorrowSeminarListView: View {
    @Binding var selectedTab: Int
    @ObservedObject var userStore: UserStore
    var seminar : Seminar
    var body: some View {
        VStack(alignment: .leading) {

            NavigationLink(destination: DetailView(selectedTab: $selectedTab, userStore: userStore, seminar: seminar)) {
                
                // 텍스트 부분
                VStack (alignment: .leading){
                    if seminar.category == "프론트" {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.front)
                                .cornerRadius(10)
                                .frame(width: 62, height: 17)
                            Text("\(seminar.category)엔드")
                                .modifier(LabelText())
            
                        }
   
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

                    } else {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.yellow)
                                .cornerRadius(10)
                                .frame(width:52, height: 17)
                            Text(seminar.category)
                                .modifier(LabelText())
                                .kerning(1)
                        }
                    }
                    Text(seminar.name)
                        .fontWeight(.heavy)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .padding(.bottom, 3)
                        Text(seminar.createdDate)
                    }
                    .font(.caption)
                    .foregroundColor(.mediumGray)
                    .padding(.top, 3)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                       // Link("참석 장소 바로가기", destination: (URL(string: seminar.location) ?? URL(string: "www.naver.com")!))
                        Text(seminar.location)
                    }
                    .font(.caption)
                    .foregroundColor(.mediumGray)
                }
                .padding(.horizontal)
            }
        }
      
    }
}

struct TomorrowSeminarListView_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowSeminarListView(selectedTab: .constant(0), userStore: UserStore(), seminar: Seminar(id: "", image: ["https://techit.education/img/techit_ogImage.png"], name: "테스트", date: Date(), startingTime: "", endingTime: "", category: "프론트", location: "광화문", locationUrl: "", hostName: "", hostImage: "", hostIntroduction: "", seminarDescription: "", seminarCurriculum: ""))
    }
}
