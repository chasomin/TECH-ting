//
//  TaskViewModel.swift
//  calendarViewEX
//
//  Created by 조운상 on 2022/12/27.
//

import SwiftUI

class TaskViewModel: ObservableObject {
   
    //sample
//    let now = Date().timeIntervalSince1970
    
//    Date().timeIntervalSince1970
//    1672129481.84146
    
    @Published var storedTasks: [Task] = [
        
//        Task(taskTitle: "t1", taskDescription: "t1t1t1t1t1t1", taskDate: .init(timeIntervalSince1970: 1672129481)),
//        Task(taskTitle: "t2", taskDescription: "t2t2t2t2t2t2", taskDate: .init(timeIntervalSince1970: Date().timeIntervalSince1970)),
//        Task(taskTitle: "t3", taskDescription: "t3t3t3t3t3t3", taskDate: .init(timeIntervalSince1970: 1641652697)),
//        Task(taskTitle: "t4", taskDescription: "t4t4t4t4t4t4", taskDate: .init(timeIntervalSince1970: 1641656297)),
//        Task(taskTitle: "t5", taskDescription: "t5t5t5t5t5t5", taskDate: .init(timeIntervalSince1970: 1641661897)),
//        Task(taskTitle: "t6", taskDescription: "t6t6t6t6t6t6", taskDate: .init(timeIntervalSince1970: 1641641897)),
//        Task(taskTitle: "t7", taskDescription: "t7t7t7t7t7t7", taskDate: .init(timeIntervalSince1970: 1641677897)),
//        Task(taskTitle: "t8", taskDescription: "t8t8t8t8t8t8", taskDate: .init(timeIntervalSince1970: 1641681497)),
        
        Task(taskTitle: "t1", taskDescription: "t1t1t1t1t1t1", taskDate: Date()),
        Task(taskTitle: "t2", taskDescription: "t2t2t2t2t2t2", taskDate: Date(timeIntervalSinceNow: 86400)),
        Task(taskTitle: "t3", taskDescription: "t3t3t3t3t3t3", taskDate: Date()),
        Task(taskTitle: "t4", taskDescription: "t4t4t4t4t4t4", taskDate: Date()),
        Task(taskTitle: "t5", taskDescription: "t5t5t5t5t5t5", taskDate: Date()),
        Task(taskTitle: "t6", taskDescription: "t6t6t6t6t6t6", taskDate: Date()),
        Task(taskTitle: "t7", taskDescription: "t7t7t7t7t7t7", taskDate: Date()),
        Task(taskTitle: "t8", taskDescription: "t8t8t8t8t8t8", taskDate: Date()),

    ]
    
    //MARK: Current week Days
    @Published var currentWeek: [Date] = []
    
    //MARK: Current Day
    @Published var currentDay: Date = Date()
    
    //MARK: Filtering Today Tasks
    @Published var filteredTask: [Task]?
    
    //MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    //MARK: Filter Today Tasks
    //날짜 비교
    func filterTodayTasks() {

        DispatchQueue.global(qos: .userInteractive).async {

            let calendar = Calendar.current

            let filtered = self.storedTasks.filter {
//                Date()
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }//taskDate의 타임인터벌 값만 잘 가져오면 비교도 알아서 됨!

            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTask = filtered
                }
            }
        }

    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
            
        }
    }
    
    //MARK: Extracting Date
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
        
    }
    
    //MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        //self.currentDay
        return calendar.isDate(currentDay, inSameDayAs: date)
        
    }
    
}
