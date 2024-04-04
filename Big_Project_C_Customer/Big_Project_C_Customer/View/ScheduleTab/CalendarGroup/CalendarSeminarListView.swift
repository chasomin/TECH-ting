//
//  CalendarSeminarListView.swift
//  Big_Project_C_Customer
//
//  Created by 정소희 on 2022/12/28.
//

import SwiftUI
/*
struct CalendarSeminarListView: View {
    
    //@StateObject var taskModel: TaskViewModel
   // @StateObject var seminarStore: SeminarStore = SeminarStore()
    var seminar : Seminar

    var body: some View {
        NavigationLink(destination: DetailView(seminar: seminar)) {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: seminar.image.first ?? "https://techit.education/img/techit_ogImage.png")){ image in
                    image.resizable()
                        .frame(width: 370, height: 230)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                    
                } placeholder: {
                    Rectangle()
                        .frame(width:370, height: 230)
                    
                }
                
                // 텍스트 부분
                VStack (alignment: .leading){
                    Text(seminar.name)
                        .fontWeight(.heavy)
                    HStack {
                        Image(systemName: "calendar")
                        Text(seminar.createdDate)
                    }
                    .font(.caption)
                    .foregroundColor(.mediumGray)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Link("참석 장소 바로가기", destination: (URL(string: seminar.location) ?? URL(string: "www.naver.com")!))
                    }
                    .font(.caption)
                    .foregroundColor(.mediumGray)
                }
                .padding(.horizontal)
            }
        }
        //        .frame(height:250)
    }
}

struct CalendarSeminarListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSeminarListView(seminar: Seminar(id: "", image: ["https://techit.education/img/techit_ogImage.png"], name: "", date: Date(), startingTime: "", endingTime: "", category: "", location: "", locationUrl: "", host: "", hostIntroduction: "", seminarDescription: "", seminarCurriculum: ""))
    }
}
*/
