import Foundation


public struct Person {
    var name: String
    var birthday: Date
    var annotation: String
    var age: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthday, to: Date())
        return components.year ?? 0
    }
    
    init(name: String, birthday: Date) {
        self.name = name
        self.birthday = birthday
        self.annotation = ""
    }
}

public struct BirthdayController {
    public init() {}
    
    public func createPerson(name: String, birthdayDay: Int,
                      birthdayMonth: Int, birthdayYear: Int) -> Person? {
        let birthdayString = String(format: "%02d.%02d.%04d", arguments: [birthdayDay, birthdayMonth, birthdayYear])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatter.date(from: birthdayString) {
            let person = Person(name: name, birthday: date)
            return person
        } else {
            return nil
        }
    }
    
    public func addPersonToCalendar(person: Person) -> [Event] {
        var birthdayEvents: [Event] = []
        for index in -5..<5 {
            let eventYears = person.age + index
            
            if let eventDate = Calendar.current.date(byAdding: .year, value: eventYears, to: person.birthday) {
                var spelling = ""
                switch eventYears%10 {
                case 1: spelling = "st"
                case 2: spelling = "nd"
                case 3: spelling = "rd"
                default: spelling = "th"
                }
                let annotation = person.annotation.isEmpty ? "" : "(\(person.annotation))"
                let birthdayEvent = Event(title: "\(person.name)’s \(eventYears)\(spelling) Birthday \(annotation)", startDate: eventDate,
                                          endDate: eventDate, type: .birthday, isFullTime: true)
                birthdayEvents.append(birthdayEvent)
            }
            
        }
        return birthdayEvents
    }
}
