//
//  RAMRouterCollection.m
//  QJYRouter
//
//  Created by 裘俊云 on 2018/11/10.
//  Copyright © 2018年 裘俊云. All rights reserved.
//

#import "RAMRouterCollection.h"

#import <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>

#import <mach-o/dyld.h>
#import <mach-o/getsect.h>

NSString *RAMExtractClassName(NSString *methodName) {
    // Parse class and method
    NSArray *parts = [[methodName substringWithRange:NSMakeRange(2, methodName.length - 3)] componentsSeparatedByString:@" "];
    if (parts.count > 0)
        return parts[0];
    
    return nil;
}

NSArray *RAMExportedMethodsByModuleID(void) {
    static NSMutableArray *classes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!classes){
            classes = [NSMutableArray new];
        }
        
        Dl_info info;
        //这里可能要外部传进来，用来支持动态库导出router信息
        dladdr(&RAMExportedMethodsByModuleID, &info);
        
#ifdef __LP64__
        typedef uint64_t RAMExportValue;
        typedef struct section_64 RAMExportSection;
#define RAMGetSectByNameFromHeader getsectbynamefromheader_64
#else
        typedef uint32_t RAMExportValue;
        typedef struct section RAMExportSection;
#define RAMGetSectByNameFromHeader getsectbynamefromheader
#endif
        
        const RAMExportValue mach_header = (RAMExportValue)info.dli_fbase;
        const RAMExportSection *section = RAMGetSectByNameFromHeader((void *)mach_header, "__DATA", "RAMExport");
        
        if (section == NULL) {
            return;
        }
        
        int addrOffset = sizeof(const char **);
        /**
         *  防止address sanitizer报global-buffer-overflow错误
         *  RAMtps://github.com/google/sanitizers/issues/355
         *  因为address sanitizer填充了符号地址，使用正确的地址偏移
         */
#if defined(__has_feature)
#  if __has_feature(address_sanitizer)
        addrOffset = 64;
#  endif
#endif
        
        for (RAMExportValue addr = section->offset;
             addr < section->offset + section->size;
             addr += addrOffset) {
            
            NSString *entry = @(*(const char **)(mach_header + addr));
            if (entry.length == 0) {
                continue;
            }
            
            NSString *className = RAMExtractClassName(entry);
            Class class = className ? NSClassFromString(className) : nil;
            if (class){
                [classes addObject:class];
            }
        }
    });
    
    return classes;
}
