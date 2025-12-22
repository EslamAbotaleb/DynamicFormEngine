//
//  NoDataTableViewExtention.swift
//  PantherAppIOS
//
//  Created by Mahmoud ibrahim on 12/20/19.
//  Copyright © 2019 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit

extension UITableView: NoDataProtocol {
    
    func setNoDataPlaceholderWithButton(
        title: String = "No Files Yet!",
        buttonTitle: String, // now mandatory
        buttonTitleColor: UIColor = .systemBlue,
        buttonAction: @escaping () -> Void, // now mandatory
        messageImage: UIImage = UIImage(named: "emptyState")!,
        showImage: Bool = true,
        whiteBG: Bool = false
    ) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))

        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let actionButton = UIButton(type: .system)

        messageImageView.backgroundColor = .clear

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = primaryMain
        titleLabel.font = UIFont.bodyLMedium()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        actionButton.setTitleColor(buttonTitleColor, for: .normal)
        actionButton.titleLabel?.font = UIFont.bodyMRegular()
        actionButton.contentHorizontalAlignment = .center
        actionButton.setTitle(buttonTitle.localized, for: .normal) // mandatory
        actionButton.addTargetClosure { _ in buttonAction() }        // mandatory

        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(actionButton)

        // Constraints for messageImageView
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -70).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 155).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 155).isActive = true

        // Constraints for titleLabel
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -5).isActive = true

        // Constraints for actionButton
        actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        actionButton.widthAnchor.constraint(lessThanOrEqualTo: emptyView.widthAnchor, multiplier: 0.5).isActive = true

        // Set content
        messageImageView.image = messageImage
        titleLabel.text = title.localized

        // Animation of image
        UIView.animate(withDuration: 1, animations: {
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { _ in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
        })

        if whiteBG {
            emptyView.backgroundColor = .white
            emptyView.layer.borderColor = UIColor.lightGray.cgColor
            emptyView.layer.cornerRadius = 8
        }
        self.backgroundView = emptyView
    }

    func setNoDataPlaceholder(title: String = "No Files Yet!", message: String = "", messageImage: UIImage = UIImage(named: "emptyState")!, showImage: Bool = true, whiteBG: Bool = false) {

        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))

        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()

        messageImageView.backgroundColor = .clear

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = primaryMain
        titleLabel.font = UIFont.bodyLMedium()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        messageLabel.textColor = typographyBody // UIColor(hexCerqel: "#969696")
        messageLabel.font = UIFont.bodyMRegular()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)

        // Constraints for messageImageView
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -70).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 155).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 155).isActive = true

        // Constraints for titleLabel
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -5).isActive = true

        // Constraints for messageLabel
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
       // messageLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 50).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -50).isActive = true



        // Set content
        messageImageView.image = messageImage
        titleLabel.text = title.localized
        messageLabel.text = message.localized
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        // Animation
        UIView.animate(withDuration: 1, animations: {
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
        })
        
        if whiteBG {
            emptyView.backgroundColor = .white
            emptyView.layer.borderColor = UIColor.lightGray.cgColor
            emptyView.layer.cornerRadius = 8
        }
        self.backgroundView = emptyView
    }

    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
    }
}
