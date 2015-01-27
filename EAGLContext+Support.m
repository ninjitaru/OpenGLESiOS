#import "EAGLContext+GraphitiKit.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES3/glext.h>

@implementation EAGLContext (Supports)

+ (NSMutableDictionary *) glSupportedExtensions {
    static NSMutableDictionary *_supportedExtensions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _supportedExtensions = [NSMutableDictionary dictionary];
    });
    return _supportedExtensions;
}

+ (EAGLRenderingAPI) highestSupportedAPI {
    if([[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]) {
        return kEAGLRenderingAPIOpenGLES3;
    }
    if([[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]) {
        return kEAGLRenderingAPIOpenGLES2;
    }
    return kEAGLRenderingAPIOpenGLES1;
}

- (BOOL) hasExtension:(NSString *)extensionName {
    NSAssert(self == [EAGLContext currentContext], @"can onlt get correct implemented extensions on current context");
    if([EAGLContext currentContext] != self) {
        
    }
    NSSet * set = [self getImplementedExtensionSetWithAPI:self.API];
    return [set containsObject:extensionName];
}

- (NSString *) supportedExtensionStrings {
    NSAssert(self == [EAGLContext currentContext], @"can onlt get correct implemented extensions on current context");
    NSSet * set = [self getImplementedExtensionSetWithAPI:self.API];
    NSMutableString *string = [NSMutableString string];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [string appendFormat:@"%@,",obj];
    }];
    return [string copy];
}

- (NSSet *) getImplementedExtensionSetWithAPI:(EAGLRenderingAPI)api {
    NSSet *set = [EAGLContext glSupportedExtensions][@(api)];
    if(!set) {
        switch(api) {
            case kEAGLRenderingAPIOpenGLES3: {
                int max = 0;
                glGetIntegerv(GL_NUM_EXTENSIONS, &max);
                NSMutableSet *extensions = [NSMutableSet set];
                for (int i = 0; i < max; i++) {
                    [extensions addObject: @( (char *)glGetStringi(GL_EXTENSIONS, i) )];
                }
                set = [extensions copy];
                break;
            }
            default: {
                NSString *extensionString = [NSString stringWithUTF8String:(char *)glGetString(GL_EXTENSIONS)];
                NSArray *extensions = [extensionString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                set = [NSSet setWithArray:extensions];
                break;
            }
        }
        [EAGLContext glSupportedExtensions][@(api)] = set;
    }
    return set;
}

@end
