import UIKit

public class UIEmitterPreviewView: UIView {
    public var emitter = CAEmitterLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup() {
        emitter.emitterPosition = CGPoint(x: 320.0/2.0, y: 100)
        
        var cells: [CAEmitterCell] = []
        
        for index in 0..<3 {
            let cell = CAEmitterCell()
            
            let intensity = Float(0.3)
            
            cell.birthRate = 1.5
            cell.lifetime = 3
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi/4
            cell.spin = CGFloat(3.5 * intensity)
            cell.spinRange = CGFloat(4.0 * intensity)
            cell.scaleRange = CGFloat(intensity)
            cell.scaleSpeed = CGFloat(-0.1 * intensity)
            
            cell.redRange = 200
            cell.greenRange = 200
            cell.alphaRange = 1
            cell.alphaSpeed = 1
            
            switch index%3 {
            case 0: cell.contents = UIImage(named: "confetti_1.png")!.cgImage
            case 1: cell.contents = UIImage(named: "confetti_2.png")!.cgImage
            case 2: cell.contents = UIImage(named: "confetti_3.png")!.cgImage
            default:
                break
            }
            
            cells.append(cell)
        }
        
        emitter.emitterCells = cells
        
        //        self.layer.addSublayer(emitter)
    }
}
