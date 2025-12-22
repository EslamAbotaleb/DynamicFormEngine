//
//  ForeCastDailyWidget.swift
//  CERQEL
//
//  Created by Youxel on 01/11/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import SwiftUI

struct ForeCastDailyDetailsWidgetView: View {
    let forCastDailyItem : ForeCastDailyDetailsResponseModel
    var isSelected : Bool = false
    var body: some View {
        LazyVStack{
            HStack{
                VStack{
                    Text(forCastDailyItem.day).frame(maxWidth: .infinity)
                    Text(forCastDailyItem.date).frame(maxWidth: .infinity)
                }
                VStack{
                    Image(forCastDailyItem.imageUrl).resizable().frame(width: 40,height: 40)
                    Text(forCastDailyItem.comment)
                }.frame(maxWidth: .infinity)
                Text(forCastDailyItem.temperture).frame(maxWidth: .infinity)
            }
            //.background(primaryMain.cgColor)
            Divider().padding(.horizontal, 16).padding(.vertical,10)
        }

    }
}
