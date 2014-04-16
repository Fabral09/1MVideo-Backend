#!/usr/bin/perl

###############################################################################
# Nome: main.pl
#
# Autore: Fabrizio Alonzi
#
# Descrizione: Contiene lo script per l'assegnazione degli extended attributes
# ai file video e la loro memorizzazione all'interno del db
###############################################################################

use strict;
use warnings;
use diagnostics;
use File::Basename;
use DBI;

use constant FILES_DIRECTORY => './files'; # Directory che contiene i file video e .m
my @filesM; # Hash che contiene i nomi dei file .m
my $connMySQL; # Variabile di connessione al db

########################################
# Procedura di scrittura dei dati su db
########################################

sub ScriviSuDB
{
 my (%localHash) = @_; # Effettuo il push nella variabile localHash dei valori passati nella chiamata alla funzione
 
 # Aggiungo le info del file video nel db
 my $query = "INSERT INTO tbl_videos ( id, file_name, video_id, user_id, device, 
 s_geo_position, s_gravity, s_linear_acceleration, s_orientation, s_gyroscope, duration, original_name,
 type, tmp_name, error, size, server_name ) VALUES ( NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )";

 my $insertVideoQuery = $connMySQL->prepare( $query );
 $insertVideoQuery->execute( 
 ( $localHash{"file_name"} or '' ), ( $localHash{"videoid"} or '' ), ( $localHash{"user_id"} or '' ), ( $localHash{"device"} or '' ), ( $localHash{"s_geo_position"} or '' ), ( $localHash{"s_gravity"} or '' ), ( $localHash{"s_linear_acceleration"} or '' ), ( $localHash{"s_orientation"} or '' ), ( $localHash{"s_gyroscope"} or '' ), ( $localHash{"duration"} or '0' ), ( $localHash{"original_name"} or '' ), ( $localHash{"type"} or '' ), ( $localHash{"tmp_name"} or '' ), ( $localHash{"error"} or '0' ), ( $localHash{"size"} or '0' ), ( $localHash{"server_name"} or '' ) ) or die( "IMPOSSIBILE ESEGUIRE LA QUERY DI INSERIMENTO NUOVO VIDEO!\n" );

 # Recupero l'ID dell'ultimo video inserito ovvero quello inserito tramite la query precedente
 my $selectLastIdQuery = $connMySQL->prepare( "SELECT LAST_INSERT_ID()" );
 $selectLastIdQuery->execute() or die( "IMPOSSIBILE ESEGUIRE LA QUERY DI RECUPERO DELL'ID DELL'ULTIMO VIDEO INSERITO!\n" );
 my @result = $selectLastIdQuery->fetchrow_array();
 my $lastInsertedId = $result[0]; # $lastInsertedId contiene l'id dell'ultimo file video inserito nel db
 $selectLastIdQuery->finish();
 
 # Inizio a scorrere i campi tags associati al video inserito nel db
 my $selectIdTagValueQuery;
 
 foreach my $key ( keys %localHash )
 {
  # Verifico se l'elemento su cui mi trovo è un campo "tag_" ...
  if ( index( $key, "tag_" ) != -1 )
  {
   # ... e nel caso in cui il test è positivo, recupero l'id del valore tag associato al campo
   $selectIdTagValueQuery = $connMySQL->prepare( "SELECT id FROM tbl_valori_tags WHERE valore_tag = ?" );
   $selectIdTagValueQuery->execute( $localHash{$key} ) or die( "IMPOSSIBILE ESEGUIRE LA QUERY DI SELEZIONE DEL VALORE TAG!\n" );
   # Se il valore del campo ha un id, allora è un valore predefinito nel db ...
   if ( my @data = $selectIdTagValueQuery->fetchrow_array() )
   {
    # ... e posso eseguire la query di registrazione ... 
    my $insertTagsVideosInfo = $connMySQL->prepare( "INSERT INTO tbl_tags_videos VALUES ( NULL, ?, ?, '', ? )" );
	$insertTagsVideosInfo->execute( $data[0], $key, $lastInsertedId ) or die( "IMPOSSIBILE ESEGUIRE LA QUERY!\n" );
	$insertTagsVideosInfo->finish();
    print( "CHIAVE: " . $key . " || VALORE: " . $localHash{$key} . " || ID: " . $data[0] . "\n" );
   }
   else
   {
    # ... altrimenti vuol dire che il campo è di tipo personalizzato e specifico il nuovo valore lasciando a 0
	# il campo di id del valore tag.
    my $insertTagsVideosInfo = $connMySQL->prepare( "INSERT INTO tbl_tags_videos VALUES ( NULL, 0, ?, ?, ? )" );
	#$insertTagsVideosInfo->trace( 2 );
	$insertTagsVideosInfo->execute( $key, ( $localHash{$key} or '' ), $lastInsertedId ) or die( "IMPOSSIBILE ESEGUIRE LA QUERY!\n" );
	$insertTagsVideosInfo->finish();
    print( "HAI INSERITO UN VALORE PERSONALIZZATO!\n" );
   }
  }
 }
 $selectIdTagValueQuery->finish();
}

