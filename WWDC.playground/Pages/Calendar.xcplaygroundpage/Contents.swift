//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

struct Particle {
    var emitter: CAEmitterLayer
    var startDelay: Double
    var stopDelay: Double
}

public class ParticleController {
    private var layer: CALayer
    private var particles: [Particle] = []
    private var isParticleAnimationRunning = false
    private let simulatorScreenWidth: CGFloat = 320
    private let simulatorScreenCenterPoint = CGPoint(x: 320.0/2.0, y: 44)
    private let particleRect = CGRect(x: 20, y: 60, width: 280, height: 200)
    private var group = DispatchGroup()
    
    init(layer: CALayer) {
        self.layer = layer
    }
    
    func startParticleAnimation(forEventType eventType: EventType) {
        if particles.isEmpty {
            particles = getParticles(forEventType: eventType)
        }
        if !particles.isEmpty && !isParticleAnimationRunning {
            isParticleAnimationRunning = true
            
            for index in 0..<particles.count {
                group.enter()
                let particle = particles[index]
                
                // start particle animation with delay
                DispatchQueue.main.asyncAfter(deadline: .now() + particle.startDelay, execute: {
                    particle.emitter.beginTime = CACurrentMediaTime()
                    self.layer.addSublayer(particle.emitter)
                    self.stopParticleAnimation(ofParticle: particle)
                })
            }
            group.notify(queue: .main, execute: {
                self.deleteAllParticles()
            })
        }
    }
    
