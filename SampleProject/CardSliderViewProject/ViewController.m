//
//  ViewController.m
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

#import "ViewController.h"

@implementation ViewController

@synthesize cardSliderView;

- (void)viewDidLoad
{
	
	NSLog(@"viewDidLoad");
    [super viewDidLoad];
	
	//Here we just prespecify three views in an array to test it out.
	UIView *red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardSliderView.frame.size.width, cardSliderView.frame.size.height)];
	red.backgroundColor = [UIColor redColor];
	UILabel *one = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 200, 200)];
	one.font = [UIFont fontWithName:@"Courier" size:60.0f];
	one.text = @"1";
	one.backgroundColor = [UIColor clearColor];
	[red addSubview:one];
	
	UIView *green = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardSliderView.frame.size.width, cardSliderView.frame.size.height)];
	green.backgroundColor = [UIColor greenColor];
	UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 200, 200)];
	two.font = [UIFont fontWithName:@"Courier" size:60.0f];
	two.backgroundColor = [UIColor clearColor];
	two.text = @"2";
	[green addSubview:two];
	
	UIView *blue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardSliderView.frame.size.width, cardSliderView.frame.size.height)];
	blue.backgroundColor = [UIColor blueColor];
	UILabel *three = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 200, 200)];
	three.text = @"3";
	three.backgroundColor = [UIColor clearColor];
	three.font = [UIFont fontWithName:@"Courier" size:60.0f];
	[blue addSubview:three];
	
	cardViewsArray = [[NSArray alloc] initWithObjects:red, green, blue, nil];
	
	cardSliderView.dataSource = self;
	
	currentCardIndex = 0;
}

- (void)viewDidUnload
{
	cardViewsArray = nil;
    [self setCardSliderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CardSliderDataSource Methods

- (UIView*)viewForCurrentCardForCardSlider:(CardSliderView *)slider {
	NSLog(@"VIEW-FOR-CURRENT");
	return [cardViewsArray objectAtIndex:currentCardIndex];
}

- (UIView*)viewForNextCardForCardSlider:(CardSliderView *)slider {
	//This is where you know you'll be showing the next card. Any set-up
	// you want to do for the card's view could happen here before you return it.
	if (currentCardIndex+1 < cardViewsArray.count) {
		currentCardIndex++;
	} else {
		currentCardIndex = 0;
	}
	NSLog(@"FILLING CARD: %d", currentCardIndex);
	return [cardViewsArray objectAtIndex:currentCardIndex];
}

- (UIView*)viewForPreviousCardForCardSlider:(CardSliderView *)slider {
	//This is where you know you'll be showing the previous card. Any set-up
	// you want to do for the card's view could happen here before you return it.
	if (currentCardIndex-1 >= 0) {
		currentCardIndex--;
	} else {
		currentCardIndex = cardViewsArray.count-1;
	}
	NSLog(@"FILLING CARD: %d", currentCardIndex);
	return [cardViewsArray objectAtIndex:currentCardIndex];
}

@end
