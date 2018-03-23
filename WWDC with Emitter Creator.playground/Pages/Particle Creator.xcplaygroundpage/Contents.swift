//: [Previous](@previous)

import UIKit
import PlaygroundSupport


public class FoldableData<T, U> {
    public var data: T
    public var foldableItems: [U]
    public var isUnfolded: Bool = false
    
    public init(data: T, foldableItems: [U] = []) {
        self.data = data
        self.foldableItems = foldableItems
    }
    
    public func isFoldable() -> Bool {
        return !foldableItems.isEmpty
    }
    
    public func numberOfFoldableElements() -> Int {
        return foldableItems.count
    }
}



public protocol UIFoldableTableViewDelegate: class {
    func foldableTableView(didSelectUnfoldedRowAt indexPath: IndexPath)
}

open class UIFoldableTableView<T, U>: UITableView, UITableViewDataSource, UITableViewDelegate {
    public var sections: [String] = []
    public var elements: [[FoldableData<T, U>]] = []
    private var selectedIndexPath: IndexPath?
    private var unfoldedIndexPaths: [IndexPath] = []
    
    public var foldableDelegate: UIFoldableTableViewDelegate?
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setup() {
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        dataSource = self
        delegate = self
    }
    
    // MARK - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isUnfoldedCell(atIndexPath: indexPath) {
            foldableDelegate?.foldableTableView(didSelectUnfoldedRowAt: indexPath)
        } else {
            let selectedFoldedElement = getElement(atIndexPath: indexPath)
            if selectedFoldedElement.isFoldable() {
                let foldBeforeUnfold = selectedIndexPath != indexPath && selectedIndexPath != nil
                let oldSelectedIndexPath = selectedIndexPath
                selectedIndexPath = indexPath
                
                if selectedFoldedElement.isUnfolded {
                    selectedFoldedElement.isUnfolded = false
                    fold()
                } else {
                    var indexPath: IndexPath = indexPath
                    if foldBeforeUnfold {
                        if let oldSelectedIndexPath = oldSelectedIndexPath {
                            if oldSelectedIndexPath.section == indexPath.section && oldSelectedIndexPath.row < indexPath.row {
                                indexPath = IndexPath(row: indexPath.row - unfoldedIndexPaths.count,
                                                      section: oldSelectedIndexPath.section)
                            }
                            let oldSelectedElement = getElement(atIndexPath: oldSelectedIndexPath)
                            oldSelectedElement.isUnfolded = false
                            fold()
                        }
                    }
                    selectedFoldedElement.isUnfolded = true
                    unfold(atIndexPath: indexPath)
                }
            } else {
                if let oldSelectedIndexPath = selectedIndexPath {
                    let oldSelectedElement = getElement(atIndexPath: oldSelectedIndexPath)
                    oldSelectedElement.isUnfolded = false
                    fold()
                }
            }
        }
    }
    
    // MARK: - Fold
    private func fold() {
        let indexPathsToDelete = unfoldedIndexPaths
        unfoldedIndexPaths = []
        self.deleteRows(at: indexPathsToDelete, with: .right)
        selectedIndexPath = nil
    }
    
    public func fold(atIndexPath indexPath: IndexPath) {
        let element = getElement(atIndexPath: indexPath)
        element.isUnfolded = false
        fold()
    }
    
    
    // MARK: - Unfold
    private func unfold(atIndexPath indexPath: IndexPath) {
        unfoldedIndexPaths = []
        selectedIndexPath = indexPath
        
        createUnfoldIndexPaths(ofSelectedIndexPath: indexPath)
        self.insertRows(at: unfoldedIndexPaths, with: .left)
    }
    
    private func createUnfoldIndexPaths(ofSelectedIndexPath indexPath: IndexPath) {
        let selectedElement = getElement(atIndexPath: indexPath)
        let numberOfUnfoldingSections = selectedElement.foldableItems.count
        if numberOfUnfoldingSections > 0 {
            for index in 1...numberOfUnfoldingSections {
                let unfoldingIndexPath = IndexPath(row: indexPath.row + index, section: indexPath.section)
                unfoldedIndexPaths.append(unfoldingIndexPath)
            }
        }
    }
    
    
    // MARK: - Hilfsmethoden
    public func isUnfoldedCell(atIndexPath indexPath: IndexPath) -> Bool {
        return unfoldedIndexPaths.contains(indexPath)
    }
    
    public func getUnfoldedElement(atIndexPath indexPath: IndexPath) -> U {
        let element = getElement(atIndexPath: indexPath)
        var adjustedIndex = indexPath.row
        if let firstUnfoldedIndexPath = unfoldedIndexPaths.first {
            if firstUnfoldedIndexPath.row <= indexPath.row {
                adjustedIndex -= firstUnfoldedIndexPath.row
            }
        }
        return element.foldableItems[adjustedIndex]
    }
    
    public func getElement(atIndexPath indexPath: IndexPath) -> FoldableData<T, U> {
        let section = indexPath.section
        var row = indexPath.row
        
        if !isUnfoldedCell(atIndexPath: indexPath) {
            if indexPath.row > elements[section].count {
                row = indexPath.row - unfoldedIndexPaths.count
            } else if indexPath.row == elements[section].count {
                row = indexPath.row - 1
            }
            return elements[section][row]
        } else {
            if let selectedIndexPath = selectedIndexPath {
                row = selectedIndexPath.row
                return elements[section][row]
            }
        }
        
        return elements[section][0]
    }
    
    
    // MARK - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = elements[section].count
        for foldableData in elements[section] {
            if foldableData.isUnfolded {
                rows += foldableData.numberOfFoldableElements()
            }
        }
        return rows
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isUnfoldedCell(atIndexPath: indexPath) {
            let unfoldedElement = getUnfoldedElement(atIndexPath: indexPath)
            cell.textLabel?.text = " • \(unfoldedElement)"
            return cell
        }
        
        let foldableData = getElement(atIndexPath: indexPath)
        cell.textLabel?.text = "\(foldableData.data)"
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
}

