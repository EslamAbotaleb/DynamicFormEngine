//
//  CustomNavBarWithSubmit.swift
//  CERQEL
//
//  Created by Youxel on 12/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//


import SwiftUI
internal import EasyTipView

struct CustomNavBarWithSubmitText: View {
    @Environment(\.dismiss) var dismiss
    let title : String?
    let onDone: (()->())?
    let onBack: (()->())?
    let submitBtnTitle : String?
    var submitIsAvailable : Bool = true

    var body: some View {
        VStack(){
            HStack{
                Button("Cancel".localized) {
                    //presentationMode.wrappedValue.dismiss()
                    dismiss()
                    onBack!()
                }
                .buttonStyle(.plain)
                .foregroundColor(Color(primaryMain))
                    .padding(.leading,16)
                    .frame(alignment: .leading)

                Text(title ?? "")
                    .font(CerqelFonts.bodyLMedium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .frame(maxWidth: .infinity,alignment: .center)
    
                Button(submitBtnTitle == nil ? "Done".localized : submitBtnTitle!) {
                    if submitIsAvailable {
                        //presentationMode.wrappedValue.dismiss()
                        dismiss()
                        onDone!()
                    }
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(submitIsAvailable ? Color(primaryMain) : CerqelColors.bodyGray)
                        .frame(alignment: .trailing)
                        .padding(.trailing,16)
                
            }
            Divider()
                .padding(.horizontal,0)
                .padding(.top,16)
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 1)

        }
    }
}

