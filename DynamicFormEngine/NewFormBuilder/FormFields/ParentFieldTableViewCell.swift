//
//  ParentFieldTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 11/01/2022.
//

import UIKit


class ParentFieldTableViewCell: UITableViewCell {

    var attachmentView: AttachmentNoteView!
    var objectOuterViews: [UIView]!
    var formVC: FormViewController?
    {
        if let formVC = self.parentContainerViewController() as? FormViewController {
            return formVC
        }
        return UIApplication.topViewController() as? FormViewController
    }
    var nestedFormVC: NestedFormViewController?
    {
        if let nestedFormVC = self.parentContainerViewController() as? NestedFormViewController {
            return nestedFormVC
        }
        return UIApplication.topViewController() as? NestedFormViewController
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateErrorState(_ error: Bool, with errorMessage: String) {
        if let formVC = formVC {
            formVC.activeTableView.beginUpdates()
            fieldError(error, errorMessage: errorMessage)
//            formVC.changeErrorValue(isError: error, section: attachmentView.indexPath.section, row: attachmentView.indexPath.row)
            formVC.activeTableView.endUpdates()
        }else if let nestedVC = nestedFormVC {
            nestedVC.activeTableView.beginUpdates()
            fieldError(error, errorMessage: errorMessage)
//            nestedVC.changeErrorValue(isError: error, section: attachmentView.indexPath.section, row: attachmentView.indexPath.row)
            nestedVC.activeTableView.endUpdates()
        }
    }
    
    private func fieldError(_ on: Bool, errorMessage: String = "") {
//        if on {
//            attachmentView.errorView.isHidden = false
//            for view in objectOuterViews {
//                view.layer.borderColor = UIColor.errorColor.cgColor
//            }
//        } else {
//            attachmentView.errorView.isHidden = true
//            for view in objectOuterViews {
//                view.layer.borderColor = UIColor(r: 208, g: 217, b: 226).cgColor
//            }
//        }
//        if self.parentContainerViewController() != nil {
//            cardModeError(on)
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                self.cardModeError(on)
//            }
//        }
//        attachmentView.errorLabel.text = errorMessage
    }
    
    private func cardModeError(_ on: Bool) {
        if let formVC = formVC {
            if formVC.formBuilder.isCardMode {
                if on {
//                    formVC.cardTableView.backgroundColor = .errorBGColor
                } else {
//                    formVC.cardTableView.backgroundColor = .white
                }
            } else {
                if on {
//                    self.contentView.backgroundColor = .errorBGColor
                } else {
                    self.contentView.backgroundColor = .clear
                }
            }
        }
    }
    
    func handleHideAttachment(_ isEditable: Bool, item: FormViewModelInteractiveItem) {
        if !isEditable {
            var empty = true
            if let note = item.note, !note.isEmpty {
                empty = false
            }
            if let attachmentImages = item.attachmentImages, attachmentImages.count > 0 {
                empty = false
            }
            if let attachmentFiles = item.attachmentFiles, attachmentFiles.count > 0 {
                empty = false
            }
            attachmentView.isHidden = empty
        }
    }
    
    func handleMCQLocalization(_ options: [MCQOption], item: FormViewModelMCQBaseItem) -> ([MCQOption], String?, String?) {
        var lOptions = [MCQOption]()
        var lOtherOptionText: String?
        var lNAOptionText: String?
//        if Localizer.isFormSameLanguage {
            lOptions = options
            lOtherOptionText = item.otherOptionText
            lNAOptionText = item.naOptionText
//        } else {
//            if let localization = item.localization as? MCQLocalization {
//                handleOtionsLocalization(localization, options, &lOptions)
//                handleExtraOptionsTextLocalization(localization, &lOtherOptionText, item, &lNAOptionText)
//            } else {
//                lOptions = options
//                lOtherOptionText = item.otherOptionText
//                lNAOptionText = item.naOptionText
//            }
//        }
        return (lOptions, lOtherOptionText, lNAOptionText)
    }
    
    fileprivate func handleOtionsLocalization(_ localization: MCQLocalization, _ options: [MCQOption], _ lOptions: inout [MCQOption]) {
//        if let localizedOptions = localization[Localizer.currentLanguage]?.options {
//            var newOptions = [MCQOption]()
//            for option in options {
//                if let x = localizedOptions.first(where: {$0.id == option.id}) {
//                    newOptions.append(x)
//                } else {
//                    newOptions.append(option)
//                }
//            }
//            lOptions = newOptions
//        } else {
//            lOptions = options
//        }
    }
    
    fileprivate func handleExtraOptionsTextLocalization(_ localization: MCQLocalization, _ lOtherOptionText: inout String?, _ item: FormViewModelMCQBaseItem, _ lNAOptionText: inout String?) {
//        if let localizedOtherOption = localization[Localizer.currentLanguage]?.otherOptionText, !localizedOtherOption.isEmpty {
//            lOtherOptionText = localizedOtherOption
//        } else {
//            lOtherOptionText = item.otherOptionText
//        }
//        if let localizedNAOptionText = localization[Localizer.currentLanguage]?.naOptionText, !localizedNAOptionText.isEmpty {
//            lNAOptionText = localizedNAOptionText
//        } else {
//            lNAOptionText = item.naOptionText
//        }
    }
}
