import UIKit



public protocol UIEmitterAttributeTableViewCellDelegate: class {
    func valueChanged(newValue: Float, onAttribute attribute: Attribute)
    func twoFoldedValueChanged(newValue1: Float, newValue2: Float, onAttribute attribute: Attribute)
}
