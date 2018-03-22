import Foundation

public class EventController {
    public var events: [Event] = []
    public var dates: [Date] = []
    
    public init() {
    }
    
    public func createDemonstrationEvents() {
        let halfAHour: TimeInterval = 60*30
        events = [Event(title: "BIRTHDAY",
                        startDate: Date(),
                        endDate: Date(timeIntervalSinceNow: halfAHour),
                        type: .birthday, isFullTime: false),
                  Event(title: "CHRISTMAS",
                        startDate: Date(timeIntervalSinceNow: halfAHour),
                        endDate: Date(timeIntervalSinceNow: halfAHour*2),
                        type: .christmas, isFullTime: false),
                  Event(title: "HOLIDAY",
                        startDate: Date(timeIntervalSinceNow: halfAHour*2),
                        endDate: Date(timeIntervalSinceNow: halfAHour*3),
                        type: .holiday, isFullTime: false),
                  Event(title: "IMPORTANT",
                        startDate: Date(timeIntervalSinceNow: halfAHour*3),
                        endDate: Date(timeIntervalSinceNow: halfAHour*4),
                        type: .important, isFullTime: false),
                  Event(title: "NEW YEAR",
                        startDate: Date(timeIntervalSinceNow: halfAHour*4),
                        endDate: Date(timeIntervalSinceNow: halfAHour*5),
                        type: .newYear, isFullTime: false),
                  Event(title: "NONE",
                        startDate: Date(timeIntervalSinceNow: halfAHour*5),
                        endDate: Date(timeIntervalSinceNow: halfAHour*6),
                        type: .none, isFullTime: false),
                  Event(title: "WWDC",
                        startDate: Date(timeIntervalSinceNow: halfAHour*6),
                        endDate:Date(timeIntervalSinceNow: halfAHour*7),
                        type: .wwdc, isFullTime: false),
                  Event(title: "Denise Hagmann's Birthday (Sister)",
                        startDate: Date(timeIntervalSince1970: 1523523600),
                        endDate: Date(timeIntervalSince1970: 1523527200),
                        type: .birthday, isFullTime: true),
                  Event(title: "Marcel Hagmann's Birthday (Me)",
                        startDate: Date(timeIntervalSince1970: 1538384400),
                        endDate: Date(timeIntervalSince1970: 1538388000),
                        type: .birthday, isFullTime: true),
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
        
        var dateSet: Set<Date> = []
        for event in events {
            for date in event.getDatesBetweenStartAndEnd() {
                dateSet.insert(date)
            }
        }
        dates = Array(dateSet)
    }
    
    public func getEvents(forDate date: Date) -> [Event] {
        var result: [Event] = []
        for event in events {
            if event.isDateBetweenStartAndEndDate(dateToCheck: date) {
                result.append(event)
            }
        }
        return result
    }
}
