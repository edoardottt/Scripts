#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <stdbool.h>
#include <string.h>

bool r;
bool w;
bool directory;
main(int argc, char *argv[])
{
  int i;
  if (argc != 4) /* il programma non viene avviato con gli argomenti richiesti */
    {
      fprintf(stderr,"Usage %s file sed_script\n",argv[0]);exit(10);
    }
  struct stat fileStat;
  stat(argv[1],&fileStat);
  int len=fileStat.st_size;
  if ((S_ISDIR(fileStat.st_mode))) {directory=true;} else {directory=false;}        //controlla se è una directory
  if ((fileStat.st_mode & S_IRUSR)>0)  {r=true;} else {r=false;}                    //controlla se è accessibile in lettura
  if ((fileStat.st_mode & S_IWUSR)>0) {w=true;} else {w=false;}                     //controlla se è accessibile in scrittura
  /* il file 1 non è accessibile */
  if (!((!(directory))&& r && w))
    { char *re;
      if (r==false) {re="read from"; }
      else {if (w==false) {re="write to";}}
      fprintf(stderr,"Unable to %s file %s because of ",re,argv[1]);
      perror("Error");
      exit(20);
    }
    int ii;
    int appoggio[70000];
    FILE *file = fopen(argv[1],"rb");                                               //puntatore al file.bin_in in lettura
    int c;
    int contatore=0;
    int flag=1;
    int index1=0;
    while(contatore<len)                                                            //finché contatore è minore della lunghezza del file
    {
      c = fgetc(file);                                                              //c = primo carattere disponibile nel file
      contatore++;
      for (ii = 0; ii < 8; ii++)
      {
          if (flag==1)                                                              //se devo scartare i primi 4 bit
            {
              if (ii==0 || ii==1 || ii==2 || ii==3)                                 //se sono diversi da 0 va in errore
              {
                if ((!!((c<<ii) & 0x80)) != 0)
                {fprintf(stderr,"Wrong format for input binary file %s at byte %d\n",argv[1],contatore-1);
                fclose(file); FILE *out= fopen(argv[2],"ab+");
                if(out == NULL)                                                     //se il file di output non esiste crealo
                {freopen(argv[2], "ab+", out);}fclose(out);exit(30);
                }
              }
              else if (ii==4 || ii==5 || ii==6 || ii==7)                            //questi invece li salvo in un array appoggio
              {
                int app=!!((c<<ii) & 0x80);
                appoggio[index1]=app;
                index1++;                                                           //index1= indice dell'array appoggio
              }
            }
          if (flag==2)                                                              //se devo scartare i secondi 4 bit
            {
              if (ii==4 || ii==5 || ii==6 || ii==7)                                 //se sono diversi da 0 va in errore
              {
                if ((!!((c<<ii) & 0x80)) != 0)
                  {fprintf(stderr,"Wrong format for input binary file %s at byte %d\n",argv[1],contatore-1);
                  fclose(file); FILE *out= fopen(argv[2],"ab+");
                  if(out == NULL)                                                   //se il file di output non esiste, crealo
                  {freopen(argv[2], "ab+", out);}fclose(out);exit(30);
                  }
              }
              else if (ii==0 || ii==1 || ii==2 || ii==3)                            //questi invece li salvo in un array appoggio
                {
                  int app=!!((c<<ii) & 0x80);
                  appoggio[index1]=app;
                  index1++;
                }
            }
          if (flag==1 && ii==7) {flag=2;}                                           //scambio di flag quando finisce un byte
          else {
                  if (flag==2 && ii==7) {flag=1;}
               }
      }
    }
    fclose(file);                                                                   // libera puntatore file input
    char appoggio2[index1];
    unsigned char appoggio3;
    int index2=0;
    int iii=0;
    while (index2<index1)
      {
            appoggio3 = appoggio[index2]<<7 |
                        appoggio[index2+1]<<6 |
                        appoggio[index2+2]<<5 |
                        appoggio[index2+3]<<4 |
                        appoggio[index2+4]<<3 |
                        appoggio[index2+5]<<2 |                                     //RICOMPATTA I BIT IN CARATTERI
                        appoggio[index2+6]<<1 |
                        appoggio[index2+7]<<0;
            appoggio2[iii]=appoggio3;
            iii++;
            index2=index2+8;
      }
    FILE *fp = fopen("temp.bin", "ab");                                             // fp=puntatore ad un file temporaneo
    fwrite(appoggio2,1,iii,fp);                                                     // scrivi appoggio2 nel file temporaneo
    fclose(fp);                                                                     // libera puntatore file temporaneo
   /*SED*/
   char sedb[6000];                                                                 // sedb = stringa finale
   int cont=0;
   int filedes[2];
   pipe(filedes);
   pid_t id_figlio = fork();
   if ( id_figlio == 0)
   {
     dup2(filedes[1],STDOUT_FILENO);                                                 // se sono il figlio duplico lo stdout sul file descriptor
     close(filedes[0]);
     close(filedes[1]);
     execl("/bin/sed","sed","-e",argv[3],"temp.bin",NULL);                           //eseguo sed
   }
   else
   {
     close(filedes[1]);
     wait(NULL);                                                                      // sincronizzo i processi
     int num=0;
     while(true)
     {
       char temp[1];
       int byte=read(filedes[0],temp,1);
       if (byte<1) {break;}                                                           // salvo carattere per carattere il risultato in sedb
       sedb[num]=temp[0];
       num++;
       cont++;
     }
     sedb[num]='\0';
   }
     int offuscato[100000];
     int indice_sed=0;
     int char_sed_off=0;
     int indice_offuscato=0;
     while (indice_sed<cont)
     {                                                                                //primi quattro bit per offuscamento
       offuscato[indice_offuscato]=0;
       offuscato[indice_offuscato+1]=0;
       offuscato[indice_offuscato+2]=0;
       offuscato[indice_offuscato+3]=0;
       //scrittura char in byte
       char character=sedb[indice_sed];
       offuscato[indice_offuscato+4]=!!((character<<0) & 0x80);
       offuscato[indice_offuscato+5]=!!((character<<1) & 0x80);
       offuscato[indice_offuscato+6]=!!((character<<2) & 0x80);
       offuscato[indice_offuscato+7]=!!((character<<3) & 0x80);
       offuscato[indice_offuscato+8]=!!((character<<4) & 0x80);
       offuscato[indice_offuscato+9]=!!((character<<5) & 0x80);
       offuscato[indice_offuscato+10]=!!((character<<6) & 0x80);
       offuscato[indice_offuscato+11]=!!((character<<7) & 0x80);
       //ultimi quattro bit per offuscamento
       offuscato[indice_offuscato+12]=0;
       offuscato[indice_offuscato+13]=0;
       offuscato[indice_offuscato+14]=0;
       offuscato[indice_offuscato+15]=0;
       indice_offuscato=indice_offuscato+16;
       indice_sed++;
       char_sed_off=char_sed_off+2;
     }
     int ind_off=0;
     int ind_sed=0;
     unsigned char appoggio4;
     char offuscamento[char_sed_off];
     while(ind_sed<char_sed_off)
     {                                                                                // offuscamento finale
       appoggio4 = offuscato[ind_off]<<7 |
                   offuscato[ind_off+1]<<6 |
                   offuscato[ind_off+2]<<5 |
                   offuscato[ind_off+3]<<4 |
                   offuscato[ind_off+4]<<3 |
                   offuscato[ind_off+5]<<2 |
                   offuscato[ind_off+6]<<1 |
                   offuscato[ind_off+7]<<0;
       offuscamento[ind_sed]=appoggio4;
       ind_sed++;
       ind_off=ind_off+8;
     }
     FILE *out;
    out = fopen(argv[2],"ab+");                                                        // se non esiste il file.bin_out, crealo.
    if(out == NULL)                                                                    // poi scrivi il risultato offuscato nel file di output
    {                                                                                  // libera il puntatore di output e rimuovi il file temporaneo.
        freopen(argv[2], "ab+", out);
    }
     fwrite(offuscamento,1,ind_sed,out);
     fclose(out);
     remove("temp.bin");
}
