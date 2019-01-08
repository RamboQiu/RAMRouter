//
//  RAMRouterCollection.h
//  QJYRouter
//
//  Created by 裘俊云 on 2018/11/10.
//  Copyright © 2018年 裘俊云. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  收集所有实现了configureRouter，这个函数内部必须调用了RAM_EXPORT宏
 *
 *  @return 类的数组
 */
NSArray *RAMExportedMethodsByModuleID(void);
