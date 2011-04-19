//
//  AUnder.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AUnder.h"
#import "TBXML.h"

#define URL_SERIES "http://www.aunder.org/xml/seriesxml.php"

@implementation AUnder

static AUnder* sharedInstance = nil;
static Foro* theForo = nil;

+(AUnder*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}

- (Foro*)foro {
    if (!foro) 
        foro = [[Foro alloc]init];
    
    return foro;
}

- (void)setUpdateHandler:(id)aDelegate {
    updateHandler = aDelegate; /// Not retained
}

- (BOOL)update {
    // TODO hacer el método asíncrono
    [lock lock];

    [updateHandler onBeginUpdate:self];
    // series, entes, noticias

    TBXML *tb = [[TBXML alloc] initWithXMLString:[[self foro] webGet:@"http://www.aunder.org/xml/seriesxml.php"]];
    TBXMLElement *root = tb.rootXMLElement;
    
    TBXMLElement *serie = [TBXML childElementNamed:@"Serie" parentElement:root];
    
    while (serie!=nil) {
        
        // hay que comprobar la existencia de los que varían antes de convertirlos
        
        NSString *ids = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:serie]];
        NSString *nombreSerie = [TBXML textForElement:[TBXML childElementNamed:@"Nombre" parentElement:serie]];
        NSString *sinopsisSerie = [TBXML textForElement:[TBXML childElementNamed:@"Sinopsis" parentElement:serie]];
        NSString *estudioSerie = [TBXML textForElement:[TBXML childElementNamed:@"Estudio" parentElement:serie]];
        
        NSString *generoSerie = [TBXML textForElement:[TBXML childElementNamed:@"Genero" parentElement:serie]];
        
        NSString *capitulosSerie = [TBXML textForElement:[TBXML childElementNamed:@"Capitulos" parentElement:serie]];
        NSString *capitulosTotales = [TBXML textForElement:[TBXML childElementNamed:@"CapituloActual" parentElement:serie]];
        NSString *imagenSerie = [TBXML textForElement:[TBXML childElementNamed:@"Imagen" parentElement:serie]];
        NSString *imagenBotonSerie = [TBXML textForElement:[TBXML childElementNamed:@"ImagenBoton" parentElement:serie]];
        NSString *precuelaSerie = [TBXML textForElement:[TBXML childElementNamed:@"Precuela" parentElement:serie]];
        NSString *secuelaSerie = [TBXML textForElement:[TBXML childElementNamed:@"Secuela" parentElement:serie]];
        NSString *fuenteSerie = [TBXML textForElement:[TBXML childElementNamed:@"Fuente" parentElement:serie]];
        NSString *codecVideoSerie = [TBXML textForElement:[TBXML childElementNamed:@"CodecVideo" parentElement:serie]];
        NSString *codecAudioSerie = [TBXML textForElement:[TBXML childElementNamed:@"CodecAudio" parentElement:serie]];
        NSString *resolucionSerie = [TBXML textForElement:[TBXML childElementNamed:@"Resolucion" parentElement:serie]];
        NSString *contenedorSerie = [TBXML textForElement:[TBXML childElementNamed:@"Contenedor" parentElement:serie]];
        NSString *subtitulosSerie = [TBXML textForElement:[TBXML childElementNamed:@"Subtitulos" parentElement:serie]];
        NSString *pesoSerie = [TBXML textForElement:[TBXML childElementNamed:@"Peso" parentElement:serie]];
        NSString *recomendableSerie = [TBXML textForElement:[TBXML childElementNamed:@"Recomendable" parentElement:serie]];
        NSString *isCanceladaSerie = [TBXML textForElement:[TBXML childElementNamed:@"Cancelada" parentElement:serie]];
        NSString *isTerminadaSerie = [TBXML textForElement:[TBXML childElementNamed:@"Terminada" parentElement:serie]];
        
        NSLog(@"Analizada serie %@",nombreSerie);
        
        serie = [TBXML childElementNamed:@"Serie" parentElement:root];
    }
    
    [tb release];
    
    [lock unlock];
    [updateHandler onFinishUpdate:self];
    return NO;
}


// functiones necesarias para singleton

+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (void)release {
	
}
- (id)autorelease {
    return self;
}

@end