extension UIFoldableTableView where T: Equatable {
    public func getIndexPath(ofData data: T) -> IndexPath? {
        var sectionResult = 0
        var rowResult = 0
        for section in elements {
            rowResult = 0
            for foldableData in section {
                if foldableData.data == data {
                    let foundIndexPath = IndexPath(row: rowResult, section: sectionResult)
                    return foundIndexPath
                }
                rowResult += 1
            }
            sectionResult += 1
        }
        return nil
    }
}

extension UIFoldableTableView where U: Equatable {
    public func getParentIndexPath(ofData data: U) -> IndexPath? {
        var sectionResult = 0
        var rowResult = 0
        for section in elements {
            rowResult = 0
            for foldableData in section {
                for item in foldableData.foldableItems {
                    if item == data {
                        let foundIndexPath = IndexPath(row: rowResult, section: sectionResult)
                        return foundIndexPath
                    }
                }
                rowResult += 1
            }
            sectionResult += 1
        }
        return nil
    }
}













public class UIEmitterAttributeTableViewCell: UITableViewCell {
    public var attributeTitleLabel = UILabel()
    public var attribute: Attribute!
    
    let borderSpace: CGFloat = 8.0
    
    public weak var delegate: UIEmitterAttributeTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        self.addSubview(attributeTitleLabel)
    }
    
    func setupConstraints() {
        // Attribute Title Label Constraints
        let constraintBuilder = ConstraintBuilder(subview: attributeTitleLabel, superview: self)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: borderSpace)
            .constraint(subviewAttribute: .left, superviewAttribute: .left, constant: borderSpace)
            .constraint(subviewAttribute: .top, superviewAttribute: .top, constant: borderSpace)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -borderSpace)
            .buildAndApplyConstrains()
    }
    
    func displayAttribute() {
        attributeTitleLabel.text = attribute.title
    }
}

public class UIEmitterAttributeTableViewBasicCell: UIEmitterAttributeTableViewCell {
    public var descriptionLabel = UILabel()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func setup() {
        super.setup()
        self.addSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        // Selected Attribute Label Constraints
        let constraintBuilder = ConstraintBuilder(subview: descriptionLabel, superview: self)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: borderSpace)
            .constraint(subviewAttribute: .top, anotherView: attributeTitleLabel, anotherAttribute: .bottom, constant: borderSpace)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -borderSpace)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .buildAndApplyConstrains()
    }
}


