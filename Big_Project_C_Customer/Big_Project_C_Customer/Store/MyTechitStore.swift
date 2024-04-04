//
//  MyTechitStore.swift
//  QRView
//
//  Created by 조현호 on 2022/12/27.
//

import Foundation
import SwiftUI

class MyTechitStore: ObservableObject {
    
    @Published var myTechit: MyTechit
    
    init(myTechit: MyTechit = MyTechit(image: "event", category: "프론트엔드", name: "나도 할 수 있다 웹사이트 만들기!", dateAndTime: "2023년 1월 9일 오후6시~", location: "멋쟁이사자처럼 광화문 사무실")) {
        self.myTechit = myTechit
    }
    
}
