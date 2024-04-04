//
//  ContentView.swift
//  Big_Project_C_Customer
//
//  Created by Yooj on 2022/12/27.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 1
    @StateObject var userStore : UserStore = UserStore()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(selectedTab: $selectedTab, userStore: userStore).tabItem {
                Image(systemName: "newspaper")
                Text("메인") }.tag(1)
                .toolbarBackground(Color.white, for: .tabBar)
            ScheduleView(userStore: userStore, selectedTab: $selectedTab).tabItem {
                Image(systemName: "calendar")
                Text("세미나 일정")
            }.tag(2)
                .toolbarBackground(Color.white, for: .tabBar)
            
            if userStore.currentUser == nil {
                LoginSignInView(userStore: userStore).tabItem {
                    Image(systemName: "ticket")
                    Text("마이 테킷")
                }.tag(3)
                    .toolbarBackground(Color.white, for: .tabBar)
            } else {
                MyPageView(userStore: userStore).tabItem {
                    Image(systemName: "ticket")
                    Text("마이 테킷")
                }.tag(3)
                    .toolbarBackground(Color.white, for: .tabBar)

            }
            
        }
        
        .onAppear {
            userStore.fetchCurrentUser{}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userStore: UserStore())
    }
}
