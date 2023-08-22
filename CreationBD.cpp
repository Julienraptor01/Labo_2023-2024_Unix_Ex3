#include <stdio.h>
#include <stdlib.h>
#include <mysql.h>
#include <time.h>
#include <string.h>

typedef struct
{
  char nom[12];
  char groupe[8];
} ETUDIANT;

ETUDIANT Elm[] = 
{
  {"aaa010","g2201"},
  {"ccc002","g2203"},
  {"bbb001","g2202"},
  {"ddd005","g2204"},
  {"aaa006","g2201"},
  {"aaa008","g2201"},
  {"ccc003","g2203"},
  {"aaa009","g2201"},
  {"ddd003","g2204"},
  {"bbb002","g2202"},
  {"aaa004","g2201"},
  {"bbb004","g2202"},
  {"bbb005","g2202"},
  {"bbb006","g2202"},
  {"ddd002","g2204"},
  {"ccc001","g2203"},
  {"ccc003","g2203"},
  {"ddd004","g2204"},
  {"ccc004","g2203"},
  {"aaa001","g2201"},
  {"aaa002","g2201"},
  {"ddd006","g2204"},
  {"aaa003","g2201"},
  {"bbb003","g2202"},
  {"aaa005","g2201"},
  {"ccc005","g2203"},
  {"ccc007","g2203"},
  {"aaa007","g2201"},
  {"ddd001","g2204"},
  {"ccc006","g2203"}
};

int main(int argc,char *argv[])
{
  // Connection a MySql
  printf("Connection a la BD...\n");
  MYSQL* connexion = mysql_init(NULL);
  mysql_real_connect(connexion,"localhost","Student","PassStudent1_","PourStudent",0,0,0);

  // Creation d'une table UNIX_EX3
  printf("Creation de la table UNIX_EX3...\n");
  mysql_query(connexion,"drop table UNIX_EX3;"); // au cas ou elle existerait deja
  mysql_query(connexion,"create table UNIX_EX3 (id INT(4) auto_increment primary key, nom varchar(12),groupe varchar(8));");

  // Ajout de tuples dans la table UNIX_EX3
  printf("Ajout de 30 tuples la table UNIX_EX3...\n");
  char requete[256];
  for (int i=0 ; i<30 ; i++)
  {
	  sprintf(requete,"insert into UNIX_EX3 values (NULL,'%s','%s');",Elm[i].nom,Elm[i].groupe);
	  mysql_query(connexion,requete);
  }

  // Deconnection de la BD
  mysql_close(connexion);
  exit(0);
}
