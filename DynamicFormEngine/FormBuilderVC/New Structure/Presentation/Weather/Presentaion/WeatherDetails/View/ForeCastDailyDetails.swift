//
//  ForeCastDailyDetails.swift
//  CERQEL
//
//  Created by Youxel on 01/11/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import SwiftUI

struct ForeCastDailyDetails: View {
    @StateObject var viewModel = WeatherDetailsViewModel()
    var body: some View {
        ForecastDailyDetailsBody(viewModel: viewModel)
            .onViewDidLoad{
                viewModel.getForeCasDailyList()
            }
    }
}

struct ForeCastDailyDetails_Previews: PreviewProvider {
    static var previews: some View {
        ForeCastDailyDetails()
    }
}

struct ForecastDailyDetailsBody: View {
    @ObservedObject var viewModel : WeatherDetailsViewModel
    var body: some View {
        VStack(alignment: .leading){
            CustomNavBar(title: "Forecast Details")
            NavigationView{
                List{
                    ForEach(viewModel.foreCasDailytList) { item in
                        ForeCastDailyDetailsWidgetView(forCastDailyItem : item,isSelected: false).listRowInsets(EdgeInsets())
                    }.listSectionSeparator(.hidden, edges: .top).listRowSeparator(.hidden)
                }.listStyle(.inset).navigationTitle("Daily Forecast").navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
