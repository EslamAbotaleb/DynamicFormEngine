import UIKit
import EzPopup
//internal import FittedSheetsDF
import Expression
import SwiftMessages
import RxCocoa
internal import RxSwift
import SwiftUI
import JGProgressHUD
import EasyTipView

extension FormViewController {
    
    
    func isSinglePageHasErrors() -> Bool {
        var hasErrors = false
        for sectionIndex in 0..<formBuilder.sectionObjects.count {
            let section = formBuilder.sectionObjects[sectionIndex]
            for rowIndex in 0..<section.items.count {
                let item = section.items[rowIndex]
                let validationResult = FormManager.shared.validateControl(vc: self, item)
                
                if validationResult.isError {
                    hasErrors = true
                    item.inLineError = true
                    item.errorMessageInline = validationResult.errorMessage
                    // Update UI for inline error
                    updateInlineError(for: item, at: IndexPath(row: rowIndex, section: sectionIndex), message: validationResult.errorMessage)
                } else {
                    item.inLineError = false
                    item.errorMessageInline = ""
                    clearInlineError(for: item, at: IndexPath(row: rowIndex, section: sectionIndex))
                }
            }
        }
        return hasErrors
    }
    
    func isFormHasErrors() -> (Bool, Int?) {
        var hasErrors = false
        var firstErrorPageIndex: Int? = nil
        
        // Iterate over pages in the correct order
        for (pageIndex, pageItem) in formBuilder.pagesArray.enumerated() {
            guard !pageItem.hidden else { continue }
            guard let pageFieldId = pageItem.fieldId,
                  let items = formBuilder.formPageDictionary[pageFieldId] else { continue }
            
            var pageHasErrors = false
            
            for (rowIndex, item) in items.enumerated() {
                if let sectionControl = item as? FormViewModelSectionItem {
                    // If the item is a section, retrieve its items
                    if let sectionItems = formBuilder.formSectionDictionary[sectionControl.fieldId] {
                        // Loop through the section items
                        for (sectionRowIndex, sectionItem) in sectionItems.enumerated() {
                            let validationResult = FormManager.shared.validateControl(vc: self, sectionItem)
                            
                            if validationResult.isError {
                                hasErrors = true
                                pageHasErrors = true
                                
                                // Capture the first error page index if not already set
                                if firstErrorPageIndex == nil {
                                    firstErrorPageIndex = pageIndex
                                }
                                
                                // Update UI for inline error
                                sectionItem.inLineError = true
                                sectionItem.errorMessageInline = validationResult.errorMessage
                                updateInlineError(for: sectionItem, at: IndexPath(row: sectionRowIndex, section: pageIndex), message: validationResult.errorMessage)
                            } else {
                                sectionItem.inLineError = false
                                sectionItem.errorMessageInline = ""
                                clearInlineError(for: sectionItem, at: IndexPath(row: sectionRowIndex, section: pageIndex))
                            }
                        }
                    }
                    var updatedItems = items
                    updatedItems[rowIndex] = sectionControl
                    formBuilder.formPageDictionary[pageFieldId] = updatedItems
                } else {
                    // Normal code for non-section items
                    let validationResult = FormManager.shared.validateControl(vc: self, item)
                    
                    if validationResult.isError {
                        hasErrors = true
                        pageHasErrors = true
                        
                        // Capture the first error page index if not already set
                        if firstErrorPageIndex == nil {
                            firstErrorPageIndex = pageIndex
                        }
                        item.inLineError = true
                        item.errorMessageInline = validationResult.errorMessage
                        // Update UI for inline error
                        updateInlineError(for: item, at: IndexPath(row: rowIndex, section: pageIndex), message: validationResult.errorMessage)
                    } else {
                        item.inLineError = false
                        item.errorMessageInline = ""
                        clearInlineError(for: item, at: IndexPath(row: rowIndex, section: pageIndex))
                    }
                    var updatedItems = items
                    updatedItems[rowIndex] = item
                    formBuilder.formPageDictionary[pageFieldId] = updatedItems
                }
            }
            
            
            // Reset firstErrorPageIndex if current page no longer has errors
            if firstErrorPageIndex == pageIndex && !pageHasErrors {
                firstErrorPageIndex = nil
            }
        }
        
        // Recalculate firstErrorPageIndex if needed
        if firstErrorPageIndex == nil && hasErrors {
            for (pageIndex, pageItem) in formBuilder.pagesArray.enumerated() {
                guard !pageItem.hidden else { continue }
                guard let pageFieldId = pageItem.fieldId,
                      let items = formBuilder.formPageDictionary[pageFieldId] else { continue }
                
                for (rowIndex, item) in items.enumerated() {
                    let validationResult = FormManager.shared.validateControl(vc: self, item)
                    if validationResult.isError {
                        firstErrorPageIndex = pageIndex
                        break
                    }
                }
                
                if firstErrorPageIndex != nil {
                    break
                }
            }
        }
        return (hasErrors, firstErrorPageIndex)
    }
    
