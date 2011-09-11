//
//  Checkin.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 04/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "Checkin.h"
#import "Foro.h"
#import "AUnder.h"
#import "Serie.h"


@implementation Checkin

static NSString *CHECKIN_COOKIE = @"AUCheckin";
static NSString *CMD_ADD = @"add";
static NSString *CMD_DEL = @"del";	

- (id) init {
    self = [super init];
    if (self) {
        checkins = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
        for (NSHTTPCookie *cookieAux in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
        {	
            if (([[cookie domain] isEqual:@".aunder.org"]) && [[cookie name] isEqual:CHECKIN_COOKIE]) {
                NSLog(@"name: '%@'\n",   [cookie name]);
                NSLog(@"value: '%@'\n",  [cookie value]);
                NSLog(@"domain: '%@'\n", [cookie domain]);
                NSLog(@"path: '%@'\n",   [cookie path]);
                            //[cookie retain];
                cookie = [cookieAux retain];
                }
                        
       }
    }
    return self;
}

- (void) dealloc {
    [cookie release];
    [checkins release];
} 

- (BOOL) isInitialized
{
    return (cookie!=nil);
}

//private synchronized void refreshCookie()
//{
//    Log.d("AU","++refreshCookie");
//    foro.doGet(new HttpGet(AnimeUnderground.FULL_CHECKIN));
//    cookie = foro.getCookieByName(CHECKIN_COOKIE);
//    if (cookie!=null)
//        Log.d("AU","cookie = "+cookie.toString());
//    else
//        Log.d("AU","cookie = null -> sin checkins");
//    Log.d("AU","--refreshCookie");
//}

- (BOOL) refreshCookie {
	if (cookie!=NULL) [cookie release];
	cookie = NULL;
	for (NSHTTPCookie *cookieAux in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
	{	
		if (([[cookieAux domain] isEqual:@".aunder.org"]) && [[cookieAux name] isEqual:CHECKIN_COOKIE]) {
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookieAux];
		}
		
	}
        	
    [[[AUnder sharedInstance] foro] webGet:@"http://www.aunder.org/checkins.php"];
		
	for (NSHTTPCookie *cookieAux in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
	{	
		if (([[cookie domain] isEqual:@".aunder.org"]) && [[cookie name] isEqual:CHECKIN_COOKIE]) {
			NSLog(@"name: '%@'\n",   [cookie name]);
			NSLog(@"value: '%@'\n",  [cookie value]);
			NSLog(@"domain: '%@'\n", [cookie domain]);
			NSLog(@"path: '%@'\n",   [cookie path]);
			//[cookie retain];
			cookie = cookieAux;
		}
		
	}
    
	if (cookie == NULL) {
		NSLog(@"No se ha podido encontrar la cookie");
		return NO;
	}
	
	[cookie retain];
    
	return YES;
}

//private synchronized void parseCheckins()
//{
//    Log.d("AU","++parseCheckins");
//    checkins.clear();
//    if (cookie!=null){
//        String value = cookie.getValue();
//        for (String serieRow : value.split("k")) // "k" separa series
//        {
//            try
//            {
//                String[] bySerie = serieRow.split("d"); // "d" separa id serie de la informaci�n de cap�tulos
//                Serie serie = AUnder.single().getSerieById(Integer.valueOf(bySerie[0]));
//                LinkedList<Integer> capitulos = new LinkedList<Integer>(); 
//                for (String byCapitulos: bySerie[1].split("i")) // "i" 
//                {
//                    if (!byCapitulos.trim().equals("")) {
//                        int separador = byCapitulos.indexOf("-"); 
//                        
//                        if (separador==-1) // no es rango
//                        {
//                            int capitulo = Integer.valueOf(byCapitulos);
//                            capitulos.add(Integer.valueOf(capitulo));					
//                        }
//                        else
//                        {
//                            int capituloPrimero = Integer.valueOf(byCapitulos.substring(0,separador));
//                            int capituloUltimo = Integer.valueOf(byCapitulos.substring(separador+1));		
//                            for (int i=capituloPrimero; i<=capituloUltimo; i++)
//                                capitulos.add(Integer.valueOf(i));								
//                        }					
//                    }
//                }
//                if (serie!=null && capitulos.size()>0)
//                {
//                    checkins.put(serie, capitulos);
//                }
//            } catch (Exception ex)
//            {
//                ex.printStackTrace();
//                if (cHandler!=null) cHandler.onErrorLoading();
//                Log.d("AU","Excepcion en CheckIn: "+ex.getLocalizedMessage()+" "+ex.getMessage());
//                Log.d("AU","SerieRow = "+serieRow);
//            }
//        }
//    } else Log.d("AU","cookie null @ parseCheckins");
//    Log.d("AU","--parseCheckins");
//}

-(void) parseCheckins {

    NSLog(@"-> parseCheckins ");

    @synchronized(self) {
        [checkins removeAllObjects];
        if (cookie != nil) {
            NSString *value = [cookie value] ;
            NSArray *series = [value componentsSeparatedByString:@"k"];
            for (NSString *serieRow in series ) {
                @try {
                    NSArray *bySerie = [serieRow componentsSeparatedByString:@"d"];
                    Serie *serie = [[AUnder sharedInstance] getSerieById:[[bySerie objectAtIndex:0] integerValue ]];
                    NSMutableArray *capitulos = [[NSMutableArray arrayWithCapacity:serie.capitulosActuales] autorelease];
                    NSArray *capisAux = [[bySerie objectAtIndex:1] componentsSeparatedByString:@"i"];
                    for (NSString *byCapitulos in capisAux) {
                        if ([[byCapitulos stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0) { //no es vacio
                            NSInteger separador = [byCapitulos rangeOfString:@"-"].location;
                            if (separador == NSNotFound) { //no es rango
                                NSNumber *capitulo = [NSNumber numberWithInteger:[byCapitulos integerValue]];
                                [capitulos addObject:capitulo];
                            } else {
                                NSArray *capisEnRango = [byCapitulos componentsSeparatedByString:@"-"];
                                for (NSInteger i = [[capisEnRango objectAtIndex:0] integerValue]; i<= [[capisEnRango objectAtIndex:1] integerValue];i++){
                                    [capitulos addObject:[NSNumber numberWithInteger:i]];
                                }
                            }
                        }
                    }
                    if (serie != nil && [capitulos count] > 0) {
                        [checkins setObject:capitulos forKey:serie];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"Error: %@",[exception description]);
                }
                @finally {
                    
                }
            }
        } else {
            NSLog(@"cookie nil");
        }
        
    } //sincro
    
    NSLog(@"parseCheckins ->");

}

//public List<Integer> getSerieInfo(Serie serie)
//{
//    if (checkins.containsKey(serie))
//        return checkins.get(serie);
//    else 
//        return new LinkedList<Integer>();
//}

-(NSMutableArray*) getSerieInfo: (Serie *)serie {
    
    NSMutableArray *ret = [[checkins objectForKey:serie] autorelease];
    if (ret == nil) {
        ret = [[NSMutableArray arrayWithCapacity:0] autorelease];
    } 
    
    return ret;
}

// refresca el valor de una serie que ha sido modificada
//private synchronized void refresh(Serie serie)
//{
//    if (cHandler!=null) cHandler.updateStarted();
//    
//    HttpPost httpost = new HttpPost(AnimeUnderground.FULL_CHECKIN_MODIFY);
//    
//    
//    List<Integer> capis = getSerieInfo(serie);
//    Collections.sort(capis);
//    String accion;
//    
//    String capitulos = "";
//    if (capis.size()>0)
//    {
//        for (int i: getSerieInfo(serie))			
//            capitulos+=i+",";
//        capitulos = capitulos.substring(0,capitulos.length()-1);
//        accion = CMD_ADD;
//    }
//    else 
//        accion = CMD_DEL;
//    
//    Log.d("AU","capitulos="+capitulos+" accion="+accion);
//    List<NameValuePair> nvps = new ArrayList <NameValuePair>();
//    nvps.add(new BasicNameValuePair("uid", String.valueOf(foro.getUid())));
//    nvps.add(new BasicNameValuePair("ids", String.valueOf(serie.getId())));
//    nvps.add(new BasicNameValuePair("accion",accion));
//    if (accion==CMD_ADD) nvps.add(new BasicNameValuePair("capi",capitulos));
//    
//    try {
//        httpost.setEntity(new UrlEncodedFormEntity(nvps, HTTP.UTF_8));
//    } catch (UnsupportedEncodingException e) { }// noooot gonna happen
//    
//    foro.doPost(httpost);
//    try {
//        Log.d("AU", "Respuesta="+Helpers.inputStreamToString(foro.getResponse().getEntity().getContent()));
//    } catch (Exception ex) { }
//    refreshCookie();
//    parseCheckins();
//    if (cHandler!=null) cHandler.updateFinished();
//}

-(void) refresh:(Serie*) serie {
    @synchronized(self) {
        
        NSString *uid;
        NSString *accion;
        NSString *capitulos;
        
        NSMutableArray *capis = [self getSerieInfo:serie];
        

        [capis sortUsingSelector:@selector(compare:)];
        
        if ([capis count] >0 ) {
            for (NSNumber *i in capis) {
                capitulos = [capitulos stringByAppendingString:@","];
            }
            capitulos = [capitulos substringToIndex:([capitulos length] -1) ];
            accion = CMD_ADD;
        } else {
            accion = CMD_DEL;
        }

        uid = [[AUnder sharedInstance] foro].uid;
        
        NSString *post =[NSString stringWithFormat:@"uid=%@&ids=%@&accion=%@&capi=%@",uid,serie.codigo,accion,capitulos];
        NSString *ret= [[AUnder foro] webPost:@"http://www.aunder.org/checkins.php" :post];
        NSLog(@"Respuesta=%@",ret);
    }
}



//public synchronized void add(Serie serie,int capitulo)
//{		
//    List<Integer> capis = getSerieInfo(serie);
//    if (!capis.contains(Integer.valueOf(capitulo)))
//        capis.add(Integer.valueOf(capitulo));
//    if (checkins.containsKey(serie)) checkins.remove(serie);
//    checkins.put(serie,capis);
//    
//    refresh(serie);		
//}

-(void) add: (Serie*) serie elCapitulo:(NSNumber*) capitulo{
    @synchronized(self) {
        NSMutableArray *capis = [self getSerieInfo:serie];
        if (![capis containsObject:capitulo]) {
            [capis addObject:capitulo];
        }
        [checkins setObject:capis forKey:serie];
        
        [self refresh:serie];
    }
}

//public synchronized void add(Serie serie, List<Integer> capitulos)
//{
//    if (capitulos.size()>1)
//    {
//        List<Integer> cmem = getSerieInfo(serie);
//        for (Integer i: capitulos)
//        {
//            if (!cmem.contains(i))
//                cmem.add(i);
//        }
//        if (checkins.containsKey(serie)) checkins.remove(serie);
//        checkins.put(serie,cmem);
//        refresh(serie);
//    }
//    else if (capitulos.size()==1)
//    {
//        add(serie,capitulos.get(0));
//    } 
    // si esta vacio capitulos no hacemos nada
//}

-(void) add:(Serie*) serie losCapitulos:(NSMutableArray*) capitulos {
        @synchronized(self) {
            if ([capitulos count]>1){
                NSMutableArray *capis = [self getSerieInfo:serie];
                for (NSNumber *i in capitulos) {
                    if (![capis containsObject:i]) {
                        [capis addObject:i];
                    }
                }
                [checkins setObject:capis forKey:serie];
                [self refresh:serie];                
            } else {
                [self add:serie elCapitulo:[capitulos objectAtIndex:0]];
            }
        }
}

//public synchronized void addAll(Serie serie)
//{
//    List<Integer> todos = new LinkedList<Integer>();
//    for (int i=1; i<=serie.getCapitulosActuales(); i++)
//        todos.add(Integer.valueOf(i));
//    add(serie,todos);
//}	

-(void) addAll:(Serie*) serie {
    NSMutableArray *todos = [NSMutableArray arrayWithCapacity:serie.capitulosActuales];
    for (NSInteger i = 1; i <= serie.capitulosActuales ; i++ ) {
        [todos addObject:[NSNumber numberWithInteger:i]];
    }
    [self add:serie losCapitulos:todos];
}

//public synchronized void del(Serie serie, int capitulo)
//{
//    List<Integer> lista = getSerieInfo(serie);
//    if (lista.contains(Integer.valueOf(capitulo)))
//        lista.remove(Integer.valueOf(capitulo));
//    if (checkins.containsKey(serie)) checkins.remove(serie);
//    checkins.put(serie,lista);
//    refresh(serie);
//}

-(void) del:(Serie*)serie elCapitulo:(NSNumber *) capitulo {
    @synchronized(self) {
        NSMutableArray *capis = [self getSerieInfo:serie];
        if ([capis containsObject:capitulo]) {
            [capis removeObject:capitulo];
        }
        [checkins setObject:capis forKey:serie];
        
        [self refresh:serie];
    }
}

//public synchronized void delAll(Serie serie)
//{
//    List<Integer> lista = getSerieInfo(serie);
//    lista.clear();
//    if (checkins.containsKey(serie)) checkins.remove(serie);
//    checkins.put(serie,lista);
//    refresh(serie);
//}
-(void) delAll:(Serie*)serie {
    @synchronized(self) {
        NSMutableArray *capis = [self getSerieInfo:serie];
        [capis removeAllObjects];
        [checkins setObject:capis forKey:serie];
        [self refresh:serie];
    }
}



//public void setCallback(CheckInHandler cHandler) {
//    this.cHandler = cHandler;
//}

@end