public class UIEmitterAttributeTableViewSliderCell: UIEmitterAttributeTableViewCell {
    public var attribetuSlider = UISlider()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setup() {
        super.setup()
        self.addSubview(attribetuSlider)
        attribetuSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        // Attribute Slider Constraints
        attribetuSlider.translatesAutoresizingMaskIntoConstraints = false
        let constraintBuilder = ConstraintBuilder(subview: attribetuSlider, superview: self)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: borderSpace)
            .constraint(subviewAttribute: .top, anotherView: attributeTitleLabel, anotherAttribute: .bottom, constant: borderSpace)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -borderSpace)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .buildAndApplyConstrains()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        delegate?.valueChanged(newValue: sender.value, onAttribute: attribute)
        displaySelectedValue()
    }
    
    public func displaySelectedValue() {
        super.displayAttribute()
        let selectedNumber = attribetuSlider.value
        let selectedFormattedNumber = String(format: "%.2f", arguments: [selectedNumber])
        attributeTitleLabel.text?.append(" \(selectedFormattedNumber)")
    }
    
    public func initializeCell(withAttribute attribute: AttributeValueRange) {
        self.attribute = attribute
        attribetuSlider.minimumValue = attribute.min
        attribetuSlider.maximumValue = attribute.max
    }
}


public class UIEmitterAttributeTableViewTwofoldValueCell: UIEmitterAttributeTableViewCell, UITextFieldDelegate {
    private var containerStackView = UIStackView()
    public var inputSlider1 = UISlider()
    public var inputSlider2 = UISlider()
    var inputTextLabel1 = UILabel()
    var inputTextLabel2 = UILabel()
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func setup() {
        super.setup()
        
        inputSlider1.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        inputSlider2.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        inputTextLabel1.textAlignment = .center
        inputTextLabel2.textAlignment = .center
        
        containerStackView.axis = .horizontal
        containerStackView.spacing = borderSpace
        containerStackView.distribution = .fillEqually
        
        let leftContainer = UIStackView()
        leftContainer.axis = .vertical
        leftContainer.spacing = borderSpace
        leftContainer.distribution = .fillEqually
        leftContainer.addArrangedSubview(inputTextLabel1)
        leftContainer.addArrangedSubview(inputSlider1)
        
        let rightContainer = UIStackView()
        rightContainer.axis = .vertical
        rightContainer.spacing = borderSpace
        rightContainer.distribution = .fillEqually
        rightContainer.addArrangedSubview(inputTextLabel2)
        rightContainer.addArrangedSubview(inputSlider2)
        
        containerStackView.addArrangedSubview(leftContainer)
        containerStackView.addArrangedSubview(rightContainer)
        self.addSubview(containerStackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        // Attribute Slider Constraints
        let constraintBuilder = ConstraintBuilder(subview: containerStackView, superview: self)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: borderSpace)
            .constraint(subviewAttribute: .top, anotherView: attributeTitleLabel, anotherAttribute: .bottom, constant: borderSpace)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -borderSpace)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .buildAndApplyConstrains()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        delegate?.twoFoldedValueChanged(newValue1: inputSlider1.value, newValue2: inputSlider2.value,
                                        onAttribute: attribute)
        displaySelectedValue()
    }
    
    public func displaySelectedValue() {
        let selectedNumber1 = inputSlider1.value
        let selectedNumber2 = inputSlider2.value
        let selectedFormattedNumber1 = String(format: "%.2f", arguments: [selectedNumber1])
        let selectedFormattedNumber2 = String(format: "%.2f", arguments: [selectedNumber2])
        if let attribute = attribute as? AttributeTwoValueRange {
            inputTextLabel1.text = "\(attribute.value1Name) (\(selectedFormattedNumber1))"
            inputTextLabel2.text = "\(attribute.value2Name) (\(selectedFormattedNumber2))"
        }
    }
    
    public func initializeCell(withAttribute attribute: AttributeTwoValueRange) {
        self.attribute = attribute
        
        attributeTitleLabel.text = attribute.title
        
        inputSlider1.minimumValue = attribute.min1
        inputSlider1.maximumValue = attribute.max1
        inputSlider2.minimumValue = attribute.min2
        inputSlider2.maximumValue = attribute.max2
        
        displaySelectedValue()
    }
    
}


















































