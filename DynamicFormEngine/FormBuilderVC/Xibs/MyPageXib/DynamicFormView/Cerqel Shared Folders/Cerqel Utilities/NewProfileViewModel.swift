//
//  NewProfileViewModel.swift
//  CERQEL
//
//  Created by Marwan on 20/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EFQRCode

class NewProfileViewModel: CerqelBaseViewModel {
    
    private let service: cerqel_NetworkService
    private let pickImageManager: PickImageProtocol
    private let router: CerqelRouterManager
    
    
    private let disposeBag = DisposeBag()
    
    var profile: BehaviorRelay<ModelUserProfileDataCerqel?> = BehaviorRelay(value: nil)
    var personalInfoList:DynamicObjects<[PersonalInfoModel]> = DynamicObjects([])
    var profilePhoto:DynamicObjects<UIImage?> = DynamicObjects(nil)
    var personId: String?
    var qrImage : CGImage?
    
    var pageNumber = 1
    var pageSize = 10
    var totalCount = -1
    var totalDataCount = 0
    var itemsList: BehaviorRelay<[ProfileSectionResponse]?> = BehaviorRelay(value: nil)
    var workExperienceCV: BehaviorRelay<GeneralAttachmentCerqel?> = BehaviorRelay(value: nil)
    var cvUploadedCV: BehaviorRelay<GeneralAttachmentCerqel?> = BehaviorRelay(value: nil)
    var isLoading = false
    var deletedItemIndex: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    var cvUploadedSuccessfully: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    var validationError: DynamicObjects<String?> = DynamicObjects(nil)
    var quoteIsEditted: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    var quote: BehaviorRelay<ModelQuoteCerqel?> = BehaviorRelay(value: nil)
    var originalQuote: String? = nil
    var removeProfilePictureError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    var profileTVList : [ProfileListCerqel] = [
        ProfileListCerqel(id: 1, title: "Personal Information".localized, addTitle: "Personal Information".localized, profileSection: .personalInfo, deleteUrlProfileSection: .personalInfo, editUrlProfileSection: .personalInfo, emptyTitle: "", emptyImage: ""),
        ProfileListCerqel(id: 2, title: "My Salary".localized, addTitle: "My Salary".localized, profileSection: .mySalary, deleteUrlProfileSection: .mySalary, editUrlProfileSection: .mySalary, emptyTitle: "", emptyImage: ""),
        ProfileListCerqel(id: 3, title: "Emergency Contacts".localized, addTitle: "Emergency Contacts".localized, profileSection: .emergencyContacts, deleteUrlProfileSection: .emergencyContacts, editUrlProfileSection: .emergencyContacts, emptyTitle: "No Emergency Contacts Yet!".localized, emptyImage: "Emergency empty"),
        ProfileListCerqel(id: 4, title: "Social Media".localized, addTitle: "New Social Media".localized, profileSection: .socialMedia, deleteUrlProfileSection: .socialMedia, editUrlProfileSection: .socialMedia, emptyTitle: "No Social Media Yet!".localized, emptyImage: "SocialMedia empty"),
        ProfileListCerqel(id: 5, title: "Dependents".localized, addTitle: "Add Dependents".localized, profileSection: .dependents, deleteUrlProfileSection: .dependents, editUrlProfileSection: .dependents, emptyTitle: "No Dependents Yet!".localized, emptyImage: "Dependants empty"),
        ProfileListCerqel(id: 6, title: "Education".localized, addTitle: "Education".localized, profileSection: .education, deleteUrlProfileSection: .education, editUrlProfileSection: .education, emptyTitle: "No Education Yet!".localized, emptyImage: "Education empty"),
        ProfileListCerqel(id: 7, title: "Work Experience".localized, addTitle: "Work Experience".localized, profileSection: .workExperience, deleteUrlProfileSection: .workExperience, editUrlProfileSection: .workExperience, emptyTitle: "No Work Experience Yet!".localized, emptyImage: "Work empty"),
        ProfileListCerqel(id: 8, title: "Certificates & Courses".localized, addTitle: "Certificates & Courses".localized, profileSection: .certificatesAndCourses, deleteUrlProfileSection: .certificatesAndCourses, editUrlProfileSection: .certificatesAndCourses, emptyTitle: "No Certificates & Courses Yet!".localized, emptyImage: "certificates empty"),
    ]
    
