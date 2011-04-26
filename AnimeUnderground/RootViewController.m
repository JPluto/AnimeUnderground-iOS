//
//  RootViewController.m
//  AnimeUnderground
//
//  Created by Nacho L on 06/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "RootViewController.h"
#import "Noticia.h"
#import "Ente.h"
#import "Serie.h"
#import "NoticiaCell.h"
#import "DeviantDownload.h"
#import "Imagen.h"

@implementation RootViewController
@synthesize loadingView;
@synthesize loadingText;
@synthesize loadingSpinner;
@synthesize tableView;

@class AUnder;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"AnimeUnderground";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    //self.tableView = tableView;
    [[AUnder sharedInstance]setUpdateHandler:self];
    [[AUnder sharedInstance]update]; // el mŽtodo es as’ncrono
    
    [tableView setDataSource:self];
	[tableView setDelegate:self];
}

// delegates

- (void)onBeginUpdate:(AUnder*)aunder {
    NSLog(@"Actualizaci—n comenzada");
    
    [self.view addSubview:loadingView];
    loadingView.center = self.view.center;
    [loadingSpinner startAnimating];
    
}
- (void)onUpdateStatus:(AUnder*)aunder:(NSString*)withStatus {
    //NSLog(@"Estado actual de la actualizaci—n: %@",withStatus);
    [loadingText setText:withStatus];
}
- (void)onFinishUpdate:(AUnder*)aunder {
    NSLog(@"Actualizaci—n finalizada");    
    
    downloads = [[[NSMutableArray alloc]init]retain];
    
    for (Noticia *n in [[AUnder sharedInstance] noticias]) {
        DeviantDownload *dd = [[DeviantDownload alloc]init];
        NSString *def = @"http://www.aunder.org/templates/v3Theme/img/ico_news.png";
        if ([[n imagenes]count]>0) {
            Imagen *img = [[n imagenes]objectAtIndex:0];
            def = [img getThumbUrl];
        }
        dd.urlString = [def retain];
        [downloads addObject: [dd retain]];
        
    }
    
    [loadingView removeFromSuperview];
    [tableView reloadData];
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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AUnder sharedInstance] noticias]count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"NoticiaCell";
    
    NoticiaCell *cell = (NoticiaCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NoticiaCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (NoticiaCell*) currentObject;
				break;
			}
		}
    }    
    
    Noticia *noti = [[[AUnder sharedInstance]noticias] objectAtIndex:indexPath.row];
    
    cell.titulo.text = [noti titulo];
    cell.autor.text = [[noti autor]nick];
    cell.fecha.text = [noti fecha];
    
    cell.titulo.tag = [noti codigo];
    
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
    
    cell.imagen.image = cellImage;
    
    // Configure the cell.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.loadingText = nil;
    self.loadingView = nil;
    self.loadingSpinner = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [tableView release];
    [loadingSpinner release];
    [loadingText release];
    [loadingView release];
    [downloads release];
    [super dealloc];
}

@end