public class UIEmitterCellAttributesFoldableTableView: UIFoldableTableView<Attribute, String> {
    weak var emitter: CAEmitterLayer!
    var indexPathToEdit: IndexPath? {
        didSet {
            self.reloadData() // TODO: ✅ finde ich eine bessere Lösung?
        }
    }
    var emitterCell: CAEmitterCell? {
        guard let indexPathToEdit = indexPathToEdit else { return nil }
        return emitter.emitterCells?[indexPathToEdit.row]
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? UIFoldableTableView<Attribute, String> else { return UITableViewCell() }
        
        // create expanded cell
        if isUnfoldedCell(atIndexPath: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic_apple_cell", for: indexPath)
            let cellText = tableView.getUnfoldedElement(atIndexPath: indexPath)
            cell.textLabel?.text = "\t\(cellText)"
            cell.accessoryType = .none
            return cell
        }
        
        let element = tableView.getElement(atIndexPath: indexPath)
        let attribute = element.data
        
        if let attributeValueRange = attribute as? AttributeValueRange {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider_cell",
                                                     for: indexPath) as! UIEmitterAttributeTableViewSliderCell
            cell.delegate = self
            cell.initializeCell(withAttribute: attributeValueRange)
            
            var sliderValue: Float = 0.0
            if let emitterCell = emitterCell {
                switch attribute.type {
                case EmitterCellVisualAttribute.redRange: sliderValue = emitterCell.redRange
                case EmitterCellVisualAttribute.greenRange: sliderValue = emitterCell.greenRange
                case EmitterCellVisualAttribute.blueRange: sliderValue = emitterCell.blueRange
                case EmitterCellVisualAttribute.alphaRange: sliderValue = emitterCell.alphaRange
                case EmitterCellVisualAttribute.redSpeed: sliderValue = emitterCell.redSpeed
                case EmitterCellVisualAttribute.greenSpeed: sliderValue = emitterCell.greenSpeed
                case EmitterCellVisualAttribute.blueSpeed: sliderValue = emitterCell.blueSpeed
                case EmitterCellVisualAttribute.alphaSpeed: sliderValue = emitterCell.alphaSpeed
                case EmitterCellVisualAttribute.minificationFilterBias: sliderValue = emitterCell.minificationFilterBias
                case EmitterCellVisualAttribute.scale: sliderValue = Float(emitterCell.scale)
                case EmitterCellVisualAttribute.scaleRange: sliderValue = Float(emitterCell.scaleRange)
                    
                case EmitterCellMotionAttribute.spin: sliderValue = Float(emitterCell.spin)
                case EmitterCellMotionAttribute.spinRange: sliderValue = Float(emitterCell.spinRange)
                case EmitterCellMotionAttribute.emissionLatitude: sliderValue = Float(emitterCell.emissionLatitude)
                case EmitterCellMotionAttribute.emissionLongitude: sliderValue = Float(emitterCell.emissionLongitude)
                case EmitterCellMotionAttribute.emissionRange: sliderValue = Float(emitterCell.emissionRange)
                    
                case EmitterCellTemporalAttribute.lifetime: sliderValue = emitterCell.lifetime
                case EmitterCellTemporalAttribute.lifetimeRange: sliderValue = emitterCell.lifetimeRange
                case EmitterCellTemporalAttribute.birthRate: sliderValue = emitterCell.birthRate
                case EmitterCellTemporalAttribute.scaleSpeed: sliderValue = Float(emitterCell.scaleSpeed)
                case EmitterCellTemporalAttribute.velocity: sliderValue = Float(emitterCell.velocity)
                case EmitterCellTemporalAttribute.velocityRange: sliderValue = Float(emitterCell.velocityRange)
                case EmitterCellTemporalAttribute.xAcceleration: sliderValue = Float(emitterCell.xAcceleration)
                case EmitterCellTemporalAttribute.yAcceleration: sliderValue = Float(emitterCell.yAcceleration)
                case EmitterCellTemporalAttribute.zAcceleration: sliderValue = Float(emitterCell.zAcceleration)
                    
                default: break
                }
                
                cell.attribetuSlider.value = sliderValue
                cell.displaySelectedValue()
                
                return cell
            }
        } else if let attributeTwoValueRange = attribute as? AttributeTwoValueRange {
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoFoldValue_cell",
                                                     for: indexPath) as! UIEmitterAttributeTableViewTwofoldValueCell
            cell.delegate = self
            
