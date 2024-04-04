//
//  MainQRTicketView.swift
//  Big_Project_C_Customer
//
//  Created by 차소민 on 2023/01/04.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import SDWebImageSwiftUI

struct MainQRTicketView: View {
    
    @StateObject var seminarStore = SeminarStore()
    @ObservedObject var userStore : UserStore
    @Binding var isShowingTicketSheet: Bool
    
    
    var body: some View {
        
        VStack {
            TabView {
                ForEach(userStore.currentUserSeminars) { seminar in
                    TicketView(seminar: seminar, userStore: userStore)
                    
                }
            }
            .overlay{
                Button {
                    isShowingTicketSheet.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 20, height: 20)
                }
                .offset(x:160, y: -350)
            }
            
            .ignoresSafeArea()
            //            .edgesIgnoringSafeArea(.bottom)
            .tabViewStyle(.page)
            
            //            Button {
            //                isShowingTicketSheet.toggle()
            //            } label: {
            //                Image(systemName: "chevron.left")
            //            }
            //            .offset(x: -150, y: 200)
            
            //                .toolbar{
            //                    ToolbarItem(placement: .navigationBarLeading) {
            //                        Button {
            //                            isShowingTicketSheet.toggle()
            //                        } label: {
            //                            Image(systemName: "chevron.left")
            //                        }
            //
            //
            //                    }
            //            }
        }
        //        .backgroundStyle(Color.main)
        .onAppear{
            userStore.fetchCurrentUser{
                seminarStore.fetchSeminarEscaping {
                    userStore.currentUserSeminars = []
                    guard let currentUser = userStore.currentUserData else { return }
                    for seminar in seminarStore.seminarList {
                        if currentUser.goSemId.contains(seminar.id) {
                            userStore.currentUserSeminars.append(seminar)
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    //    func didDismiss() {
    //        dismiss()
    //    }
    //
    //    func generateQRCode(from string: String) -> UIImage {
    //        filter.message = Data(string.utf8)
    //
    //        if let outputImage = filter.outputImage {
    //            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
    //                return UIImage(cgImage: cgimg)
    //            }
    //        }
    //
    //        return UIImage(systemName: "xmark.circle") ?? UIImage()
    //    }
}

struct MainQRTicketView_Previews: PreviewProvider {
    static var previews: some View {
        MainQRTicketView(userStore: UserStore(), isShowingTicketSheet: .constant(true))
    }
}
