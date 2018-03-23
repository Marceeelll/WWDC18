import UIKit





public protocol UIEmitterAttributeTableViewCellDelegate: class {
    func valueChanged(newValue: Float, onAttribute attribute: Attribute)
    func twoFoldedValueChanged(newValue1: Float, newValue2: Float, onAttribute attribute: Attribute)
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