            cell.initializeCell(withAttribute: attributeTwoValueRange)
            
            var sliderValue1: Float = 0.0
            var sliderValue2: Float = 0.0
            
            if let emitterCell = emitterCell {
                
                switch attribute.type {
                case EmitterCellContentAttribute.contentsRect:
                    sliderValue1 = Float(emitterCell.contentsRect.width)
                    sliderValue2 = Float(emitterCell.contentsRect.height)
                default: break
                }
                
            }
            
            cell.inputSlider1.value = sliderValue1
            cell.inputSlider2.value = sliderValue2
            cell.displaySelectedValue()
            
            return cell
        } else if let _ = attribute as? AttributeSelection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic_cell", for: indexPath) as! UIEmitterAttributeTableViewBasicCell
            
            cell.attributeTitleLabel.text = attribute.title
            cell.accessoryType = .disclosureIndicator
            
            var value: String = ""
            
            if let emitterCell = emitterCell {
                switch attribute.type {
                case EmitterCellVisualAttribute.magnificationFilter:
                    value = emitterCell.magnificationFilter
                case EmitterCellVisualAttribute.minificationFilter:
                    value = emitterCell.minificationFilter
                default: break
                }
            }
            
            cell.descriptionLabel.text = value
            
            return cell
        }
        return UITableViewCell()
    }
}

extension UIEmitterCellAttributesFoldableTableView: UIEmitterAttributeTableViewCellDelegate {
    public func valueChanged(newValue: Float, onAttribute attribute: Attribute) {
        
        switch attribute.type {
        case EmitterCellVisualAttribute.redRange: emitterCell?.redRange = newValue
        case EmitterCellVisualAttribute.greenRange: emitterCell?.greenRange = newValue
        case EmitterCellVisualAttribute.blueRange: emitterCell?.blueRange = newValue
        case EmitterCellVisualAttribute.alphaRange: emitterCell?.alphaRange = newValue
        case EmitterCellVisualAttribute.redSpeed: emitterCell?.redSpeed = newValue
        case EmitterCellVisualAttribute.greenSpeed: emitterCell?.greenSpeed = newValue
        case EmitterCellVisualAttribute.blueSpeed: emitterCell?.blueSpeed = newValue
        case EmitterCellVisualAttribute.alphaSpeed: emitterCell?.alphaSpeed = newValue
        case EmitterCellVisualAttribute.minificationFilterBias: emitterCell?.minificationFilterBias = newValue
        case EmitterCellVisualAttribute.scale: emitterCell?.scale = CGFloat(newValue)
        case EmitterCellVisualAttribute.scaleRange: emitterCell?.scaleRange = CGFloat(newValue)
            
        case EmitterCellMotionAttribute.spin: emitterCell?.spin = CGFloat(newValue)
        case EmitterCellMotionAttribute.spinRange: emitterCell?.spinRange = CGFloat(newValue)
        case EmitterCellMotionAttribute.emissionLatitude: emitterCell?.emissionLatitude = CGFloat(newValue)
        case EmitterCellMotionAttribute.emissionLongitude: emitterCell?.emissionLongitude = CGFloat(newValue)
        case EmitterCellMotionAttribute.emissionRange: emitterCell?.emissionRange = CGFloat(newValue)
            
        case EmitterCellTemporalAttribute.lifetime: emitterCell?.lifetime = newValue
        case EmitterCellTemporalAttribute.lifetimeRange: emitterCell?.lifetimeRange = newValue
        case EmitterCellTemporalAttribute.birthRate: emitterCell?.birthRate = newValue
        case EmitterCellTemporalAttribute.scaleSpeed: emitterCell?.scaleSpeed = CGFloat(newValue)
        case EmitterCellTemporalAttribute.velocity: emitterCell?.velocity = CGFloat(newValue)
        case EmitterCellTemporalAttribute.velocityRange: emitterCell?.velocityRange = CGFloat(newValue)
        case EmitterCellTemporalAttribute.xAcceleration: emitterCell?.xAcceleration = CGFloat(newValue)
        case EmitterCellTemporalAttribute.yAcceleration: emitterCell?.yAcceleration = CGFloat(newValue)
        case EmitterCellTemporalAttribute.zAcceleration: emitterCell?.zAcceleration = CGFloat(newValue)
            
        default: break
        }
        
        updateEmitter()
    }
    
