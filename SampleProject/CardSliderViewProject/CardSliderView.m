//
//  CardSliderView.m
//  CardSliderViewProject
//
//  Copyright 2012 David Sweetman
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "CardSliderView.h"

#define kTransitionCardFrame CGRectMake(cardScroller.frame.size.width*2, 0, cardScroller.frame.size.width, cardScroller.frame.size.height);
#define kActiveCardFrame CGRectMake(cardScroller.frame.size.width, 0, cardScroller.frame.size.width, cardScroller.frame.size.height);
#define kFauxCardFrame CGRectMake(0, 0, cardScroller.frame.size.width, cardScroller.frame.size.height);


@interface CardSliderView() {
	// The cardScroller is how we swipe from card to card. It is 3x as wide as self.frame.width, so 
	// we can always scroll 1 card-width left or right.  A completed scroll (scrollViewDidEndDecelerating) 
	//immediately re-centers cardScroller, so it is ready for the next scroll.
	UIScrollView *cardScroller;
	UIView *transitionCardShell;
	UIView *activeCard;
	UIView *transitionCard;
	BOOL didStartScrollingNext;
	BOOL didStartScrollingPrev;
	
	BOOL startedIncompleteNextScroll;
	BOOL startedIncompletePreviousScroll;
		
	UIView *incomingCardView;
	UIView *currentCardView;
	
	//dimmer is only used to create visual separation betw. background & foreground cards while swiping
	UIView *dimmer;
	
}
@end


@implementation CardSliderView

@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setupCardViews];
    }
    return self;
}

- (void)awakeFromNib {
	[self setupCardViews];
}

- (void)didMoveToWindow {
	incomingCardView = [self.dataSource viewForCurrentCardForCardSlider:self];
	[activeCard addSubview:incomingCardView];
	[cardScroller addSubview:activeCard];
	
}

- (void)setupCardViews {
	self.backgroundColor = [UIColor clearColor];
	
	cardScroller = [[UIScrollView alloc] initWithFrame:self.frame];
	cardScroller.contentSize = CGSizeMake(self.frame.size.width*3, self.frame.size.height);
	cardScroller.contentOffset = CGPointMake(cardScroller.frame.size.width, 0);
	cardScroller.backgroundColor = [UIColor clearColor];
	cardScroller.pagingEnabled = YES;
	cardScroller.delegate = self;
	cardScroller.showsHorizontalScrollIndicator = NO;
	cardScroller.showsVerticalScrollIndicator = NO;
	[cardScroller setBounces:NO];
	
	activeCard = [[UIScrollView alloc] init];
	activeCard.frame = kActiveCardFrame;
	transitionCard = [[UIScrollView alloc] initWithFrame:cardScroller.frame];
	transitionCardShell = [[UIScrollView alloc] initWithFrame:cardScroller.frame];
	
	if (self.dataSource) {
		incomingCardView = [self.dataSource viewForCurrentCardForCardSlider:self];
		[activeCard addSubview:incomingCardView];
		UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		white.backgroundColor = [UIColor whiteColor];
		[activeCard addSubview:white];
		[cardScroller addSubview:activeCard];
	}
	
	dimmer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardScroller.frame.size.width, cardScroller.frame.size.height)];
	dimmer.backgroundColor = [UIColor blackColor];
	dimmer.alpha = 0;
	
	[transitionCardShell addSubview:transitionCard];
	[transitionCardShell addSubview:dimmer];
	[self addSubview:transitionCardShell];
	[self addSubview:cardScroller];

}

#pragma mark - ScrollView Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (scrollView.contentOffset.x > scrollView.contentSize.width/3+1) {
		// NEW CARD COMING FROM RIGHT <---x
		
		if (!didStartScrollingNext) {
			
			if (startedIncompletePreviousScroll) {
				startedIncompletePreviousScroll = NO;
				currentCardView = [self.dataSource viewForNextCardForCardSlider:self];
			}
			if (!startedIncompleteNextScroll) {
				startedIncompleteNextScroll = YES;
				startedIncompleteNextScroll = YES;
				currentCardView = [self.dataSource viewForCurrentCardForCardSlider:self];
				incomingCardView = [self.dataSource viewForNextCardForCardSlider:self];
			}
			
			[transitionCard addSubview:incomingCardView];
			transitionCard.frame = kTransitionCardFrame;
			[cardScroller addSubview:transitionCard];
			
			activeCard.frame = kFauxCardFrame;
			[activeCard addSubview:currentCardView];
			[transitionCardShell addSubview:activeCard];
			
			didStartScrollingNext = YES;
			didStartScrollingPrev = NO;
		}
	} else if (scrollView.contentOffset.x < scrollView.contentSize.width/3-1){
		// OLD CARD GOING RIGHT x--->
		
		activeCard.frame = kActiveCardFrame;
				
		if (!didStartScrollingPrev) {
			
			if (startedIncompleteNextScroll) {
				startedIncompleteNextScroll = NO;
				currentCardView = [self.dataSource viewForPreviousCardForCardSlider:self];
			}
			if (!startedIncompletePreviousScroll) {
				startedIncompletePreviousScroll = YES;
				startedIncompletePreviousScroll = YES;
				currentCardView = [self.dataSource viewForCurrentCardForCardSlider:self];
				incomingCardView = [self.dataSource viewForPreviousCardForCardSlider:self];
			}
			
			[transitionCard addSubview:incomingCardView];
			transitionCard.frame = kFauxCardFrame;
			[transitionCardShell addSubview:transitionCard];
			
			[cardScroller addSubview:activeCard];
			didStartScrollingPrev = YES;
			didStartScrollingNext = NO;
		}
	}
	
	//Dim the background card:
	CGFloat scrollDistance = (scrollView.contentOffset.x-scrollView.frame.size.width)/1700;
	if (scrollDistance < 0) { 
		scrollDistance = .188 + scrollDistance;
	}
	[dimmer setAlpha:(scrollDistance)];
	[transitionCardShell bringSubviewToFront:dimmer];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
	if (scrollView.contentOffset.x == 0) {
		//DECREMENTED:
		activeCard.frame = kActiveCardFrame;
		[activeCard addSubview:incomingCardView];
		startedIncompletePreviousScroll = NO;
		
	} else if (scrollView.contentOffset.x == scrollView.frame.size.width) {
		//currentCard DID NOT CHANGE
		
	} else if (scrollView.contentOffset.x == scrollView.frame.size.width*2) {
		//INCREMENTED:
		startedIncompleteNextScroll = NO;
		activeCard.frame = kActiveCardFrame;
		[activeCard addSubview:incomingCardView];
		[cardScroller addSubview:activeCard];
	}
	
	scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
	
	//This is the end of a move, so reset the did-'s:
	didStartScrollingPrev = NO;
	didStartScrollingNext = NO;
}

@end