############################################
# Procedura di recupero dei nomi dei file .m
############################################

sub RecuperoElencoFileM
{
 # Apro la directory
 opendir(DIR, FILES_DIRECTORY) or die $!;
 # Inizio a navigare nella directory
 while (my $file = readdir(DIR)) 
 {
  # Verifico se l'elemento attuale è un file
  next unless (-f FILES_DIRECTORY . "/$file");
  # Uso una regular exp per verificare se il file è .m
  next unless ($file =~ m/\.m$/);
  # Se .m allora aggiungo il nome all'array globale dei files
  push( @filesM, $file );
 }
 # Chiudo la directory
 closedir(DIR);	
}

#############################################################################
# Procedura scansione dei file .m e di assegnazione degli extended attributes
#############################################################################

sub ScansioneFilesM
{
 # Per ogni file nell'array
 foreach( @filesM )
 {
  # Recupero il nome del file .m
  my $fileM = $_;
  # Ricavo il nome del relativo file video associato
  my $fileVideo = basename("$fileM",  ".m");
  $fileVideo .= ".v";
    
  # Apro il file .m ...
  open( MYFILE, FILES_DIRECTORY . "/$fileM" );
  print( "FILE M: $fileM  ||  FILE VIDEO: $fileVideo\n" ); # ... stampo il suo nome ...
  print( "\n==============================\n\n" );
  # ... e ne stampo le righe contenute
  my %hashDB;
  
  # Memorizzo il nome del file, campo non presente nel file .m, nell'hash
  $hashDB{"file_name"} = $fileVideo;
  
  while( <MYFILE> )
  {
   chomp;
   my @hash = split( '=', $_ );
   # Effettuo un controllo per verificare di non trovarmi sulla riga tags ( da escludere dal processo di assegnazione degli extended attributes )
   if ( $hash[0] eq "tags" )
   {
    next;
   }
   else
   {
	$hashDB{$hash[0]} = $hash[1];
	# Lancio il comando bash per l'assegnazione della copia chiave / valore come extended attribute del file
    my $dir = FILES_DIRECTORY;
    `attr -s $hash[0] -V "$hash[1]" $dir/$fileVideo`
   }
  }
  ScriviSuDB( %hashDB );
  close( MYFILE );
  print( "\n\n==============================\n\n" );
 }
}

#######################
# Procedura principale
#######################

sub Main
{
 print( "\n\nPROCEDURA AVVIATA!\n\n" );
 # Effettuo la connessione con MySQL
 $connMySQL = DBI->connect('DBI:mysql:1mvideo', 'root', 'your_password' ) or die( "IMPOSSIBILE COLLEGARSI AL DB!\n" ); 
 RecuperoElencoFileM();
 ScansioneFilesM();
 # Chiudo la connessione
 $connMySQL->disconnect();		
 print( "PROCEDURA TERMINATA!\n\n" );
}

Main( @ARGV );