    public func twoFoldedValueChanged(newValue1: Float, newValue2: Float, onAttribute attribute: Attribute) {
        
        switch attribute.type {
        case EmitterCellContentAttribute.contentsRect:
            emitterCell?.contentsRect = CGRect(x: 0.0, y: 0.0,
                                               width: CGFloat(newValue1), height: CGFloat(newValue2))
        default: break
        }
        
        updateEmitter()
    }
    
    func updateEmitter() {
        guard let indexPathToEdit = indexPathToEdit, var emitterCells = emitter.emitterCells else { return }
        let changedCell = emitterCells[indexPathToEdit.row]
        emitter.emitterCells = emitterCells
        emitter.emitterCells?.remove(at: indexPathToEdit.row)
        emitter.emitterCells?.insert(changedCell, at: indexPathToEdit.row)
    }
    
}

/************************************
 Emitter CELL Attributes - END
 ************************************/































public class UIEmitterAttributesFoldableTableView: UIFoldableTableView<Attribute, String> {
    
    weak var emitter: CAEmitterLayer!
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? UIFoldableTableView<Attribute, String> else { return UITableViewCell() }
        
        // create expanded cell
        if isUnfoldedCell(atIndexPath: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic_apple_cell", for: indexPath)
            let cellText = tableView.getUnfoldedElement(atIndexPath: indexPath)
            cell.textLabel?.text = "\t\(cellText)"
            cell.accessoryType = .none
            return cell
        }
        
        let element = tableView.getElement(atIndexPath: indexPath)
        let attribute = element.data
        
        if let attributeValueRange = attribute as? AttributeValueRange {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider_cell",
                                                     for: indexPath) as! UIEmitterAttributeTableViewSliderCell
            cell.delegate = self
            cell.attribute = attribute
            cell.initializeCell(withAttribute: attributeValueRange)
            
            var sliderValue: Float = 0.0
            
            switch attribute.type {
            case EmitterLayerGeometryAttribute.emitterZPosition: sliderValue = Float(emitter.zPosition)
            case EmitterLayerGeometryAttribute.emitterDepth: sliderValue = Float(emitter.emitterDepth)
            case EmitterLayerCellAttribute.scale: sliderValue = emitter.scale
            case EmitterLayerCellAttribute.seed: sliderValue = Float(emitter.seed)
            case EmitterLayerCellAttribute.spin: sliderValue = emitter.spin
            case EmitterLayerCellAttribute.velocity: sliderValue = emitter.velocity
            case EmitterLayerCellAttribute.birthRate: sliderValue = emitter.birthRate
            case EmitterLayerCellAttribute.lifetime: sliderValue = emitter.lifetime
            default: break
            }
            
            cell.attribetuSlider.value = sliderValue
            cell.displaySelectedValue()
            
            return cell
        } else if let attributeTwoValueRange = attribute as? AttributeTwoValueRange {
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoFoldValue_cell",
                                                     for: indexPath) as! UIEmitterAttributeTableViewTwofoldValueCell
            cell.delegate = self
            
            cell.initializeCell(withAttribute: attributeTwoValueRange)
            
            var sliderValue1: Float = 0.0
            var sliderValue2: Float = 0.0
            
            switch attribute.type {
            case EmitterLayerGeometryAttribute.emitterPosition:
                sliderValue1 = Float(emitter.emitterPosition.x)
                sliderValue2 = Float(emitter.emitterPosition.y)
            case EmitterLayerGeometryAttribute.emitterSize:
                sliderValue1 = Float(emitter.emitterSize.width)
                sliderValue2 = Float(emitter.emitterSize.height)
            default: break
            }
            
            cell.inputSlider1.value = sliderValue1
            cell.inputSlider2.value = sliderValue2
            cell.displaySelectedValue()
            
            return cell
        } else if let _ = attribute as? AttributeSelection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic_cell", for: indexPath) as! UIEmitterAttributeTableViewBasicCell
            
            cell.attributeTitleLabel.text = attribute.title
            cell.accessoryType = .disclosureIndicator
            
            var value: String = ""
            
            switch attribute.type {
            case EmitterLayerGeometryAttribute.renderMode:
                value = emitter.renderMode
            case EmitterLayerGeometryAttribute.emitterShape:
                value = emitter.emitterShape
            case EmitterLayerCellAttribute.emitterMode:
                value = emitter.emitterMode
            default: break
            }
            
            cell.descriptionLabel.text = value
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}


