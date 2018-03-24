import Foundation

public class EventController {
    private var events: [Event] = []
    public var filter: [EventType] = []
    
    public init(filter: [EventType], events: [Event]) {
        self.filter = filter
        self.events = events
        createDemonstrationEvents()
    }
    
    private func createDemonstrationEvents() {
        let interval: TimeInterval = 60*5
        events += [Event(title: "BIRTHDAY",
                        startDate: Date(),
                        endDate: Date(timeIntervalSinceNow: interval),
                        type: .birthday, isFullTime: false),
                  Event(title: "CHRISTMAS",
                        startDate: Date(timeIntervalSinceNow: interval),
                        endDate: Date(timeIntervalSinceNow: interval*2),
                        type: .christmas, isFullTime: false),
                  Event(title: "HOLIDAY",
                        startDate: Date(timeIntervalSinceNow: interval*2),
                        endDate: Date(timeIntervalSinceNow: interval*3),
                        type: .holiday, isFullTime: false),
                  Event(title: "IMPORTANT",
                        startDate: Date(timeIntervalSinceNow: interval*3),
                        endDate: Date(timeIntervalSinceNow: interval*4),
                        type: .important, isFullTime: false),
                  Event(title: "NEW YEAR",
                        startDate: Date(timeIntervalSinceNow: interval*4),
                        endDate: Date(timeIntervalSinceNow: interval*5),
                        type: .newYear, isFullTime: false),
                  Event(title: "NO CATEGORY",
                        startDate: Date(timeIntervalSinceNow: interval*5),
                        endDate: Date(timeIntervalSinceNow: interval*6),
                        type: .none, isFullTime: false),
                  Event(title: "WWDC",
                        startDate: Date(timeIntervalSinceNow: interval*6),
                        endDate: Date(timeIntervalSinceNow: interval*7),
                        type: .wwdc, isFullTime: false),
                  Event(title: "WWDC Scholarship Result",
                        startDate: Date(timeIntervalSince1970: 1524225600),
                        endDate: Date(timeIntervalSince1970: 1524240000),
                        type: .important, isFullTime: false),
                  Event(title: "WWDC Submission",
                        startDate: Date(timeIntervalSince1970: 1522054800),
                        endDate: Date(timeIntervalSince1970: 1522558800),
                        type: .important, isFullTime: false),
                  Event(title: "WWDC Submission Deadline",
                        startDate: Date(timeIntervalSince1970: 1522555200),
                        endDate: Date(timeIntervalSince1970: 1522558800),
                        type: .important, isFullTime: true),
                  Event(title: "WWDC 2018",
                        startDate: Date(timeIntervalSince1970: 1528108860),
                        endDate: Date(timeIntervalSince1970: 1528480800),
                        type: .wwdc, isFullTime: false),
                  Event(title: "New Year 2017",
                        startDate: Date(timeIntervalSince1970: 1483261200),
                        endDate: Date(timeIntervalSince1970: 1483264800),
                        type: .newYear, isFullTime: true),
                  Event(title: "New Year 2018",
                        startDate: Date(timeIntervalSince1970: 1514797200),
                        endDate: Date(timeIntervalSince1970: 1514800800),
                        type: .newYear, isFullTime: true),
                  Event(title: "Independence Day",
                        startDate: Date(timeIntervalSince1970: 1530694800),
                        endDate: Date(timeIntervalSince1970: 1530698400),
                        type: .holiday, isFullTime: true),
                  Event(title: "Martin Luther King Jr. Day",
                        startDate: Date(timeIntervalSince1970: 1516006800),
                        endDate: Date(timeIntervalSince1970: 1516010400),
                        type: .holiday, isFullTime: true),
                  Event(title: "Memorial Day",
                        startDate: Date(timeIntervalSince1970: 1527498000),
                        endDate: Date(timeIntervalSince1970: 1527501600),
                        type: .holiday, isFullTime: true),
                  Event(title: "Thanksgiving",
                        startDate: Date(timeIntervalSince1970: 1542877200),
                        endDate: Date(timeIntervalSince1970: 1542880800),
                        type: .holiday, isFullTime: true),
                  Event(title: "Black Friday",
                        startDate: Date(timeIntervalSince1970: 1542963600),
                        endDate: Date(timeIntervalSince1970: 1543003200),
                        type: .important, isFullTime: false)]
        
        let birthdayCtrl = BirthdayController()
        if var marcel = birthdayCtrl.createPerson(name: "Marcel Hagmann", birthdayDay: 1, birthdayMonth: 10, birthdayYear: 1994) {
            marcel.annotation = "me"
            events += birthdayCtrl.addPersonToCalendar(person: marcel)
        }
        
        if var denise = birthdayCtrl.createPerson(name: "Denise Hagmann", birthdayDay: 12, birthdayMonth: 4, birthdayYear: 1997) {
            denise.annotation = "sister"
            events += birthdayCtrl.addPersonToCalendar(person: denise)
        }
    }
    
    
    public func getEvents(forDate date: Date, andFilters filters: [EventType]) -> [Event] {
        var result: [Event] = []
        for event in events {
            if event.isDateBetweenStartAndEndDate(dateToCheck: date) && filters.contains(event.type) {
                result.append(event)
            }
        }
        return result
    }
    
    public func getDates(forFilter filters: [EventType]) -> [Date] {
        var dateSet: Set<Date> = []
        for event in events {
            for date in event.getDatesBetweenStartAndEnd() {
                if filters.contains(event.type) {
                    dateSet.insert(date)
                }
            }
        }
        return Array(dateSet)
    }
}
