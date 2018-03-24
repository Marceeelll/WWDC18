import UIKit


public class WelcomeViewController: UIViewController {
    var startLabel = UILabel()
    var appleImageView = UIImageView()
    
    let word = "WWDC18"
    var letters: [Character] = []
    
    var letterLabels: [UILabel] = []
    
    let size: CGFloat = 40.0
    let font = UIFont(name: "Avenir", size: 30.0)!
    
    var fullAnimationTime: CFTimeInterval = 5.0
    
    var colors: [UIColor] = [AppColor.Apple.green,
                             AppColor.Apple.yellow,
                             AppColor.Apple.orange,
                             AppColor.Apple.red,
                             AppColor.Apple.purple,
                             AppColor.Apple.blue]
    
    public var userBirthdayEvents: [Event] = []
    public var selectedWeekdayStart = UICalendarWeekday.wednesday
    
    var canContinueToNextScreen = false
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        letters = Array(word)
        
        startLabel.frame = CGRect(x: 0, y: 450, width: 375, height: 50)
        startLabel.font = font
        startLabel.text = "Touch to Start"
        startLabel.textColor = UIColor.darkGray
        startLabel.textAlignment = .center
        startLabel.isHidden = true
        view.addSubview(startLabel)
        
        appleImageView.image = UIImage(named: "icon_jumping_ball_black.png")
        appleImageView.frame = CGRect(x: 5, y: 250, width: size, height: size)
        view.addSubview(appleImageView)
        
        createWWDC()
        
        view.backgroundColor = UIColor.white
        
        startAnimationWithDelay()
        let startAnimatingLabelDelay = fullAnimationTime + 2
        startAnimatingStartLabel(withDelay: startAnimatingLabelDelay)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canContinueToNextScreen {
            canContinueToNextScreen = false
            let calendarVCtrl = CalendarViewController(userBirthdayEvents: userBirthdayEvents,
                                                       selectedWeekdayStart: selectedWeekdayStart)
            navigationController?.pushViewController(calendarVCtrl, animated: true)
        }
    }
    
    func startAnimatingStartLabel(withDelay delay: Double = 0) {
        UIView.animate(withDuration: 1.0, delay: delay,
                       options: [], animations: {
                        self.startLabel.alpha = 0.2
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                    self.startLabel.alpha = 1.0
                }, completion: { (finished) in
                    if finished {
                        self.startAnimatingStartLabel()
                    }
                })
            }
        }
    }
    
    func startAnimationWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.colorAppleLogo()
            self.startLabelColoring()
        }
    }
    
    func startLabelColoring() {
        let timeForOneAnimationStep = fullAnimationTime / Double(letters.count + 1)
        for index in 0..<letters.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeForOneAnimationStep * Double(index+1), execute: {
                let color = self.colors[index]
                self.letterLabels[index].textColor = color
                if index == self.letters.count - 1 {
                    self.canContinueToNextScreen  = true
                    self.startLabel.isHidden = false
                }
            })
        }
    }
    
    func createWWDC() {
        let startPosition = appleImageView.frame
        
        for index in 0..<letters.count {
            let letter = letters[index]
            let letterLabel = UILabel(frame: CGRect(x: startPosition.maxX + size*CGFloat(index),
                                                    y: startPosition.minY,
                                                    width: size,
                                                    height: size))
            letterLabel.font = font
            letterLabel.text = "\(letter)"
            letterLabel.textAlignment = .center
            self.view.addSubview(letterLabel)
            letterLabels.append(letterLabel)
        }
    }
    
    
    
    @objc func colorAppleLogo() {
        UIView.transition(with: appleImageView,
                          duration: 0.25, options: .transitionCrossDissolve,
                          animations: {
                            self.appleImageView.image = UIImage(named: "icon_jumping_ball_colored.png")
        }, completion: { (finished) in
            if finished {
                self.animateBouncingApple()
            }
        })
    }
    
    private func animateBouncingApple() {
        let path = self.createAppleAnimationPath()
        
        let animation = CAKeyframeAnimation()
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.keyPath = "position"
        animation.path = path
        animation.duration = fullAnimationTime
        animation.isAdditive = true
        
        self.appleImageView.layer.add(animation, forKey: "move")
    }
    
    private func createAppleAnimationPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        let appleSize = appleImageView.frame.width
        let applePoint = appleImageView.center
        
        let jumpSize: CGFloat = -100.0
        for index in 0..<letterLabels.count {
            let letterlabel = letterLabels[index]
            let endPosition = CGPoint(x: letterlabel.center.x - applePoint.x,
                                      y: letterlabel.frame.minY - applePoint.y)
            let halfEndPosition = CGPoint(x: endPosition.x,
                                          y: endPosition.y + jumpSize)
            
            path.addQuadCurve(to: endPosition, controlPoint: halfEndPosition)
            
            if index == letterLabels.count - 1 {
                let appleEndXPosition = letterlabel.center.x - applePoint.x + appleSize
                path.addQuadCurve(to: CGPoint(x: appleEndXPosition, y: 0),
                                  controlPoint: CGPoint(x: letterlabel.center.x + appleSize/2, y: jumpSize))
            }
        }
        
        return path.cgPath
    }
    
    func setupConstraints() {
    }
    
}