    private func deleteAllParticles() {
        var maxLifetimeResult: Float = 0.0
        for particle in particles {
            let maxCellLifeTimes = particle.emitter.emitterCells?.map({ (cell) -> Float in
                return cell.lifetime
            })
            if let maxLifeTime = maxCellLifeTimes?.max() {
                maxLifetimeResult = max(maxLifetimeResult, maxLifeTime)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(maxLifetimeResult)) {
            self.isParticleAnimationRunning = false
            for particle in self.particles {
                particle.emitter.removeFromSuperlayer()
            }
            self.particles = []
        }
    }
    
    private func stopParticleAnimation(ofParticle particle: Particle) {
        DispatchQueue.main.asyncAfter(deadline: .now() + particle.stopDelay) {
            particle.emitter.birthRate = 0.0
            self.group.leave()
        }
    }
    
    func getParticles(forEventType eventType: EventType) -> [Particle] {
        switch eventType {
        case .birthday:
            print("BIRTHDAY PARTICLES")
            var result: [Particle] = []
            for _ in 0..<1 {
                if let emitter = getEmitter(forEventType: eventType) {
                    let delay = 0.0
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 5.0)
                    result.append(particle)
                }
            }
            return result
        case .christmas:
            print("CHRISTMAS PARTICLES")
            var result: [Particle] = []
            for _ in 0..<1 {
                if let emitter = getEmitter(forEventType: eventType) {
                    let delay = 0.0
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 4.0)
                    result.append(particle)
                }
            }
            return result
        case .wwdc:
            print("WWDC PARTICLES")
            var result: [Particle] = []
            for _ in 0..<1 {
                if let emitter = getEmitter(forEventType: eventType) {
                    let delay = 0.0
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 1.3)
                    result.append(particle)
                }
            }
            return result
        case .newYear:
            print("NEW YEAR PARTICLES")
            var result: [Particle] = []
            for index in 0..<5 {
                if let emitter = getEmitter(forEventType: eventType) {
                    let delay = Double(index)
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 0.2)
                    result.append(particle)
                }
            }
            return result
        case .important:
            print("IMPORTANT PARTICLES")
            return []
        case .holiday:
            print("HOLIDAY PARTICLES")
            return []
        case .none:
            print("NONE PARTICLES :D")
            return []
        }
    }
    
    func getEmitter(forEventType eventType: EventType) -> CAEmitterLayer? {
        switch eventType {
        case .birthday:
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = simulatorScreenCenterPoint
            emitter.emitterShape = kCAEmitterLayerLine
            emitter.emitterSize = CGSize(width: 300, height: 30)
            
            var cells: [CAEmitterCell] = []
            
            for index in 0..<9 {
                let cell = CAEmitterCell()
                
                cell.birthRate = 6.0
                cell.lifetime = 5.0
                cell.lifetimeRange = 0
                cell.velocity = 140.0
                cell.velocityRange = 20.0
                cell.emissionLongitude = CGFloat(Double.pi)
                cell.emissionRange = 0.5
                cell.spin = 3.5
                cell.spinRange = 0
                cell.color = getRandomColor().cgColor
                cell.scaleRange = 0.25
                cell.scale = 0.3
                
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
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = simulatorScreenCenterPoint
            emitter.emitterShape = kCAEmitterLayerLine
            emitter.emitterSize = CGSize(width: 300, height: 30)
            
            var cells: [CAEmitterCell] = []
            
            for _ in 0..<1 {
                let cell = CAEmitterCell()
                
                cell.birthRate = 6.0
                cell.lifetime = 3.5
                cell.velocity = 80.0
                
                cell.emissionLongitude = (180.0*(CGFloat.pi/180.0))
                cell.emissionRange = 0.3
                cell.spin = 0.0
                cell.spinRange = 3.0
                cell.scale = 0.4
                cell.scaleRange = 0.15
                cell.color = AppColor.Particle.coldBlue.cgColor
                cell.alphaSpeed = -0.3
                cell.contents = UIImage(named: "snow.png")!.cgImage
                
                cells.append(cell)
            }
            
            emitter.emitterCells = cells
            
            return emitter
        case .wwdc:
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = simulatorScreenCenterPoint
            emitter.emitterShape = kCAEmitterLayerPoint
            emitter.emitterSize = CGSize(width: 300, height: 30)
            
            var cells: [CAEmitterCell] = []
            
            for _ in 0..<1 {
                let cell = CAEmitterCell()
                
                cell.birthRate = 1.0
                cell.lifetime = 6.0
                cell.lifetimeRange = 0
                cell.velocity = 120.0
                cell.emissionLongitude = 1.58
                cell.emissionLatitude = 0.0
                cell.emissionRange = 0.3
                cell.spin = 0.0
                cell.spinRange = 3.0
                cell.scale = 0.4
                cell.contents = UIImage(named: "wwdc18ticket.png")!.cgImage
                
                cells.append(cell)
            }
            
            emitter.emitterCells = cells
            
            return emitter
        case .newYear:
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = calculateRandomPoint(inRect: particleRect)
            if !particles.isEmpty {
                emitter.emitterPosition = CGPoint(x: 20, y: 400)
            }
            emitter.emitterShape = kCAEmitterLayerPoint
            emitter.emitterSize = CGSize(width: 1, height: 1)
            var cells: [CAEmitterCell] = []
            for _ in 0..<1 {
                let cell = CAEmitterCell()
                cell.birthRate = 5_000
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
                cell.color = getRandomColor().cgColor
                cell.contents = UIImage(named: "confetti_2.png")!.cgImage
                cell.scale = 0.2
                cells.append(cell)
            }
            
            emitter.emitterCells = cells
            
            return emitter
        case .important:
            return nil
        case .holiday:
            print("HOLIDAY PARTICLES")
            return nil
        case .none:
            print("NONE PARTICLES :D")
            return nil
        }
    }
    
    func calculateRandomPoint(inRect rect: CGRect) -> CGPoint {
        let xSpan = rect.width - rect.minX
        let ySpan = rect.height - rect.minY
        
        let randomXPosition = Int(arc4random_uniform(UInt32(xSpan))) + Int(rect.minX)
        let randomYPosition = Int(arc4random_uniform(UInt32(ySpan))) + Int(rect.minY)
        
        let randomPoint = CGPoint(x: randomXPosition, y: randomYPosition)
        return randomPoint
    }
    
    func getRandomColor() -> UIColor {
        let numberOfColors = AppColor.Apple.allColors.count
        let randomIndex = Int(arc4random_uniform(UInt32(numberOfColors)))
        return AppColor.Apple.allColors[randomIndex]
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









