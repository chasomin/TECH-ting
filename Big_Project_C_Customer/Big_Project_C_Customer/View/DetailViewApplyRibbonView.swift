//
//  DetailViewApplyRibbonView.swift
//  Big_Project_C_Customer
//
//  Created by 김혜지 on 2023/01/02.
//

import SwiftUI

struct DetailViewApplyRibbonView: View {
    var body: some View {
        VStack{
            ZStack{
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 55))
                    .foregroundColor(.pointMain)
                
                VStack(spacing:-3){
                    Text("신청")
                    Text("완료")
                }
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.top,-15)
            }
        }
    }
}

struct DetailViewApplyRibbonView_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewApplyRibbonView()
    }
}
