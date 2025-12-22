//
//  ForeCastDetailsWidget.swift
//  SwiftUIDemo
//
//  Created by Youxel on 30/10/2023.
//

import SwiftUI

struct ForeCastHourlyDetailsWidgetView: View {
    let forCastHourlyItem : ForeCastHourlyDetailsResponseModel
    var body: some View {
        LazyVStack{
            HStack{
                Text(forCastHourlyItem.time).frame(maxWidth: .infinity)
                VStack{
                    Image(forCastHourlyItem.imageUrl).resizable().frame(width: 40,height: 40)
                    Text(forCastHourlyItem.comment)
                }.frame(maxWidth: .infinity)
                Text(forCastHourlyItem.temperture).frame(maxWidth: .infinity)
            }
            Divider().padding(.horizontal, 16).padding(.vertical,10)
        }

    }
}
