/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalAppDelegate.h"
#import "KalViewController.h"
#import "HolidayCalendarDataSource.h"

@implementation KalAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  KalViewController *kal = [[KalViewController alloc] initWithDataSource:[HolidayCalendarDataSource dataSource]];
  navController = [[UINavigationController alloc] initWithRootViewController:kal];
  [kal release];
  [window addSubview:navController.view];
  [window makeKeyAndVisible];
}

- (void)dealloc
{
  [window release];
  [navController release];
  [super dealloc];
}

@end
