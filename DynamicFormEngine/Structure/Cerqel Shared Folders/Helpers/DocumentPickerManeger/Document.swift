//
//  Document.swift
//  it_graduate_new
//
//  Created by Mahmoud Ibaraheim on 7/8/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//


import UIKit

public class DocumentCerqel: UIDocument {

    var data: Data?

    override public func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }

        return try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
    }

    override public func load(fromContents contents: Any, ofType typeName: String?) throws {

        guard let data = contents as? Data else { return }

        self.data = data
    }

}

extension URL {
    public var isDirectory: Bool! {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
    }
    public var fileSize: Double? {
        let value = try? resourceValues(forKeys: [.fileSizeKey])
        return (Double (value?.fileSize ?? 0) / 1000000)
    }


}
