//
//  MainCategoryView.swift
//  Big_Project_C_Customer
//
//  Created by BOMBSGIE on 2022/12/27.
//

import SwiftUI

struct MainCategoryView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil)
    ]
    
    let sampleImages: [String] = ["sampleImage", "sampleImage2", "sampleImage4", "sampleImage3"]
    let schools: [String] = ["프론트엔드 스쿨", "백엔드 스쿨", "UI/UX 디자인 스쿨", "블록체인 스쿨"]
    
    @ObservedObject var userStore: UserStore
    @StateObject var seminarStore: SeminarStore = SeminarStore()
    @Binding var selectedTab: Int
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,
                      alignment:.center,
                      spacing: 10,
                      content: {
                ForEach(0 ..< schools.count, id: \.self) { index in
                    NavigationLink(destination: CategoryListView(selectedTab: $selectedTab, userStore: userStore, categoryView: Category(rawValue: seminarStore.categoryNames[index + 1]) ?? .allCategory, categories: seminarStore.categories)) {
                        VStack(alignment:.leading){
                            Image(sampleImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 170, height: 150)
                                .clipped()
                                .foregroundColor(.gray)
                            
                                Text(schools[index])
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.leading, 5)
                                    .padding(.bottom, 3)
                                
                                Text("기초가 튼튼한 프론트엔드 개발자 양성 교육")
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 5)
                                    .padding(.top, -5)
                                    
                        }
                    }
                }
            })
            .padding(.horizontal,15)
            .padding(.bottom,30)
            
            
        
        }
    
    }
}

//struct MainCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCategoryView()
//    }
//}
