//
//  FileOps.m
//  FileOperation
//
//  Created by Kevin Languedoc on 11/28/11.
//  Copyright (c) 2011 kCodebook. All rights reserved.
//

#import "FileOps.h"

@implementation FileOps
@synthesize fileMgr;
@synthesize homeDir;
@synthesize filename;
@synthesize filepath;


-(NSString *) setFilename{
    filename = @"mytextfile.txt";
    
    return filename;
}

/*
 Get a handle on the directory where to write and read our files. If
 it doesn't exist, it will be created.
 */

-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}


/*Create a new file*/
-(void)WriteToStringFile:(NSMutableString *)textToWrite andname:(NSString *)name{
    filepath = [[NSString alloc] init];
    NSError *err;
    
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:name];
    
    BOOL ok = [textToWrite writeToFile:filepath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    
    if (!ok) {
        NSLog(@"Error writing file at %@\n%@",
              filepath, [err localizedFailureReason]);
    }else{
        NSLog(@"write ok");
    }
    
}

-(BOOL)fileexits:(NSString *)name
{
    filepath = [[NSString alloc] init];
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:name];
    BOOL result =[[NSFileManager defaultManager]fileExistsAtPath:filepath];
    return result;
}

/*
 Read the contents from file
 */
-(NSString *) readFromFile:(NSString *)name
{
    filepath = [[NSString alloc] init];
    NSError *error;
    NSString *title;
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:name];
    NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUnicodeStringEncoding error:&error];
    
    if(!txtInFile)
    {
        
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get text from file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
        
        
    }
    return txtInFile;
}



@end
