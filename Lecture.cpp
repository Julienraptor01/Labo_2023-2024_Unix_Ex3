#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mysql.h>
#include <string.h>

int main(int argc,char*argv[])
{
  if (argc != 2) 
  {
	  printf("Erreur: Trop ou trop peu d\'argument(s)...\n");
	  exit(1);
  }

  fprintf(stderr,"Lecture pour le groupe %s\n",argv[1]);

  int  compteur = 0;
  char requete[255];

  // Connection à la BD
  MYSQL* connexion = mysql_init(NULL);
  mysql_real_connect(connexion,"localhost","Student","PassStudent1_","PourStudent",0,0,0);

  // Envoi de la requete de comptage de tuples de la Table UNIX_EX3 pour le groupe précisé
  sprintf(requete,"select count(*) from UNIX_EX3 where groupe = '%s'",argv[1]);
  mysql_query(connexion,requete);
  MYSQL_RES* resultat = mysql_store_result(connexion);
  if (resultat)
  {
    MYSQL_ROW tuple = mysql_fetch_row(resultat); // Ce tuple comprend un seul champ correspondant au comptage demandé 
    compteur = atoi(tuple[0]);
  }

  // Deconnection de la BD
  mysql_close(connexion);

  // Attente de quelques secondes et exit de la valeur obtenue
  fprintf(stderr,"(%d) %s  (attend %d secondes)\n",getpid(),argv[1],compteur);
  sleep(compteur);
  exit(compteur);
}
