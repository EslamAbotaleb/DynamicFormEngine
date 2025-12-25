//
//  StepProgressViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 19/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation

public class StepProgressViewModel: ObservableObject {
    @Published var totalPages: [FormViewModelItem] = []
    @Published var currentPage: Int = 0
    @Published var enablePageValidation:  Bool = true
    @Published private(set)var progress: Double = 0.0



    public init(pages: [FormViewModelItem], currentPage: Int,enablePageValidation: Bool) {

        self.totalPages = pages
        self.currentPage = currentPage
        self.enablePageValidation = enablePageValidation
        activateSteps(upTo: 0)

    }

    public func setCurrentPage(_ index: Int) {
        guard index >= 0, index < totalPages.count else { return }
        currentPage = index
        unActiveSteps()
        activateSteps(upTo: index)
    }

    private func updateProgress(){
        self.progress = Double(currentPage + 1) / Double(totalPages.count)
    }


    // Activates all steps up to the given index
    public func unActiveSteps() {
        self.totalPages = self.totalPages.map{var step = $0; step.isActive = false; return step}


    }

    // Activates all steps up to the given index
    public func activateSteps(upTo index: Int) {
        for i in 0...index {
            totalPages[i].isActive = true
        }
        currentPage = index
        updateProgress()
    }

    // Deactivates steps from the current index down to the given index
    public func deactivateSteps(downTo index: Int) {
        guard let backVisibility = (totalPages[currentPage] as? FormViewModelPageItem)?.backVisibility, backVisibility else { return }

        for i in stride(from: currentPage, to: index, by: -1) {
            print("Current Index: \(i)")
            if let backVisibility = (totalPages[i] as? FormViewModelPageItem)?.backVisibility, !backVisibility {
                break
            }
            totalPages[i].isActive = false
        }


        currentPage = totalPages.lastIndex(where: { $0.isActive }) ?? 0
        updateProgress()
    }

    // Determines if the line between steps should be active
    public func isLineActive(currentIndex: Int, nextIndex: Int) -> Bool {
        let currentStep = totalPages[currentIndex]
        return currentIndex < totalPages.count - 1
        ? currentStep.isActive && totalPages[nextIndex].isActive
        : currentStep.isActive
    }
}
