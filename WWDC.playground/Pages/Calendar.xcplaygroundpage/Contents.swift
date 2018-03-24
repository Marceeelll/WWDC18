//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import AVFoundation


public protocol UICalendarDayOverviewTableViewDelegate {
    func overviewTableView(_ tableView: UICalendarDayOverviewTableView, didSelectedEvent event: Event)
}

public class UICalendarDayOverviewTableView: UITableView {
    public var data: [Event] = []
    public var selectedDate: Date?
    
    public var overViewDelegate: UICalendarDayOverviewTableViewDelegate?
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.dataSource = self
        self.delegate = self
    }
    
}

extension UICalendarDayOverviewTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UICalendarDayOverviewTableViewCell
        let event = getEvent(atIndexPath: indexPath)
        cell.descriptionLabel.text = "\(event.type.symbol)\(event.title)"
        if let selectedDate = selectedDate {
            let times = event.getTimes(forDate: selectedDate)
            cell.startTimeLabel.text = times.startTime
            cell.endTimeLabel.text = times.endTime
        }
        
        cell.flipCell()
        cell.seperatorView.backgroundColor = event.type.color
        return cell
    }
    
    public func getEvent(atIndexPath indexPath: IndexPath) -> Event {
        return  data[indexPath.row]
    }
}

extension UICalendarDayOverviewTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEvent = getEvent(atIndexPath: indexPath)
        overViewDelegate?.overviewTableView(self, didSelectedEvent: selectedEvent)
    }
}



// START -- UICalendarDayOverviewTableViewCell

public class UICalendarDayOverviewTableViewCell: UITableViewCell {
    private var timeStackView = UIStackView()
    public var startTimeLabel = UILabel()
    public var endTimeLabel = UILabel()
    public var descriptionLabel = UILabel()
    public var eventImageView = UILabel()
    public var seperatorView = UIView()
    
    private let borderSpace: CGFloat = 8.0
    
    let fontTest = UIFont(name: "Helvetica", size: 12.0)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(endTimeLabel)
        timeStackView.alignment = .fill
        timeStackView.distribution = .fillEqually
        timeStackView.axis = .vertical
        self.addSubview(timeStackView)
        
        startTimeLabel.font = fontTest
        startTimeLabel.textAlignment = .right
        endTimeLabel.font = fontTest
        endTimeLabel.textAlignment = .right
        
        seperatorView.backgroundColor = UIColor.blue
        self.addSubview(seperatorView)
        
        self.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        let stackViewCB = ConstraintBuilder(subview: timeStackView, superview: self)
        stackViewCB.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: borderSpace)
            .constraint(subviewAttribute: .top, superviewAttribute: .top, constant: borderSpace)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .constraint(subviewAttribute: .width, constant: 55.0)
            .buildAndApplyConstrains()
        
        let seperatorViewCB = ConstraintBuilder(subview: seperatorView, superview: self)
        seperatorViewCB.constraint(subviewAttribute: .top, superviewAttribute: .top, constant: borderSpace)
            .constraint(subviewAttribute: .left, anotherView: timeStackView, anotherAttribute: .right, constant: borderSpace/2)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .constraint(subviewAttribute: .width, constant: 2.0)
            .buildAndApplyConstrains()
        
        let descLabelCB = ConstraintBuilder(subview: descriptionLabel, superview: self)
        descLabelCB.constraint(subviewAttribute: .top, superviewAttribute: .top, constant: borderSpace)
            .constraint(subviewAttribute: .left, anotherView: seperatorView, anotherAttribute: .right, multiplier: 1.0, constant: borderSpace/2)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -borderSpace)
            .buildAndApplyConstrains()
    }
    
    func flipCell() {
        UIView.transition(with: self, duration: AnimationDuration.normal, options: .transitionFlipFromTop, animations: {})
    }
    
}



// END


struct Particle {
    var emitter: CAEmitterLayer
    var startDelay: Double
    var stopDelay: Double
    var soundName: String? = nil
    var soundType: String? = nil
    var loopSound: Bool = false
    
    init(emitter: CAEmitterLayer, startDelay: Double, stopDelay: Double,
         soundName: String? = nil, soundType: String? = nil, loopSound: Bool = false) {
        self.emitter = emitter
        self.startDelay = startDelay
        self.stopDelay = stopDelay
        self.soundName = soundName
        self.soundType = soundType
        self.loopSound = loopSound
    }
}

