//
//  TestUI.m
//  solanum
//
//  Created by YA CHEN on 30/7/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

#import "TestUI.h"

@implementation TestUI


- (void)beforeAll {
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Debug Mode"];
    [tester tapViewWithAccessibilityLabel:@"Clear History"];
    [tester tapViewWithAccessibilityLabel:@"Clear"];
    [tester waitForTimeInterval:1];
}


- (void)test00TabBarButtons {
    // 1
//    [tester tapViewWithAccessibilityLabel:@"History"];
//    [tester waitForViewWithAccessibilityLabel:@"History List"];
//    
    // 2
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    [tester waitForViewWithAccessibilityLabel:@"Task Name"];
    
    // 3
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester waitForViewWithAccessibilityLabel:@"Debug Mode"];
}

- (void)test10PresetTimer {
    // 1
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    // 2
    [tester enterText:@"Set up a test" intoViewWithAccessibilityLabel:@"Task Name"];
   // [tester tapViewWithAccessibilityLabel:@"Done"];
    
    // 3
    [self selectPresetAtIndex:1];
    
    // 4
    UISlider *slider = (UISlider *)[tester waitForViewWithAccessibilityLabel:@"Work Time Slider"];
   
    XCTAssertEqualWithAccuracy([slider value], 15.0f, 0.1,@"Work time slider was not set!");
    
}


- (void)selectPresetAtIndex:(NSInteger)index {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester tapViewWithAccessibilityLabel:@"Presets"];

    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] inTableViewWithAccessibilityIdentifier:@"Presets List"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Presets List"];
}


-(void)test20StartTimerAndWaitForFinish {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester clearTextFromAndThenEnterText:@"Test the timer"
           intoViewWithAccessibilityLabel:@"Task Name"];
   // [tester tapViewWithAccessibilityLabel:@"done"];
    
    [tester setValue:1 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    [tester setValue:50 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    [tester setValue:1 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    [tester setValue:8 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    
    [tester setValue:1 forSliderWithAccessibilityLabel:@"Break Time Slider"];
    [tester setValue:25 forSliderWithAccessibilityLabel:@"Break Time Slider"];
    [tester setValue:2 forSliderWithAccessibilityLabel:@"Break Time Slider"];
    
    
    
    // 1
    UIStepper *repsStepper = (UIStepper*)[tester waitForViewWithAccessibilityLabel:@"Reps Stepper"];
    CGPoint stepperCenter = [repsStepper.window convertPoint:repsStepper.center
                                                    fromView:repsStepper.superview];
    
    CGPoint minusButton = stepperCenter;
    minusButton.x -= CGRectGetWidth(repsStepper.frame) / 4;
    
    CGPoint plusButton = stepperCenter;
    plusButton.x += CGRectGetWidth(repsStepper.frame) / 4;
    
    // 2
    [tester waitForTimeInterval:1];
    
    // 3
    for (int i = 0; i < 20; i++) {
        [tester tapScreenAtPoint:minusButton];
    }
    
    [tester waitForTimeInterval:1];
    [tester tapScreenAtPoint:plusButton];
    [tester waitForTimeInterval:1];
    [tester tapScreenAtPoint:plusButton];
    [tester waitForTimeInterval:1];
    
    // 4
    [KIFUITestActor setDefaultTimeout:60];
    
    // 5
    [tester tapViewWithAccessibilityLabel:@"Start Working"];
    // the timer is ticking away in the modal view...
    [tester waitForViewWithAccessibilityLabel:@"Start Working"];
    
    // 6
    [KIFUITestActor setDefaultTimeout:10];
}

- (void)test30StartTimerAndGiveUp {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester clearTextFromAndThenEnterText:@"Give Up"
           intoViewWithAccessibilityLabel:@"Task Name"];
  //  [tester tapViewWithAccessibilityLabel:@"done"];
    [self selectPresetAtIndex:2];
    
    [tester tapViewWithAccessibilityLabel:@"Start Working"];
    [tester waitForTimeInterval:3];
    
    [tester tapViewWithAccessibilityLabel:@"Give Up"];
    [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Start Working"];
}



- (void)test40SwipeToDeleteHistoryItem
{
    // 1
    [tester tapViewWithAccessibilityLabel:@"History"];
    
    // 2
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"History List"];
    NSInteger originalHistoryCount = [tableView numberOfRowsInSection:0];
   
   
    XCTAssertTrue(originalHistoryCount>0,@"There should be at least one history item!");
    // 3
    [tester swipeViewWithAccessibilityLabel:@"Section 0 Row 0" inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    
    // 4
    [tester waitForTimeInterval:1];
    NSInteger currentHistoryCount = [tableView numberOfRowsInSection:0];
    XCTAssertTrue(currentHistoryCount == originalHistoryCount - 1,
                 @"The history item was not deleted :[");
}



@end
