/*:
 [Go to Demo](@next)
 
 ## IMPORTANT
 
 Most of the time if the Playground-Project is startet for the first time it shows that it's missing files. It appears with storing the files in the "Source"-folder. My assumption is that Playground tries to start the project without having all files completly compiled... I really hope that this don't effect the judgment process. I already startet a tread in the WWDC Schoolarship Forum and other developers seem to have the same problem. Thank you :)
 

 
 # About:
 I ❤️ creating UIElements so I decided to create my own Calendar. Then I had the idea to play a small particle animation to the diferent types of events. To get faster into the zusammenhänge of the different parameters I created a Particle Creator, mit dem all meine Animationen erstellt wurden.
 
 
 ### Author:
 [Marcel Hagmann 👨‍💻](http://marcelhagmann.de)
 
 
 # Features:
 
 ### UICalendarView 📅
 With this UICalendarView it is super easy to give the user a well looking overview about his upcoming events. The user can navigation between the months and select a day to get a detail overview about the events on that selected day. Days that contain a event are highlighted different so that the user can see his events faster.
 
 ![title](info_uicalendarview.gif  width="193" height="207")
 
 
 
 ### UIOverview 🔍
 The UICalendarOverview is an extension to the UICalendarView and represents the events of the selected day in the calendar. With a touch on a cell an animation will appear depended of the selected event. Each EventType has it's own animation. There are six different type of events.
 
 ![title](info_uicalendardayoverviewtableviewcell.png width="252" height="60")
 
 ### Filter Event Types ⚙️
 In a real world situation the user could could add a lot of eventy and by the time the calendar will be overcrowded. To still guarntee a good overview the user can filter and select which type of events should be shown.
 
![title](info_filter.gif width="191" height="189")
 
 ### UIButtonMenu ⏫
 A touch on the button will expand the menu with a soft animation. Great if the user has the option to select between different actions without to occupy to much of the view.
 
 ![title](info_menubutton.gif width="186" height="180")
 
 
 ## 
 
 # Used Technolgy
 
 ### CAEmitterLayer & CAEmitterCell
 Is used for the different event type animations. E.g. the birthday event will play a confetti animation.
 
 ### UIViewPropertyAnimator
 Is used to animate the UIMenuButton. The advatage is in comparison to the UIView.animate that the UIElements are touchable durring the animation.
 
 
 ### CAKeyframeAnimation
 The CAKeyframeAnimation objects animates the apple logo to the calculatet CGPath.
 
  ![title](info_jumpingintro.gif)
 
 
 ### UIKit
 The complete calendar was created by my own with the UIKit.
 
 ### AVFoundation
 The 'Birthday' and 'New Year' events providing sounds and is played together with the particle effect. I apologize for beeing a developer and not a sound designer 😅
 
 
 
  # Annotation
 
 ### First Start
 Running the app for the first time might be a little bit of a wait, but it's **well worth the wait** 😄
 
 ### Music 🔉
 Two events provide sounds while they are playing. Don't forget to turn up the volume :)

 [Go to Demo](@next)
 
*/
