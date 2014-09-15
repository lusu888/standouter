//
//  FileOps.h
//  FileOperation
//
//  Created by Kevin Languedoc on 11/28/11.
//  Copyright (c) 2011 kCodebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOps : NSObject{
    NSFileManager *fileMgr;
    NSString *homeDir;
    NSString *filename;
    NSString *filepath;
    
    
    
}


@property(nonatomic,retain) NSFileManager *fileMgr;
@property(nonatomic,retain) NSString *homeDir;
@property(nonatomic,retain) NSString *filename;
@property(nonatomic,retain) NSString *filepath;

-(BOOL)fileexits:(NSString *)name;
-(NSString *) GetDocumentDirectory;
-(void)WriteToStringFile:(NSMutableString *)textToWrite andname:(NSString *)name;
-(NSString *) readFromFile:(NSString *)name;
-(NSString *) setFilename;
@end