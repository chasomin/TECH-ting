//
//  CategoryListView.swift
//  Big_Project_C_Customer
//
//  Created by Yooj on 2022/12/27.
//

import SwiftUI


struct CategoryListView: View {
    @StateObject var seminarStore: SeminarStore = SeminarStore()
    
    @Binding var selectedTab: Int
    @ObservedObject var userStore: UserStore
    
    @State var categoryView: Category
    var categories: [Category]
    
    var body: some View {
        VStack {
            HStack{
                ForEach(categories, id: \.self) { select in
                    ZStack {
                        Button(action: {
                            categoryView = select
                            print("\(select.rawValue)")
                        }) {
                            Text(select.rawValue)
                                .foregroundColor(categoryView == select ? Color(.black) : Color(.gray))
                                .font(.callout)
                                .bold()
                        }
                        .frame(width: 60)
                        if categoryView == select {
                            Capsule()
                                .foregroundColor(.black)
                                .frame(width: 50, height: 3)
                                .offset(y:17)
                        }
                    }
                }
            }.padding(.top,10)
            ScrollView{
                ForEach(seminarStore.matchCategory(category: categoryView)) { seminar in
                    //                    Divider().frame(height:20)
                    //                        .background(Color.gray)
                    LazyVStack{
                        Rectangle()
                            .foregroundColor(.lightGray)
                            .frame(height: 9)
                            .padding(.bottom,30)
                        SeminarView(seminar: seminar, selectedTab: $selectedTab, userStore: userStore)
                            .frame(height: 270)
                            .padding(.top)
                            .padding(.bottom,10)
                    }
                    //                    Divider().frame(height:20)
                }
                
            }
            .padding(.bottom,1)
            .onAppear{
                seminarStore.fetchSeminar()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
}


/*
 struct maingTabView: View {
 var mainTab: tabInfo
 var body: some View {
 VStack {
 switch mainTab {
 case .all:
 postStore.fetdataCategory(category: category)
 CategoryListView()
 case .back:
 
 }
 }
 }
 }
 */

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(seminarStore: SeminarStore(), selectedTab:.constant(3), userStore: UserStore(),categoryView: .allCategory, categories: [.allCategory, .front, .back, .design, .blockChain])
    }
}
