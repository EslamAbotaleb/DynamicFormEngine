//
//  SettingWidget.swift
//  CERQEL
//
//  Created by ahmed maher on 31/10/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import SwiftUI

struct SettingWidget: View {

    var settingItem: SettingModel
    
    var body: some View {
        VStack {
            HStack {
                VStack (spacing: 5) {
                    Text(settingItem.title)
                        .font(
                            Font.custom("Poppins", size: 16)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.14, green: 0.16, blue: 0.18))
                        .frame(maxWidth: .infinity,alignment: .leading)
                    Text(settingItem.decription)
                        .font(Font.custom("Poppins", size: 12))
                        .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.59))
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
                Image(settingItem.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
            }
            Divider()
        }
        .padding(16)
    }
}

struct SettingWidget_Previews: PreviewProvider {
    static var previews: some View {
        SettingWidget(settingItem: SettingModel(id: 0, title: "", decription: "", icon: ""))
    }
}
