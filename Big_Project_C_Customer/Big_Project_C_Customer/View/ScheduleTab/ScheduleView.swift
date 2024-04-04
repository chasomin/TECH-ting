//
//  ScheduleView.swift
//  Big_Project_C_Customer
//
//  Created by Yooj on 2022/12/27.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var userStore: UserStore
    @Binding var selectedTab: Int
    var body: some View {
        NavigationStack{
            Home(seminar: Seminar(id: "", image: ["https://techit.education/img/techit_ogImage.png"], name: "", date: Date(), startingTime: "", endingTime: "", category: "", location: "", locationUrl: "", hostName: "", hostImage: "", hostIntroduction: "", seminarDescription: "", seminarCurriculum: ""), selectedTab: $selectedTab, userStore: userStore)
         //   CalendarSeminarListView()
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(userStore: UserStore(), selectedTab: .constant(0))
    }
}
