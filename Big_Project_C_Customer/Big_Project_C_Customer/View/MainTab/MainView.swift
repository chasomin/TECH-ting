//
//  MainView.swift
//  Big_Project_C_Customer
//
//  Created by Yooj on 2022/12/27.
//

import SwiftUI

struct MainView: View {
    @StateObject var seminarStore : SeminarStore = SeminarStore()
    @Binding var selectedTab: Int
    
    @ObservedObject var userStore: UserStore
    
    @State var isShowingTicketSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                // 전체 세미나 보기
                HStack{
                    Spacer()
                    NavigationLink(destination: CategoryListView(seminarStore: seminarStore, selectedTab: $selectedTab, userStore: userStore, categoryView: .allCategory, categories: seminarStore.categories)) {
                        Text("전체 세미나 보기")
                        Image(systemName: "chevron.right")
                            .padding(.leading, -5)
                    }
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.trailing, 20)
                    .padding(.vertical,15)
                }
                
                
                VStack{
                    // 다가오는 세미나
                    Section{
                        TabView{
                            ForEach(seminarStore.upcomingSeminarList){ seminar in
                                VStack(alignment:.center){
                                    SeminarView(seminar: seminar, selectedTab: $selectedTab, userStore: userStore)
                                    Rectangle()
                                        .size(width: 400, height: 200)
                                        .fill(Color.white)
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

                        .frame(height: 350)
                    }
                    

 
                    // 카테고리
                    MainCategoryView(userStore: userStore, selectedTab: $selectedTab)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("textBlack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 170)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingTicketSheet.toggle()
                    } label: {
                        Image(systemName: "qrcode")
                            .font(.title3)
                    }

//                        NavigationLink(destination: MainQRTicketView(userStore: userStore).toolbar(.hidden, for: .tabBar)) {
//                            Image(systemName: "qrcode")
//                                .font(.title3)
//                        }
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $isShowingTicketSheet) {
            MainQRTicketView(userStore: userStore, isShowingTicketSheet: $isShowingTicketSheet)
        }
        .onAppear {
            seminarStore.fetchSeminarEscaping {
                seminarStore.upcomingSeminarList = []
                for seminar in seminarStore.seminarList {
                    seminarStore.upcomingSeminarList.append(seminar)
                    if seminarStore.upcomingSeminarList.count == 5 {
                        break
                    }
                }
            }
        }
        .refreshable {
            seminarStore.fetchSeminarEscaping {
                seminarStore.upcomingSeminarList = []
                for seminar in seminarStore.seminarList {
                    seminarStore.upcomingSeminarList.append(seminar)
                    if seminarStore.upcomingSeminarList.count == 5 {
                        break
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(selectedTab: .constant(3), userStore: UserStore())
    }
}
