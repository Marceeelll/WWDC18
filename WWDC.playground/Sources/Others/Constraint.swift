import UIKit


public class ConstraintBuilder {
    // MARK: - Instance Variable
    private var subview: UIView?
    private var superview: UIView?
    private var constraints: [UIView: [NSLayoutAttribute: NSLayoutConstraint]] = [:]
    
    
    // MARK: - Initializer
    public init() {
    }
    
    public init(subview: UIView, superview: UIView) {
        self.subview = subview
        self.superview = superview
    }
    
    
    // MARK: - Instance Methods
    public func set(subview: UIView) {
        self.subview = subview
    }
    
    public func set(superview: UIView) {
        self.subview = superview
    }
    
    
    public func specificConstraint(_ attribute: NSLayoutAttribute, forView view: UIView) -> NSLayoutConstraint? {
        let constraints = constraintsDictionary(forView: view)
        return constraints[attribute]
    }
    
    public func constraints(forView view: UIView?) -> [NSLayoutConstraint] {
        if let view = view, let viewConstraintsDictionary = constraints[view] {
            return Array(viewConstraintsDictionary.values)
        }
        return []
    }
    
    public func constraintsDictionary(forView view: UIView) -> [NSLayoutAttribute: NSLayoutConstraint] {
        if let viewConstraintsDictionary = constraints[view] {
            return viewConstraintsDictionary
        }
        return [:]
    }
    
    
    @discardableResult
    public func constraint(subviewAttribute: NSLayoutAttribute, superviewAttribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> ConstraintBuilder {
        guard let subview = subview, let superview = superview else {
            printErrors()
            return self
        }
        
        let constraint = NSLayoutConstraint(item: subview,
                                            attribute: subviewAttribute, relatedBy: .equal,
                                            toItem: superview, attribute: superviewAttribute,
                                            multiplier: multiplier, constant: constant)
        append(toView: subview, attribute: subviewAttribute, constraint: constraint)
        return self
    }
    
    @discardableResult
    public func constraint(subviewAttribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> ConstraintBuilder {
        guard let subview = subview else {
            printErrors()
            return self
        }
        
        let constraint = NSLayoutConstraint(item: subview,
                                            attribute: subviewAttribute, relatedBy: .equal,
                                            toItem: nil, attribute: subviewAttribute,
                                            multiplier: multiplier, constant: constant)
        append(toView: subview, attribute: subviewAttribute, constraint: constraint)
        return self
    }
    
    @discardableResult
    public func constraint(subviewAttribute: NSLayoutAttribute, anotherView: UIView, anotherAttribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> ConstraintBuilder {
        guard let subview = subview else {
            printErrors()
            return self
        }
        
        let constraint = NSLayoutConstraint(item: subview,
                                            attribute: subviewAttribute, relatedBy: .equal,
                                            toItem: anotherView, attribute: anotherAttribute,
                                            multiplier: multiplier, constant: constant)
        append(toView: subview, attribute: subviewAttribute, constraint: constraint)
        return self
    }
    
    
    public func clone(newSubview: UIView, newSuperview: UIView) -> ConstraintBuilder {
        return ConstraintBuilder()
    }
    
    public func buildAndApplyConstrains() {
        subview?.translatesAutoresizingMaskIntoConstraints = false
        let subviewConstraints = constraints(forView: subview)
        superview?.addConstraints(subviewConstraints)
    }
    
    
    // MARK: - Help Methods
    private func printErrors() {
        if subview == nil {
            print("ConstraintBuilder-Error: Subview was not set.")
        }
        if superview == nil {
            print("ConstraintBuilder-Error: Superview was not set.")
        }
    }
    
    private func append(toView view: UIView, attribute: NSLayoutAttribute, constraint: NSLayoutConstraint) {
        if constraints[view] == nil {
            constraints[view] = [attribute: constraint]
        } else {
            constraints[view]?[attribute] = constraint
        }
    }
}









public struct ConstraintAssistant {
    /**
     Die `subview` passt sich exact der Größe der `subview` an, der Abstand zu `.left`, `.right`, `.bottom`, `.top` kann prozentual zwischen 0 bis 1.0 angegeben werden.
     
     Betroffene `NSLayoutAttribute`:
     - `left`
     - `right`
     - `centerX`
     - `centerY`
     
     - parameters:
     - constantLeft: Der Abstand zum linken Rand
     - constantRight: Der Abstand zum rechten Rand
     */
    public static func addConstraints(on subview: UIView, andMatchTheSameSizeAsView matchingView: UIView, percentOfSpacingToBorder: CGFloat) {
        let borderWidthSpacing = matchingView.frame.width * percentOfSpacingToBorder
        let borderHeightSpacing = matchingView.frame.height * percentOfSpacingToBorder
        ConstraintAssistant.addConstraints(on: subview, andMatchTheSameSizeAsView: matchingView,
                                           heightBorderSpace: borderHeightSpacing, widthBorderSpace: borderWidthSpacing)
    }
    
    
    /**
     Die `subview` wird in die Mitte der `superview` gesetzt und passt sich der Größe der `superview` an.
     
     Betroffene `NSLayoutAttribute`:
     - `left`
     - `right`
     - `centerX`
     - `centerY`
     
     - parameters:
     - constantLeft: Der Abstand zum linken Rand
     - constantRight: Der Abstand zum rechten Rand
     */
    public static func addConstraints(on subview: UIView, centerInSuperviewAndMatchWidth matchingView: UIView, constantLeft: CGFloat = 0.0, constantRight: CGFloat = 0.0) {
        let constraintBuilder = ConstraintBuilder(subview: subview, superview: matchingView)
        
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: constantLeft)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -constantRight)
            .constraint(subviewAttribute: .centerX, superviewAttribute: .centerX)
            .constraint(subviewAttribute: .centerY, superviewAttribute: .centerY)
            .buildAndApplyConstrains()
    }
    
    
    /**
     Die `subview` passt sich exact der Größe der `subview` an.
     
     Betroffene `NSLayoutAttribute`:
     - `top`
     - `right`
     - `bottom`
     - `left`
     
     - parameters:
     - heightBorderSpace: Der Abstand zwischen .top und .bottom
     - widthBorderSpace: Der Abstand zwischen .left und .right
     */
    @discardableResult
    public static func addConstraints(on subview: UIView, andMatchTheSameSizeAsView matchingView: UIView, heightBorderSpace: CGFloat = 0.0,
                               widthBorderSpace: CGFloat = 0.0) -> [NSLayoutAttribute:NSLayoutConstraint] {
        
        let constraintBuilder = ConstraintBuilder(subview: subview, superview: matchingView)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: widthBorderSpace/2)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -widthBorderSpace/2)
            .constraint(subviewAttribute: .top, superviewAttribute: .top, constant: heightBorderSpace/2)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -heightBorderSpace/2)
            .buildAndApplyConstrains()
        
        let constraintDictionary = constraintBuilder.constraintsDictionary(forView: subview)
        return constraintDictionary
    }
    
    
    
    /**
     Die `subview` wird an `.top` oder `.bottom` an die `superview` angeheftet mit der entsprechenden `height`.
     
     - parameters:
     - attachToTop: `True` = attach to `.top` | `False` = attach to `.bottom`.
     */
    public static func addConstraints(on subview: UIView, withSuperView superview: UIView, withHeightConstant height: CGFloat, attachToTop: Bool) {
        let attribute: NSLayoutAttribute = attachToTop ? .top : .bottom
        
        let constraintBuilder = ConstraintBuilder(subview: subview, superview: superview)
        
        constraintBuilder.constraint(subviewAttribute: attribute, superviewAttribute: attribute)
            .constraint(subviewAttribute: .left, superviewAttribute: .left)
            .constraint(subviewAttribute: .right, superviewAttribute: .right)
            .constraint(subviewAttribute: .height, constant: height)
            .buildAndApplyConstrains()
    }
    
    
    /**
     Die `subview` wird zwischen dem `.bottom` der `superview` und dem `.bottom` der `topView` angeheftet.
     */
    public static func addConstraints(on subview: UIView, inSuperView superview: UIView, withTopView topView: UIView) {
        let constraintBuilder = ConstraintBuilder(subview: subview, superview: superview)
        constraintBuilder.constraint(subviewAttribute: .top, anotherView: topView, anotherAttribute: .bottom)
            .constraint(subviewAttribute: .left, superviewAttribute: .left)
            .constraint(subviewAttribute: .right, superviewAttribute: .right)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom)
            .buildAndApplyConstrains()
    }
    
    
    /**
     Die `subview` wird quadratisch in der Mitte der `superview` zentriert.
     
     **TODO: ✅ der Code ist nicht ganz gut, muss überarbeitet werden!**
     
     Betroffene `NSLayoutAttribute`:
     - `...`
     */
    public static func addConstraints(on subview: UIView, makeSquareInSuperview superview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subviewSize = min(superview.bounds.width, superview.bounds.height)
        
        addWidth(on: subview, inSuperview: superview, width: subviewSize)
        addHeight(on: subview, inSuperview: superview, height: subviewSize)
        addConstraints(on: subview, centerInSuperview: superview)
    }
    
    
    /**
     Setzt die Breite der `subview` in der `superview` auf den als Parameter übergebenen Wert.
     
     Betroffene `NSLayoutAttribute`:
     - `width`
     
     - parameters:
     - width: Die Breiter, die der `subview` zugewiesen werden soll.
     */
    public static func addWidth(on subview: UIView, inSuperview superview: UIView, width: CGFloat) {
        let constraintBuilder = ConstraintBuilder(subview: subview, superview: superview)
        constraintBuilder.constraint(subviewAttribute: .width, constant: width)
        constraintBuilder.buildAndApplyConstrains()
    }
    
    
    /**
     Setzt die Höhe der `subview` in der `superview` auf den als Parameter übergebenen Wert.
     
     Betroffene `NSLayoutAttribute`:
     - `height`
     
     - parameters:
     - height: Die Höhe, die der `subview` zugewiesen werden soll.
     */
    public static func addHeight(on subview: UIView, inSuperview superview: UIView, height: CGFloat) {
        let constraintBuilder = ConstraintBuilder(subview: subview, superview: superview)
        constraintBuilder.constraint(subviewAttribute: .height, constant: height)
        constraintBuilder.buildAndApplyConstrains()
    }
    
    
    /**
     Zentriert die `subview` in der `superview`.
     
     Betroffene `NSLayoutAttribute`:
     - `centerX`
     - `centerY
     */
    public static func addConstraints(on subview: UIView, centerInSuperview superview: UIView) {
        let constraintBuilder = ConstraintBuilder(subview: subview, superview: superview)
        constraintBuilder.constraint(subviewAttribute: .centerX, superviewAttribute: .centerX)
            .constraint(subviewAttribute: .centerY, superviewAttribute: .centerY)
            .buildAndApplyConstrains()
    }
    
    
    /**
     The default multiplier = 1.0.
     */
    public static func aspectRadioConstraint(view: UIView, inSuperview superview: UIView, withMultiplier multiplier: CGFloat = 1.0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let aspectRadio = NSLayoutConstraint(item: view,
                                             attribute: .height, relatedBy: .equal,
                                             toItem: view, attribute: .width,
                                             multiplier: multiplier,
                                             constant: 0.0)
        superview.addConstraint(aspectRadio)
    }
    
}

