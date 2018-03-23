import UIKit

public protocol AttributeType {
}


public enum EmitterLayerGeometryAttribute: AttributeType {
    case renderMode
    case emitterPosition
    case emitterShape
    case emitterZPosition
    case emitterDepth
    case emitterSize
    
    public static var allAttributes: [EmitterLayerGeometryAttribute] {
        return [EmitterLayerGeometryAttribute.renderMode,
                EmitterLayerGeometryAttribute.emitterPosition,
                EmitterLayerGeometryAttribute.emitterShape,
                EmitterLayerGeometryAttribute.emitterZPosition,
                EmitterLayerGeometryAttribute.emitterDepth,
                EmitterLayerGeometryAttribute.emitterSize]
    }
}


public enum EmitterLayerCellAttribute: AttributeType {
    case scale
    case seed
    case spin
    case velocity
    case birthRate
    case emitterMode
    case lifetime
    
    public static var allAttributes: [EmitterLayerCellAttribute] {
        return [EmitterLayerCellAttribute.scale,
                EmitterLayerCellAttribute.seed,
                EmitterLayerCellAttribute.spin,
                EmitterLayerCellAttribute.velocity,
                EmitterLayerCellAttribute.birthRate,
                EmitterLayerCellAttribute.emitterMode,
                EmitterLayerCellAttribute.lifetime]
    }
}

public enum EmitterCellContentAttribute: AttributeType {
    case contentsRect
    
    public static var allAttributes: [EmitterCellContentAttribute] {
        return [EmitterCellContentAttribute.contentsRect]
    }
}

public enum EmitterCellVisualAttribute: AttributeType {
    case redRange
    case greenRange
    case blueRange
    case alphaRange
    case redSpeed
    case greenSpeed
    case blueSpeed
    case alphaSpeed
    case magnificationFilter
    case minificationFilter
    case minificationFilterBias
    case scale
    case scaleRange
    
    public static var allAttributes: [EmitterCellVisualAttribute] {
        return [EmitterCellVisualAttribute.redRange,
                EmitterCellVisualAttribute.greenRange,
                EmitterCellVisualAttribute.blueRange,
                EmitterCellVisualAttribute.alphaRange,
                EmitterCellVisualAttribute.redSpeed,
                EmitterCellVisualAttribute.greenSpeed,
                EmitterCellVisualAttribute.blueSpeed,
                EmitterCellVisualAttribute.alphaSpeed,
                EmitterCellVisualAttribute.magnificationFilter,
                EmitterCellVisualAttribute.minificationFilterBias,
                EmitterCellVisualAttribute.scale,
                EmitterCellVisualAttribute.scaleRange]
    }
}

public enum EmitterCellMotionAttribute: AttributeType {
    case spin
    case spinRange
    case emissionLatitude
    case emissionLongitude
    case emissionRange
    
    public static var allAttributes: [EmitterCellMotionAttribute] {
        return [EmitterCellMotionAttribute.spin,
                EmitterCellMotionAttribute.spinRange,
                EmitterCellMotionAttribute.emissionLatitude,
                EmitterCellMotionAttribute.emissionLongitude,
                EmitterCellMotionAttribute.emissionRange]
    }
}

public enum EmitterCellTemporalAttribute: AttributeType {
    case lifetime
    case lifetimeRange
    case birthRate
    case scaleSpeed
    case velocity
    case velocityRange
    case xAcceleration
    case yAcceleration
    case zAcceleration
    
    public static var allAttributes: [EmitterCellTemporalAttribute] {
        return [EmitterCellTemporalAttribute.lifetime,
                EmitterCellTemporalAttribute.lifetimeRange,
                EmitterCellTemporalAttribute.birthRate,
                EmitterCellTemporalAttribute.scaleSpeed,
                EmitterCellTemporalAttribute.velocity,
                EmitterCellTemporalAttribute.velocityRange,
                EmitterCellTemporalAttribute.xAcceleration,
                EmitterCellTemporalAttribute.yAcceleration,
                EmitterCellTemporalAttribute.zAcceleration]
    }
}



public protocol Attribute {
    var title: String { get }
    var type: AttributeType { get set }
}

public struct AttributeSelection: Attribute {
    public var title: String
    public var type: AttributeType
    public var selections: [String]
    
    public init(title: String, type: AttributeType, selections: [String]) {
        self.title = title
        self.type = type
        self.selections = selections
    }
}


public struct AttributeValueRange: Attribute {
    public var title: String
    public var type: AttributeType
    public var min: Float
    public var max: Float
    
    public init(title: String, type: AttributeType, min: Float, max: Float) {
        self.title = title
        self.type = type
        self.min = min
        self.max = max
    }
}

