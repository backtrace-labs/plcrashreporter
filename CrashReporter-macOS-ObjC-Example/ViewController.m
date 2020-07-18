#import "ViewController.h"
#import <Backtrace_PLCrashReporter/CrashReporter.h>
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PLCrashReporter.sharedReporter enableCrashReporter];
}

-(NSString *) concatString:(NSString*) s1 toString:(NSString *) s2 {
    return [s1 stringByAppendingString:s2];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}
- (IBAction)onButtonTapped:(id)sender {
    NSMenuItem *menuItem = [NSApplication sharedApplication].mainMenu.itemArray.firstObject;
    [self validateMenuItem: menuItem];
}

- (BOOL) validateMenuItem:(NSMenuItem *)item {
    BOOL result = NO;
    NSLog(@"%@", [self concatString:@"bob" toString:nil]);
    
    return result;
}

@end