public class ParticleController {
    private var layer: CALayer
    private var particles: [Particle] = []
    private var soundPlayers: [AVAudioPlayer] = []
    private var isParticleAnimationRunning = false
    private let simulatorScreenWidth: CGFloat = 320
    private let simulatorScreenCenterPoint = CGPoint(x: 320.0/2.0, y: 44)
    private let simulatorScreenBottomCenterPoint = CGPoint(x: 320.0/2.0, y: 684)
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
                
                var soundPlayer: AVAudioPlayer?
                
                do {
                    if let resourceName = particle.soundName, let resourceType = particle.soundType, let urlString = Bundle.main.path(forResource: resourceName, ofType: resourceType) {
                        let url = URL(fileURLWithPath: urlString)
                        soundPlayer = try AVAudioPlayer(contentsOf: url)
                        soundPlayer?.prepareToPlay()
                        soundPlayer?.setVolume(1, fadeDuration: 0.5)
                        soundPlayer?.numberOfLoops = particle.loopSound ? -1 : 0
                        soundPlayers.append(soundPlayer!)
                    }
                } catch {
                    print("Couldn't play sound")
                }
                
                // start particle animation with delay
                DispatchQueue.main.asyncAfter(deadline: .now() + particle.startDelay, execute: {
                    soundPlayer?.play()
                    particle.emitter.beginTime = CACurrentMediaTime()
                    self.layer.addSublayer(particle.emitter)
                    self.stopParticleAnimation(ofParticle: particle, witAudioPlayer: soundPlayer)
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
            self.soundPlayers = []
        }
    }
    
    private func stopParticleAnimation(ofParticle particle: Particle, witAudioPlayer audioPlayer: AVAudioPlayer?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + particle.stopDelay) {
            particle.emitter.birthRate = 0.0
            audioPlayer?.stop()
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
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 5.0,
                                            soundName: "sound_birthday", soundType: "m4a", loopSound: false)
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
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 0.5,
                                            soundName: "sound_rocket", soundType: "m4a", loopSound: false)
                    result.append(particle)
                }
            }
            return result
        case .important:
            print("IMPORTANT PARTICLES")
            var result: [Particle] = []
            for _ in 0..<1 {
                if let emitter = getEmitter(forEventType: eventType) {
                    let delay = 0.0
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 5.0)
                    result.append(particle)
                }
            }
            return result
        case .holiday:
            print("HOLIDAY PARTICLES")
            var result: [Particle] = []
            for _ in 0..<1 {
                if let emitter = getEmitter(forEventType: eventType) {
                    let delay = 0.0
                    let particle = Particle(emitter: emitter, startDelay: delay, stopDelay: 5.0)
                    result.append(particle)
                }
            }
            return result
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
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint(x: simulatorScreenCenterPoint.x, y: 150)
            emitter.emitterShape = kCAEmitterLayerRectangle
            emitter.emitterSize = CGSize(width: particleRect.width, height: particleRect.height)
            
            var cells: [CAEmitterCell] = []
            
            for index in 0..<2 {
                let cell = CAEmitterCell()
                
                cell.birthRate = 1.7
                cell.lifetime = 3.5
                cell.spin = 0.0
                cell.spinRange = 3.0
                cell.scale = 0.02
                cell.scaleSpeed = 0.3
                cell.scaleRange = 0.15
                cell.alphaSpeed = -0.5

                switch index%2 {
                case 0: cell.contents = UIImage(named: "important1.png")!.cgImage
                case 1: cell.contents = UIImage(named: "important2.png")!.cgImage
                default: break
                }
                
                cells.append(cell)
            }
            
            emitter.emitterCells = cells
            
            return emitter
        case .holiday:
            print("HOLIDAY PARTICLES")
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = simulatorScreenBottomCenterPoint
            emitter.emitterShape = kCAEmitterLayerLine
            emitter.emitterSize = CGSize(width: 300, height: 30)
            
            var cells: [CAEmitterCell] = []
            
            for index in 0..<10 {
                let cell = CAEmitterCell()
                
                cell.birthRate = 2
                cell.lifetime = 5.0
                cell.lifetimeRange = 0
                cell.emissionLongitude = CGFloat.pi
                cell.spinRange = 0.7
                cell.scaleRange = 0.25
                cell.scale = 0.5
                cell.emissionRange = 0.71
                cell.velocityRange = 20.0
                cell.velocity = -247.0
                cell.yAcceleration = 109
                cell.contents = UIImage(named: "holiday\(index+1).png")!.cgImage
                
                cells.append(cell)
            }
            
            emitter.emitterCells = cells
            
            return emitter
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
        let colors: [UIColor] = [AppColor.Apple.blue,
                                 AppColor.Apple.green,
                                 AppColor.Apple.orange,
                                 AppColor.Apple.purple,
                                 AppColor.Apple.red,
                                 AppColor.Apple.yellow]
        let numberOfColors = colors.count
        let randomIndex = Int(arc4random_uniform(UInt32(numberOfColors)))
        return colors[randomIndex]
    }
    
    func image(fromText: Character) -> UIImage? {
        let size: CGFloat = 100.0
        let rect: CGRect = CGRect(x: 0, y: 0, width: size, height: size)
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        if let currentContext = UIGraphicsGetCurrentContext() {
            print("IN HERE")
            let label = UILabel(frame: rect)
            label.text = "\(fromText)"
            label.textAlignment = .center
            label.layer.render(in: currentContext)
            label.backgroundColor = UIColor.orange
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        } else {
            print("NOOOOOT in here!!")
        }
        
        return nil
    }
}


