//: [Previous](@previous)

import UIKit
import PlaygroundSupport


/************************************
 Emitter CELL Attributes - END
 ************************************/



// MARK: - UIEmitterPreviewView


/************************************
 Emitter CELL Attributes - START
 ************************************/


/************************************
 Emitter CELL Attributes - END
 ************************************/

/************************************
 Emitter CELL Attributes - START
 ************************************/












class ViewController: UIViewController {
    private var emitterPreview = UIEmitterPreviewView()
    private var emitterTableView = UIEmitterAttributesFoldableTableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    private var emitterCellTableView = UIEmitterCellAttributesFoldableTableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    private var emitterCellOverview = UIEmitterCellsOverviewTableView()
    
    var menuButton = MenuButton(frame: CGRect.zero)
    
    var expandingMenuButton1 = UIButton()
    var expandingMenuButton2 = UIButton()
    var expandingMenuButton3 = UIButton()
    
    var viewMode = ViewMode.emitterAttributeEditor
    
    enum ViewMode {
        case emitterAttributeEditor
        case emitterCellAttributeEditor
        case emitterCellOverview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create Emitter Animation"
        
        emitterPreview.setup()
        
        registerCells()
        
        emitterTableView.emitter = emitterPreview.emitter
        emitterTableView.foldableDelegate = self
        
        emitterCellTableView.emitter = emitterPreview.emitter
        emitterCellTableView.foldableDelegate = self
        
        emitterCellOverview.emitter = emitterPreview.emitter
        emitterCellOverview.overviewDelegate = self
        
        createAndAssignEmitterTableViewData()
        createAndAssignEmitterCellTableViewData()
        
        view.backgroundColor = UIColor.lightGray
        
        setup()
        setupConstraints()
    }
    
    func setup() {
        view.backgroundColor = UIColor.white
        emitterPreview.backgroundColor = UIColor.lightGray
        
        view.addSubview(emitterPreview)
        view.addSubview(emitterTableView)
        view.addSubview(emitterCellTableView)
        view.addSubview(emitterCellOverview)
        
        emitterCellTableView.isHidden = true
        emitterCellOverview.isHidden = true
        
        // Expandable Menu
        expandingMenuButton1.setImage(UIImage(named: "icon_edit_white.png"), for: .normal)
        expandingMenuButton2.setImage(UIImage(named: "icon_particle_white.png"), for: .normal)
        expandingMenuButton3.setImage(UIImage(named: "icon_swift_white.png"), for: .normal)
        
        expandingMenuButton1.addTarget(self, action: #selector(editEmitterLayerAction(_:)), for: .touchUpInside)
        expandingMenuButton2.addTarget(self, action: #selector(editEmitterCellAction(_:)), for: .touchUpInside)
        expandingMenuButton3.addTarget(self, action: #selector(showEmitterInDevMode(_:)), for: .touchUpInside)
        
        menuButton.append(expandingView: expandingMenuButton1)
        menuButton.append(expandingView: expandingMenuButton2)
        menuButton.append(expandingView: expandingMenuButton3)
        
        let menuButtonHeight: CGFloat = 50.0
        menuButton.frame = CGRect(x: 0, y: 0,
                                  width: menuButtonHeight, height: menuButtonHeight)
        menuButton.center = CGPoint(x: self.view.frame.width/2/2,
                                    y: 630)
        menuButton.addTarget(self, action: #selector(toggleButtonMenu(_:)), for: .touchUpInside)
        menuButton.titleLabel?.adjustsFontSizeToFitWidth = true
        menuButton.titleLabel?.font = UIFont(name: "Helvetica", size: 31.0)
        menuButton.setTitle("+", for: .normal)
        menuButton.backgroundColor = UIColor.black
        menuButton.layer.cornerRadius = menuButton.frame.width/2
        self.view.addSubview(menuButton)
    }
    
    func setupConstraints() {
        // Preview View Constraints
        let navigationBarHeight: CGFloat = 44.0
        let constraintBuilder = ConstraintBuilder(subview: emitterPreview, superview: self.view)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left)
            .constraint(subviewAttribute: .top, superviewAttribute: .top, constant: navigationBarHeight)
            .constraint(subviewAttribute: .right, superviewAttribute: .right)
            .constraint(subviewAttribute: .left, superviewAttribute: .left)
            .constraint(subviewAttribute: .height, superviewAttribute: .height, multiplier: 1.0/3.0)
            .buildAndApplyConstrains()
        
        setConstraints(forTableView: emitterTableView)
        setConstraints(forTableView: emitterCellTableView)
        setConstraints(forTableView: emitterCellOverview)
        
    }
    
    private func setConstraints(forTableView tableView: UITableView) {
        let constraintBuilder = ConstraintBuilder(subview: tableView, superview: self.view)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left)
            .constraint(subviewAttribute: .top, anotherView: emitterPreview, anotherAttribute: .bottom)
            .constraint(subviewAttribute: .right, superviewAttribute: .right)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom)
            .buildAndApplyConstrains()
    }
    
    func registerCells() {
        emitterTableView.register(UIEmitterAttributeTableViewSliderCell.self,
                                  forCellReuseIdentifier: "slider_cell")
        emitterTableView.register(UIEmitterAttributeTableViewTwofoldValueCell.self,
                                  forCellReuseIdentifier: "twoFoldValue_cell")
        emitterTableView.register(UITableViewCell.self,
                                  forCellReuseIdentifier: "basic_apple_cell")
        emitterTableView.register(UIEmitterAttributeTableViewBasicCell.self,
                                  forCellReuseIdentifier: "basic_cell")
        
        emitterCellTableView.register(UIEmitterAttributeTableViewSliderCell.self,
                                      forCellReuseIdentifier: "slider_cell")
        emitterCellTableView.register(UIEmitterAttributeTableViewTwofoldValueCell.self,
                                      forCellReuseIdentifier: "twoFoldValue_cell")
        emitterCellTableView.register(UITableViewCell.self,
                                      forCellReuseIdentifier: "basic_apple_cell")
        emitterCellTableView.register(UIEmitterAttributeTableViewBasicCell.self,
                                      forCellReuseIdentifier: "basic_cell")
        
        emitterCellOverview.register(UITableViewCell.self,
                                     forCellReuseIdentifier: "basic_apple_cell")
    }
    
}

/************************************
    Actions
 ************************************/
extension ViewController {
    @objc func toggleButtonMenu(_ sender: MenuButton? = nil) {
        menuButton.toggle(onView: view)
    }
    
