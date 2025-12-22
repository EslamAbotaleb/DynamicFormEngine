//
//  SliderTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 05/04/2022.
//

import UIKit
import MultiSlider

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var multiSlider: MultiSlider!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelSliderItem {
                labelView.item = item
                labelView.required = item.required
                attachmentNoteView.item = item
                if let start = item.start, let end = item.end {
                    minValueLabel.text = "\(start)"
                    maxValueLabel.text = "\(end)"
                    multiSlider.minimumValue = CGFloat(start)
                    multiSlider.maximumValue = CGFloat(end)
                }
                if let selectionMode = item.selectionMode {
                    if selectionMode == .Single {
                        multiSlider.thumbCount = 1
                    } else {
                        multiSlider.thumbCount = 2
                    }
                }
                if let step = item.step {
                    multiSlider.snapStepSize = CGFloat(step)
                }
                if let defaultAnswer = item.defaultAnswer, let value = defaultAnswer.value {
                    let floatValues = value.map({CGFloat($0)})
                    multiSlider.value = floatValues
                }
                if let value = (item.answer as? SliderAnswer)?.value {
                    let floatValues = value.map({CGFloat($0)})
                    multiSlider.value = floatValues
                }
                handleLanguageView()
            }
        }
    }
    
    var valueChanged: ((SliderAnswer) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        multiSlider.orientation = .horizontal
        multiSlider.valueLabelPosition = .top
//        multiSlider.outerTrackColor = .primaryLightColor
//        multiSlider.tintColor = .primaryColor
        multiSlider.thumbImage = UIImage(named: "sliderControl")
        multiSlider.trackWidth = 4
        multiSlider.keepsDistanceBetweenThumbs = false
        multiSlider.hasRoundTrackEnds = true
        multiSlider.showsThumbImageShadow = false
        multiSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    func handleLanguageView() {
//        if Localizer.currentAppLanguageArabic() {
//            multiSlider.transform = CGAffineTransform(scaleX: -1, y: 1)
//            multiSlider.valueLabels.forEach { textField in
//                textField.transform = CGAffineTransform(scaleX: -1, y: 1)
//            }
//        }
    }
    
    @objc func sliderValueChanged(_ slider: MultiSlider) {
        let doubleValues = slider.value.map({Double($0)})
        valueChanged?(SliderAnswer(val: doubleValues))
    }
}
