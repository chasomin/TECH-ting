//
//  File.swift
//  ScheduleDemo
//
//  Created by 정소희 on 2022/12/27.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
