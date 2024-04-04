//
//  SeminarStore.swift
//  Big_Project_C_Customer
//
//  Created by 이종현 on 2022/12/27.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import Firebase


class SeminarStore : ObservableObject {
    // 세미나 배열
    @Published var seminarList : [Seminar] = []
    // 다가오는 세미나
    @Published var upcomingSeminarList : [Seminar] = []
    let database = Firestore.firestore()
    
    // 카테고리 세그먼트
    let categories: [Category] = [.allCategory, .front, .back, .design, .blockChain]
    let categoryNames: [String] = ["전체", "프론트", "백엔드", "디자인", "블록체인"]
    
    // 모든 세미나들을 seminarList에 담아줌
    func fetchSeminar() {
        seminarList.removeAll()
        database.collection("Seminar")
            .order(by: "date")
            .getDocuments { (snapshot, error) in
                if let snapshot {
                    for document in snapshot.documents {
                        let docData = document.data()
                        let id : String = document.documentID
                        let image: [String] = docData["image"] as? [String] ?? []
                        let name: String = docData["name"] as? String ?? ""
                        // Firebase가 주는 Timestamp 형식의 값을 가져오긴 해봐야겠다
                        let createdAtTimeStamp: Timestamp = docData["date"] as? Timestamp ?? Timestamp()
                        
                        // 그런데 Timestamp형식을 그대로 쓸 수는 없고,
                        // 우리의 Swift가 제공하는 기본 Date 형식으로 바꿔서 꺼야써야겠다
                        let date: Date = createdAtTimeStamp.dateValue()
                        let startingTime: String = docData["startingTime"] as? String ?? ""
                        let endingTime: String = docData["endingTime"] as? String ?? ""
                        let category: String = docData["category"] as? String ?? ""
                        let location: String = docData["location"] as? String ?? ""
                        let locationUrl: String = docData["locationUrl"] as? String ?? ""
                        let hostName: String = docData["hostName"] as? String ?? ""
                        let hostImage: String = docData["hostImage"] as? String ?? ""
                        let hostIntroduction: String = docData["hostIntroduction"] as? String ?? ""
                        let seminarDescription: String = docData["seminarDescription"] as? String ?? ""
                        let seminarCurriculum: String = docData["seminarCurriculum"] as? String ?? ""
                        
                        let seminar = Seminar(id: id, image: image, name: name, date: date, startingTime: startingTime, endingTime: endingTime, category: category, location: location, locationUrl: locationUrl, hostName: hostName, hostImage: hostImage, hostIntroduction: hostIntroduction, seminarDescription: seminarDescription, seminarCurriculum: seminarCurriculum)
                        
                        self.seminarList.append(seminar)
                    }
                }
            }
    }
    
    // 날짜를 맞추기 위한 패치 함수
    func matchDate(completion: @escaping() -> ()) {
        seminarList.removeAll()
        database.collection("Seminar").getDocuments { (snapshot, error) in
            if let snapshot {
                for document in snapshot.documents {
                    let docData = document.data()
                    let id : String = document.documentID
                    let image: [String] = docData["image"] as? [String] ?? []
                    let name: String = docData["name"] as? String ?? ""
                    let date: Date = docData["date"] as? Date ?? Date()
                    let startingTime: String = docData["startingTime"] as? String ?? ""
                    let endingTime: String = docData["endingTime"] as? String ?? ""
                    let category: String = docData["category"] as? String ?? ""
                    let location: String = docData["location"] as? String ?? ""
                    let locationUrl: String = docData["locationUrl"] as? String ?? ""
                    let hostName: String = docData["hostName"] as? String ?? ""
                    let hostImage: String = docData["hostImage"] as? String ?? ""
                    let hostIntroduction: String = docData["hostIntroduction"] as? String ?? ""
                    let seminarDescription: String = docData["seminarDescription"] as? String ?? ""
                    let seminarCurriculum: String = docData["seminarCurriculum"] as? String ?? ""
                    
                    let seminar = Seminar(id: id, image: image, name: name, date: date, startingTime: startingTime, endingTime: endingTime, category: category, location: location, locationUrl: locationUrl, hostName: hostName, hostImage: hostImage, hostIntroduction: hostIntroduction, seminarDescription: seminarDescription, seminarCurriculum: seminarCurriculum)
                    
                    self.seminarList.append(seminar)
                }
            }
            completion()
        }
        
    }
    
