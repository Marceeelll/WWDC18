import UIKit

public protocol Expandable: class {
    var expandingViewsMenu: [UIView] { get set }
    var expandingViewsSpaceInDegree: CGFloat { get set }
    
    var backgroundView: UIView { get set }
    var backgroundViewColor: UIColor { get }
    var isRunningAnimation: Bool { get set }
    var isMenuExpanded: Bool { get set }
    var startFromPoint: CGPoint? { get set }
    var endAtPoint: CGPoint? { get set }
}


public extension Expandable where Self: UIView {
    public func toggle(onView view: UIView) {
        if !isRunningAnimation {
            if !isMenuExpanded {
                expandMenu(onView: view)
            } else {
                closeMenu(onView: view)
            }
        }
    }
    
    public func append(expandingView: UIView) {
        expandingViewsMenu.append(expandingView)
    }
    
    public func append(expandingViews: [UIView]) {
        expandingViewsMenu.append(contentsOf: expandingViews)
    }
    
    private func expandMenu(onView view: UIView) {
        isRunningAnimation = true
        isMenuExpanded = true
        
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.frame = view.frame
        
        view.insertSubview(backgroundView, belowSubview: self)
        
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.backgroundColor = self.backgroundViewColor
        }
        
        if let startFromPoint = startFromPoint {
            UIView.animate(withDuration: 0.75, animations: {
                self.center = startFromPoint
                self.setNeedsDisplay()
            }) { (finished) in
                if finished {
                    self.expandButtons(onView: view)
                }
            }
        } else {
            expandButtons(onView: view)
        }
    }
    
    private func expandButtons(onView view: UIView) {
        for index in 0..<expandingViewsMenu.count {
            let button = expandingViewsMenu[index]
            button.frame = self.frame
            button.backgroundColor = self.backgroundColor
            button.layer.cornerRadius = self.layer.cornerRadius
            view.insertSubview(button, belowSubview: self)
            let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.5) {
                let point = self.position(forButtonIndex: index, forDegree: 0)
                button.layer.position.y = point.y
                button.layer.position.x = point.x
            }
            
            if index == self.expandingViewsMenu.count - 1 {
                animator.addCompletion({ _ in
                    self.isRunningAnimation = false
                })
            }
            
            animator.startAnimation(afterDelay: 0.1 * Double(index))
        }
    }
    
    private func position(forButtonIndex index: Int, forDegree degree: CGFloat) -> CGPoint {
        var adjustedDegree = degree
        if expandingViewsMenu.count%2 == 0 {
            let middleElement = expandingViewsMenu.count/2
            if index < middleElement {
                adjustedDegree -= expandingViewsSpaceInDegree * CGFloat(expandingViewsMenu.count/2 - index) - expandingViewsSpaceInDegree/2
            } else {
                adjustedDegree += expandingViewsSpaceInDegree * CGFloat(index - middleElement) + expandingViewsSpaceInDegree/2
            }
        } else {
            let middleElement = expandingViewsMenu.count/2
            if index == middleElement {
                adjustedDegree = degree
            } else if index < middleElement {
                if index == 0 {
                    adjustedDegree -= expandingViewsSpaceInDegree * CGFloat(expandingViewsMenu.count/2)
                } else {
                    adjustedDegree -= expandingViewsSpaceInDegree * CGFloat(expandingViewsMenu.count/2 - index)
                }
            } else if index > middleElement {
                adjustedDegree += expandingViewsSpaceInDegree * CGFloat(index - middleElement)
            }
        }
        
        let radian = toRadian(degree: adjustedDegree, startFrom: .top)
        var point = calculatePoint(withRadius: 100.0, andRadian: radian)
        point.x += self.layer.position.x
        point.y += self.layer.position.y
        
        return point
    }
    
    private func closeMenu(onView view: UIView) {
        self.isRunningAnimation = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundView.backgroundColor = UIColor.clear
        }) { (finished) in
            if finished {
                self.backgroundView.removeFromSuperview()
                self.isMenuExpanded = false
            }
        }
        
        closeButtons(onView: view)
    }
    
    private func closeButtons(onView view: UIView) {
        for index in 0..<expandingViewsMenu.count {
            let button = self.expandingViewsMenu[index]
            let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.9) {
                button.frame = self.frame
            }
            animator.addCompletion({ _ in
                button.removeFromSuperview()
                if index == self.expandingViewsMenu.count - 1 {
                    self.isRunningAnimation = false
                    if let endAtPoint = self.endAtPoint {
                        UIView.animate(withDuration: 0.75, animations: {
                            self.center = endAtPoint
                            view.setNeedsDisplay()
                        })
                    }
                }
            })
            animator.startAnimation(afterDelay: 0.1 * Double(index))
        }
    }
    
    private func calculatePoint(withRadius radius: CGFloat, andRadian radian: CGFloat) -> CGPoint {
        // position on a circle with the radius
        let x = cos(radian)
        let y = sin(radian)
        
        // calculate the position in a bigger/smaller circle
        let positionX = radius * x
        let positionY = radius * y
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    /**
     A circle with radian=0 starts right.
     This method adjust the start point.
     */
    private func toRadian(degree: CGFloat, startFrom direction: Direction) -> CGFloat {
        switch direction {
        case .right: return toRadian(degree: degree)
        case .bottom: return toRadian(degree: degree) + toRadian(degree: 90.0)
        case .left: return toRadian(degree: degree) + toRadian(degree: 180.0)
        case .top: return toRadian(degree: degree) + toRadian(degree: 270.0)
        }
    }
    
    private func toRadian(degree: CGFloat) -> CGFloat {
        let oneDegreeInRadian: CGFloat = 0.0175
        return degree*oneDegreeInRadian
    }
}

public enum Direction {
    case right
    case bottom
    case left
    case top
}


public class MenuButton: UIButton, Expandable {
    public var expandingViewsMenu: [UIView] = []
    public var expandingViewsSpaceInDegree: CGFloat = 40.0
    public var backgroundView: UIView = UIView()
    public var backgroundViewColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    public var isRunningAnimation: Bool = false
    public var isMenuExpanded: Bool = false
    public var startFromPoint: CGPoint?
    public var endAtPoint: CGPoint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
