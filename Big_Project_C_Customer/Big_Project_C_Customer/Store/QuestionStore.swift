//
//  QuestionStore.swift
//  Big_Project_C_Customer
//
//  Created by 이종현 on 2022/12/27.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import Firebase

class QuestionStore : ObservableObject {
    
    // @Published var userList : [User] = []
    @Published var questions : [Question] = []
    
    
    let database = Firestore.firestore().collection("Seminar")
    
    func addQuestion (seminarID: String, question: Question, completion: @escaping (Bool) -> ()) {
        database.document(seminarID).collection("Question").document(question.id)
            .setData([
                "id": question.id,
                "question": question.question]) { error in
                    if let error = error {
                        print(error)
                        completion(false)
                    } else {
                        print("성공!")
                        completion(true)
                    }
                }
    }
    
}
