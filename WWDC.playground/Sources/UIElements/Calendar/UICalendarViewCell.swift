import UIKit

public class UICalendarViewCell: UIView {
    // MARK: - Instance Variable
    public var dateLabel: UILabel!
    
    private let markerSize: CGFloat = 5.0
    
    private var hasDoneWorkoutView: UIView!
    private var isSelectedView: UIView!
    
    private var isSelectedMonth = false
    private var hasDoneWorkout = false
    private var isToday = false
    
    public var date: Date!
    
    
    // MARK: - Delegates
    public weak var delegate: UICalendarViewCellDelegate?
    
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        isSelectedView = UIView()
        self.addSubview(isSelectedView)
        
        hasDoneWorkoutView = UIView(frame: CGRect(x: 0, y: 0, width: markerSize, height: markerSize))
        hasDoneWorkoutView.alpha = 0.0
        hasDoneWorkoutView.layer.cornerRadius = hasDoneWorkoutView.frame.width/2
        self.addSubview(hasDoneWorkoutView)
        
        dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.textColor = AppColor.Calendar.text
        self.addSubview(dateLabel)
        
        setUpConstraints()
    }
    
    
    // MARK: - Instance Methods
    public func set(isSelectedMonth: Bool, hasDoneWorkout: Bool, isToday: Bool) {
        self.isSelectedMonth = isSelectedMonth
        self.hasDoneWorkout = hasDoneWorkout
        self.isToday = isToday
        
        setUpCellColors()
    }
    
    public func deselectCell() {
        setUpCellColors()
    }
    
    /**
     Changes the appereance of the cell after the cell has been selected or deselected.
     */
    private func setUpCellColors() {
        isSelectedView.backgroundColor = backgroundColor
        if isToday && hasDoneWorkout {
            isTodayWithWorkout()
        } else if isToday {
            isTodayDay()
        } else if isSelectedMonth && hasDoneWorkout {
            isNormalMonthWithWorkoutDay()
        } else if !isSelectedMonth && hasDoneWorkout {
            isOutsideSelectedMonthWorkoutDay()
        } else if !isSelectedMonth {
            isOutsideSelectedMonthDay()
        } else {
            isNormalMonthDay()
        }
    }
    
    private func isTodayDay() {
        dateLabel.textColor = AppColor.Theme.main
    }
    
    private func isTodayWithWorkout() {
        dateLabel.textColor = AppColor.Theme.main
        hasDoneWorkoutView.backgroundColor = AppColor.Theme.main
    }
    
    private func isNormalMonthDay() {
        dateLabel.textColor = AppColor.Calendar.text
    }
    
    private func isNormalMonthWithWorkoutDay() {
        dateLabel.textColor = AppColor.Calendar.text
        hasDoneWorkoutView.backgroundColor = AppColor.Calendar.trainingMarker
    }
    
    private func isOutsideSelectedMonthDay() {
        dateLabel.textColor = AppColor.Calendar.otherMonth
    }
    
    private func isOutsideSelectedMonthWorkoutDay() {
        dateLabel.textColor = AppColor.Calendar.otherMonth
        hasDoneWorkoutView.backgroundColor = AppColor.Calendar.otherMonth
    }
    
    private func setUpConstraints() {
        // Date Label
        //        ConstraintAssistant.addConstraints(on: dateLabel, andMatchTheSameSizeAsView: self)
        ConstraintAssistant.addConstraints(on: dateLabel, centerInSuperview: self)
        
        // Small Circle - Training Marker
        hasDoneWorkoutView.translatesAutoresizingMaskIntoConstraints = false
        // Rules: (damit auch auf kleinen Geräten wie iPhone 5 korrekt)
        //          - Abstand von label.bottom zu self.bottom > markerSize --> dann den Marker an label.bottom anheften
        //          - Abstand von label.bottom zu self.bottom < markerSize --> dann den Marker an self.bottom anheften
        let centerX = NSLayoutConstraint(item: hasDoneWorkoutView,
                                         attribute: .centerX, relatedBy: .equal,
                                         toItem: self, attribute: .centerX,
                                         multiplier: 1.0, constant: 0.0)
        let height = NSLayoutConstraint(item: hasDoneWorkoutView,
                                        attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: markerSize)
        let width = NSLayoutConstraint(item: hasDoneWorkoutView,
                                       attribute: .width, relatedBy: .equal,
                                       toItem: nil, attribute: .notAnAttribute,
                                       multiplier: 1.0, constant: markerSize)
        var variableConstraint: NSLayoutConstraint!
        
        
        // der folgende Teil wird wird verzögert aufgerufen.
        // Grund: Die Konstanten der Constraints werden anhand der Bildschirmgröße berechnet.
        //          Diese sind erst nach der vollständigen Initialisierung vorhanden
        //          Aus diesem Grund wird ein Moment gewartet, und dann verzögert gesetzt.
        //          Dieser Teil kann gelöscht werden, wenn die Constraints korrekt gesetzt wurden und nicht berechnet werden.
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.changeBackgroundSpeedSuperFast) {
            if self.shouldDocToBottom() {
                variableConstraint = NSLayoutConstraint(item: self.hasDoneWorkoutView,
                                                        attribute: .bottom, relatedBy: .equal,
                                                        toItem: self, attribute: .bottom,
                                                        multiplier: 1.0, constant: 0.0)
            } else {
                variableConstraint = NSLayoutConstraint(item: self.hasDoneWorkoutView,
                                                        attribute: .top, relatedBy: .equal,
                                                        toItem: self.dateLabel, attribute: .bottom,
                                                        multiplier: 1.0, constant: 0.0)
            }
            
            self.addConstraints([centerX, height, width, variableConstraint])
            
            self.animateWorkoutMarkerAppearing()
        }
    }
    
    /*
     Da der Screen des iPhone 5 kleiner ist, muss die Celle komplett ausgenutzt werden.
     Diese Methode berechnet, ob es abstand gelassen werden kann oder ob der Cellen-Inhalt an den Boden gehäftet werden muss
     True = An Boden heften (z.B. beim iPhone 5)
     */
    private func shouldDocToBottom() -> Bool {
        return self.bounds.height - (dateLabel.bounds.height + markerSize*2) < markerSize
    }
    
    private func animateWorkoutMarkerAppearing() {
        UIView.animate(withDuration: AnimationDuration.changeBackgroundSpeed) {
            self.hasDoneWorkoutView.alpha = 1.0
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.calendarViewCell(self)
        cellWasSelected()
    }
    
    private func cellWasSelected() {
        ConstraintAssistant.addConstraints(on: isSelectedView, makeSquareInSuperview: self)
        isSelectedView.layer.cornerRadius = bounds.height / 2
        isSelectedView.backgroundColor = AppColor.Calendar.selectedToday
        dateLabel.textColor = AppColor.Calendar.selectedDayText
        if hasDoneWorkout {
            self.hasDoneWorkoutView.backgroundColor = AppColor.Calendar.selectedDayText
        }
    }
}
