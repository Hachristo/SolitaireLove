# SolitaireLove

**Programming Patterns Used**
I used the update programming pattern for essentially all of this project. My reasoning for this intially was that I felt that the project would be 
simple enough that implementing more complex patterns would save less time in the production phase of the project than it would take to set them up
in the preproduction phase. Looking back on it now, I regret having chosen to do this, as it made my code less and less readable the more I added. I
did my best to seperate functionality with an object oriented mindset, but debugging became a problem the more I added, and led to me running out of
time to fix everything. I have some ideas for how I could've used other programming patterns, which I'll detail in the postmortem section.

**Postmortem**
To start with a positive, I think that I did a good job with making seperate classes and keeping main relatively empty. Looking at the classes (tables),
it's clear what each one's purpose is, and many of them inherit functionality from other classes appropriately.
Looking back, I realized that there were a few programming patterns that we've been going over in class that I should've employed here. The first thing that
comes to mind is the flyweight pattern in relation to cards. I'm not sure how much performance would've been saved, but an obvious way to implement the
flyweight pattern would've been to have the cards all draw their back sprite on the fly, rather than each drawing their own version of the same sprite.
Another pattern that might've helped especially with debugging is the observer pattern. Using events and listeners to recognize things like mouse up, mouse down,
card stacking, and card removing would've removed the need for many of the update loops, which would've improved performance, but more importantly would've helped
keep my code more readable.

**Asset List**
Sprites: https://kenney.nl/assets/playing-cards-pack