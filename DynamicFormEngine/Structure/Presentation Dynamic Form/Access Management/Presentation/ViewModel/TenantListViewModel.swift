//
//  TenantListViewModel.swift
//  CERQEL
//
//  Created by Youxel on 15/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

class TenantListViewModel: BaseVM {

    //Dependency
    private var router:CerqelRouterManager
    private var accessManagementUseCase: AccessManagementUseCase

    var tenantList: DynamicObjects<[TenantListEntity]> = DynamicObjects([])
    var selectedTenant: DynamicObjects<TenantListEntity?> = DynamicObjects(nil)

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    init(router: CerqelRouterManager,accessManagementUseCase: AccessManagementUseCase) {
        self.router = router
        self.accessManagementUseCase = accessManagementUseCase

    }

    func selectTenant()  {
        AuthManager.shared.tenant = TenantListDTO(tenantId: selectedTenant.value?.tenantID ?? "", tenantName: selectedTenant.value?.tenantName ?? "", tenantLogo: selectedTenant.value?.fullLogoAttachment?.url ?? "", isSelected: true)
        refreshToken()
    }

    func showAction(navigationController: UINavigationController){
        router.presentbottomSheet(fromProfile: false, controller: TenantActionsViewController.self, viewModel: TenantActionsViewModel.self, item: ActionItem(navigationController: navigationController ))
    }


    func refreshToken() {
        self.showHudLoading()
        TokenManager.shared.refreshToken {
            ThemeManager.shared.getThemeAndConfiguration { success in
                self.appDelegate.goToMain()
                self.hideHudLoading()
            }
        }

    }


    func tenantListEndPoint() {
        self.showLoadingCerqel()
        accessManagementUseCase.getTenantList().then { (response) in
            self.tenantList.value = response.result.data
            print(response.result.data)

        }.catch { (error) in
            self.hideLoadingCerqel()
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
    
    func removeAllSelectedTenants() {
        for (idx,_) in tenantList.value.enumerated() {
            tenantList.value[idx].isSelected = false
        }
    }
    
    func didSelectTenant(in row: Int) {
        removeAllSelectedTenants()
        tenantList.value[row].isSelected = true
        selectedTenant.value =  tenantList.value[row]
    }
    
    
}
