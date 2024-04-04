//
//  Home.swift
//  rerecalendar
//
//  Created by 조운상 on 2022/12/27.
//

import SwiftUI

struct Home: View {
    @StateObject var seminarStore: SeminarStore = SeminarStore()
    let seminar: Seminar
    // @StateObject var seminarStore: SeminarStore
    @Namespace var animation
    
    @Binding var selectedTab: Int
    @ObservedObject var userStore: UserStore
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // MARK: Lazy Stack with Pinned Header
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    Section {
                        
                        // MARK: Current Week View
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10) {
                                
                                ForEach(seminarStore.currentWeek, id: \.self) { day in
                                    
                                    VStack(spacing: 10) {
                                        
                                        Text(seminarStore.extractDate(date: day, format: "EEE"))
                                            .font(.system(size: 14))
                                        
                                        Text(seminarStore.extractDate(date: day, format: "dd"))
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                        
                                        
                                        //MARK: Foreground Style
                                        //                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                            .foregroundColor(seminarStore.isToday(date: day) ? .white : .black)
                                        //MARK: Circle Shape
                                            .frame(width: 50, height: 50)
                                            .background(
                                                ZStack {
                                                    //MARK: Matched Geometry Effect
                                                    if seminarStore.isToday(date: day) {
                                                        Circle()
                                                            .fill(.black)
                                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                                    
                                                    }
                                                }
                                                
                                            )
                                    }
                                    .contentShape(Capsule()) //??
                                    .onTapGesture {
                                        //Updating Current Day
                                        withAnimation {
                                            seminarStore.currentDay = day
                                        }
                                    }
                                    .background {
                                        ZStack{
                                            if let task = seminarStore.seminarList.first(where: { task in
                                                return isSameDay(date1: task.date, date2: day)
                                            }) {
                                              
                                                Circle()
                                                    .fill(isSameDay(date1: task.date, date2: day) ? .black : .white)
                                                    .frame(width: 8, height: 8)
                                                    .offset(y:30)
                                            }
                                           
                                        }
                                    }
                                }
                                
                            }//HStack
                            .padding([.leading, .top, .bottom])
                            .background {
                                Color("Lightgray")
                            }
                        }
                        TaskView()
                            .padding(.bottom, 20)
                        Divider()
                        TomorrowTaskView()
                    } header: {
                        //  HeaderView()
                    }
                }
                Divider()
                HStack {
                    Spacer()
                }
                .padding(.leading, 20)
                
                Spacer()
            }
            .onAppear {
                seminarStore.fetchSeminar()
            }
            //VStack
            //        .onAppear {
            //            seminarStore.matchDate {
            //                for index in 0 ..< seminarStore.seminarList.count {
            //                    seminarStore.seminarList[index].date
            //                }
            //            }
            //
            //        }
        }
        
        
    }
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // MARK: Task View
    func TaskView() -> some View {
        
        LazyVStack(spacing: 18) {
            
            if let tasks = seminarStore.filteredSeminar {
                
                if tasks.isEmpty {
                    Text("오늘 세미나 없음")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .padding(.top)
                    //                        .offset(y: 100)
                } else {
                   // ScrollView(.horizontal, showsIndicators: false) {
                    if tasks.count < 2 {
                        HStack{
                            TabView{
                                ForEach(tasks) {
                                    task in
                                    SeminarRowView(seminar: task, userStore: userStore, selectedTab: $selectedTab)
                                }
                                
                            }
                            .tabViewStyle(.page)
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

                            .frame(height: 370)
                        }
                        .frame(height: 350)
                    } else {
                        HStack{
                            TabView{
                                ForEach(tasks) {
                                    task in
                                    SeminarRowView(seminar: task, userStore: userStore, selectedTab: $selectedTab)
                                }
                                
                            }
                            .frame(height: 400)
                            .tabViewStyle(.page)
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

                            
                            
                        }
                        .frame(height: 350)
                    }
                   // }
                    
                }
                
            } else {
                //MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
            
        }
        .onChange(of: Date()) { newValue in
            seminarStore.filterTodayTasks()
//            print(seminarStore.currentDay)
        }
        //MARK: Updating Tasks
        .onChange(of: seminarStore.currentDay) { newValue in
            seminarStore.filterTodayTasks()
//            print(seminarStore.currentDay)
        }
    }
    
    //MARK: Task Card View
    func TaskCardView(seminar: Seminar) -> some View {
        HStack {
            VStack(spacing: 10) {
                Text(seminar.name)
                Text(seminar.category)
            }
        }
    }
   
    func TomorrowTaskView() -> some View {
        
        LazyVStack(spacing: 18) {
            
            if let tasks = seminarStore.filteredTomorrowSeminar {
                
                if tasks.isEmpty {
                    Divider()
                    Text("내일 세미나 없음")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .padding([.top, .bottom])
                    //                        .offset(y: 100)
                } else {
                    VStack(alignment: .leading) {
                        
                        Text(tasks[0].createdDate)
                            .padding(.leading, 15)
                            .padding(.bottom, 1)
                            .fontWeight(.bold)
                        
                        HStack{
                            VStack(alignment: .leading) {
                                ForEach(tasks) { task in
                                    TomorrowSeminarListView(selectedTab: $selectedTab, userStore: userStore, seminar: task)
                                        .padding(.bottom, 15)
                                }
                                
                            }
                            
                            Spacer()
                            
                        }
                    }
                    
                }
                
            } else {
                //MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
            
        }
        .onChange(of: Date()) { newValue in
            seminarStore.filterTodayTasks()
//            print(seminarStore.currentDay)
        }
        //MARK: Updating Tasks
        .onChange(of: seminarStore.currentDay) { newValue in
            seminarStore.filterTomorrowTasks()
//            print(seminarStore.currentDay)
        }
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(seminar: Seminar(id: "", image: ["https://techit.education/img/techit_ogImage.png"], name: "", date: Date(), startingTime: "", endingTime: "", category: "", location: "", locationUrl: "", hostName: "", hostImage: "", hostIntroduction: "", seminarDescription: "", seminarCurriculum: ""), selectedTab: .constant(0), userStore: UserStore())
    }
}


//MARK: UI design Helper functions

extension View {
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