public struct AttributeTwoValueRange: Attribute {
    public var title: String
    public var type: AttributeType
    public var value1Name: String
    public var min1: Float
    public var max1: Float
    public var value2Name: String
    public var min2: Float
    public var max2: Float
    
    public init(title: String, type: AttributeType, value1Name: String, min1: Float, max1: Float,
                value2Name: String, min2: Float, max2: Float) {
        self.title = title
        self.type = type
        self.value1Name = value1Name
        self.min1 = min1
        self.max1 = max1
        self.value2Name = value2Name
        self.min2 = min2
        self.max2 = max2
    }
}



public func createEmitterLayerGeometryAttributes() -> [Attribute] {
    var result: [Attribute] = []
    
    for attributeType in EmitterLayerGeometryAttribute.allAttributes {
        var attribute: Attribute
        switch attributeType {
        case .renderMode:
            attribute = AttributeSelection(title: "Render Mode",
                                           type: attributeType,
                                           selections: [kCAEmitterLayerPoint,
                                                        kCAEmitterLayerOutline,
                                                        kCAEmitterLayerSurface,
                                                        kCAEmitterLayerVolume])
        case .emitterPosition:
            attribute = AttributeTwoValueRange(title: "Emitter Position",
                                               type: attributeType,
                                               value1Name: "x", min1: 0, max1: 384,
                                               value2Name: "y", min2: 0, max2: 200)
        case .emitterShape:
            attribute = AttributeSelection(title: "Emitter Shape",
                                           type: attributeType,
                                           selections: [kCAEmitterLayerPoint,
                                                        kCAEmitterLayerLine,
                                                        kCAEmitterLayerRectangle,
                                                        kCAEmitterLayerCuboid,
                                                        kCAEmitterLayerCircle,
                                                        kCAEmitterLayerSphere])
        case .emitterZPosition:
            attribute = AttributeValueRange(title: "Emitter Z Position",
                                            type: attributeType,
                                            min: -100, max: 100)
        case .emitterDepth:
            attribute = AttributeValueRange(title: "Emitter Depth",
                                            type: attributeType,
                                            min: -100, max: 100)
        case .emitterSize:
            attribute = AttributeTwoValueRange(title: "Emitter Size",
                                               type: attributeType,
                                               value1Name: "Width", min1: 0, max1: 384,
                                               value2Name: "Height", min2: 0, max2: 200)
        }
        result.append(attribute)
    }
    
    return result
}

public func createEmitterLayerCellAttributes() -> [Attribute] {
    var results: [Attribute] = []
    
    for attributeType in EmitterLayerCellAttribute.allAttributes {
        var attribute: Attribute
        switch attributeType {
        case .scale:
            attribute = AttributeValueRange(title: "Scale", type: attributeType, min: 0.0, max: 10.0)
        case .seed:
            attribute = AttributeValueRange(title: "Seed", type: attributeType, min: 0, max: 100.0)
        case .spin:
            attribute = AttributeValueRange(title: "Spin", type: attributeType, min: -100.0, max: 100.0)
        case .velocity:
            attribute = AttributeValueRange(title: "Velocity", type: attributeType, min: -100.0, max: 100.0)
        case .birthRate:
            attribute = AttributeValueRange(title: "Birth Rate", type: attributeType, min: -100.0, max: 100.0)
        case .emitterMode:
            attribute = AttributeSelection(title: "Emitter Mode",
                                           type: attributeType,
                                           selections: [kCAEmitterLayerPoints,
                                                        kCAEmitterLayerOutline,
                                                        kCAEmitterLayerSurface,
                                                        kCAEmitterLayerVolume])
        case .lifetime:
            attribute = AttributeValueRange(title: "Lifetime", type: attributeType, min: 0.0, max: 10.0)
        }
        results.append(attribute)
    }
    
    return results
}

public func createEmitterLayerAttributes() -> [Attribute] {
    return []
}

public func createEmitterCellContentAttributes() -> [Attribute] {
    var results: [Attribute] = []
    for attributeType in EmitterCellContentAttribute.allAttributes {
        var attribute: Attribute
        switch attributeType {
        case .contentsRect:
            attribute = AttributeTwoValueRange(title: "Contents Rect",
                                               type: attributeType,
                                               value1Name: "Width", min1: 0, max1: 10,
                                               value2Name: "Height", min2: 0, max2: 10)
        }
        results.append(attribute)
    }
    return results
}

