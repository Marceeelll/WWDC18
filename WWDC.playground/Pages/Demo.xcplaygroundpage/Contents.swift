/*:
 # Demo:
 [ ◀️ Back to Info](@previous)
 */

import UIKit

//: die Farben des Kalenders können ganz einfach verändert werden
let calendarMainColor: UIColor = UIColor.red

//: bestimme ganz einfach, mit welchem Wochentag der Kalender beginnen soll
let weekday = UICalendarWeekday.wednesday


//: ein Kalender eintrag kannst du ganz einfach hinzufügen

let eventName: String = ""

//: set the start Date with the following format
//: yyyy-MM-dd hh:mm
let startDate: String = "2018-03-26 09:41"

//: set the end Date with the following format
//: yyyy-MM-dd hh:mm
let endDate: String = "2018-03-26 09:41"

//: setze das den event type
//let eventType: EventType = .none

//: streckt sich das Event über den ganzen Tag, oder ist geht es genau von start bis end Datum?
let isFullTime: Bool = false

//let createdEvent = Event(title: <#T##String#>, startDate: <#T##Date#>, endDate: <#T##Date#>, type: <#T##EventType#>, isFullTime: <#T##Bool#>)


let showEventTypes: [EventType] = [EventType.birthday, .wwdc]
