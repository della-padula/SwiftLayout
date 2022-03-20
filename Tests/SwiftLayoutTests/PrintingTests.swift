import XCTest
import SwiftLayout

class PrintingTests: XCTestCase {
    
    var window: UIView!
    
    var activation: Activation? 
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
    }

    override func tearDownWithError() throws {
        activation = nil
    }
}

extension PrintingTests {
    func testPrintWithViewsSimple() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
        activation = root {
            child
        }.active()
        
        let expect = """
        root {
            child
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoViews() throws {
        let root = UIView().viewTag.root
        let a = UIView().viewTag.a
        let b = UIView().viewTag.b
        
        activation = root {
            a
            b
        }.active()
        
        let expect = """
        root {
            a
            b
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoDepthOfViews() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let grandchild = UIView().viewTag.grandchild
        
        activation = root {
            child {
                grandchild
            }
        }.active()
        
        let expect = """
        root {
            child {
                grandchild
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithMultipleDepthOfViews() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        let grandchild = UIView().viewTag.grandchild
        
        activation = root {
            child {
                grandchild
            }
            friend
        }.active()
        
        let expect = """
        root {
            child {
                grandchild
            }
            friend
        }
        """.tabbed
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithSimpleAnchors() {
        let root = UIView().viewTag.root
        activation = root.anchors {
            Anchors(.width, .height)
        }.active()
        
        let expect = """
        root.anchors {
            Anchors(.width, .height)
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsWithOneDepth() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        activation = root {
            child.anchors {
                Anchors(.top)
                Anchors(.bottom).equalTo(constant: -10.0)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.bottom).equalTo(constant: -10.0)
                Anchors(.top)
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsOfTwoViewWithOneDepth() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        activation = root {
            child.anchors {
                Anchors(.top)
                Anchors(.bottom).equalTo(constant: -10.0)
            }
            friend.anchors {
                Anchors(.top).equalTo(child, attribute: .bottom)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.bottom).equalTo(constant: -10.0)
                Anchors(.top)
            }
            friend.anchors {
                Anchors(.top).equalTo(child, attribute: .bottom)
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }

    func testPrintWithAnonymousTaggedView() {
        let root = UIView().viewTag.root
        activation = root {
            UILabel().viewTag.label.anchors {
                Anchors.allSides()
            }
        }.active()
        
        let expect = """
        root {
            label.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwwDepthsWithSublayout() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let grandchild = UIView().viewTag.grandchild
        
        activation = root {
            child.anchors{
                Anchors.allSides()
            }.sublayout {
                grandchild.anchors {
                    Anchors.allSides()
                }
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                grandchild.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithInstantTags() {
        let root = UIView().viewTag.root
        let child = UILabel()
        let grand = UILabel().viewTag.grand
        
        activation = root {
            child {
                grand.anchors {
                    Anchors(.top)
                }
            }
        }.active()
        
        let expect = """
        root {
            child {
                grandchild.anchors {
                    Anchors(.top)
                }
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root, tags: [child: "child", grand: "grandchild"]).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithSafeAreaLayoutGuide() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        activation = root {
            child.anchors {
                Anchors(.top, .bottom).equalTo(root.safeAreaLayoutGuide)
                Anchors(.leading)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.leading)
                Anchors(.top, .bottom).equalTo(root.safeAreaLayoutGuide)
            }
        }
        """.tabbed
       
        let result = SwiftLayoutPrinter(root).print()
        
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithFindingViewIdentifiers() {
        let cell = Cell()
        let expect = """
        contentView {
            profileView:\(UIImageView.self)
            nameLabel:\(UILabel.self)
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(cell, tags: [cell: "contentView"]).print(.withTypeOfView)
        XCTAssertEqual(result, expect)
    }
    
    func testPrintMoreEfficiently() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        
        activation = root {
            child.anchors {
                Anchors.cap()
            }
            friend.anchors {
                Anchors(.leading, .bottom)
                Anchors(.top).greaterThanOrEqualTo(child, attribute: .bottom, constant: 8)
                Anchors(.trailing).equalTo(child)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .leading, .trailing)
            }
            friend.anchors {
                Anchors(.bottom, .leading)
                Anchors(.top).greaterThanOrEqualTo(child, attribute: .bottom, constant: 8.0)
                Anchors(.trailing).equalTo(child)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testGreaterThanAndLessThan() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        activation = root {
            child.anchors {
                Anchors(.top).greaterThanOrEqualTo()
                Anchors(.bottom).lessThanOrEqualTo()
                Anchors(.height).equalTo(constant: 12.0)
            }
            friend.anchors {
                Anchors(.height).equalTo(child)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.bottom).lessThanOrEqualTo()
                Anchors(.height).equalTo(constant: 12.0)
                Anchors(.top).greaterThanOrEqualTo()
            }
            friend.anchors {
                Anchors(.height).equalTo(child)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
}

// MARK: - automatic identifier assignment
extension PrintingTests {
    
    func testautomaticIdentifierAssignmentOption() {
        let cell = Cell().updateIdentifiers()
        
        XCTAssertEqual(cell.profileView.accessibilityIdentifier, "profileView")
        XCTAssertEqual(cell.nameLabel.accessibilityIdentifier, "nameLabel")
    }
    
    class Cell: UIView, Layoutable {
        
        var profileView: UIImageView = .init(image: .init())
        var nameLabel: UILabel = .init()
        
        var activation: Activation?
        
        var layout: some Layout {
            self {
                profileView
                nameLabel
            }
        }
        
        init() {
            super.init(frame: .zero)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            sl.updateLayout()
        }
    }
}

// MARK: - identifier assignment deeply
extension PrintingTests {
    
    class One: UIView {}
    class Two: One {}
    class Three: Two {}
   
    func testDeepAssignIdentifier() {
        let gont = Gont()
        
        XCTAssertEqual(SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView),
        """
        gont {
            sea:\(UILabel.self).anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                duny:Duny.anchors {
                    Anchors(.centerX).setMultiplier(1.2000000476837158)
                    Anchors(.centerY).setMultiplier(0.800000011920929)
                }.sublayout {
                    duny.nickname:\(UILabel.self).anchors {
                        Anchors(.top, .leading, .trailing)
                    }.sublayout {
                        sparrowhawk.anchors {
                            Anchors(.top, .bottom, .leading, .trailing)
                        }
                    }
                    duny.truename:\(UILabel.self).anchors {
                        Anchors(.bottom, .leading, .trailing)
                        Anchors(.top).equalTo(duny.nickname:\(UILabel.self), attribute: .bottom)
                    }.sublayout {
                        ged.anchors {
                            Anchors(.top, .bottom, .leading, .trailing)
                        }
                    }
                }
            }
        }
        """.tabbed)
    }
    
    class Earth: UIView {
        let sea = UILabel()
    }
    
    class Gont: Earth, Layoutable {
        lazy var duny = Duny(in: self)
        
        var activation: Activation?
        var layout: some Layout {
            self {
                sea.anchors({
                    Anchors.allSides()
                }).sublayout {
                    duny.anchors {
                        Anchors(.centerX).setMultiplier(1.2)
                        Anchors(.centerY).setMultiplier(0.8)
                    }
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class Wizard: UIView {
        let truename = UILabel()
    }
    
    class Duny: Wizard, Layoutable {
        
        init(in earth: Earth) {
            super.init(frame: .zero)
            self.earth = earth
            sl.updateLayout()
        }
        
        weak var earth: Earth?
        let nickname = UILabel()
        
        var activation: Activation? 
        var layout: some Layout {
            self {
                nickname.anchors({
                    Anchors.cap()
                }).sublayout {
                    UIView().viewTag.sparrowhawk.anchors {
                        Anchors.allSides()
                    }
                }
                truename.anchors({
                    Anchors(.top).equalTo(nickname.bottomAnchor)
                    Anchors.shoe()
                }).sublayout {
                    UIView().viewTag.ged.anchors {
                        Anchors.allSides()
                    }
                }
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            sl.updateLayout()
        }
    }
    
}

// MARK: - print system constraint
extension PrintingTests {
    
    func testSystemConstraint() {
        
        let root = UIView().viewTag.root
        let label = UILabel().viewTag.label
        label.font = .systemFont(ofSize: 12)
        label.text = "HELLO"
        @LayoutBuilder
        func layout() -> some Layout {
            root {
                label.anchors {
                    Anchors.allSides()
                }
            }
        }
        
        layout().finalActive()
        XCTAssertEqual(SwiftLayoutPrinter(root).print(options: .onlyIdentifier), """
        root {
            label.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }
        }
        """.tabbed)
    }
    
}

// MARK: - options for IdentifierUpdater
extension PrintingTests {
    func testNameOnly() {
        let id = ID()
        IdentifierUpdater.nameOnly.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier ?? "", "")
    }
    
    func testWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.withTypeOfView.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier ?? "", "")
    }
    
    func testReferenceAndName() {
        let id = ID()
        IdentifierUpdater.referenceAndName.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "name.label")
    }
    
    func testReferenceAndNameWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.referenceAndNameWithTypeOfView.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "name.label:\(UILabel.self)")
    }

    class Name: UIView {
        let label = UILabel()
    }
    
    class ID: UIView {
        let name = Name()
    }
}

// MARK: - performance
extension PrintingTests {
    func testSwiftLayoutPrinterPerformance() {
        measure {
            let gont = Gont()
            _ = SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView)
        }
    }
}