    /// submitting form
    func submitForm() {
        if formBuilder.isPageMode {
            // Check if currentPage has reached the last page
            if currentPage == formBuilder.pages.count - 1 {
                // Change the Next button title to "Submit"
                loadNextPrevBtnsTitles(direction: 1)
                
                let result = isFormHasErrors()
                
                // Navigate to the first error page if necessary
                if let errorPageIndex = result.1 {
                    self.currentPage = errorPageIndex
                    // Trigger page navigation logic if required
                }
                
                // Navigation logic for summary screen
                if !result.0 {
                    getSummaryPage()
                } else {
                    loadNextPrevBtnsTitles(direction: 1)
                }
            } else {
                    currentPage += 1
                    stepProgressViewModel.setCurrentPage(currentPage)
                    loadNextPrevBtnsTitles(direction: 1)
            }
        }
        else {
            getSummaryPage()
        }
    }
    
    /// navigate to summary page
    func getSummaryPage() {
        formBuilder.goToSummary = true
        navigationController?.pushViewController(DynamicSharedRouterDynamicForm.goTo(viewName: .serviceSummaryPagesVC(buttonId: self.buttonId ?? nil, actionId: self.buttonId ?? nil, isEditable: FormManager.shared.isEditable, isApproverForm: isApproverForm, requestIdForApprover: self.requestIdForApprover, view: self)), animated: true)
    }
    
    /// loading next & previous buttons titles
    func loadNextPrevBtnsTitles(direction: Int) {
        // Ensure the index is valid to avoid out-of-bounds access
        while currentPage >= 0 && currentPage < formBuilder.pages.count {
            let pageId = formBuilder.pages[currentPage] // Get the ID from pages at the current page index

            // Find the item in pagesArray with fieldId matching the pageId
            if let matchedItem = formBuilder.pagesArray.first(where: { $0.fieldId == pageId }) {
                if let currentPageItem = matchedItem as? FormViewModelPageItem {
                    
                    // If the current page is hidden, move to the next page
                    if currentPageItem.hidden || currentPageItem.disabled {
                        currentPage += direction
                        continue // Restart the loop with the new page
                    }

                    // Set titles for Next and Prev buttons
                    if currentPage == formBuilder.pages.count - 1 {
                        submitButton.setTitle(currentPageItem.submitText ?? "", for: .normal)
                    }else {
                        submitButton.setTitle(currentPageItem.nextText ?? "", for: .normal)
                    }
                    prevBtn.isHidden = !formBuilder.isPageMode || formBuilder.pages.count <= 0
                    prevBtn.setTitle(currentPageItem.backText ?? "", for: .normal)

                    // Handle visibility and colors for the Prev button
                    if (currentPageItem.backVisibility ?? false) == false {
                        prevContainterView.isHidden = true
                    } else {
                        prevContainterView.isHidden = false
                    }
                    break // Exit the loop once a valid page is loaded
                }
            } else {
                print("No matched item found for pageId: \(pageId)")
                break // Exit the loop if no match is found
            }
        }

        // Handle case when all pages are hidden
        if currentPage >= formBuilder.pages.count {
            print("No valid pages to display")
            // Optionally, you can disable the buttons or show an alert
        }
    }
    
    /// loading next and previous buttons
    func loadPrevAndNextBtns() {
        let pageId = formBuilder.pages[currentPage] // Get the ID from pages at the current page index

        // Find the item in pagesArray with fieldId matching the pageId
        if let matchedItem = formBuilder.pagesArray.first(where: { $0.fieldId == pageId }) {
            if let currentPageItem = matchedItem as? FormViewModelPageItem {
                
                // If the current page is hidden, move to the next page
                if !(currentPageItem.hidden ?? false) || !(currentPageItem.disabled) {
                    submitButton.setTitle(currentPageItem.nextText ?? "", for: .normal)
                    prevBtn.isHidden = !formBuilder.isPageMode || formBuilder.pages.count <= 0
                    prevBtn.setTitle(currentPageItem.backText ?? "", for: .normal)

                    // Handle visibility and colors for the Prev button
                    if (currentPageItem.backVisibility ?? false) == false {
                        prevContainterView.isHidden = true
                    } else {
                        prevContainterView.isHidden = false
                    }
                }

                // Set titles for Next and Prev buttons
            }
        }
    }
}