    @objc func editEmitterLayerAction(_ sender: UIButton) {
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            if viewMode != .emitterAttributeEditor {
                viewMode = .emitterAttributeEditor
                flip()
            }
        }
    }
    
    
    @objc func editEmitterCellAction(_ sender: UIButton) {
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            if viewMode != .emitterCellOverview {
                viewMode = .emitterCellOverview
                flip()
            }
        }
    }
    
    @objc func showEmitterInDevMode(_ sender: UIButton) {
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            let devOverview = EmitterDeveloperCodeViewController()
            devOverview.emitter = self.emitterPreview.emitter
            navigationController?.pushViewController(devOverview, animated: true)
        }
    }
}


/************************************
    Flip Animations
 ************************************/
extension ViewController {
    func flip() {
        var transitionOptions: UIViewAnimationOptions = []
        switch viewMode {
        case .emitterAttributeEditor:
            transitionOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        case .emitterCellAttributeEditor: fallthrough
        case .emitterCellOverview:
            transitionOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        }
        
        UIView.transition(with: emitterTableView, duration: 1.0,
                          options: transitionOptions,
                          animations: {
                            self.setUpVisiablityAfterFlip()
        })
        UIView.transition(with: emitterCellTableView, duration: 1.0,
                          options: transitionOptions,
                          animations: {
                            self.setUpVisiablityAfterFlip()
        })
        UIView.transition(with: emitterCellOverview, duration: 1.0,
                          options: transitionOptions,
                          animations: {
                            self.setUpVisiablityAfterFlip()
        })
    }
    
    private func setUpVisiablityAfterFlip() {
        switch viewMode {
        case .emitterAttributeEditor:
            emitterTableView.isHidden = false
            emitterCellTableView.isHidden = true
            emitterCellOverview.isHidden = true
        case .emitterCellAttributeEditor:
            emitterTableView.isHidden = true
            emitterCellTableView.isHidden = false
            emitterCellOverview.isHidden = true
        case .emitterCellOverview:
            emitterTableView.isHidden = true
            emitterCellTableView.isHidden = true
            emitterCellOverview.isHidden = false
        }
    }
}


/************************************
    Create Emitter TV Data
 ************************************/
