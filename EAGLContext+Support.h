#import <GLKit/GLKit.h>

@interface EAGLContext (Supports)

+ (EAGLRenderingAPI) highestSupportedAPI;
- (BOOL) hasExtension:(NSString *)extensionName;
- (NSString *) supportedExtensionStrings;

@end
