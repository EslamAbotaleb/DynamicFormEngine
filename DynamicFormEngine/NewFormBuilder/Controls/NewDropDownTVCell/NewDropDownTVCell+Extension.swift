//
//  NewDropDownTVCell+Extension.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 07/07/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//


import UIKit

extension NewDropDownTVCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectedValues.count > 2 {
                 return 3
             } else {
                 return self.selectedValues.count
             }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddEditInvitedCV.cerqel_identifier, for: indexPath) as! AddEditInvitedCV
//    
//        if indexPath.row == 2 && self.selectedValues.count > 2 {
//            cell.invitedPeopleNameLbl.text = "+\((self.selectedValues.count) - 2)"
//        } else {
//            cell.invitedPeopleNameLbl.text = self.selectedValues[indexPath.row].name
//        }
//            return cell
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
        selectedOptionsCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2 && self.selectedValues.count > 2 {
            return CGSize(width: 30 , height: 30)
        } else {
            var width: CGFloat?
            if isArabicCerqel() {
                width = self.selectedValues[indexPath.row].name?.width(withConstrainedHeight: 30, font: UIFont.heading1(ofSize: 12))
            } else {
                width = self.selectedValues[indexPath.row].name?.width(withConstrainedHeight: 30, font: UIFont.heading1(ofSize: 12))
            }
            let extraWidth = 5 + 5
            return CGSize(width: Int(width ?? 0) + extraWidth, height: 30)
        }
    }
}
    
