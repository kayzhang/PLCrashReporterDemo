//
//  AppDelegate.m
//  PLCrashReporterDemo
//
//  Created by Zhang, Kai on 2023/2/21.
//

#import "AppDelegate.h"
@import CrashReporter;

@interface AppDelegate ()
- (void)reportCrashWithCrashReporter:(PLCrashReporter *) crashReporter;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enabling in-process crash reporting will conflict with any attached debuggers
    // So we only test PLCrashReporter in non-DEBUG mode
#if !(DEBUG)
    // It is strongly recommended that local symbolication only be enabled for non-release builds.
    // Use PLCrashReporterSymbolicationStrategyNone for release versions.
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType: PLCrashReporterSignalHandlerTypeMach
                                                                       symbolicationStrategy: PLCrashReporterSymbolicationStrategyAll];
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration: config];

    // Enable the Crash Reporter.
    NSError *error;
    if (![crashReporter enableCrashReporterAndReturnError: &error]) {
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    }
    NSLog(@"Local Testing - PLCrashReporter enabled successfully");
    
    [self reportCrashWithCrashReporter:crashReporter];
#endif
    
    return YES;
}

- (void)reportCrashWithCrashReporter:(PLCrashReporter *) crashReporter {
    if ([crashReporter hasPendingCrashReport]) {
        NSLog(@"Local Testing - There were pending crash reports");
        NSError *error;
        
        // Try loading the crash report.
        NSData *data = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
        if (data == nil) {
            NSLog(@"Failed to load crash report data: %@", error);
            return;
        }
        
        // Retrieving crash reporter data.
        PLCrashReport *report = [[PLCrashReport alloc] initWithData: data error: &error];
        if (report == nil) {
            NSLog(@"Failed to parse crash report: %@", error);
            return;
        }
        
        // We could send the report from here, but we'll just print out some debugging info instead.
        NSString *text = [PLCrashReportTextFormatter stringValueForCrashReport: report withTextFormat: PLCrashReportTextFormatiOS];
        NSLog(@"Local Testing - The crash report is: %@", text);
        
        // Purge the report.
        [crashReporter purgePendingCrashReport];
    } else {
        NSLog(@"Local Testing - There were NO pending crash reports");
    }
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
