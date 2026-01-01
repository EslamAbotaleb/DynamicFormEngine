//
//  CustomNavBarWithBackText.swift
//  CERQEL
//
//  Created by Youxel on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import SwiftUI
//import EasyTipView

public struct CustomNavBarWithBackText: View {
    @Environment(\.dismiss) var dismiss
    let title : String?
    let onDone: (()->())?
    let onBack: (()->())?
    
    public init(title: String? = nil, onDone: (() -> Void)? = nil, onBack: (() -> Void)? = nil) {
        self.title = title
        self.onDone = onDone
        self.onBack = onBack
    }
   
   public var body: some View {
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
    
                    Button("Done".localized) {
                        //presentationMode.wrappedValue.dismiss()
                        dismiss()
                        onDone!()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(Color(primaryMain))
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