class ViewController: UIViewController {
    var calendarView: UICalendarView = UICalendarView()
    var calenderDayOverviewTableView = UICalendarDayOverviewTableView()
    
    var eventCtrl: EventController!
    var particleCtrl: ParticleController!
    
    var menuButton = MenuButton(frame: CGRect.zero)
    var expandingMenuButton1 = UIButton()
    var expandingMenuButton2 = UIButton()
    
    var eventFilters: [EventType] = EventType.allEventTypes
    
    var calendarRepresentation: CalendarRepresentation = .calendar
    
    var calendarHeightConstraint: NSLayoutConstraint!
    
    var selectedDate: Date = Date()

    var dataSource: UICalendarViewDataSource! {
        didSet {
            dataSource.datesWithEvent = eventCtrl.getDates(forFilter: eventFilters)
            calendarView.dataSource = dataSource
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCtrl = EventController(filter: eventFilters)
        
        particleCtrl = ParticleController(layer: self.view.layer)
        calenderDayOverviewTableView.register(UICalendarDayOverviewTableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationController?.navigationBar.tintColor = AppColor.Theme.main
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(selectToday))

        self.view.backgroundColor = UIColor.white
        
        selectToday()
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
        
        setup()
    }
    
    func setup() {
        // Expandable Menu
        expandingMenuButton1.setImage(calendarRepresentation.opositeImage, for: .normal)
        expandingMenuButton2.setImage(UIImage(named: "icon_filter_white.png"), for: .normal)
        
        expandingMenuButton1.addTarget(self, action: #selector(switchCalendarRepresentation), for: .touchUpInside)
        expandingMenuButton2.addTarget(self, action: #selector(showFilterScreen), for: .touchUpInside)
        
        menuButton.append(expandingView: expandingMenuButton1)
        menuButton.append(expandingView: expandingMenuButton2)
        
        let menuButtonHeight: CGFloat = 50.0
        
        menuButton.frame = CGRect(x: 0, y: 0,
                                  width: menuButtonHeight, height: menuButtonHeight)
        menuButton.center = CGPoint(x: 330, y: 630)
        menuButton.addTarget(self, action: #selector(toggleButtonMenu(_:)), for: .touchUpInside)
        menuButton.titleLabel?.adjustsFontSizeToFitWidth = true
        menuButton.titleLabel?.font = UIFont(name: "Helvetica", size: 31.0)
        menuButton.setTitle("+", for: .normal)
        menuButton.backgroundColor = UIColor.black
        menuButton.layer.cornerRadius = menuButton.frame.width/2
        menuButton.expandingDirection = .degree(225)
        self.view.addSubview(menuButton)
    }

    func setupConstraints() {
        // Set Calendar Constraints
        let constraintBuilder = ConstraintBuilder(subview: calendarView, superview: self.view)
        constraintBuilder.constraint(subviewAttribute: .top, superviewAttribute: .top, multiplier: 1.0, constant: 44.0)
            .constraint(subviewAttribute: .left, superviewAttribute: .left, multiplier: 1.0, constant: 0.0)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, multiplier: 1.0, constant: 0.0)
            .buildAndApplyConstrains()
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendarView,
                                                      attribute: .height, relatedBy: .equal,
                                                      toItem: nil, attribute: .notAnAttribute,
                                                      multiplier: 1.0, constant: 300.0)
        self.view.addConstraint(calendarHeightConstraint)
        
        ConstraintAssistant.addConstraints(on: calenderDayOverviewTableView,
                                           inSuperView: self.view,
                                           withTopView: calendarView)
    }
    
    @objc func selectToday() {
        let today = Date()
        selectedDate = today
        reloadWith(date: today)
    }
    
    func reloadWith(date: Date) {
        calenderDayOverviewTableView.data = eventCtrl.getEvents(forDate: date, andFilters: eventFilters)
        calenderDayOverviewTableView.selectedDate = date
        calenderDayOverviewTableView.reloadData()
        dataSource = UICalendarViewDataSource(date: date)
        calendarView.delegate = self
        calendarView.drawCalendar()
    }
    
    @objc func toggleButtonMenu(_ sender: MenuButton? = nil) {
        menuButton.toggle(onView: view)
    }
    
    @objc func switchCalendarRepresentation() {
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            toggleCalendarRepresentation()
            adjustCalendarConstraintForRepresentationMode()
        }
    }
    
    func toggleCalendarRepresentation() {
        switch calendarRepresentation {
        case .calendar: calendarRepresentation = .list
        case .list: calendarRepresentation = .calendar
        }
        self.expandingMenuButton1.setImage(self.calendarRepresentation.opositeImage, for: .normal)
    }
    
    func adjustCalendarConstraintForRepresentationMode() {
        var calendarHeight: CGFloat
        switch calendarRepresentation {
        case .list:
            calendarHeight = 0.0
        case .calendar:
            calendarHeight = 300.0
        }
        calendarHeightConstraint?.constant = calendarHeight
        reloadWith(date: selectedDate)
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func showFilterScreen() {
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            let filterVCtrl = FilterEventTypesViewController()
            filterVCtrl.selectedFilter = eventFilters
            filterVCtrl.filterDelegate = self
            navigationController?.pushViewController(filterVCtrl, animated: true)
        }
    }
    
    enum CalendarRepresentation {
        case list
        case calendar
        
        var image: UIImage? {
            switch self {
            case .list: return UIImage(named: "icon_list_white.png")
            case .calendar: return UIImage(named: "icon_calendar_white.png")
            }
        }
        
        var opositeImage: UIImage? {
            switch self {
            case .list: return  UIImage(named: "icon_calendar_white.png")
            case .calendar: return UIImage(named: "icon_list_white.png")
            }
        }
    }
}


extension ViewController: UICalendarViewDelegateProtocol {
    func calendarView(_ calendarView: UICalendarView, didSelectedDate selectedDate: Date) {
        self.selectedDate = selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.title = dateFormatter.string(from: selectedDate)
        let eventsOnSelectedDay = eventCtrl.getEvents(forDate: selectedDate, andFilters: eventFilters)
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

extension ViewController: FilterEventTypesDelegate {
    func receiveNew(filterSelection: [EventType]) {
        eventFilters = filterSelection
        reloadWith(date: selectedDate)
    }
}

protocol FilterEventTypesDelegate {
    func receiveNew(filterSelection: [EventType])
}

class FilterEventTypesViewController: UITableViewController {
    var selectedFilter: [EventType]!
    
    var filterDelegate: FilterEventTypesDelegate?
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filterDelegate?.receiveNew(filterSelection: selectedFilter)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventType.allEventTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let eventType = getEventType(atIndexPath: indexPath)
        cell.textLabel?.text = "\(eventType.symbol)\(eventType.name)"
        cell.accessoryType = isSelected(eventType: eventType) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEventType = getEventType(atIndexPath: indexPath)
        if selectedFilter.contains(selectedEventType) {
            remove(selectedEventType: selectedEventType)
        } else {
            selectedFilter.append(selectedEventType)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func getEventType(atIndexPath indexPath: IndexPath) -> EventType {
        return EventType.allEventTypes[indexPath.row]
    }
    
    func isSelected(eventType: EventType) -> Bool {
        return selectedFilter.contains(eventType)
    }
    
    func remove(selectedEventType: EventType) {
        for index in 0..<selectedFilter.count {
            let eventType = selectedFilter[index]
            if eventType == selectedEventType {
                selectedFilter.remove(at: index)
                break
            }
        }
    }
}


let vCtrl = ViewController()
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl









