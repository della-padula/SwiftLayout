//
//  AnchorsContainer.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public final class AnchorsContainer {
    
    public private(set) var constraints: [AnchorsConstraintProperty] = []
    
    init(_ constraints: [AnchorsConstraintProperty] = []) {
        self.constraints = constraints
    }
    
    init<A>(_ expression: AnchorsExpression<A>) where A: AnchorsAttribute {
        self.constraints = expression.constraintProperties
    }
    
    func append(_ container: AnchorsContainer) {
        self.constraints.append(contentsOf: container.constraints)
    }
    
    func append<A>(_ expression: AnchorsExpression<A>) where A: AnchorsAttribute {
        self.constraints.append(contentsOf: expression.constraintProperties)
    }
    
    func constraints(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView] = [:]) -> [NSLayoutConstraint] {
        constraints.map {
            $0.nsLayoutConstraint(item: fromItem, toItem: toItem, viewDic: viewDic)
        }
    }
    
    public func multiplier(_ multiplier: CGFloat) -> Self {
        for i in 0..<constraints.count {
            constraints[i].multiplier = multiplier
        }
        return self
    }
    
    public func priority(_ priority: UILayoutPriority) -> Self {
        for i in 0..<constraints.count {
            constraints[i].priority = priority
        }
        return self
    }
}
