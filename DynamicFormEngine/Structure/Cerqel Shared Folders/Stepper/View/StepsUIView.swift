//
//  StepsUIView.swift
//  CERQEL
//
//  Created by ahmed maher on 12/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import SwiftUI

struct StepListView: View {

    @ObservedObject var viewModel: StepProgressViewModel
    @State private var currentIndex: Int = 0
    @Binding var isModelPresented: Bool 
    var callBackWithCurrentPage: (Int) -> Void

    var body: some View {
        StepsHeaderView(title: "Steps (\(viewModel.totalPages.count))"){
            isModelPresented = false
        }

        ScrollView {
            VStack(alignment: .leading, spacing: 5){
                ForEach(viewModel.totalPages.indices, id: \.self) { index in
                    let currentStep = viewModel.totalPages[index]
                    StepWidget(
                        stepNumber: "step \(index + 1)",
                        stepName: viewModel.totalPages[index].label,
                        isActive: currentStep.isActive,
                        isLineActive:  index <  viewModel.totalPages.count - 1 ? currentStep.isActive &&  viewModel.totalPages[index + 1].isActive : currentStep.isActive ,
                        showLine: index < viewModel.totalPages.count - 1
                    )
                    .onTapGesture {
                        if index > viewModel.currentPage {
                            viewModel.activateSteps(upTo: index)
                        } else {
                            viewModel.deactivateSteps(downTo: index)
                        }
                        isModelPresented = false
                        callBackWithCurrentPage(viewModel.currentPage)
                    }
                }

            }
            .padding(.horizontal,20)
            .padding(.top,20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


struct StepWidget: View {
    let stepNumber: String
    let stepName: String
    let isActive: Bool
    let isLineActive: Bool
    let showLine: Bool

    let bluecolor = Color(UIColor(hexCerqel: "#2E97EF")!)
    let greyColor = Color(UIColor(hexCerqel: "#D6DCE8")!)

    var body: some View {
        HStack(alignment: .top,spacing: 15) {
            VStack {
                ZStack {
                    // Outer Circle
                    Circle()
                        .stroke(isActive ? bluecolor : greyColor, lineWidth: 1)
                        .frame(width: 31, height: 31)

                    Circle()
                        .fill(isActive  ? bluecolor : greyColor)
                        .frame(width: 11, height: 11)
                }

                if showLine {
                    Rectangle()
                        .fill(isLineActive ? bluecolor : greyColor)
                        .frame(width: 2, height: 50)

                }
            }


            // Step Texts
            VStack(alignment: .leading, spacing: 5) {
                Text(stepNumber)
                    .font( Font.caption3Regular())
                    .foregroundColor(Color(typographySubtitle))

                Text(stepName)
                    .font( Font.bodySMedium())
                    .foregroundColor(Color(typographySubtitle))
            }
        }


    }
}

struct StepsHeaderView: View {
    var title: String = ""
    var onClose: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(Font.subtitleMMedium())
                .foregroundColor(.black)

            Spacer() // Pushes the elements apart

            Button(action: {
                onClose()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(typographyTitle))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.white) // Background color
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}



//#Preview {
//    StepListView()
//}