extension UIEmitterAttributesFoldableTableView: UIEmitterAttributeTableViewCellDelegate {
    public func valueChanged(newValue: Float, onAttribute attribute: Attribute) {
        
        switch attribute.type {
        case EmitterLayerGeometryAttribute.emitterZPosition:
            emitter.zPosition = CGFloat(newValue)
        case EmitterLayerGeometryAttribute.emitterDepth:
            emitter.emitterDepth = CGFloat(newValue)
        case EmitterLayerCellAttribute.scale:
            emitter.scale = newValue
        case EmitterLayerCellAttribute.seed:
            let intSeed = newValue > 0 ? Int(newValue) : 0
            emitter.seed = UInt32(intSeed)
        case EmitterLayerCellAttribute.spin:
            emitter.spin = newValue
        case EmitterLayerCellAttribute.velocity:
            emitter.velocity = newValue
        case EmitterLayerCellAttribute.birthRate:
            emitter.birthRate = newValue
        case EmitterLayerCellAttribute.lifetime:
            emitter.lifetime = newValue
        default: break
        }
    }
    
    public func twoFoldedValueChanged(newValue1: Float, newValue2: Float, onAttribute attribute: Attribute) {
        
        switch attribute.type {
        case EmitterLayerGeometryAttribute.emitterPosition:
            emitter.emitterPosition = CGPoint(x: CGFloat(newValue1),
                                              y: CGFloat(newValue2))
        case EmitterLayerGeometryAttribute.emitterSize:
            emitter.emitterSize = CGSize(width: CGFloat(newValue1),
                                         height: CGFloat(newValue2))
        default: break
        }
    }
}



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















protocol UIEmitterCellsOverviewDelegate {
    func editEmitterCell(atIndexPath indexPath: IndexPath)
}

class UIEmitterCellsOverviewTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var emitter: CAEmitterLayer!
    
    var overviewDelegate: UIEmitterCellsOverviewDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        dataSource = self
        delegate = self
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emitter.emitterCells?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic_apple_cell", for: indexPath)
        
        cell.textLabel?.text = "Emitter Cell Nr. \(indexPath.row+1)"
        
        if let emitterCell = getEmitterCell(atIndexPath: indexPath) {
            let cgImage = emitterCell.contents as! CGImage
            let particleImage = UIImage(cgImage: cgImage)
            cell.imageView?.image = particleImage
            cell.imageView?.dyeImage(imageColor: UIColor.red)
        }
        
        return cell
    }
    
    func getEmitterCell(atIndexPath indexPath: IndexPath) -> CAEmitterCell? {
        return emitter.emitterCells?[indexPath.row]
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.overviewDelegate?.editEmitterCell(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.emitter.emitterCells?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            let cellsToReload = self.cellIndexPaths(afterIndexPath: indexPath)
            tableView.reloadRows(at: cellsToReload, with: .none)
        }
        deleteAction.backgroundColor = UIColor.red
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            self.overviewDelegate?.editEmitterCell(atIndexPath: indexPath)
        }
        editAction.backgroundColor = UIColor.orange
        
        return [deleteAction, editAction]
    }
    
    func cellIndexPaths(afterIndexPath indexPath: IndexPath) -> [IndexPath] {
        let startCell = self.cellForRow(at: indexPath)
        var indexPaths: [IndexPath] = []
        var foundCell = false
        for index in 0..<self.visibleCells.count {
            let cell = self.visibleCells[index]
            if cell == startCell {
                foundCell = true
            }
            if foundCell {
                if let cellIndexPath = self.indexPath(for: cell) {
                    let indexPath = IndexPath(row: index, section: cellIndexPath.section)
                    indexPaths.append(indexPath)
                }
            }
        }
        return indexPaths
    }
}