    var mySalaryDataList : [MySalaryModel] = [
//        MySalaryModel(title: "Basic Salary ", subTitle: nil, amount: "10,000 LE",mainColor: primaryMain,bgColor: .primaryColorPurpleLight, subCategory: nil),
//        MySalaryModel(title: "Benefits ", subTitle: "Total Benefits ", amount: "3,150 LE",mainColor: .success,bgColor: .successLight, subCategory: [MySalarySubCategory(title: "Over Time", amount: "1,000 LE"),MySalarySubCategory(title: "Over Time", amount: "1,000 LE"),MySalarySubCategory(title: "Over Time", amount: "1,000 LE"),MySalarySubCategory(title: "Over Time", amount: "1,000 LE")]),
//        MySalaryModel(title: "Deductions ", subTitle: "Total Deductions ", amount: "1,000 LE",mainColor: .secondaryRed,bgColor: .secondaryRedLight, subCategory: [MySalarySubCategory(title: "Social Insurance", amount: "1,000 LE")]),
//        MySalaryModel(title: "Total Income", subTitle: nil, amount: "12,000 LE",mainColor: .completed,bgColor: .completedLight, subCategory: nil),
    ]
    
    var selectedProfileSection : ProfileListCerqel?
    
    init(_ service: cerqel_NetworkService,pickImageManager: PickImageProtocol,router: CerqelRouterManager) {
        self.service = service
        self.pickImageManager = pickImageManager
        self.router = router
        super.init()
    }
    
    func setPersonalInfoList(){
        personalInfoList.value =
        [
            PersonalInfoModel(title: "Basic Info".localized, additionalInfo: [PersonalInfoSubModel(title: "Full Name".localized, subTitle: profile.value?.name ?? "-"),
                                                                              PersonalInfoSubModel(title: "Date of birth".localized, subTitle: /*profile.value?.basicInfo?.dateOfBirth ??*/ "-"),
                                                                              PersonalInfoSubModel(title: "Gender".localized, subTitle: /*profile.value?.basicInfo?.gender ??*/ "-"),
                                                                              PersonalInfoSubModel(title: "Nationality".localized, subTitle: /*profile.value?.basicInfo?.nationality ??*/ "-" )]),
            
            PersonalInfoModel(title: "Job Details".localized, additionalInfo: [PersonalInfoSubModel(title: "Job Title".localized, subTitle: profile.value?.jobTitle ?? "-"),
                                                                               PersonalInfoSubModel(title: "Job ID".localized, subTitle: /*profile.value?.jobDetails?.jobID ??*/ "-"),
                                                                               PersonalInfoSubModel(title: "Department".localized, subTitle: /*profile.value?.departmentName ??*/ "-"),
                                                                               PersonalInfoSubModel(title: "Report To".localized, subTitle: /*profile.value?.jobDetails?.reportsTo ??*/ "-"),
                                                                               PersonalInfoSubModel(title: "Company Name".localized, subTitle: /*profile.value?.jobDetails?.companyName ??*/ "-"),
                                                                               PersonalInfoSubModel(title: "Joining Date".localized, subTitle: /*profile.value?.jobDetails?.joiningDate ??*/ "-")
                                                                              ]),
            
            PersonalInfoModel(title: "Contact Info.".localized, additionalInfo: [PersonalInfoSubModel(title: "Email".localized, subTitle: profile.value?.mail ?? "-"),
                                                                                 PersonalInfoSubModel(title: "Phone".localized, subTitle: profile.value?.phone ?? "-"),
                                                                                 PersonalInfoSubModel(title: "Mobile".localized, subTitle: /*profile.value?.contactInfo?.mobileNumber ??*/ "-"),
                                                                                 PersonalInfoSubModel(title: "EXT".localized, subTitle: /*profile.value?.contactInfo?.ext ??*/ "-")
                                                                                ]),
            PersonalInfoModel(title: "Medical Insurance".localized,  additionalInfo:
                                medicalInsuranceDataSource()
                             )
        ]
        
    }
    
    private func medicalInsuranceDataSource() -> [PersonalInfoSubModel] {
        return   /*profile.value?.medicalInsuranceInfo?.hasMedicalInsurance ??*/ false ?
        [PersonalInfoSubModel(title: "Has medical insurance?".localized, subTitle: "Yes".localized),
         PersonalInfoSubModel(title: "Insurance Company Name".localized, subTitle: /*profile.value?.medicalInsuranceInfo?.insuranceCompanyName ??*/ "-"),
         PersonalInfoSubModel(title: "Insurance Tier".localized, subTitle: /*profile.value?.medicalInsuranceInfo?.insuranceTier ??*/ "-")
        ]
        :
        [PersonalInfoSubModel(title: "Has medical insurance?".localized, subTitle: "No".localized)
         
        ]
    }
    
    
    // pick image
    
