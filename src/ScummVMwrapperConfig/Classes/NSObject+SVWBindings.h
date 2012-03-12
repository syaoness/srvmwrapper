/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             NSObject+SVWBindings.h                                                                        *
 * Copyright:        (c) 2010-2012 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Foundation/Foundation.h>

@interface NSObject (SVWBindings)

- (void)propagateValue:(id)value forBinding:(NSString*)binding;

@end
