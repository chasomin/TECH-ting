//
//  ContentView.swift
//  QRView
//
//  Created by 조현호 on 2022/12/27.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import SDWebImageSwiftUI

struct TicketView: View {
    
    var seminar : Seminar
    @ObservedObject var userStore : UserStore
    @ObservedObject var attendanceStore = AttendanceStore()
    @State private var isShowingQR: Bool = false
    @State private var isQuestioned: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Main"), Color("Gradation")]),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                HStack {
                    Text("My TECH!T")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                    
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.leading, 30)
                .padding(.bottom, 40)
                
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(height: 460)
                        .padding(.horizontal, 58)
                    VStack {
                        VStack {
                            
                            WebImage(url: URL(string: seminar.image.first ?? "https://techit.education/img/techit_ogImage.png"))
                                .resizable()
                                .frame(height:175)
                                .cornerRadius(10)
                                .padding(.horizontal, 58)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    ZStack {
                                        if seminar.category == "프론트" {
                                            Rectangle()
                                                .foregroundColor(Color("Front"))
                                                .cornerRadius(10)
                                                .frame(width:52, height: 17)
                                        } else if seminar.category == "백엔드" {
                                            Rectangle()
                                                .foregroundColor(Color("Back"))
                                                .cornerRadius(10)
                                                .frame(width:52, height: 17)
                                        } else if seminar.category == "디자인" {
                                            Rectangle()
                                                .foregroundColor(Color("Design"))
                                                .cornerRadius(10)
                                                .frame(width:52, height: 17)
                                        } else if seminar.category == "블록체인" {
                                            Rectangle()
                                                .foregroundColor(Color("Blockchain"))
                                                .cornerRadius(10)
                                                .frame(width:52, height: 17)
                                        } else {
                                            Rectangle()
                                                .foregroundColor(.yellow)
                                                .cornerRadius(10)
                                                .frame(width:52, height: 17)
                                        }
                                        
                                        // 카테고리
                                        if seminar.category == "프론트" {
                                            Text("프론트엔드")
                                                .foregroundColor(.white)
                                                .font(.system(size: 9, weight: .bold))
                                                .bold()
                                        } else {
                                            Text(seminar.category)
                                                .foregroundColor(.white)
                                                .font(.system(size: 9, weight: .bold))
                                                .bold()
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                
                                HStack {
                                    // 이름
                                    Text(seminar.name)
                                        .font(.system(size: 16, weight: .bold))
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 75)
                            
                            Divider()
                                .frame(width: 240)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Date & Time")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                HStack {
                                    // 날짜 및 시간
                                    Text("\(seminar.date, format:.dateTime.day().month().year().hour().minute())")
                                        .font(.system(size: 12, weight: .regular))
                                        .padding(.bottom, 3)
                                    Spacer()
                                }
                                HStack {
                                    Text("Location")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                HStack {
                                    // 장소
                                    Text(seminar.location)
                                        .font(.system(size: 12, weight: .regular))
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 75)
                        }
                        .offset(y:-20)
                     
                        Image(uiImage: generateQRCode(from: "\(seminar.id)\n\(userStore.currentUserData!.nickname)\n\(userStore.currentUserData!.uid)"))
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .opacity(isShowingQR ? 0.2 : 1)
                       
                        
                    }
                    
                    
                }
                Spacer()
                
                Image("textWhite")
                
            }
            
            if isShowingQR == true {
                Button {
                    isQuestioned.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width:80)
                            .foregroundColor(Color("PointMain"))
                        Text("질문\n하기")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: self.$isQuestioned) {
                        QuestionModalView(seminar: seminar)
                            .presentationDetents([.height(570)])
                    }
                }
                .offset(x:130, y:-250)
            }
        }
        .onAppear {
            print("onAppear")
            print(seminar.id)
            print(userStore.currentUserData!.uid, "uid")
            print(userStore.currentUserData!.id, "id")
            attendanceStore.checkAttendanceListener(seminarID: seminar.id, completion: { result in
                if result == true {
                    print("성공~~")
                    attendanceStore.fetchAttendance(seminarID: seminar.id, uid: userStore.currentUserData!.uid, userNickname: userStore.currentUserData!.nickname, completion: { result in
                        if result == true {
                            isShowingQR.toggle()
                            print("출석완료")
                        } else {
                            print("실패ㅠ")
                        }
                    })
                } else {
                    print("아직 실행안됨")
                }
            })
        }
    }
    
    func didDismiss() {
        dismiss()
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

//struct Big_Project_C_Customer_Previews: PreviewProvider {
//    static var previews: some View {
//        TicketView()
//    }
//}
