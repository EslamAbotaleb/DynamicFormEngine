//
//  FormViewModel.swift
//  FormBuilderEngine
//
//  Created by hassan elshaer on 28/02/2024.
//

import Foundation
import RxCocoa
internal import RxSwift
import Photos
import UIKit

public class  FormDFViewModel: BaseViewModel {
    
    // MARK: - Variables
    
    private let service: cerqel_NetworkServiceDynamicForm
    private let disposeBag = DisposeBag()
    var view: UIViewController

    
    init(_ service:  cerqel_NetworkServiceDynamicForm, view: UIViewController) {
        self.service = service
        self.view = view
        super.init()
    }
}