    func handlePhotoActions(actionId: Int){
        switch actionId {
        case 1: viewProfilePhoto()
        case 2: selectPhototFormLibrary()
        case 3: selectPhototFormCamera()
            
        default:  break
            
        }
     
    }
    
     func viewProfilePhoto(){
        router.presentbottomSheet(controller: ProfilePhotoSheetVC.self, viewModel: ProfilePhotoEditViewModel.self, item: profileImageItem(profileImage: (UIImage(),profile.value?.photo ?? ""), profileAction: .View))
    }

   func  presentPhotoPreview(){
       self.router.presentbottomSheet(controller: ProfilePhotoSheetVC.self, viewModel: ProfilePhotoEditViewModel.self, item: profileImageItem(profileImage: (self.profilePhoto.value ?? UIImage(),""), profileAction: .Edit))
    }
    
    private func selectPhototFormLibrary(){
        pickImageManager.selectSingleImage(imageSource:[.library]) { image in
            self.profilePhoto.value = image
        }
    }
    
    private func selectPhototFormCamera(){
        pickImageManager.selectSingleImage(imageSource:[.photo]) { image in
            self.profilePhoto.value = image
        }
    }
     func deleteProfilePhoto(){
         deleteProfilePhotoEndPoint()
    }
    
    private func generateQrCode(QrCode: String) {
        let vCard = "BEGIN:VCARD\nVERSION:4.0\nFN:Ahmed Maher Sebaee\nTITLE:\nTEL;TYPE=CELL:\nEMAIL:asebaee@youxel.com\nEND:VCARD"

        if let image = EFQRCode.generate(
            for: vCard,
            foregroundColor: primaryMain.cgColor
        ) {
            qrImage = image
        } else {
            print("Create QRCode image failed!")
        }
    }
    func fetchProfile(){
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObject<ModelUserProfileDataCerqel>(action: CerqelProfileBasicAction.fetchProfile)).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            if let prof = response.item?.data{
//                self?.generateQrCode(QrCode: prof.qrCode ?? "")
                self?.profile.accept(prof)
            }
        }, onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
    }
    
    func fetchList(refresh: Bool = false, section: ProfileSectionCerqel){
        if refresh {
            pageNumber = 1
            totalCount = -1
        }
        if totalCount == -1 || (totalCount > self.itemsList.value?.count ?? 0){
            self.loadingSubject.onNext(.show)
            self.isLoading = true
            
            switch section {
                
            case .emergencyContacts:
                self.service.load(cerqel_CodableResponseObject<ModelProfileEmergencyContactDataCerqel>(action: CerqelProfileBasicAction.fetchProfileLists(path: section.rawValue))).subscribe(onNext: {
                    [weak self] (response) in
                    self?.isLoading = false
                    self?.loadingSubject.onNext(.hide)
                    if let list = response.item?.arrData {
                        self?.setList(list: list, totalCount: response.item?.totalCount, refresh: refresh)
                    } else {
                        self?.itemsList.accept([])
                    }
                }, onError: { (error) in
                    self.fireError(error: error)
                }).disposed(by: self.disposeBag)
                
            case .socialMedia:
                self.service.load(cerqel_CodableResponseObject<ModelProfileSocialMediaDataCerqel>(action: CerqelProfileBasicAction.fetchProfileSocialMedia)).subscribe(onNext: {
                    [weak self] (response) in
                    self?.isLoading = false
                    self?.loadingSubject.onNext(.hide)
                    if let list = response.item?.arrData {
                        self?.setList(list: list, totalCount: response.item?.totalCount, refresh: refresh)
                    } else {
                        self?.itemsList.accept([])
                    }
                }, onError: { (error) in
                    self.fireError(error: error)
                }).disposed(by: self.disposeBag)
                
            case .dependents:
                self.service.load(cerqel_CodableResponseObject<ModelProfileDependantDataCerqel>(action: CerqelProfileBasicAction.fetchProfileLists(path: section.rawValue))).subscribe(onNext: {
                    [weak self] (response) in
                    self?.isLoading = false
                    self?.loadingSubject.onNext(.hide)
                    if let list = response.item?.arrData {
                        self?.setList(list: list, totalCount: response.item?.totalCount, refresh: refresh)
                    } else {
                        self?.itemsList.accept([])
                    }
                }, onError: { (error) in
                    self.fireError(error: error)
                }).disposed(by: self.disposeBag)
                
            case .education:
                self.service.load(cerqel_CodableResponseObject<ModelProfileEducationDataCerqel>(action: CerqelProfileBasicAction.fetchProfileLists(path: section.rawValue))).subscribe(onNext: {
                    [weak self] (response) in
                    self?.isLoading = false
                    self?.loadingSubject.onNext(.hide)
                    if let list = response.item?.arrData {
                        self?.setList(list: list, totalCount: response.item?.totalCount, refresh: refresh)
                    } else {
                        self?.itemsList.accept([])
                    }
                }, onError: { (error) in
                    self.fireError(error: error)
                }).disposed(by: self.disposeBag)
                
            case .workExperience:
                self.service.load(cerqel_CodableResponseObject<ModelProfileWorkExperienceDataCerqel>(action: CerqelProfileBasicAction.fetchProfileLists(path: section.rawValue))).subscribe(onNext: {
                    [weak self] (response) in
                    self?.isLoading = false
                    self?.loadingSubject.onNext(.hide)
                    if let list = response.item?.arrData {
                        self?.setList(list: list, totalCount: response.item?.totalCount, refresh: refresh)
                    } else {
                        self?.itemsList.accept([])
                    }
                }, onError: { (error) in
                    self.fireError(error: error)
                }).disposed(by: self.disposeBag)
                
            case .certificatesAndCourses:
                self.service.load(cerqel_CodableResponseObject<ModelProfileCertificateAndCourseDataCerqel>(action: CerqelProfileBasicAction.fetchProfileLists(path: section.rawValue))).subscribe(onNext: {
                    [weak self] (response) in
                    self?.isLoading = false
                    self?.loadingSubject.onNext(.hide)
                    if let list = response.item?.arrData {
                        self?.setList(list: list, totalCount: response.item?.totalCount, refresh: refresh)
                    } else {
                        self?.itemsList.accept([])
                    }
                }, onError: { (error) in
                    self.fireError(error: error)
                }).disposed(by: self.disposeBag)
                
            case .mySalary:
                print("sd")
                
            case .personalInfo:
                print("sdw")
                
            }
            
        }
    }
    
    func deleteItem(deleteSection: ProfileSectionDeleteUrlCerqel, id: String, index: Int){
        self.loadingSubject.onNext(.show)
        self.isLoading = true
        
        self.service.load(cerqel_CodableResponseObject<Bool>(action: CerqelProfileBasicAction.deleteProfileList(path: deleteSection.rawValue, id: id))).subscribe(onNext: {
            [weak self] (response) in
            self?.isLoading = false
            self?.loadingSubject.onNext(.hide)
            if response.item?.data ?? false {
                self?.deletedItemIndex.accept(index)
            }
        }, onError: { (error) in
            self.fireError(error: error)
        }).disposed(by: self.disposeBag)
        
    }
    
    
    func setList<T: ProfileSectionResponse>(list: [T], totalCount: Int?, refresh: Bool) {
        self.totalDataCount = totalCount ?? 0
        if refresh {
            self.itemsList.accept(list)
        } else {
            if self.itemsList.value? .count == 0{
                self.itemsList.accept(itemsList.value)
            }else{
                
                var old = [ProfileSectionResponse]()
                for element in self.itemsList.value ?? []{
                    old.append(element)
                }
                for item in list{
                    old.append(item)
                }
                
                self.itemsList.accept(old)
            }
            
        }
        
        if let totalCount = totalCount {
            self.totalCount = totalCount
            self.pageNumber += 1
        }
        
    }
    
    func deleteCV(){
        self.loadingSubject.onNext(.show)
        self.isLoading = true
        
        self.service.load(cerqel_CodableResponseObject<Bool>(action: CerqelProfileBasicAction.deleteCV)).subscribe(onNext: {
            [weak self] (response) in
            self?.isLoading = false
            self?.loadingSubject.onNext(.hide)
            if response.item?.data ?? false {
                self?.workExperienceCV.accept(nil)
            }
            //            self?.cvUpdated.accept(response.item?.data)
        }, onError: { (error) in
            self.fireError(error: error)
        }).disposed(by: self.disposeBag)
        
    }
    
    func fetchCV(isFromProfileList: Bool){
        self.loadingSubject.onNext(.show)
        self.isLoading = true
        
        self.service.load(cerqel_CodableResponseObject<GeneralAttachmentCerqel>(action: CerqelProfileBasicAction.fetchCV)).subscribe(onNext: {
            [weak self] (response) in
            self?.isLoading = false
            self?.loadingSubject.onNext(.hide)
            if isFromProfileList {
                self?.workExperienceCV.accept(response.item?.data)
            } else {
                self?.cvUploadedCV.accept(response.item?.data)
            }
            //            self?.cvUpdated.accept(true)
        }, onError: { (error) in
            self.fireError(error: error)
        }).disposed(by: self.disposeBag)
        
    }
    
    func fetchQuote(isFromProfileList: Bool){
        self.loadingSubject.onNext(.show)
        self.isLoading = true
        
        self.service.load(cerqel_CodableResponseObject<ModelQuoteCerqel>(action: CerqelProfileBasicAction.getQuote)).subscribe(onNext: {
            [weak self] (response) in
            self?.isLoading = false
            self?.loadingSubject.onNext(.hide)
            self?.quote.accept(response.item?.data)
            self?.originalQuote = response.item?.data?.text
        }, onError: { (error) in
            self.fireError(error: error)
        }).disposed(by: self.disposeBag)
        
    }
    
    func editQuote(text: String){
        self.loadingSubject.onNext(.show)
        self.isLoading = true
        
        self.service.load(cerqel_CodableResponseObject<Bool>(action: CerqelProfileBasicAction.editQuote(text: text))).subscribe(onNext: {
            [weak self] (response) in
            self?.isLoading = false
            self?.loadingSubject.onNext(.hide)
            //                self?.workExperienceCV.accept(response.item?.data)
            self?.quoteIsEditted.accept(response.item?.data)
        }, onError: { (error) in
            self.fireError(error: error)
        }).disposed(by: self.disposeBag)
        
    }
    
    
    func uploadMedia(mediaImg: UIImage?, fileUrl: URL?){
        self.loadingSubject.onNext(.show)
        
        cerqel_NormalAPIcall().uploadFile(action: .uploadFile(isPublic: true), photo: mediaImg, fileUrl: fileUrl, onCompletion: { (result) in
            if let res = result?["result"] as? [[String: Any]], let fir = res.first, let media = GeneralAttachmentResponseCerqel(dictionary: fir), let id = media.id{
                //                ModelUploadedMediaCerqel(JSON: fir)
                print(id)
                
                self.cvUploadedCV.accept(media.toAttachment())
                //                self.attachment.value = media.toAttachment()
            }
            self.loadingSubject.onNext(.hide)
            
            
        }, onError:  { (error) in
            self.loadingSubject.onNext(.hide)
            if let err = error {
                self.fireError(error: err)
            }
        })
    }
    
    
    func uploadCV(cv: GeneralAttachmentCerqel) {
        self.loadingSubject.onNext(.show)
        self.isLoading = true
        
        self.service.load(cerqel_CodableResponseObject<GeneralAttachmentCerqel>(action: CerqelProfileBasicAction.uploadCV(cv: cv))).subscribe(onNext: {
            [weak self] (response) in
            self?.isLoading = false
            self?.loadingSubject.onNext(.hide)
            self?.workExperienceCV.accept(response.item?.data)
            self?.cvUploadedSuccessfully.accept(response.success)
            //            self?.cvUpdated.accept(true)
        }, onError: { (error) in
            self.fireError(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    func validateQuote(text: String?) -> Bool {
        guard let _ = text, !(text?.isEmpty ?? true), text != "Add your inspiring quote here".localized else {
            validationError.value = "Please enter your quote".localized
            return false
        }
        
        guard let min = text, min.count >= 20 else {
            validationError.value = "Please enter your quote at least 20 characters".localized
            return false
            
        }
        
        guard let max = text, max.count <= 100 else {
            validationError.value = "Please enter your quote maximum 100 characters".localized
            return false
        }
        
        guard self.originalQuote.value != text else {
            validationError.value = "Please edit the quote".localized
            return false
        }
        
        return true
    }
    
    
    func fireError(error: Error) {
        self.errorsSubject.onNext(error)
        self.loadingSubject.onNext(.hide)
        //        self.deletedItemIndex.accept(false)
    }
    
    func deleteProfilePhotoEndPoint(){
        removeProfilePictureError.accept(nil)
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObject<ModelUserProfileDataCerqel>(action: CerqelProfileBasicAction.deleteProfilePhoto)).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            if  response.success ?? false{
                self?.fetchProfile()
            }
            else {
                print("Failed")
                self?.removeProfilePictureError.accept("Failed")
                
            }
        }, onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
    }

}
