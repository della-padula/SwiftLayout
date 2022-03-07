# ``SwiftLayout``

DSL library for unite UIView and AutoLayout constraints

![logo](swiftlayout-logo.png)

## overview

SwiftLayout provides methods of handle UIView hierarchy and autolayout constraint in consistency DSL syntax.

```swift
superview {
    subview.anchors {
        Anchors(.top, .bottom, .leading, .trailing) // .equalTo(superview)
    }
}

// instead of

superview.addSubview(subview)
NSLayoutConstraint.activate([
    subview.topAnchor.constraint(equalTo: superview.topAnchor),
    subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
    subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
])
```

## Topics

### Essentials

- <doc:GettingStarted>
<!--- <doc:tutorial-table>-->

### Layout Elements

- ``Layout``
- ``Anchors``
- ``Activation``

### Builder

- ``LayoutBuilder``
- ``AnchorsBuilder``

### Convenient way to apply Layout

- ``Layoutable``
- ``LayoutProperty``
- ``LayoutableViewRepresentable``
- ``LayoutableViewControllerRepresentable``

### Conversion from native way

- ``SwiftLayoutPrinter``
- ``IdentifierUpdater``
