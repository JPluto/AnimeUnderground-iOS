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
#import "Genero.h"
#import "Foro.h"
#import "CargoEnteSerie.h"
#import "Descarga.h"
#import "Imagen.h"

@implementation AUnder

static AUnder* sharedInstance = nil;
static Foro* theForo = nil;

@synthesize series;
@synthesize entes;
@synthesize noticias;
@synthesize foro;

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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateHandler onBeginUpdate:self];
        });
        
        @try {
        
        // cargamos la información de las series
        
        [Genero clearGeneros];
        NSMutableArray *tmpSeries = [[NSMutableArray alloc]init];
        NSMutableArray *tmpEntes = [[NSMutableArray alloc]init];
        NSMutableArray *tmpNoticias = [[NSMutableArray alloc]init];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateHandler onUpdateStatus:self :NSLocalizedString(@"Descargando información de series", @"")];
        });
        
        NSString *loadString = [[self foro] webGet:@"http://www.aunder.org/xml/seriesxml.php"];    
        
        if ([loadString isEqualToString:@""]) {
            NSLog(@"Error cargando la información");
            [updateHandler onUpdateError:self];
        }
            
        TBXML *tb = [[TBXML alloc] initWithXMLString:loadString];
                       
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateHandler onUpdateStatus:self :NSLocalizedString(@"Parseando información de series", @"")];
        });
        
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
            
            NSString *capitulosTotales = [TBXML textForElement:[TBXML childElementNamed:@"Capitulos" parentElement:serie]];
            NSString *capitulosSerie = [TBXML textForElement:[TBXML childElementNamed:@"CapituloActual" parentElement:serie]];
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
            
            Serie *s = [[[Serie alloc]init]retain];
            
            int idserie = [ids intValue];
            s.codigo = idserie;            
            s.nombre = nombreSerie;
            s.sinopsis = sinopsisSerie;
            s.estudio = estudioSerie;
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
            s.generos = [[NSMutableArray alloc]init];
            s.staff = [[NSMutableArray alloc]init];
            
            [Genero addGeneros:generoSerie:s];
                        
            [tmpSeries addObject:s];
                        
            int precuela = [precuelaSerie intValue];
            int secuela = [secuelaSerie intValue];
            if (precuela>0) 
                [seriesConPrecuela setValue:s forKey:precuelaSerie];
            if (secuela>0)
                [seriesConSecuela setValue:s forKey:secuelaSerie];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [updateHandler onUpdateStatus:self:[NSString stringWithFormat:NSLocalizedString(@"Analizando la serie %@", @""),nombreSerie]];
            });
            serie = [TBXML nextSiblingNamed:@"Serie" searchFromElement:serie];
        }
        
        series = [[NSArray arrayWithArray:tmpSeries]retain];
                    
        // ahora arreglamos las precuelas/secuelas ya que tenemos todas las series en memoria
        
        for (NSString *key in [seriesConPrecuela allKeys]) {
            Serie *conPrecuela = [seriesConPrecuela valueForKey:key];
            NSString *secKey = [NSString stringWithFormat:@"%d",[conPrecuela codigo]];
            Serie *conSecuela = [seriesConSecuela valueForKey:secKey];
            
            [conPrecuela setSecuela:conSecuela];
            [conSecuela setPrecuela:conPrecuela];
        }
        
        // series parseadas, parseamos entes
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateHandler onUpdateStatus:self :NSLocalizedString(@"Descargando información de entes", @"")];
        });
        tb = [[TBXML alloc] initWithXMLString:[[self foro] webGet:@"http://www.aunder.org/xml/entesxml.php"]];
        
        TBXMLElement *ente = [TBXML childElementNamed:@"Ente" parentElement:[tb rootXMLElement]];
        while (ente!=nil) {
            // extraemos los datos de ente
            NSString *ide = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:ente]];
            NSString *nombreEnte = [TBXML textForElement:[TBXML childElementNamed:@"Nombre" parentElement:ente]];
            NSString *activoEnte = [TBXML textForElement:[TBXML childElementNamed:@"Activo" parentElement:ente]];
            NSString *uidEnte = [TBXML textForElement:[TBXML childElementNamed:@"Uid" parentElement:ente]];
            NSString *avatarEnte = [TBXML textForElement:[TBXML childElementNamed:@"Avatar" parentElement:ente]];
            NSString *tituloUsuarioEnte = [TBXML textForElement:[TBXML childElementNamed:@"TituloUsuario" parentElement:ente]];
            NSString *ciudadEnte = [TBXML textForElement:[TBXML childElementNamed:@"Ciudad" parentElement:ente]];
            NSString *bioEnte = [TBXML textForElement:[TBXML childElementNamed:@"Bio" parentElement:ente]];
            NSString *sexoEnte = [TBXML textForElement:[TBXML childElementNamed:@"Sexo" parentElement:ente]];
            NSString *edadEnte = [TBXML textForElement:[TBXML childElementNamed:@"Edad" parentElement:ente]];
            
            int codigo = [ide intValue];
            int uid = [uidEnte intValue];
            BOOL activo = [activoEnte isEqualToString:@"1"];
            int edad = [edadEnte intValue];
            
            Ente *e = [[[Ente alloc] initWithCodigo:codigo nick:nombreEnte]retain];
            e.activo = activo;
            e.uid = uid;
            e.avatar = avatarEnte;
            e.titulo = tituloUsuarioEnte;
            e.ciudad = ciudadEnte;
            e.bio = bioEnte;
            e.sexo = sexoEnte;
            e.edad = edad;
            
            TBXMLElement *seriesRoles = [TBXML childElementNamed:@"Serie" parentElement:ente];
            while (seriesRoles!=nil) {
                
                int serieCodigo = [[TBXML textForElement:seriesRoles]intValue];
                NSString *rol = [TBXML valueOfAttributeNamed:@"rol" forElement:seriesRoles];
                int capitulos = [[TBXML valueOfAttributeNamed:@"capitulos" forElement:seriesRoles]intValue];
                
                CargoEnteSerie *ces = [[CargoEnteSerie alloc] initWithEnte:e serie:[self getSerieById:serieCodigo] cargo:rol capitulos:capitulos];
                
                seriesRoles = [TBXML nextSiblingNamed:@"Serie" searchFromElement:seriesRoles];
            }
            
            [tmpEntes addObject:e];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [updateHandler onUpdateStatus:self:[NSString stringWithFormat:NSLocalizedString (@"Analizando el ente %@", @""),nombreEnte]];
            });
            ente = [TBXML nextSiblingNamed:@"Ente" searchFromElement:ente];
        }
        
        entes = [[NSArray arrayWithArray:tmpEntes]retain];
        
        // entes parseados, parseamos noticias
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateHandler onUpdateStatus:self :NSLocalizedString(@"Descargando información de las noticias", @"")];
        });
        tb = [[TBXML alloc] initWithXMLString:[[self foro] webGet:@"http://www.aunder.org/xml/newsxml.php"]];
        
        TBXMLElement *noticia = [TBXML childElementNamed:@"Noticia" parentElement:tb.rootXMLElement];
        
        while (noticia!=nil) {
            // elementos fijos
            NSString *idn = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:noticia]];
            NSString *tituloNoticia = [TBXML textForElement:[TBXML childElementNamed:@"Titulo" parentElement:noticia]];
            NSString *autorNoticia = [TBXML textForElement:[TBXML childElementNamed:@"Autor" parentElement:noticia]];
            NSString *fechaNoticia = [TBXML textForElement:[TBXML childElementNamed:@"Fecha" parentElement:noticia]];
            NSString *textoNoticia = [TBXML textForElement:[TBXML childElementNamed:@"Texto" parentElement:noticia]];
            NSString *enlaceNoticia = [TBXML textForElement:[TBXML childElementNamed:@"Enlace" parentElement:noticia]];
            NSString *threadNoticia = [TBXML textForElement:[TBXML childElementNamed:@"Thread" parentElement:noticia]];
            
            // ahora tenemos que comprobar los que no son fijos
            
            TBXMLElement *serieNotiElem = [TBXML childElementNamed:@"Serie" parentElement:noticia];
            int serieId = 0;
            if (serieNotiElem!=NULL)
                serieId = [[TBXML textForElement:serieNotiElem]intValue];
            NSMutableArray *descargas = [[NSMutableArray alloc]init];
            
            TBXMLElement *descargaDdElem = [TBXML childElementNamed:@"DescargaDirecta" parentElement:noticia];
            if (descargaDdElem!=NULL) {
                NSString *enlace = [TBXML textForElement:descargaDdElem];
                Descarga *descargaDD = [[[Descarga alloc]initWithEnlace:enlace tipo:@"DD"]retain];
                [descargas addObject:descargaDD];
            }
            
            TBXMLElement *descargaEmuleElem = [TBXML childElementNamed:@"Emule" parentElement:noticia];
            if (descargaEmuleElem!=NULL) {
                NSString *enlace = [TBXML textForElement:descargaDdElem];
                Descarga *descargaML = [[[Descarga alloc]initWithEnlace:enlace tipo:@"ML"]retain];
                [descargas addObject:descargaML];            
            }
            
            TBXMLElement *descargaTorrentElem = [TBXML childElementNamed:@"Torrent" parentElement:noticia];
            while (descargaTorrentElem!=NULL) {
                NSString *enlace = [TBXML textForElement:descargaTorrentElem];
                NSString *version = [TBXML valueOfAttributeNamed:@"version" forElement:descargaTorrentElem];
                
                Descarga *descargaBT = [[[Descarga alloc]initWithEnlace:enlace tipo:@"BT"]retain];
                descargaBT.version = version;
                [descargas addObject:descargaBT];
                
                descargaTorrentElem = [TBXML nextSiblingNamed:@"Torrent" searchFromElement:noticia];
            }
            NSMutableArray *imagenes = [[NSMutableArray alloc]init];
            TBXML *imagenesElem = [TBXML childElementNamed:@"Imagen" parentElement:noticia];
            while (imagenesElem!=NULL) {
                NSString *enlace = [TBXML textForElement:imagenesElem];
                Imagen *img = [[[Imagen alloc]initWithImagen:enlace]retain];
                [imagenes addObject:img];
                
                imagenesElem = [TBXML nextSiblingNamed:@"Imagen" searchFromElement:imagenesElem];
            }
            
            // construimos la noticia
            
            Noticia *n = [[[Noticia alloc]init]retain];
            n.codigo = idn;
            n.titulo = tituloNoticia;
            n.autor = [[self getEnteByName:autorNoticia]retain];
            n.fecha = fechaNoticia;
            n.texto = textoNoticia;
            n.enlace = enlaceNoticia;
            n.tid = threadNoticia;
            if (serieId>0)
                n.serie = [self getSerieById:serieId];
            n.descargas = [[NSArray arrayWithArray:descargas]retain];
            n.imagenes = [[NSArray arrayWithArray:imagenes]retain];
            
            [tmpNoticias addObject:n];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [updateHandler onUpdateStatus:self:[NSString stringWithFormat:NSLocalizedString (@"Analizando la noticia %@", tituloNoticia),@""]];
            });
            noticia = [TBXML nextSiblingNamed:@"Noticia" searchFromElement:noticia];
        }
        
        noticias = [[NSArray arrayWithArray:tmpNoticias]retain];
        
        // parseo finalizado
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateHandler onUpdateStatus:self:NSLocalizedString (@"Terminando el proceso de actualización", @"")];
        });
        [tb release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateHandler onFinishUpdate:self];
        });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [updateHandler onUpdateError:self];
            });
        }
        @finally {
            [lock unlock];
        }        
    });        
}


- (Serie*)getSerieById:(int)codigo {
    for (Serie *s in series) {
        if (s.codigo == codigo)
            return s;
    }
    return nil;
}

- (Ente*)getEnteByName:(NSString*)nombre {
    for (Ente *e in entes) {
        if ([[e.nick lowercaseString] isEqualToString:[nombre lowercaseString]])
            return e;
    }
    return nil;
}

- (Ente*)getEnteById:(int)enteId {
    for (Ente *e in entes) {
        if (e.codigo == enteId)
            return e;
    }
    return nil;
}

- (Noticia*)getNoticiaByCodigo:(int)codigo {
    for (Noticia *n in noticias) {
        if (n.codigo==codigo)
            return n;
    }
    return nil;
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
