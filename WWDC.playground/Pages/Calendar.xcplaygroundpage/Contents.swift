//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

public class ParticleController {
    private var layer: CALayer
    private var particle: CAEmitterLayer?
    private var isParticleAnimationRunning = false
    
    init(layer: CALayer) {
        self.layer = layer
    }
    
    func startParticleAnimation(forEventType eventType: EventType) {
        let stopDelay: Double = 5.0
        if particle == nil {
            particle = getEmitter(forEventType: eventType)
        }
        if let particle = particle, !isParticleAnimationRunning {
            isParticleAnimationRunning = true
            particle.beginTime = CACurrentMediaTime()
            layer.addSublayer(particle)
            stopParticleAnimation(stopDeleay: stopDelay)
        }
    }
    
    private func stopParticleAnimation(stopDeleay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + stopDeleay) {
            if let particle = self.particle {
                particle.birthRate = 0.0
                
                let lifetimes = particle.emitterCells?.map({ (cell) -> Float in
                    return cell.lifetime
                })
                if let maxLifeTime = lifetimes?.max() {
                    print(maxLifeTime)
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(maxLifeTime), execute: {
                        particle.removeFromSuperlayer()
                        self.particle = nil
                        self.isParticleAnimationRunning = false
                    })
                }
            }
        }
    }
    
    func getEmitter(forEventType eventType: EventType) -> CAEmitterLayer? {
        switch eventType {
        case .birthday:
            print("BIRTHDAY PARTICLES")
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint(x: 320.0/2.0, y: 100)
            emitter.emitterShape = kCAEmitterLayerLine
            emitter.emitterSize = CGSize(width: 300, height: 30)
            
            var cells: [CAEmitterCell] = []
            
            for index in 0..<3 {
                let cell = CAEmitterCell()
                
                let intensity = Float(0.3)
                
                //            cell.birthRate = 1.5
                cell.birthRate = 5
                cell.lifetime = 10
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
            
            return emitter
        case .christmas:
            print("CHRISTMAS PARTICLES")
        case .wwdc:
            print("WWDC PARTICLES")
        case .newYear:
            print("NEW YEAR PARTICLES")
        case .important:
            print("IMPORTANT PARTICLES")
        case .holiday:
            print("HOLIDAY PARTICLES")
        case .none:
            print("NONE PARTICLES :D")
        }
        
        return nil
    }
}


class ViewController: UIViewController {
    var calendarView: UICalendarView = UICalendarView()
    var calenderDayOverviewTableView = UICalendarDayOverviewTableView()
    
    let eventCtrl = EventController()
    var particleCtrl: ParticleController!

    var dataSource: UICalendarViewDataSource! {
        didSet {
            dataSource.datesWithEvent = eventCtrl.dates
            calendarView.dataSource = dataSource
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCtrl.createDemonstrationEvents()
        
        particleCtrl = ParticleController(layer: self.view.layer)
        calenderDayOverviewTableView.register(UICalendarDayOverviewTableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(selectToday))

        self.view.backgroundColor = UIColor.lightGray
        
        let today = Date()
        calenderDayOverviewTableView.data = eventCtrl.getEvents(forDate: today)
        calenderDayOverviewTableView.selectedDate = today
        calenderDayOverviewTableView.overViewDelegate = self
        
        self.view.addSubview(calenderDayOverviewTableView)
        self.view.addSubview(calendarView)
        
        calendarView.layer.shadowRadius = 2.0
        calendarView.layer.shadowOpacity = 1.0
        calendarView.layer.shadowColor = UIColor.lightGray.cgColor
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 1)

        setupConstraints()

        dataSource = UICalendarViewDataSource()
        calendarView.delegate = self
        calendarView.drawCalendar()
    }

    func setupConstraints() {
        // Set Calendar Constraints
        let constraintBuilder = ConstraintBuilder(subview: calendarView, superview: self.view)
        constraintBuilder.constraint(subviewAttribute: .top, superviewAttribute: .top, multiplier: 1.0, constant: 44.0)
            .constraint(subviewAttribute: .left, superviewAttribute: .left, multiplier: 1.0, constant: 0.0)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, multiplier: 1.0, constant: 0.0)
            .constraint(subviewAttribute: .height, multiplier: 1.0, constant: 300)
            .buildAndApplyConstrains()
        
        ConstraintAssistant.addConstraints(on: calenderDayOverviewTableView,
                                           inSuperView: self.view,
                                           withTopView: calendarView)
    }
    
    @objc func selectToday() {
        let today = Date()
        calenderDayOverviewTableView.data = eventCtrl.getEvents(forDate: today)
        calenderDayOverviewTableView.selectedDate = today
        calenderDayOverviewTableView.reloadData()
        dataSource = UICalendarViewDataSource()
        calendarView.delegate = self
        calendarView.drawCalendar()
    }

}


extension ViewController: UICalendarViewDelegateProtocol {
    func calendarView(_ calendarView: UICalendarView, didSelectedDate selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.title = dateFormatter.string(from: selectedDate)
        let eventsOnSelectedDay = eventCtrl.getEvents(forDate: selectedDate)
        calenderDayOverviewTableView.data = eventsOnSelectedDay
        calenderDayOverviewTableView.selectedDate = selectedDate
        calenderDayOverviewTableView.reloadData()
    }

    func calenderView(_ calendarView: UICalendarView, touchedNextMonthButton: UIButton) {
    }

    func calenderView(_ calendarView: UICalendarView, touchedPreviousMonthButton: UIButton) {
    }
}


extension ViewController: UICalendarDayOverviewTableViewDelegate {
    func overviewTableView(_ tableView: UICalendarDayOverviewTableView, didSelectedEvent event: Event) {
        particleCtrl.startParticleAnimation(forEventType: event.type)
    }
}


let vCtrl = ViewController()
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl



protocol MyProtocol {
    static var allItems: [MyProtocol] { get set }
}

enum Enum1: MyProtocol {
    case option1
    case option2
    static let allItems: [MyProtocol] = [Enum1]
}

enum Enum2 {
    case option3
    case option4
}