class ViewController: UIViewController, UIFoldableTableViewDelegate {
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
    
    @objc func toggleButtonMenu(_ sender: MenuButton? = nil) {
        menuButton.toggle(onView: view)
    }
    
    @objc func editEmitterLayerAction(_ sender: UIButton) {
        print("Edit Emitter Attributes - \(viewMode)")
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            if viewMode != .emitterAttributeEditor {
                viewMode = .emitterAttributeEditor
                flip()
            }
        }
    }
    
    
    @objc func editEmitterCellAction(_ sender: UIButton) {
        print("Edit Emitter Cells - \(viewMode)")
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            if viewMode != .emitterCellOverview {
                viewMode = .emitterCellOverview
                flip()
            }
        }
    }
    
    @objc func showEmitterInDevMode(_ sender: UIButton) {
        print("Show Developer Mode")
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            let devOverview = EmitterDeveloperCodeViewController()
            devOverview.emitter = self.emitterPreview.emitter
            navigationController?.pushViewController(devOverview, animated: true)
        }
    }
    
    
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
    
    
    func createAndAssignEmitterTableViewData() {
        let sections: [String] = ["Emitter Geometry", "Emitter Cell Attribute Multipliers"]
        let attributes: [[Attribute]] = [createEmitterLayerGeometryAttributes(),
                                         createEmitterLayerCellAttributes()]
        
        var result: [[FoldableData<Attribute, String>]] = []
        
        for attributeArrray in attributes {
            var data: [FoldableData<Attribute, String>] = []
            for attribute in attributeArrray {
                let foldableData: FoldableData<Attribute, String>!
                if let attributeSelection = attribute as? AttributeSelection {
                    foldableData = FoldableData<Attribute, String>(data: attributeSelection, foldableItems: attributeSelection.selections)
                    data.append(foldableData)
                } else if let attributeValueRange = attribute as? AttributeValueRange {
                    foldableData = FoldableData<Attribute, String>(data: attributeValueRange)
                    data.append(foldableData)
                } else if let attributeTwoValueRange = attribute as? AttributeTwoValueRange {
                    foldableData = FoldableData<Attribute, String>(data: attributeTwoValueRange)
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
        
        var result: [[FoldableData<Attribute, String>]] = []
        
        for attributeArrray in attributes {
            var data: [FoldableData<Attribute, String>] = []
            for attribute in attributeArrray {
                let foldableData: FoldableData<Attribute, String>!
                if let attributeSelection = attribute as? AttributeSelection {
                    foldableData = FoldableData<Attribute, String>(data: attributeSelection, foldableItems: attributeSelection.selections)
                    data.append(foldableData)
                } else if let attributeValueRange = attribute as? AttributeValueRange {
                    foldableData = FoldableData<Attribute, String>(data: attributeValueRange)
                    data.append(foldableData)
                } else if let attributeTwoValueRange = attribute as? AttributeTwoValueRange {
                    foldableData = FoldableData<Attribute, String>(data: attributeTwoValueRange)
                    data.append(foldableData)
                }
            }
            result.append(data)
        }
        
        emitterCellTableView.sections = sections
        emitterCellTableView.elements = result
    }
}

extension ViewController: UIEmitterCellsOverviewDelegate {
    func editEmitterCell(atIndexPath indexPath: IndexPath) {
        viewMode = .emitterCellAttributeEditor
        emitterCellTableView.indexPathToEdit = indexPath
        flip()
    }
}

class EmitterDeveloperCodeViewController: UIViewController {
    var emitter: CAEmitterLayer!
    var codeTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(codeTextView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCode))
        
        let code = emitter.developerDescription()
        codeTextView.text = code
        
        ConstraintAssistant.addConstraints(on: codeTextView, andMatchTheSameSizeAsView: self.view)
    }
    
    @objc func shareCode() {
        let code = emitter.developerDescription()
        let shareActivity = UIActivityViewController(activityItems: [code], applicationActivities: nil)
        present(shareActivity, animated: true)
    }
    
    
}



let vCtrl = ViewController()
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl






