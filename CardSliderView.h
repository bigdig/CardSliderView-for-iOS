//
//  CardSliderView.h
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

#import <UIKit/UIKit.h>

@class CardSliderView;

@protocol CardSliderDataSource
//REQUIRED METHODS:

// viewForCurrentCard is called on inital load, and is also used during transitions -
// it should return the card that we want to see when everything is settled after a transition.
- (UIView*)viewForCurrentCardForCardSlider:(CardSliderView*)slider;

// The following get called when the view is scrolled left or right.
// Implement all the logic for this however it makes sense in your application. (see sample implementation)
- (UIView*) viewForPreviousCardForCardSlider:(CardSliderView*)slider;
- (UIView*) viewForNextCardForCardSlider:(CardSliderView*)slider;
@end

//TODO: LOAD FIRST DATA SOURCE VIEW!!

@interface CardSliderView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id <CardSliderDataSource> dataSource;

@end
