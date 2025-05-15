# SolitaireLove  
  
**Programming Patterns Used**  
I used the state for the cards; cards have 3 seperate states: idle, mouse_over, and grabbed. Each card's state is updated depending on which tableau
it resides in, and what position it takes in the tableau. This makes it much easier to keep track and update how each card should work when interacted with,
rather than having to check elsewhere or invoke a lengthy list of conditionals in place, I can simply check the state to what should happen.
Though I didn't know the difference at the time, I used the prototype pattern extensively in this project. Each card and pile is an example of a prototype,
implemented through lua's table/metatable datatypes. The most prominent examples are in the card and pile prototypes, which I cloned at the start of the game
to create the tableaus and populate them with cards. If I didn't use this pattern, I would've had to define everything within a single file and had to have 
written a lot more redundant code.

**Feedback**  
I got feedback from Drew Whitmer on how I could clean up some of the clutter in my files. I deleted a lot of commented out code from older iterations of
the project, and added more inline comments, mainly in grabber, to explain what my code was doing.

**Postmortem**  
One of the main things that gave me problems in my refactor for this iteration of the project was the card stacking when dragging cards. I resolved to do this
by changing the held object variable in my grabber class to be a table containing all the cards that I wanted to drag. I was stuck for a while trying to accomplish
this because my grabber class kept getting longer and longer as I added more functionality to it, and I spent hours trying to debug what ended up being a small
error where I was trying to check if the table of held cards was empty by comparing to an empty table rather than checking the length. This resulted in one of my
many guards failing to catch a nil value which I thought was occuring much deeper into the process of grabbing cards. Ultimately I was able to implement card stacking,
and while I think the way that I did it was ultimately worth it for how modular it could be for future iterations, I should've made more of an effort to seperate functionality
into other functions within the grabber class to lessen the amount of code I was looking at at once when debugging.

**Asset List**  
Sprites: https://kenney.nl/assets/playing-cards-pack