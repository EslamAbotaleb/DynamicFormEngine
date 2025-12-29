//
//  BaseListBottomShee.swift
//  CERQEL
//
//  Created by ahmed maher on 19/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
public import PanModal

public class BaseListItem: BaseItem,Equatable {
    static public func == (lhs: BaseListItem, rhs: BaseListItem) -> Bool {
        return true
    }
    
    public var list: [ListModel]
    public var title: String
    public var type: BottomSheetType
    public var currentSelectedItem: ListModel?
    public var currentMultiSelectedItems: [ListModel]?
    public var isSingleSelection: Bool
    public var selectedItem: SelectedCallBack
    public var multiSelectedItems: MultiSelectedCallBack
    public var action: [Action]?
    public init(list: [ListModel],title: String,type: BottomSheetType,currentSelectedItem: ListModel = ListModel(),currentMultiSelectedItems: [ListModel]? = [],isSingleSelection: Bool, selectedItem: @escaping SelectedCallBack,multiSelectedItems: @escaping MultiSelectedCallBack, action: [Action]? = [] ) {
        self.list = list
        self.title = title
        self.type = type
        self.currentSelectedItem = currentSelectedItem
        self.selectedItem = selectedItem
        self.isSingleSelection = isSingleSelection
        self.multiSelectedItems = multiSelectedItems
        self.currentMultiSelectedItems = currentMultiSelectedItems
        self.action = action
    }
}


public class BaseList: BaseView<BaseListBottomSheetViewModel, BaseListItem> {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var closeIcon: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
//            self.tableView.registerCell(idintifier: RadioCell.cerqel_identifier)
//            self.tableView.registerCell(idintifier: ActionBaseListTableViewCell.cerqel_identifier)
//            self.tableView.registerCell(idintifier: CheckBoxCell.cerqel_identifier)
//            self.tableView.registerCell(idintifier: ProfilePhoneTypesCell.cerqel_identifier)
            self.tableView.register(UINib(nibName: RadioCell.cerqel_identifier, bundle: Bundle(for: type(of: self))),
                                    forCellReuseIdentifier: RadioCell.cerqel_identifier)

            self.tableView.register(UINib(nibName: ActionBaseListTableViewCell.cerqel_identifier, bundle: Bundle(for: type(of: self))),
                                    forCellReuseIdentifier: ActionBaseListTableViewCell.cerqel_identifier)

            self.tableView.register(UINib(nibName: CheckBoxCell.cerqel_identifier, bundle: Bundle(for: type(of: self))),
                                    forCellReuseIdentifier: CheckBoxCell.cerqel_identifier)

            self.tableView.register(UINib(nibName: ProfilePhoneTypesCell.cerqel_identifier, bundle: Bundle(for: type(of: self))),
                                    forCellReuseIdentifier: ProfilePhoneTypesCell.cerqel_identifier)

            tableView.estimatedRowHeight = 50.0
            tableView.rowHeight = UITableView.automaticDimension
            
        }
    }
    @IBOutlet weak var doneBtn: UIButton!
   // var comment :  ((String?)->())
    
    
     override public func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        configureUI()
        handleObservation()
       

    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    private func initialConfiguration(){
        viewModel = BaseListBottomSheetViewModel(router: CerqelRouterManagerDynamicFormImpl(self),baseListItem:item)
        titleLbl.text = item.title
        viewModel.setlist()
    }
    
    private func configureUI() {
        self.titleLbl.font = UIFont.bodyLMedium()
        self.titleLbl.textColor = typographyTitle
        self.closeIcon.tintColor = primaryMain
        
        tableView.allowsMultipleSelection = !item.isSingleSelection
        doneBtn.isHidden = item.isSingleSelection
        closeIcon.isHidden = !item.isSingleSelection
    }
    
    private func handleObservation() {
        viewModel.list.bind { layout in
            self.tableView.reloadData()
            self.panModalSetNeedsLayoutUpdate()
        }
    }
    
    override public var longFormHeight: PanModalHeight {
        guard viewModel.list.value.count > 0 else {
            return .contentHeight(400)
        }
        
        return .contentHeight(tableView.contentSize.height + 80)
        
    }
    
    override public var shortFormHeight: PanModalHeight {
        return .contentHeight(400)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        viewModel.saveMultiSelectionArray()
        dismiss(true)
    }
}



extension BaseList: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.list.value[indexPath.row]
        
        var cell: UITableViewCell!
        let type = self.item.type
        switch type  {
        case .radio :
            cell = tableView.dequeueReusableCell(withIdentifier: RadioCell.cerqel_identifier, for: indexPath) as! RadioCell
            (cell as!RadioCell).configure(indexPath: indexPath, totalRows:  viewModel.list.value.count,item: item)
            (cell as!RadioCell).selectionStyle = .none
        case .checkBox :
            cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxCell.cerqel_identifier, for: indexPath) as! CheckBoxCell
            (cell as!CheckBoxCell).configure(item: item)
            (cell as!CheckBoxCell).selectionStyle = .none
        case .action:
            cell = tableView.dequeueReusableCell(withIdentifier: ActionBaseListTableViewCell.cerqel_identifier, for: indexPath) as! ActionBaseListTableViewCell
            (cell as!ActionBaseListTableViewCell).configure(indexPath: indexPath, totalRows:  viewModel.list.value.count, item: item)
            (cell as!ActionBaseListTableViewCell).selectionStyle = .none
        case .profilePhoneTypes:
            cell = tableView.dequeueReusableCell(withIdentifier: ProfilePhoneTypesCell.cerqel_identifier, for: indexPath) as! ProfilePhoneTypesCell
            (cell as!ProfilePhoneTypesCell).configure(item: item)
            (cell as!ProfilePhoneTypesCell).selectionStyle = .none
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if item.isSingleSelection {
            viewModel.selectItem(index: indexPath.row)
            dismiss(true)
        }
        else {
            viewModel.multiSelectItem(index: indexPath.row)
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if !item.isSingleSelection {
            viewModel.multiSelectItem(index: indexPath.row)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
}

