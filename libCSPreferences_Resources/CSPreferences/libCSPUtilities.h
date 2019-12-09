#import <NSTask.h>

@interface CSPUProcessManager : NSObject

+ (NSString *_Nullable)stringFromProcessAtPath:(NSString *_Nonnull)path 
                                        handle:(NSFileHandle *_Nullable)outputHandle 
                                     arguments:(NSArray <NSString *> *_Nullable)arguments;

+ (NSData *_Nullable)dataFromProcessAtPath:(NSString *_Nonnull)path 
                                    handle:(NSFileHandle *_Nullable)outputHandle 
                                 arguments:(NSArray <NSString *> *_Nullable)arguments;

+ (void)resultFromProcessAtPath:(NSString *_Nonnull)path 
                         handle:(NSFileHandle *_Nullable)outputHandle 
                      arguments:(NSArray <NSString *> *_Nullable)arguments 
                     completion:(void (^_Nullable)(NSTask *_Nonnull))completion;

@end