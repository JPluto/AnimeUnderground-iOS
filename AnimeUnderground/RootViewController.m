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

@class AUnder, NoticiasController, SeriesController,EntesController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"AnimeUnderground";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController setNavigationBarHidden:YES];
    //self.tableView = tableView;
    [[AUnder sharedInstance]setUpdateHandler:self];
    [[AUnder sharedInstance]update]; // el método es asíncrono
    
}

// delegates

- (void)onBeginUpdate:(AUnder*)aunder {
    NSLog(@"Actualización comenzada");
    
    [self.view addSubview:loadingView];
    loadingView.center = self.view.center;
    [loadingSpinner startAnimating];
    
}
- (void)onUpdateStatus:(AUnder*)aunder:(NSString*)withStatus {
    //NSLog(@"Estado actual de la actualización: %@",withStatus);
    [loadingText setText:withStatus];
}

- (void)onUpdateError:(AUnder*)aunder {
    NSLog(@"Ha habido un error actualizando");
}

- (void)onFinishUpdate:(AUnder*)aunder {
    NSLog(@"Actualización finalizada");   
    self.title = @"Menú";
    [self.navigationController setNavigationBarHidden:NO];
    [loadingView removeFromSuperview];
    UIImage *image = [UIImage imageNamed: @"logo_barra_au.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage: image];    
	self.navigationItem.titleView = imageView;
}

- (IBAction)showNoticias {
    NoticiasController *nc = [[NoticiasController alloc]init];
    [self.navigationController pushViewController:nc animated:YES];
}

- (IBAction)showSeries {
    SeriesController *sc = [[SeriesController alloc]init];
    [self.navigationController pushViewController:sc animated:YES];
    
}

- (IBAction)showEntes {
    EntesController *ec = [[EntesController alloc]init];
    [self.navigationController pushViewController:ec animated:YES];
    
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loadingText = nil;
    self.loadingView = nil;
    self.loadingSpinner = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [loadingSpinner release];
    [loadingText release];
    [loadingView release];
    [super dealloc];
}

@end
