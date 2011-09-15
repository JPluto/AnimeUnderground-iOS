//
//  NoticiaCheckinController.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 15/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "SerieCheckinController.h"
#import "CheckinCell.h"
#import "DeviantDownload.h"
#import "CheckinHelper.h"
#import "AUnder.h"
#import "Checkin.h"
#import "UIImage+Resize.h"

@implementation SerieCheckinController

@synthesize listaCheckins,image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithSerie:(Serie*) serieAux {
    self = [super init];
    if (self) {
        
        _serie = [serieAux retain];
        capitulosCheck = [[[NSMutableArray alloc]initWithCapacity:_serie.capitulosActuales]retain];
        NSArray *capis = [[[AUnder sharedInstance] checkin] getSerieInfo:_serie];
        for (int i = 0 ; i<_serie.capitulosActuales;i++) {
            CheckinHelper *aux= [[CheckinHelper alloc] init];
            aux.capitulo = i+1;
            if ([capis containsObject:[NSNumber numberWithInteger:aux.capitulo]]) {
                aux.checked = YES;
            }
            
            [capitulosCheck addObject:aux];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_serie release];
    [capitulosCheck release];
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
    self.title = [@"Checkin " stringByAppendingString:_serie.nombre];
    DeviantDownload *dd = [[DeviantDownload alloc]init];
    dd.urlString = [_serie imagen];
    CGRect rect = CGRectMake(0, 40 , 
                             320, 105);
    self.image.image = [[dd image] croppedImage:rect];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Setters/Getters

-(void) setSerie:(Serie *)serie {
    _serie = [serie retain ];
}

#pragma mark Actions

-(IBAction) doCheckin:(id) sender {
    //TODO Splash
    [[[AUnder sharedInstance] checkin] delAll:_serie];
    NSMutableArray *aux = [NSMutableArray arrayWithCapacity:_serie.capitulosActuales];
    
    for (CheckinHelper *auxCH in capitulosCheck) {
        [aux addObject:[NSNumber numberWithInteger:auxCH.capitulo]];
    }
    
    [[[AUnder sharedInstance] checkin] add:_serie losCapitulos:aux];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!_serie) {
        return 0;
    }
    
    NSInteger tam=_serie.capitulosActuales;
    return tam;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckinCell";
    
    CheckinCell *cell = (CheckinCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CheckinCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = [(CheckinCell*) currentObject retain];
                
				break;
			}
		}
    }    
    
    
    // Configure the cell...
    cell.numero.text = [@"" stringByAppendingFormat:@"%2d",  (indexPath.row+1)];
    
    CheckinHelper *aux =[capitulosCheck objectAtIndex:indexPath.row];
    if (aux.checked) {
        cell.check.alpha = 1.0f;
    } else {
        cell.check.alpha = 0.2f;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CheckinHelper *aux =[capitulosCheck objectAtIndex:indexPath.row];
    aux.checked = !aux.checked;
    [capitulosCheck replaceObjectAtIndex:indexPath.row withObject:aux];
    [tableView reloadData];
    NSLog(@"Check/uncheck del capitulo %d de la serie %@",(indexPath.row +1),_serie.nombre);
}
@end
