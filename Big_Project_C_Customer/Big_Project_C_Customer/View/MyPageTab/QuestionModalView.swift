//
//  QuestionModalView.swift
//  QRView
//
//  Created by 조현호 on 2022/12/27.
//

import SwiftUI

struct QuestionModalView: View {
    
//    enum FocusField: Hashable {
//        case field
//    }
//    @FocusState private var focusedField: FocusField?
    
    var seminar : Seminar
    @StateObject var questionStore: QuestionStore = QuestionStore()
    @State private var questionField: String = ""
    @State var isSended: Bool = false
    @State var test: Bool = false
    @State var placeholderText: String = "공격적인 말투는 싫어요!\n예의있고 센스있는 질문 부탁드립니다."
    @State var content: String = ""
    @State var shouldShowAlert: Bool = false
    @State private var sendedMessage: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("질문을 입력해주세요")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 1)
                    Text("질문은 익명으로 강사님께 전달이 됩니다.\n답변은 세미나 때 해주실거에욤")
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                   
                }
                .padding(.leading, 40)
                Spacer()
                
            }
            .foregroundColor(.black)
            .padding(.bottom, 11)
            
            ZStack(alignment: .leading) {
                if self.content.isEmpty {
                    TextEditor(text: $placeholderText)
                        .padding(.horizontal,15)
                        .padding(.vertical,10)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(height: 350)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    //                        .padding(.bottom, 23)
                        .disabled(true)
                }
                TextEditor(text: $content)
//                    .focused($focusedField, equals: .field)
                    .padding(.horizontal,15)
                    .padding(.vertical,10)
                    .font(.subheadline)
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
                    .opacity(self.content.isEmpty ? 0.25 : 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.mediumGray, lineWidth: 2)
                    )
                    .frame(height: 350)
                    .padding(.horizontal, 30)
                //                    .padding(.bottom, 23)
            }
            
            Text(sendedMessage)
                .foregroundColor(.black)
                .frame(height: 23)
                .font(.system(size: 13, weight: .bold))
                .bold()
                .padding(test ? 5 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 2)
                )
            
            
            Button {
                isSended = true
                
                questionStore.addQuestion(seminarID: seminar.id, question: Question(id: UUID().uuidString, question: content), completion: { result in
                    if result == true {
                        isSended = false
                        startButton()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            dismiss()
                        })
                    } else {
                        isSended = false
                        sendedMessage = "오류입니다."
                    }
                })

            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(content.count > 0 ? .black : .black.opacity(0.2))
                        .frame(height: 50)
                        .padding(.horizontal, 30)
                    Text("질문 보내기")
                        .foregroundColor(.white)
                        .bold()
                    
                    if isSended {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(height: 50)
                                .padding(.horizontal, 30)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                .scaleEffect(2)
                        }
                    }
                }
            }
            .disabled(content.count > 0 ? false : true)
        }
        //        .presentationDetents([.height(550)])
        .presentationDragIndicator(.visible)
//        .onAppear {
//            self.focusedField = .field
//            print("아무거나")
//        }
    }
    
    func startButton() {
        sendedMessage = "전송이 완료되었습니다"
    }
}

//struct QuestionModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionModalView(seminar: Seminar(id: <#T##String#>, image: <#T##[String]#>, name: <#T##String#>, date: <#T##Date#>, startingTime: <#T##String#>, endingTime: <#T##String#>, category: <#T##String#>, location: <#T##String#>, locationUrl: <#T##String#>, host: <#T##String#>, hostIntroduction: <#T##String#>, seminarDescription: <#T##String#>, seminarCurriculum: <#T##String#>))
//    }
//}
