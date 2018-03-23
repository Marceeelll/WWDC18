import UIKit

public protocol CustomDeveloperStringConvertible {
    func developerDescription(varName: String) -> String
}

extension CustomDeveloperStringConvertible {
    public func line(forVariableName varName: String, attribute: String, value: String) -> String {
        return "\(varName).\(attribute) = \(value)\n"
    }
    
    public func line(forVariableName varName: String, attribute: String, value: CustomDeveloperStringConvertible) -> String {
        return "\(varName).\(attribute) = \(value.developerDescription(varName: ""))\n"
    }
    
    public func line(comment: String) -> String {
        return "\n// \(comment)\n"
    }
}

extension CAEmitterCell: CustomDeveloperStringConvertible {
    public func developerDescription(varName: String) -> String {
        var result = "let \(varName) = CAEmitterCell()\n"
        
        result += line(comment: "Providing Emitter Cell Content")
        // contents
        result += line(forVariableName: varName, attribute: "contentsRect", value: self.contentsRect)
        
        result += line(comment: "Setting Emitter Cell Visual Attributes")
        result += line(forVariableName: varName, attribute: "isEnabled", value: "\(self.isEnabled)")
        if let cgColor = self.color, let components = cgColor.components {
            if components.count >= 4 {
                let color = "UIColor(red: \(components[0]), green: \(components[1]), blue: \(components[2]), alpha: \(components[3])"
                result += line(forVariableName: varName, attribute: "color", value: "\(color)")
            }
        }
        result += line(forVariableName: varName, attribute: "redRange", value: "\(self.redRange)")
        result += line(forVariableName: varName, attribute: "greenRange", value: "\(self.greenRange)")
        result += line(forVariableName: varName, attribute: "blueRange", value: "\(self.blueRange)")
        result += line(forVariableName: varName, attribute: "alphaRange", value: "\(self.alphaRange)")
        result += line(forVariableName: varName, attribute: "redSpeed", value: "\(self.redSpeed)")
        result += line(forVariableName: varName, attribute: "greenSpeed", value: "\(self.greenSpeed)")
        result += line(forVariableName: varName, attribute: "blueSpeed", value: "\(self.blueSpeed)")
        result += line(forVariableName: varName, attribute: "alphaSpeed", value: "\(self.alphaSpeed)")
        result += line(forVariableName: varName, attribute: "magnificationFilter", value: "\(self.magnificationFilter)")
        result += line(forVariableName: varName, attribute: "minificationFilter", value: "\(self.minificationFilter)")
        result += line(forVariableName: varName, attribute: "minificationFilterBias", value: "\(self.minificationFilterBias)")
        result += line(forVariableName: varName, attribute: "scale", value: "\(self.scale)")
        result += line(forVariableName: varName, attribute: "scaleRange", value: "\(self.scaleRange)")
        if let name = self.name {
            result += line(forVariableName: varName, attribute: "name", value: "\(name)")
        }
        
        result += line(comment: "Emitter Cell Motion Attributes")
        result += line(forVariableName: varName, attribute: "spin", value: "\(self.spin)")
        result += line(forVariableName: varName, attribute: "spinRange", value: "\(self.spinRange)")
        result += line(forVariableName: varName, attribute: "emissionLatitude", value: "\(self.emissionLatitude)")
        result += line(forVariableName: varName, attribute: "emissionLongitude", value: "\(self.emissionLongitude)")
        result += line(forVariableName: varName, attribute: "emissionRange", value: "\(self.emissionRange)")
        
        result += line(comment: "Emission Cell Temporal Attributes")
        result += line(forVariableName: varName, attribute: "lifetime", value: "\(self.lifetime)")
        result += line(forVariableName: varName, attribute: "lifetimeRange", value: "\(self.lifetimeRange)")
        result += line(forVariableName: varName, attribute: "birthRate", value: "\(self.birthRate)")
        result += line(forVariableName: varName, attribute: "scaleSpeed", value: "\(self.scaleSpeed)")
        result += line(forVariableName: varName, attribute: "velocity", value: "\(self.velocity)")
        result += line(forVariableName: varName, attribute: "velocityRange", value: "\(self.velocityRange)")
        result += line(forVariableName: varName, attribute: "xAcceleration", value: "\(self.xAcceleration)")
        result += line(forVariableName: varName, attribute: "yAcceleration", value: "\(self.yAcceleration)")
        result += line(forVariableName: varName, attribute: "zAcceleration", value: "\(self.zAcceleration)")
        
        return result
    }
    
