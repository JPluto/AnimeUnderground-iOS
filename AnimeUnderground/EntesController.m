//
//  EntesController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 30/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "EntesController.h"
#import "DeviantDownload.h"
#import "EnteDetailsController.h"
@implementation EntesController
@class Ente,AUnder;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [activos release];
    [inactivos release];
    [listas release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Entes"];
    
    downloads = [[[NSMutableArray alloc]init]retain];
    activos = [[[NSMutableArray alloc]init]retain];
    inactivos = [[[NSMutableArray alloc]init]retain];
    listas = [[[NSMutableArray alloc]init]retain];
    
    for (Ente *n in [[AUnder sharedInstance] entes]) {
        DeviantDownload *dd = [[DeviantDownload alloc]init];
        dd.urlString = [n avatar];
        
        if ([n isActivo]) 
            [activos addObject:n];
        else
            [inactivos addObject:n];
        
        [downloads addObject: [dd retain]];
    }
    [listas addObject:activos];
    [listas addObject:inactivos];
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [listas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [NSArray arrayWithArray:[listas objectAtIndex:section]];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSArray *array = [NSArray arrayWithArray:[listas objectAtIndex:indexPath.section]];
    Ente* ente = [array objectAtIndex:indexPath.row];
    
    cell.text = [ente nick];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Activos";
    else
        return @"Inactivos o ex-miembros";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [NSArray arrayWithArray:[listas objectAtIndex:indexPath.section]];
    Ente* ente = [array objectAtIndex:indexPath.row];
    NSLog(@"Ente seleccionado %@",[ente nick]);
    EnteDetailsController *edc = [[EnteDetailsController alloc]initWithEnteId:ente.codigo];
    [self.navigationController pushViewController:edc animated:YES];
}

@end
