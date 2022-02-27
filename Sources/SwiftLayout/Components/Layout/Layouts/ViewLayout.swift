import Foundation
import UIKit

public final class ViewLayout<V: UIView, SubLayout: Layout>: Layout {
    
    let view: V
    
    var sublayout: SubLayout
    
    var identifier: String? {
        get { view.accessibilityIdentifier }
        set { view.accessibilityIdentifier = newValue }
    }
    
    init(_ view: V, sublayout: SubLayout) {
        self.view = view
        self.sublayout = sublayout
    }
        
    @available(*, deprecated, message: "do nothing")
    public func animationDisable() -> Self {
        return self
    }
    
    public var debugDescription: String {
        view.tagDescription + ": [\(sublayout.debugDescription)]"
    }
    
    public func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> some Layout {
        AnchorsLayout(layout: self, anchors: build())
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout<V, TupleLayout<(SubLayout, L)>>(view, sublayout: TupleLayout((self.sublayout, build())))
    }
    
    public func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        sublayout(build)
    }
}

public extension ViewLayout {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        handler(.init(superview: superview, view: view))
        guard continueAfterViewLayout else { return }
        sublayout.traverse(view, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        if sublayout is EmptyLayout {
            handler(superview, view, [], viewInfoSet)
        } else {
            sublayout.traverse(view, viewInfoSet: viewInfoSet, constraintHndler: handler)
        }
    }
}
