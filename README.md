# WWDC 18 Submission

This is my WWDC Submission for 2018 This project was rewarded a scholarship :)
by Marcel Hagmann 👨‍💻



## Features:

### UICalendarView 📅
With this UICalendarView it is super easy to give the user a well looking overview about his upcoming events. The user can navigation between the months and select a day to get a detail overview about the events on that selected day. Days that contain a event are highlighted different so that the user can see his events faster.

![alt text](http://marcelhagmann.de/wp-content/uploads/2018/05/info_uicalendarview.gif "Preview")



### UIOverview 🔍
The UICalendarOverview is an extension to the UICalendarView and represents the events of the selected day in the calendar. With a touch on a cell an animation will appear depended of the selected event. Each EventType has it's own animation. There are six different type of events.

![alt text](http://marcelhagmann.de/wp-content/uploads/2018/05/info_uicalendardayoverviewtableviewcell.png "Preview")

### Filter Event Types ⚙️
In a real world situation the user could could add a lot of eventy and by the time the calendar will be overcrowded. To still guarntee a good overview the user can filter and select which type of events should be shown.

![alt text](http://marcelhagmann.de/wp-content/uploads/2018/05/info_filter.gif "Preview")

### UIButtonMenu ⏫
A touch on the button will expand the menu with a soft animation. Great if the user has the option to select between different actions without to occupy to much of the view.

![alt text](http://marcelhagmann.de/wp-content/uploads/2018/05/info_menubutton.gif "Preview")



## Used Technolgy

### CAEmitterLayer & CAEmitterCell
Is used for the different event type animations. E.g. the birthday event will play a confetti animation.

### UIViewPropertyAnimator & CAKeyframeAnimation
Is used the UIViewPropertyAnimator to animate the UIMenuButton. The CAKeyframeAnimation objects animates the apple logo to the calculatet CGPath.


![alt text](http://marcelhagmann.de/wp-content/uploads/2018/05/info_jumpingintro.gif "Preview")


### UIKit
The complete calendar was created by my own with the UIKit.

### AVFoundation
The 'Birthday' and 'New Year' events providing sounds and is played together with the particle effect. I apologize for beeing a developer and not a sound designer 😅


