//
//  AUnder.m
//  AnimeUnderground
//
//  Created by Nacho L on 12/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "AUnder.h"
#import "TBXML.h"
#import "Serie.h"
#import "Ente.h"
#import "Noticia.h"

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

- (void)update { // método asíncrono, usa callbacks    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [lock lock];
        
        [updateHandler onBeginUpdate:self];
        // cargamos la información de las series
        
        NSMutableArray *tmpSeries = [[NSMutableArray alloc]init];
        
        [updateHandler onUpdateStatus:self :NSLocalizedString(@"Descargando información de series", @"")];
        
        TBXML *tb = [[TBXML alloc] initWithXMLString:[[self foro] webGet:@"http://www.aunder.org/xml/seriesxml.php"]];
        
        [updateHandler onUpdateStatus:self :NSLocalizedString(@"Parseando información de series", @"")];
        
        TBXMLElement *root = tb.rootXMLElement;
        
        TBXMLElement *serie = [TBXML childElementNamed:@"Serie" parentElement:root];
        
        NSMutableDictionary *seriesConPrecuela = [[[NSMutableDictionary alloc]init]autorelease];
        NSMutableDictionary *seriesConSecuela = [[[NSMutableDictionary alloc]init]autorelease];
        
        while (serie!=nil) {
                        
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
            
            Serie *s = [[Serie alloc]init];
            
            int idserie = [ids intValue];
            s.codigo = idserie;            
            s.nombre = nombreSerie;
            s.sinopsis = sinopsisSerie;
            s.estudio = estudioSerie;
            // TODO tratar los generos de las series
            s.capitulosTotales = [capitulosTotales intValue];
            s.capitulosActuales = [capitulosSerie intValue];
            s.imagen = imagenSerie;
            s.imagenBoton = imagenBotonSerie;
            s.fuente = fuenteSerie;
            s.codecVideo = codecVideoSerie;
            s.codecAudio = codecAudioSerie;
            s.resolucion = resolucionSerie;
            s.contenedor = contenedorSerie;
            s.subtitulos = subtitulosSerie;
            s.peso = [pesoSerie intValue];
            s.recomendable = [recomendableSerie isEqualToString:@"1"];
            s.cancelada = [isCanceladaSerie isEqualToString:@"1"];
            s.terminada = [isTerminadaSerie isEqualToString:@"1"];
            
            [tmpSeries addObject:s];
            
            int precuela = [precuelaSerie intValue];
            int secuela = [secuelaSerie intValue];
            if (precuela>0) 
                [seriesConPrecuela setValue:s forKey:precuelaSerie];
            if (secuela>0)
                [seriesConSecuela setValue:s forKey:secuelaSerie];
            
            [updateHandler onUpdateStatus:self:[NSString stringWithFormat:NSLocalizedString(@"Analizando la serie %@", @""),nombreSerie]];
            
            serie = [TBXML nextSiblingNamed:@"Serie" searchFromElement:serie];
        }
        
        series = [NSArray arrayWithArray:tmpSeries];
        
        // ahora arreglamos las precuelas/secuelas ya que tenemos todas las series en memoria
        
        for (NSString *key in [seriesConPrecuela allKeys]) {
            Serie *conPrecuela = [seriesConPrecuela valueForKey:key];
            NSString *secKey = [NSString stringWithFormat:@"%d",[conPrecuela codigo]];
            Serie *conSecuela = [seriesConSecuela valueForKey:secKey];
            
            [conPrecuela setSecuela:conPrecuela];
            [conSecuela setPrecuela:conSecuela];
        }
        
        // series parseadas
        
        [updateHandler onUpdateStatus:self :NSLocalizedString(@"Descargando información de entes", @"")];
        tb = [[TBXML alloc] initWithXMLString:[[self foro] webGet:@"http://www.aunder.org/xml/entesxml.php"]];
        
        [tb release];
        [updateHandler onFinishUpdate:self];
        [lock unlock];
    });        
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
