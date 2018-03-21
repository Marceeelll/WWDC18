//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

public class ParticleController {
    private var layer: CALayer
    private var particles: [CAEmitterLayer] = []
    private var isParticleAnimationRunning = false
    private let simulatorScreenWidth: CGFloat = 320
    private let simulatorScreenCenterPoint = CGPoint(x: 320.0/2.0, y: 100)
    
    init(layer: CALayer) {
        self.layer = layer
    }
    
    func startParticleAnimation(forEventType eventType: EventType) {
        var stopDelay: Double = 5.0
        if eventType == .important {
            stopDelay = 0.05
        }
        if particles.isEmpty {
            if let particle = getEmitter(forEventType: eventType) {
                particles.append(particle)
            }
            if let particle = getEmitter(forEventType: eventType) {
                particles.append(particle)
            }
        }
        if !particles.isEmpty && !isParticleAnimationRunning {
            isParticleAnimationRunning = true
            for particle in particles {
                particle.beginTime = CACurrentMediaTime()
                layer.addSublayer(particle)
                stopParticleAnimation(stopDeleay: stopDelay)
            }
        }
    }
    
    let group = DispatchGroup()
    private func stopParticleAnimation(stopDeleay: Double) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + stopDeleay) {
            for particle in self.particles {
                particle.birthRate = 0.0
                print("ENTERED")
                self.group.enter()
                
                let lifetimes = particle.emitterCells?.map({ (cell) -> Float in
                    return cell.lifetime
                })
                if let maxLifeTime = lifetimes?.max() {
                    print(maxLifeTime)
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(maxLifeTime), execute: {
                        particle.removeFromSuperlayer()
                        print("--LEAVE")
                        self.group.leave()
                        self.isParticleAnimationRunning = false
                    })
                }
            }
            self.group.notify(queue: DispatchQueue.main) {
                print("All finished")
                self.particles.removeAll()
            }
        }
    }
    
    func getEmitter(forEventType eventType: EventType) -> CAEmitterLayer? {
        switch eventType {
        case .birthday:
            print("BIRTHDAY PARTICLES")
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = simulatorScreenCenterPoint
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
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = simulatorScreenCenterPoint
            emitter.emitterShape = kCAEmitterLayerLine
            emitter.emitterSize = CGSize(width: simulatorScreenWidth, height: 1)
            var cells: [CAEmitterCell] = []
            for _ in 0..<16 {
                let cell = CAEmitterCell()
                cell.birthRate = 4
                cell.lifetime = 10.0
                cell.lifetimeRange = 0
                cell.velocity = 80
                cell.velocityRange = 120
                cell.emissionLongitude = CGFloat.pi
                cell.emissionRange = 0.5
                cell.spin = 3.0
                cell.color = UIColor.red.cgColor
                cell.contents = UIImage(named: "confetti_1.png")!.cgImage
                cell.scale = 1.0
                cells.append(cell)
            }
            emitter.emitterCells = cells
            return emitter
        case .important:
            print("IMPORTANT PARTICLES")
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = simulatorScreenCenterPoint
            if !particles.isEmpty {
                emitter.emitterPosition = CGPoint(x: 20, y: 400)
            }
            emitter.emitterShape = kCAEmitterLayerPoint
            emitter.emitterSize = CGSize(width: 1, height: 1)
            var cells: [CAEmitterCell] = []
            for _ in 0..<1 {
                let cell = CAEmitterCell()
                cell.birthRate = 10000
                cell.lifetime = 3.5
                cell.lifetimeRange = 0
                cell.velocity = 105
                cell.greenRange = 0.2
                cell.velocityRange = 120
                cell.emissionLongitude = 0
                cell.emissionLatitude = -1.66
                cell.emissionRange = 0.74
                cell.spin = 3.0
                cell.yAcceleration = 30
                cell.alphaSpeed = -0.3
                cell.color = AppColor.Apple.yellow.cgColor
                cell.contents = UIImage(named: "confetti_2.png")!.cgImage
                cell.scale = 0.2
                cells.append(cell)
            }
            emitter.emitterCells = cells
            return emitter
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









