//
//  CerqelBaseSortVC + Extenstion.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 22/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation
import UIKit
public import RxSwift
public import RxCocoa

extension CerqelBaseSortVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortNames = viewModel.arrOfSections.filter { $0.rawValue == sortType?.rawValue }
        switch sortNames[section] {
        case .radioBtnTV:
            return sortData.count
        case .checkBoxTV:
            return sortData.count
        default :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sortType {
            
        case .radioBtnTV:
            let cell = tableView.dequeueReusableCell(withIdentifier: CerqelRadioButtonSortCell.cerqel_identifier, for: indexPath) as! CerqelRadioButtonSortCell
            cell.sortNameLbl.text = sortData[indexPath.row].sortName?.localized
            if sortData[indexPath.row].sortName == sortSelectedName {
                cell.sortIcon.image = UIImage(named: "Radio Status")
            } else {
                cell.sortIcon.image = UIImage(named: "Radio Status unselected")
            }
            return cell
            
        case .checkBoxTV:
            let cell = tableView.dequeueReusableCell(withIdentifier: CerqelCheckBoxSortCell.cerqel_identifier, for: indexPath) as! CerqelCheckBoxSortCell
            cell.checkSortNameLbl.text = sortData[indexPath.row].sortName?.localized
            if selectedRows.contains(indexPath) {
                cell.checkIcon.image = UIImage(named: "Ellipse 11")
            } else {
                cell.checkIcon.image = UIImage(named: "Ellipse 10")
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch sortType {
        case .radioBtnTV:
            sortSelectedName = sortData[indexPath.row].sortName
            if let selectedSort = sortData[indexPath.row].sortName{
                didSelectedOption?(selectedSort)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.dismiss(animated: true,completion: nil)
                })
            }
            tableView.reloadData()
        case .checkBoxTV:
            let cell = tableView.dequeueReusableCell(withIdentifier: CerqelCheckBoxSortCell.cerqel_identifier, for: indexPath) as! CerqelCheckBoxSortCell
            sortBaseName = sortData[indexPath.row].sortName
            if self.selectedRows.contains(indexPath) {
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
                cell.checkIcon.image = UIImage(named: "uncheckedBtnIcon")
            } else {
                self.selectedRows.append(indexPath)
                cell.checkIcon.image = UIImage(named: "checkedBtnIcon")
            }
            tableView.reloadData()
        default:
            print("Selected")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

//MARK: - collection view data source
extension CerqelBaseSortVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CerqelTagsSortCell.cerqel_identifier, for: indexPath) as! CerqelTagsSortCell
        cell.tagNameLbl.text = optionsTags[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat?
        width = self.optionsTags[indexPath.row].cerqel_widthOfString(usingFont: UIFont.heading4(ofSize: 12))
        let extraWidth = 12 + 4 + 16 + 5
        return CGSize(width: Int(width ?? 0) + extraWidth, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