    public func developerMagnificationFilterDescription() -> String {
        switch self.magnificationFilter {
        case kCAFilterLinear: return "kCAFilterLinear"
        case kCAFilterNearest: return "kCAFilterNearest"
        case kCAFilterTrilinear: return "kCAFilterTrilinear"
        default: return ""
        }
    }
}

extension CAEmitterLayer: CustomDeveloperStringConvertible {
    public func developerDescription(varName: String = "emitter") -> String {
        var result = "let \(varName) = CAEmitterLayer()\n"
        
        result += line(comment: "Emitter Geometry")
        let renderModeDescription = developerRenderModeDescription()
        result += line(forVariableName: varName, attribute: "renderMode", value: renderModeDescription)
        result += line(forVariableName: varName, attribute: "emitterPosition", value: self.position)
        let emitterShapeDescription = developerEmitterShapeDescription()
        result += line(forVariableName: varName, attribute: "emitterShape", value: emitterShapeDescription)
        result += line(forVariableName: varName, attribute: "emitterZPosition", value: "\(self.emitterZPosition)")
        result += line(forVariableName: varName, attribute: "emitterDepth", value: "\(self.emitterDepth)")
        result += line(forVariableName: varName, attribute: "emitterSize", value: "\(self.emitterSize)")
        
        result += line(comment: "Emitter Cell Attribute Multipliers")
        result += line(forVariableName: varName, attribute: "scale", value: "\(self.scale)")
        result += line(forVariableName: varName, attribute: "seed", value: "\(self.seed)")
        result += line(forVariableName: varName, attribute: "spin", value: "\(self.spin)")
        result += line(forVariableName: varName, attribute: "velocity", value: "\(self.velocity)")
        result += line(forVariableName: varName, attribute: "birthRate", value: "\(self.birthRate)")
        let emitterModeDescription = ""
        result += line(forVariableName: varName, attribute: "emitterMode", value: emitterModeDescription)
        result += line(forVariableName: varName, attribute: "lifetime", value: "\(self.lifetime)")
        result += line(forVariableName: varName, attribute: "preservesDepth", value: "\(self.preservesDepth)")
        
        if let cells = self.emitterCells {
            print("HAS CELLS :)")
            let tabs = "\t"
            result += "for index in 0..<\(cells.count-1) {\n"
            for index in 0..<cells.count {
                let cell = cells[index]
                let cellDeveloperDescription = cell.developerDescription(varName: "cell\(index+1)")
                let cellDeveloperDescriptionLines = cellDeveloperDescription.components(separatedBy: .newlines)
                for cellDeveloperDescriptionLine in cellDeveloperDescriptionLines {
                    result += "\(tabs)\(cellDeveloperDescriptionLine)\n"
                }
                result += "\n"
            }
            result += "}"
        }
        
        return result
    }
    
    public func developerRenderModeDescription() -> String {
        print(self.renderMode)
        switch self.renderMode {
        case kCAEmitterLayerPoints: return "kCAEmitterLayerPoints"
        case kCAEmitterLayerOutline: return "kCAEmitterLayerOutline"
        case kCAEmitterLayerSurface: return "kCAEmitterLayerSurface"
        case kCAEmitterLayerVolume: return "kCAEmitterLayerVolume"
        case kCAEmitterLayerUnordered: return "kCAEmitterLayerUnordered"
        default: return ""
        }
    }
    
    public func developerEmitterShapeDescription() -> String {
        switch self.emitterShape {
        case kCAEmitterLayerPoint: return "kCAEmitterLayerPoint"
        case kCAEmitterLayerPoint: return "kCAEmitterLayerPoint"
        case kCAEmitterLayerLine: return "kCAEmitterLayerLine"
        case kCAEmitterLayerRectangle: return "kCAEmitterLayerRectangle"
        case kCAEmitterLayerCuboid: return "kCAEmitterLayerCuboid"
        case kCAEmitterLayerCircle: return "kCAEmitterLayerCircle"
        case kCAEmitterLayerSphere: return "kCAEmitterLayerSphere"
        default: return ""
        }
    }
}

extension CGPoint: CustomDeveloperStringConvertible {
    public func developerDescription(varName: String = "") -> String {
        return "CGPoint(x: \(self.x), y: \(self.y))"
    }
}

extension CGSize: CustomDeveloperStringConvertible {
    public func developerDescription(varName: String) -> String {
        return "CGSize(width: \(self.width), height: \(self.height)"
    }
}

extension CGRect: CustomDeveloperStringConvertible {
    public func developerDescription(varName: String) -> String {
        return "CGRect(x: \(self.minX), y: \(self.minY), width: \(self.width), height: \(self.height))"
    }
}