public func createEmitterCellVisualAttributes() -> [Attribute] {
    var results: [Attribute] = []
    for attributeType in EmitterCellVisualAttribute.allAttributes {
        var attribute: Attribute
        switch attributeType {
        case .redRange:
            attribute = AttributeValueRange(title: "Red Range", type: attributeType, min: 0.0, max: 255.0)
        case .greenRange:
            attribute = AttributeValueRange(title: "Green Range", type: attributeType, min: 0.0, max: 255.0)
        case .blueRange:
            attribute = AttributeValueRange(title: "Blue Range", type: attributeType, min: 0.0, max: 255.0)
        case .alphaRange:
            attribute = AttributeValueRange(title: "Alpha Range", type: attributeType, min: 0.0, max: 1.0)
        case .redSpeed:
            attribute = AttributeValueRange(title: "Red Speed", type: attributeType, min: 0.0, max: 10.0)
        case .greenSpeed:
            attribute = AttributeValueRange(title: "Green Speed", type: attributeType, min: 0.0, max: 10.0)
        case .blueSpeed:
            attribute = AttributeValueRange(title: "Blue Speed", type: attributeType, min: 0.0, max: 10.0)
        case .alphaSpeed:
            attribute = AttributeValueRange(title: "Alpha Speed", type: attributeType, min: -2.0, max: 1.0)
        case .magnificationFilter:
            attribute = AttributeSelection(title: "Magnification Filter",
                                           type: attributeType,
                                           selections: [kCAFilterLinear,
                                                        kCAFilterNearest,
                                                        kCAFilterTrilinear])
        case .minificationFilter:
            attribute = AttributeSelection(title: "Minification Filter",
                                           type: attributeType,
                                           selections: [kCAFilterLinear,
                                                        kCAFilterNearest,
                                                        kCAFilterTrilinear])
        case .minificationFilterBias:
            attribute = AttributeValueRange(title: "MinificationFilterBias", type: attributeType, min: 0.0, max: 10.0)
        case .scale:
            attribute = AttributeValueRange(title: "Scale", type: attributeType, min: 0.0, max: 10.0)
        case .scaleRange:
            attribute = AttributeValueRange(title: "Scale Range", type: attributeType, min: 0.0, max: 10.0)
        }
        results.append(attribute)
    }
    return results
}

public func createEmitterCellMotionAttributes() -> [Attribute] {
    var results: [Attribute] = []
    for attributeType in EmitterCellMotionAttribute.allAttributes {
        var attribtue: Attribute
        switch attributeType {
        case .spin:
            attribtue = AttributeValueRange(title: "Spin", type: attributeType, min: -20.0, max: 20.0)
        case .spinRange:
            attribtue = AttributeValueRange(title: "Spin Range", type: attributeType, min: -20.0, max: 20.0)
        case .emissionLatitude:
            attribtue = AttributeValueRange(title: "Emission Latitude", type: attributeType, min: -Float.pi, max: Float.pi)
        case .emissionLongitude:
            attribtue = AttributeValueRange(title: "Emission Longitude", type: attributeType, min: -Float.pi, max: Float.pi)
        case .emissionRange:
            attribtue = AttributeValueRange(title: "Emission Range", type: attributeType, min: 0, max: 6.28319)
        }
        results.append(attribtue)
    }
    return results
}

public func createEmitterCellTemporalAttributes() -> [Attribute] {
    var results: [Attribute] = []
    for attributeType in EmitterCellTemporalAttribute.allAttributes {
        var attribute: Attribute
        switch attributeType {
        case .lifetime:
            attribute = AttributeValueRange(title: "Lifetime", type: attributeType, min: 0.0, max: 10.0)
        case .lifetimeRange:
            attribute = AttributeValueRange(title: "Lifetime Range", type: attributeType, min: 0.0, max: 10.0)
        case .birthRate:
            attribute = AttributeValueRange(title: "Birth Rate", type: attributeType, min: 0.0, max: 100.0)
        case .scaleSpeed:
            attribute = AttributeValueRange(title: "Scale Speed", type: attributeType, min: -2, max: 100.0)
        case .velocity:
            attribute = AttributeValueRange(title: "Velocity", type: attributeType, min: -400.0, max: 400.0)
        case .velocityRange:
            attribute = AttributeValueRange(title: "Velocity Range", type: attributeType, min: -400.0, max: 400.0)
        case .xAcceleration:
            attribute = AttributeValueRange(title: "X-Acceleration", type: attributeType, min: -300.0, max: 300.0)
        case .yAcceleration:
            attribute = AttributeValueRange(title: "Y-Acceleration", type: attributeType, min: -300.0, max: 300.0)
        case .zAcceleration:
            attribute = AttributeValueRange(title: "Z-Acceleration", type: attributeType, min: -300.0, max: 300.0)
        }
        results.append(attribute)
    }
    return results
}
