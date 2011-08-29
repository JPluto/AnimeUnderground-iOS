//
//  NoticiasController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 05/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "NoticiasController.h"
#import "Noticia.h"
#import "Ente.h"
#import "Serie.h"
#import "NoticiaCell.h"
#import "DeviantDownload.h"
#import "Imagen.h"
#import "NoticiaDetailsController.h"

@implementation NoticiasController

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
    [downloads release];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    [self setTitle:@"Noticias"];
    
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
    
    [self.tableView reloadData];

    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Index of the menu item currently clicked: %u", ([indexPath row]));
	int codigo = [[[[AUnder sharedInstance] noticias] objectAtIndex: indexPath.row] codigo];
	
	NoticiaDetailsController *tmp = [[NoticiaDetailsController alloc]init];
    tmp.codigoNoticia = codigo;
	
	[self.navigationController pushViewController:tmp animated:YES];
}

@end
