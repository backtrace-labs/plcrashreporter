#import "AppDelegate.h"

@interface AppDelegate ()<NSMenuDelegate, NSMenuItemValidation>
@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *menuItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.menu.delegate = self;
    self.menuItem.target = self;
    self.menuItem.action = @selector(foo);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void) foo {
    
}

-(NSString *) concatString:(NSString*) s1 toString:(NSString *) s2 {
    return [s1 stringByAppendingString:s2];
}

- (BOOL) validateMenuItem:(NSMenuItem *)item {
    BOOL result = NO;
    NSLog(@"%@", [self concatString:@"bob" toString:nil]);
    
    return result;
}

@end
