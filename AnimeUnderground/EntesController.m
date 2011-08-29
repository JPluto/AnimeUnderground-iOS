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
#import "EnteCell.h"
#import "Ente.h"

@implementation EntesController
@class AUnder;

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
    
    for (Ente *n in [[AUnder sharedInstance] entes]) {
        DeviantDownload *dd = [[DeviantDownload alloc]init];
        dd.urlString = [n avatar];
        
        [downloads addObject: [dd retain]];
    }
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSArray *array = [NSArray arrayWithArray:[listas objectAtIndex:section]];
    //return [array count];
    return [[[AUnder sharedInstance]entes]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    //NSArray *array = [NSArray arrayWithArray:[listas objectAtIndex:indexPath.section]]; 
    
    static NSString *CellIdentifier = @"EnteCell";
    
    EnteCell *cell = (EnteCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EnteCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (EnteCell*) currentObject;
				break;
			}
		}
    }    
    
    // Configure the cell...
    
    //Ente* ente = [array objectAtIndex:indexPath.row];
    
    Ente *ente = [[[AUnder sharedInstance]entes] objectAtIndex:indexPath.row];
    cell.nickEnte.text = [ente nick];
    
    DeviantDownload *download = [downloads objectAtIndex:indexPath.row];
    //cell.cellLabel.text = download.filename;
    UIImage *cellImage = download.image;
    if (cellImage == nil)
    {
        //[cell.loading startAnimating];
        download.delegate = self;
    }
    else
        [cell.loading stopAnimating];
    
    cell.imagenAvatar.image = cellImage;
    
    return cell;
}

- (void)downloadDidFinishDownloading:(DeviantDownload *)download
{
    NSUInteger index = [downloads indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Activos";
    else
        return @"Inactivos o ex-miembros";
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *array = [NSArray arrayWithArray:[listas objectAtIndex:indexPath.section]];
    //Ente* ente = [array objectAtIndex:indexPath.row];
    Ente* ente = [[[AUnder sharedInstance]entes] objectAtIndex:indexPath.row];
    NSLog(@"Ente seleccionado %@",[ente nick]);
    EnteDetailsController *edc = [[EnteDetailsController alloc]initWithEnteId:ente.codigo];
    [self.navigationController pushViewController:edc animated:YES];
}

@end
