#CardSliderView for iOS

##About

My app imitates a deck of cards. It didn't take long to realize that while UIPageViewController has the exact behavior I wanted, it doesn't actually allow you to change the transition style. (Well, it does, but there's only one transition style.)

The transition style I wanted was for each page to be completely rigid, like a card, with no bending animation.

So that's the intention of CardSliderView. The idea behind CardSliderView is that you've got a deck of cards, and want to flip through them naturally. 

As you swipe from right to left, the next card in your deck comes on screen, and passes on top of the current card. When you swipe from left to right, the current card pushes off-screen to the right and reveals the previous card sitting underneath it.

For a video of this concept in action, see http://www.storyskeleton.com.

##Using CardSliderView

CardSliderView is just a UIView subclass, not a UIViewController like UIPageViewController. Use it as follows:

1. Drop CardSliderView.h and CardSliderView.m into your project
2. Create an instance of CardSliderView, just like any other UIView
3. Specify a class as the CardSliderDataSource
3. Implement the CardSliderDataSource methods

For a sample impementation of the CardSliderDataSource methods, take a look at the Sample Project.

Thanks for looking at CardSliderView for iOS! Let me know about any problems, suggestions, or comments you have.
