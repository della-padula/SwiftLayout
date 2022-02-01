//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

protocol SuperSubLayoutable: AnyObject {
    var deactivatable: AnyDeactivatable? { get set }
}

public final class SuperSubLayout<Superview, Sub>: LayoutAttachable, LayoutContainable, UIViewContainable, SuperSubLayoutable where Superview: UIView, Sub: LayoutAttachable {
    
    weak var deactivatable: AnyDeactivatable?
    
    internal init(superview: Superview, subLayout: Sub) {
        self.view = superview
        self.subLayout = subLayout
    }
    
    public let view: Superview
    let subLayout: Sub
    
    public var layouts: [LayoutAttachable] { [subLayout] }

}

extension SuperSubLayout: CustomDebugStringConvertible {
    public var debugDescription: String {
        "SuperSubLayout<\(view.tagDescription), \(subLayout.tagDescription)>"
    }
}
