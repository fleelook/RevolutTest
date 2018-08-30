# RevolutTest

This is the test task for Revolut I implemented recently. 

It took me two evenings to write and the main objective was to demonstrate the way I write code and the technology stack I use (ReactiveSwift and IGListKit). 
This is not a real production-ready app obviously and it has some limitations (for example, input is not validated, which is something I am perfectly aware of) but than again: it was aimed to give a glimpse of what the code I produce looks like.

This is the task I was given:

"You should implement one screen with a list of currencies

The app must download and update rates every 1 second using API
https://revolut.duckdns.org/latest?base=EUR.
List all currencies you get from the endpoint (one per row). Each row has an input where you
can enter any amount of money. When you tap on currency row it should slide to top and its
input becomes first responder. When you’re changing the amount the app must simultaneously
update the corresponding value for other currencies.
Use swift programming language and any libraries you want. UI does not have to be exactly the
same, it’s up to you."
