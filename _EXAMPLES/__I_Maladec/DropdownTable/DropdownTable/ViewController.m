//
//  ViewController.m
//  DropdownTable
//
//  Created by Alximik on 22.02.13.
//  Copyright (c) 2013 Unotion. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSArray *girls = [NSArray arrayWithObjects:@"Amanda", @"Ira", @"Natali", nil];
    NSArray *boys = [NSArray arrayWithObjects:@"Tom", @"Bill", @"Tom", @"Joe", @"Bob", nil];
    
    NSMutableDictionary *girlsSection = [NSMutableDictionary dictionary];
    [girlsSection setObject:girls forKey:@"items"];
    [girlsSection setObject:@"Girls" forKey:@"title"];
    
    NSMutableDictionary *boysSection = [NSMutableDictionary dictionary];
    [boysSection setObject:boys forKey:@"items"];
    [boysSection setObject:@"Boys" forKey:@"title"];
    
    self.students = @[girlsSection, boysSection];
}

- (void)didSelectSection:(UIButton*)sender {
    //Получение текущей секции
    NSMutableDictionary *currentSection = [self.students objectAtIndex:sender.tag];
    
    //Получение элементов секции
    NSArray *items = [currentSection objectForKey:@"items"];
    
    //Создание массива индексов
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i=0; i<items.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    
    //Получение состояния секции
    BOOL isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    
    //Установка нового состояния
    [currentSection setObject:[NSNumber numberWithBool:!isOpen] forKey:@"isOpen"];
    
    //Анимированное добавление или удаление ячеек секции
    if (isOpen) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    
    //Обновление картинки кнопки
    NSString *arrowNmae = isOpen? @"arrowDown.png":@"arrowUp.png";
    [sender setImage:[UIImage imageNamed:arrowNmae] forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.students.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.students objectAtIndex:section];
    if ([[currentSection objectForKey:@"isOpen"] boolValue]) {
        NSArray *items = [currentSection objectForKey:@"items"];
        return items.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.students objectAtIndex:section];
    NSString *sectionTitle = [currentSection objectForKey:@"title"];
    BOOL isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    NSString *arrowNmae = isOpen? @"arrowUp":@"arrowDown";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
    button.tag = section;
    button.backgroundColor = [UIColor brownColor];
    [button setTitle:sectionTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didSelectSection:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:arrowNmae] forState:UIControlStateNormal];
    return button;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *currentSection = [self.students objectAtIndex:indexPath.section];
    NSArray *items = [currentSection objectForKey:@"items"];
    NSString *currentItem = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = currentItem;
    
    return cell;
}

@end
