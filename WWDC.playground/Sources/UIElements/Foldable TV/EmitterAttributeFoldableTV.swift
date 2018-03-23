import UIKit

public class UIEmitterCellAttributesFoldableTableView: UIFoldableTableView {
    public weak var emitter: CAEmitterLayer!
    public var indexPathToEdit: IndexPath? {
        didSet {
            self.reloadData()
        }
    }
    public var emitterCell: CAEmitterCell? {
        guard let indexPathToEdit = indexPathToEdit else { return nil }
        return emitter.emitterCells?[indexPathToEdit.row]
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? UIFoldableTableView else { return UITableViewCell() }
        
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








public class UIEmitterAttributesFoldableTableView: UIFoldableTableView {
    
    public weak var emitter: CAEmitterLayer!
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? UIFoldableTableView else { return UITableViewCell() }
        
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
