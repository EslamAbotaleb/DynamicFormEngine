//
//  File.swift
//  it_graduate_new
//
//  Created by Mahmoud Ibaraheim on 7/8/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

public enum SourceType: Int {
    case files
    case folder
}

public protocol DocumentDelegate: AnyObject {
    func didPickDocuments(URLs: [URL]?, fromProfile: Bool)
}