    // 세미나 작성 완료시 추가됨 (input Seminar 타입으로 다 넣어주시면 됩니다.)
    func addSeminar(_ seminar: Seminar) {
        database.collection("Seminar")
            .document(seminar.id)
            .setData(["id": seminar.id,
                      "image": seminar.image,
                      "name": seminar.name,
                      "startingTime": seminar.startingTime,
                      "endingTime": seminar.endingTime,
                      "category": seminar.category,
                      "location": seminar.location,
                      "locationUrl": seminar.locationUrl,
                      "hostName": seminar.hostName,
                      "hostImage": seminar.hostImage,
                      "hostIntroduction": seminar.hostIntroduction,
                      "seminarDescription": seminar.seminarDescription,
                      "seminarCurriculum": seminar.seminarCurriculum,
                     ])
        
        //FireStore Data를 READ 해오는 함수 호출
        fetchSeminar()
    }
    
    //MARK: Current week Days
    @Published var currentWeek: [Date] = []
    
    //MARK: Current Day
    @Published var currentDay: Date = Date()
    
    //MARK: Filtering Today Tasks
    @Published var filteredSeminar: [Seminar]?
    
    @Published var filteredTomorrowSeminar: [Seminar]?
    
    //MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
        filterTomorrowTasks()
    }
    
    //MARK: Filter Today Tasks
    //날짜 비교
    func filterTodayTasks() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.seminarList.filter {
                //                Date()
//                print($0.date)
                return calendar.isDate($0.date, inSameDayAs: self.currentDay)
            }//taskDate의 타임인터벌 값만 잘 가져오면 비교도 알아서 됨!
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredSeminar = filtered
                }
            }
        }
        
    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekday, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (0...21).forEach { day in
            
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
    
    //MARK: - filterTomorrowTasks
    func filterTomorrowTasks() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.seminarList.filter {
                //                Date()
                //                print($0.date)
                //                + (86400 * 2)
                return calendar.isDate($0.date - 86400, inSameDayAs: self.currentDay)
            }//taskDate의 타임인터벌 값만 잘 가져오면 비교도 알아서 됨!
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTomorrowSeminar = filtered
                }
            }
        }
        
    }
    
    // 이스케이핑 클로저 사용 가능한 fetchSeminar함수
    func fetchSeminarEscaping(completion: @escaping ()->()) {
        seminarList.removeAll()
        database.collection("Seminar")
            .order(by: "date")
            .getDocuments { (snapshot, error) in
                if let snapshot {
                    for document in snapshot.documents {
                        let docData = document.data()
                        let id : String = document.documentID
                        let image: [String] = docData["image"] as? [String] ?? []
                        let name: String = docData["name"] as? String ?? ""
                        // Firebase가 주는 Timestamp 형식의 값을 가져오긴 해봐야겠다
                        let createdAtTimeStamp: Timestamp = docData["date"] as? Timestamp ?? Timestamp()
                        
                        // 그런데 Timestamp형식을 그대로 쓸 수는 없고,
                        // 우리의 Swift가 제공하는 기본 Date 형식으로 바꿔서 꺼야써야겠다
                        let date: Date = createdAtTimeStamp.dateValue()
                        let startingTime: String = docData["startingTime"] as? String ?? ""
                        let endingTime: String = docData["endingTime"] as? String ?? ""
                        let category: String = docData["category"] as? String ?? ""
                        let location: String = docData["location"] as? String ?? ""
                        let locationUrl: String = docData["locationUrl"] as? String ?? ""
                        let hostName: String = docData["hostName"] as? String ?? ""
                        let hostImage: String = docData["hostImage"] as? String ?? ""
                        let hostIntroduction: String = docData["hostIntroduction"] as? String ?? ""
                        let seminarDescription: String = docData["seminarDescription"] as? String ?? ""
                        let seminarCurriculum: String = docData["seminarCurriculum"] as? String ?? ""
                        
                        let seminar = Seminar(id: id, image: image, name: name, date: date, startingTime: startingTime, endingTime: endingTime, category: category, location: location, locationUrl: locationUrl, hostName: hostName, hostImage: hostImage, hostIntroduction: hostIntroduction, seminarDescription: seminarDescription, seminarCurriculum: seminarCurriculum)
                        
                        self.seminarList.append(seminar)
                    }
                }
                completion()
            }
    }
    // 카테고리에 맞는 세미나 리스트를 리턴함
    func matchCategory(category : Category) -> [Seminar] {
        if category == .allCategory {
            return self.seminarList
        }
        var seminarList : [Seminar] = []
        for seminar in self.seminarList {
            if category.rawValue == seminar.category {
                seminarList.append(seminar)
            }
        }
        return seminarList
    }
    
    
}

//    // 세미나 추가시 필요 정보들
//    @Published var image : [String] = []
//    @Published var name : String = ""
//    @Published var date : Date = Date()
//    @Published var startingTime : String = ""
//    @Published var endingTime : String = ""
//    @Published var category : String = ""
//    @Published var location : String = ""
//    @Published var host : String = ""
//    @Published var hostIntroduction : String = ""
//    @Published var seminarDescription : String = ""
//    @Published var seminarCurriculum : String = ""
