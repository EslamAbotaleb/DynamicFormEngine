//
//  StepProgressView.swift
//  CERQEL
//
//  Created by ahmed maher on 13/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import SwiftUI

struct StepProgressView: View {

    @ObservedObject var viewModel: StepProgressViewModel
    @State private var isModalPresented: Bool = false
    var callBackWithCurrentPage: (Int) -> Void

    let bluecolor = Color(UIColor(hexCerqel: "#2E97EF")!)
    let greyColor = Color(UIColor(hexCerqel: "#F1F3F9")!)
    let PrgressColor = Color(UIColor(hexCerqel: "#65D3A1")!)

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            StepProgressBar(progress: viewModel.progress, barColor: PrgressColor, backgroundColor:greyColor)
            Button(action: {
                isModalPresented = true
            }) {
                HStack {
                    HStack ( spacing: 10) {
                        ZStack {
                            // Outer Circle
                            Circle()
                                .stroke(bluecolor, lineWidth: 1)
                                .frame(width: 31, height: 31)

                            Circle()
                                .fill(bluecolor)
                                .frame(width: 11, height: 11)

                        }
                        Text("Step \(viewModel.currentPage + 1)/\(viewModel.totalPages.count)")
                         //   .font( Font.bodySMedium())
                            .foregroundColor(Color(typographySubtitle))
                    }
                    Spacer()

                    Image("arrow_down")
                        .padding(.trailing, 30)
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 11)
                .frame(height: 65)
            }
        }

        .frame(maxHeight: .infinity , alignment: .top)
        .sheet(isPresented: $isModalPresented) {
            StepListView(viewModel: viewModel,isModelPresented: $isModalPresented){currentPage in
                callBackWithCurrentPage(currentPage)
            }
        }
    }
}

//#Preview {
//    //StepProgressView()
//}

struct StepProgressBar: View {
    var progress: Double
    var barColor: Color = .blue
    var backgroundColor: Color = .gray

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(backgroundColor)

                // Progress bar
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(barColor)
                    .frame(width: CGFloat(progress) * geometry.size.width)
            }
        }
        .frame(height: 6) // Default height
    }
}
