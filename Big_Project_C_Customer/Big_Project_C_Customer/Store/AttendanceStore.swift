//
//  AttendanceStore.swift
//  Big_Project_C_Customer
//
//  Created by 이종현 on 2022/12/27.
//

import Foundation
import FirebaseFirestore
import Firebase

class AttendanceStore : ObservableObject {
    
    let database = Firestore.firestore().collection("Seminar")
    
    func fetchAttendance(seminarID: String, uid: String, userNickname: String, completion: @escaping (Bool) -> ()) {
        database.document("\(seminarID)").collection("Attendance").getDocuments { (snapshot, error) in
            if let snapshot {
                var attendanceList: [String] = []
                for document in snapshot.documents {
                    let docData = document.data()
                    let id: String = docData["id"] as? String ?? ""
                    let userNickName: String = docData["userNickName"] as? String ?? ""
                    let uid: String = docData["uid"] as? String ?? ""

                    let attendance = Attendance(id: id, uid: uid, userNickname: userNickName)
                    
                    attendanceList.append(attendance.userNickname)
                    print(attendance)
                    print(attendanceList, "attendanceList")
                }
                
                if attendanceList.contains(userNickname) {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    
    
    func checkAttendanceListener(seminarID: String, completion: @escaping (Bool) -> ()) { // - 3
        self.listener = database.document(seminarID).collection("Attendance").addSnapshotListener { querySnapshot, error in
            print("메시지 리스너 호출")
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: (error!)")
                return
            }
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New Message: (diff.document.data())")
                    completion(true)
                }
                if (diff.type == .modified) {
                    print("Modified Message: (diff.document.data())")
                    completion(true)
                }
                if (diff.type == .removed) {
                    print("Removed Message: (diff.document.data())")
                }
            }
        }
    }
}