extension ViewController {
    func createAndAssignEmitterTableViewData() {
        let sections: [String] = ["Emitter Geometry", "Emitter Cell Attribute Multipliers"]
        let attributes: [[Attribute]] = [createEmitterLayerGeometryAttributes(),
                                         createEmitterLayerCellAttributes()]
        
        var result: [[FoldableData]] = []
        
        for attributeArrray in attributes {
            var data: [FoldableData] = []
            for attribute in attributeArrray {
                let foldableData: FoldableData!
                if let attributeSelection = attribute as? AttributeSelection {
                    foldableData = FoldableData(data: attributeSelection, foldableItems: attributeSelection.selections)
                    data.append(foldableData)
                } else if let attributeValueRange = attribute as? AttributeValueRange {
                    foldableData = FoldableData(data: attributeValueRange)
                    data.append(foldableData)
                } else if let attributeTwoValueRange = attribute as? AttributeTwoValueRange {
                    foldableData = FoldableData(data: attributeTwoValueRange)
                    data.append(foldableData)
                }
            }
            result.append(data)
        }
        
        emitterTableView.sections = sections
        emitterTableView.elements = result
    }
    
    func createAndAssignEmitterCellTableViewData() {
        let sections: [String] = ["Prociding Emitter Cell Content",
                                  "Setting Emitter Cell Visual Attributes",
                                  "Emitter Cell Motion Attributes",
                                  "Emission Cell Temporal Attributes"]
        let attributes: [[Attribute]] = [createEmitterCellContentAttributes(),
                                         createEmitterCellVisualAttributes(),
                                         createEmitterCellMotionAttributes(),
                                         createEmitterCellTemporalAttributes()]
        
        var result: [[FoldableData]] = []
        
        for attributeArrray in attributes {
            var data: [FoldableData] = []
            for attribute in attributeArrray {
                let foldableData: FoldableData!
                if let attributeSelection = attribute as? AttributeSelection {
                    foldableData = FoldableData(data: attributeSelection, foldableItems: attributeSelection.selections)
                    data.append(foldableData)
                } else if let attributeValueRange = attribute as? AttributeValueRange {
                    foldableData = FoldableData(data: attributeValueRange)
                    data.append(foldableData)
                } else if let attributeTwoValueRange = attribute as? AttributeTwoValueRange {
                    foldableData = FoldableData(data: attributeTwoValueRange)
                    data.append(foldableData)
                }
            }
            result.append(data)
        }
        
        emitterCellTableView.sections = sections
        emitterCellTableView.elements = result
    }
}


/************************************
    Extension - UIEmitterCellsOverviewDelegate
 ************************************/
extension ViewController: UIEmitterCellsOverviewDelegate {
    func editEmitterCell(atIndexPath indexPath: IndexPath) {
        viewMode = .emitterCellAttributeEditor
        emitterCellTableView.indexPathToEdit = indexPath
        flip()
    }
}


/************************************
    Extension - UIFoldableTableViewDelegate
 ************************************/
extension ViewController: UIFoldableTableViewDelegate {
    func foldableTableView(didSelectUnfoldedRowAt indexPath: IndexPath) {
        switch viewMode {
        case .emitterAttributeEditor:
            let attributeName = emitterTableView.getUnfoldedElement(atIndexPath: indexPath)
            let element = emitterTableView.getElement(atIndexPath: indexPath)
            
            emitterTableView.fold(atIndexPath: indexPath)
            
            let attribute = element.data
            switch attribute.type {
            case EmitterLayerGeometryAttribute.renderMode:
                emitterPreview.emitter.renderMode = attributeName
            case EmitterLayerGeometryAttribute.emitterShape:
                emitterPreview.emitter.emitterShape = attributeName
            case EmitterLayerCellAttribute.emitterMode:
                emitterPreview.emitter.emitterMode = attributeName
            default: break
            }
            
            if let parentIndex = emitterTableView.getParentIndexPath(ofData: attributeName) {
                emitterTableView.reloadRows(at: [parentIndex], with: .none)
            } else {
                emitterTableView.reloadData()
            }
        case .emitterCellAttributeEditor:
            let attributeName = emitterCellTableView.getUnfoldedElement(atIndexPath: indexPath)
            let element = emitterCellTableView.getElement(atIndexPath: indexPath)
            
            emitterCellTableView.fold(atIndexPath: indexPath)
            
            if let emitterCell = emitterCellTableView.emitterCell {
                let attribute = element.data
                switch attribute.type {
                case EmitterCellVisualAttribute.magnificationFilter:
                    emitterCell.magnificationFilter = attributeName
                case EmitterCellVisualAttribute.minificationFilter:
                    emitterCell.minificationFilter = attributeName
                default: break
                }
            }
            
            if let parentIndex = emitterCellTableView.getParentIndexPath(ofData: attributeName) {
                emitterCellTableView.reloadRows(at: [parentIndex], with: .none)
            } else {
                emitterCellTableView.reloadData()
            }
        case .emitterCellOverview:
            break
        }
    }
}




let vCtrl = ViewController()
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl






