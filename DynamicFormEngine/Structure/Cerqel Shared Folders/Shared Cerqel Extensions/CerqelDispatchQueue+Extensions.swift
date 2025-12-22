//
//  DispatchQueue+Extensions.swift
//  CERQEL
//
//  Created by Marwan on 14/12/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation

extension DispatchQueue {

    public func cerqel_asyncDeduped(target: AnyObject, after delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        let dedupeIdentifier = DispatchQueue.cerqel_dedupeIdentifierFor(target)
        if let existingWorkItem = DispatchQueue.cerqel_workItems.removeValue(forKey: dedupeIdentifier) {
            existingWorkItem.cancel()
        }
        let workItem = DispatchWorkItem {
            DispatchQueue.cerqel_workItems.removeValue(forKey: dedupeIdentifier)

            for ptr in DispatchQueue.cerqel_weakTargets.allObjects {
                if dedupeIdentifier == DispatchQueue.cerqel_dedupeIdentifierFor(ptr as AnyObject) {
                    work()
                    break
                }
            }
        }

        DispatchQueue.cerqel_workItems[dedupeIdentifier] = workItem
        DispatchQueue.cerqel_weakTargets.addPointer(Unmanaged.passUnretained(target).toOpaque())

        asyncAfter(deadline: .now() + delay, execute: workItem)
    }

}

// MARK: - Static Properties for De-Duping
private extension DispatchQueue {

    static var cerqel_workItems = [AnyHashable : DispatchWorkItem]()

    static var cerqel_weakTargets = NSPointerArray.weakObjects()

    static func cerqel_dedupeIdentifierFor(_ object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())." + String(describing: object)
    }

}
