//
//  UserStore.swift
//  Big_Project_C_Customer
//
//  Created by BOMBSGIE on 2022/12/27.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

class UserStore : ObservableObject {
    
    @Published var userList : [User] = []
    
    // 로그인 상태 확인
    @Published var currentUser: Firebase.User?
    let database = Firestore.firestore()
    
    // 로그인
    @Published var email: String = ""
    @Published var password: String = ""
    
    //회원가입
    @Published var signUpEmail: String = ""
    @Published var signUpPw: String = ""
    @Published var nickname : String = ""
    @Published var isAdmin : Bool = false
    @Published var goSemId : [String] = []
    
    // 비밀번호 재설정
    @Published var updatePw1: String = ""
    @Published var updatePw2: String = ""
    
    //현재 로그인된 유저
    @Published var currentUserData: User?
    @Published var currentUserSeminars : [Seminar] = []
    
    init() {
        userList = [
            User(id: UUID().uuidString, nickname: "닉넴", email: "test@gamil.com", goSemId: ["asadlgjfsgljk"], isAdmin: true, uid: "sdghasgjkhsagklsj")
        ]
        currentUser = Auth.auth().currentUser
        
    }
    func fetchUser() {
        userList.removeAll()
        database.collection("User").getDocuments { (snapshot, error) in
            if let snapshot {
                for document in snapshot.documents {
                    let docData = document.data()
                    let id : String = document.documentID
                    let nickname: String = docData["nickname"] as? String ?? ""
                    let email: String = docData["email"] as? String ?? ""
                    let goSemId: [String] = docData["goSemId"] as? [String] ?? []
                    let isAdmin: Bool = docData["isAdmin"] as? Bool ?? false
                    let uid: String = docData["uid"] as? String ?? ""
                    
                    let user = User(id: id, nickname: nickname, email: email, goSemId: goSemId, isAdmin: isAdmin, uid: uid)
                    
                    self.userList.append(user)
                }
            }
            print("herer")
            dump(self.userList)
        }
    }
    
    // 로그인
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to login user:", error)
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.currentUser = result?.user
            self.email = ""
            self.password = ""
        }
        
    }
    
    // 로그아웃
    func logout() {
        self.currentUser = nil
        try? Auth.auth().signOut()
    }
    
    // 회원가입
    // Auth에 계정을 등록시키는 함수
    // 회원가입
    func createNewAccount()  {
        Auth.auth().createUser(withEmail: signUpEmail, password: signUpPw) { result, error in
            if let error = error {
                print("Failed to create user:", error)
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            //            self.storeUserInfoToDatabase(uid: result?.user.uid ?? "")
            self.storeUserInfoToDatabase(uid: result?.user.uid ?? "")
            self.currentUser = result?.user
        }
    }
    
    // 비밀번호 재설정
    func updatePassword() {
        Auth.auth().currentUser?.updatePassword(to: updatePw2) { error in
            if let error = error {
                print("Failed to updatePassword:", error)
                return
            }
        }
    }
    
    // 계정 삭제 및 fireStore에 유저 정보를 삭제하는 함수
    func deleteUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("User").document(uid).delete() { err in
            if let err = err {
                print("error: \(err)")
            } else {
                print("Deleted user in db users")
                Auth.auth().currentUser!.delete { error in
                    if let error = error {
                        print("error deleting user - \(error)")
                    } else {
                        print("Account deleted")
                        self.currentUser = nil
                    }
                }
            }
        }
    }

    // 닉네임을 재설정하는 함수
    func updateNickName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
            database
            .collection("User")
            .document(uid)
            .updateData([
                "nickName": self.nickname
            ])
        fetchCurrentUser{}
        }
    
    // Firestore에 user 정보를 보내는 함수
    func storeUserInfoToDatabase(uid : String) {
        
        // model을 쓰면 쉽게 구조화할 수 있음
        let userData = ["nickName" : self.nickname, "email" : self.signUpEmail, "uid" : uid, "goSemId" : self.goSemId, "isAdmin" : self.isAdmin] as [String : Any]
        
        Firestore.firestore().collection("User").document(uid).setData(userData as [String : Any]) { error in
            if let error = error {
                print(error)
                return
            }
            self.nickname = ""
            self.signUpEmail = ""
            self.signUpPw = ""
        }
    }
    
    // 현재 로그인된 유저의 데이터를 가져옴
    func fetchCurrentUser(completion: @escaping () -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Firestore.firestore()
                .collection("User")
                .document(uid)
                .getDocument { (snapshot, error) in
                    if let snapshot {
                        let docData = snapshot.data()
                        
                        let id: String = docData?["id"] as? String ?? ""
                        let uid: String = docData?["uid"] as? String ?? ""
                        let nickName: String = docData?["nickName"] as? String ?? ""
                        let email: String = docData?["email"] as? String ?? ""
                        let isAdmin : Bool = docData?["isAdmin"] as? Bool ?? false
                        let goSemId : [String] = docData?["goSemId"] as? [String] ?? []
                        let user: User = User(id: id, nickname: nickName, email: email, goSemId: goSemId, isAdmin: isAdmin, uid: uid)
                        
                        self.currentUserData = user
                    }
                    completion()
                }
        }
    
    // 해당 유저에 참석하는 세미나를 추가
    func updateGoSemId(seminar: Seminar) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("User")
            .document(uid)
            .updateData([
                "goSemId" : FieldValue.arrayUnion([seminar.id])
            ])
        
        print("신청하기 성공")
    }
    
    // 해당 유저에 참석하는 세미나를 추가
    func deleteGoSemId(seminar: Seminar) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("User")
            .document(uid)
            .updateData([
                "goSemId" : FieldValue.arrayRemove([seminar.id])
            ])
        
        print("신청 취소")
    }
    
}

