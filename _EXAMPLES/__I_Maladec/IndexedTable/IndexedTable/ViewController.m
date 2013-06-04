//
//  ViewController.m
//  IndexedTable
//
//  Created by Eugene Romanishin on 24.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize namesList = namesList;
@synthesize names = names;
@synthesize sectionKeys = sectionKeys;
@synthesize ssectionKeys = ssectionKeys;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.namesList = nil;
}

NSInteger alphabeticSort(id string1, id string2, void *reverse)
{
    if (reverse) {
        return [string2 localizedCaseInsensitiveCompare:string1];
    } else {
        return [string1 localizedCaseInsensitiveCompare:string2];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.names = [NSMutableDictionary dictionary];
    self.sectionKeys = [NSMutableArray array];    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"names" ofType:@"txt"];
    NSString *textNames = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *notValidNames = [textNames componentsSeparatedByString:@"\n"];
    
    for (NSString *name in notValidNames) {
        NSString *sectionName = [name substringToIndex:1];
        NSMutableArray *namesInSection = nil;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", sectionName];
        NSArray *foundSection = [sectionKeys filteredArrayUsingPredicate:predicate];
        if (foundSection.count) {
            namesInSection = [names objectForKey:sectionName];
        } else {
            namesInSection = [NSMutableArray array];
            [sectionKeys addObject:sectionName];
        }
        
        [namesInSection addObject:name];
        [names setObject:namesInSection forKey:sectionName];
    }
    
    
    BOOL reverseSort = NO;
    self.ssectionKeys = [self.sectionKeys sortedArrayUsingFunction:alphabeticSort context:(void*)reverseSort];
//    NSLog(@"Sort using function:"YES" %@", sortedArray);
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{   
    return ssectionKeys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return names.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *currentKey = [ssectionKeys objectAtIndex:section];
    NSArray *currentNames = [names objectForKey:currentKey];
    return currentNames.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *currentKey = [ssectionKeys objectAtIndex:section];
    NSString *name = [NSString stringWithFormat:@"%@ (%d)",currentKey,[[names objectForKey:currentKey] count]];
    return name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSString *currentKey = [ssectionKeys objectAtIndex:indexPath.section];
    NSArray *currentNames = [names objectForKey:currentKey];
    
    cell.textLabel.text = [currentNames objectAtIndex:indexPath.row];
    
    return cell;
}

@end
