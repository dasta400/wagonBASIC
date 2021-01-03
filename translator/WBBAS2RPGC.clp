/*********************************************************************/
/* Wagon BASIC - Convert BASIC to RPG IV                             */
/*   SYSTEM      : V4R5                                              */
/*   PROGRAMMER  : David Asta                                        */
/*   DATE-WRITTEN: 29/DEC/2020                                       */
/*   (C) 2020 David Asta under MIT License                           */
/*********************************************************************/
/* Call a REXX script that translates a Wagon BASIC source code into */
/*   an RPG IV source code                                           */
/* The source BAS must be located in &BASLIB/&BASOBJ(&BASMBR)        */
/* The resulting RPG will be created in &RPGLIB/&RPGOBJ(&RPGMBR)     */
/*                                                                   */
/* PARAMETERS:                                                       */
/*  &BASLIB: LIB where the BAS source code is located                */
/*  &BASOBJ: OBJ where the PF-SRC containing the BAS is located      */
/*  &BASMBR: MBR containing the BASIC source code                    */
/*  &RPGLIB: LIB where the RPG source code will be created           */
/*  &RPGOBJ: OBJ where the PF-SRC that will contain the RPG is locat.*/
/*  &RPGMBR: MBR for the new RPG source code                         */
/*********************************************************************/
             PGM        PARM(&BASLIB &BASOBJ &BASMBR &RPGLIB &RPGOBJ +
                          &RPGMBR)

             DCL        VAR(&BASLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BASOBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BASMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPGLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPGOBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPGMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECCNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RECCNTC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BASTEXT) TYPE(*CHAR) LEN(50)

         /* Get number or records in BAS member to convert */
             RTVMBRD    FILE(&BASLIB/&BASOBJ) MBR(&BASMBR) +
                          NBRCURRCD(&RECCNT)
         /* Convert it to *CHAR, to be able to pass it to REXX */
             CHGVAR     VAR(&RECCNTC) VALUE(&RECCNT)
         /* OVRDBF the BAS member to STDIN, so that REXX can read it */
             OVRDBF     FILE(STDIN) TOFILE(&BASLIB/&BASOBJ) +
                          MBR(&BASMBR) OVRSCOPE(*JOB)
         /* Get TEXT from BAS, so that the RPG will have the same */
             RTVMBRD    FILE(&BASLIB/&BASOBJ) MBR(&BASMBR) +
                          TEXT(&BASTEXT)
         /* Create MBR for resulting RPG */
             RMVM       FILE(&RPGLIB/&RPGOBJ) MBR(&RPGMBR)
             MONMSG     MSGID(CPF7310)
             ADDPFM     FILE(&RPGLIB/&RPGOBJ) MBR(&RPGMBR) +
                          TEXT(&BASTEXT) SRCTYPE(RPGLE)
         /* OVRDBF the RPG member to STDOUT, so that REXX can write  */
             OVRDBF     FILE(STDOUT) TOFILE(&RPGLIB/&RPGOBJ) +
                          MBR(&RPGMBR) OVRSCOPE(*JOB)
         /* Call the REXX conversion program */
             STRREXPRC  SRCMBR(WBBAS2RPGX) +
                          SRCFILE(WAGONBASIC/TRANSLATOR) PARM(&RECCNTC)
         /* Remove OVRDBF */
             DLTOVR     FILE(STDIN) LVL(*JOB)
             DLTOVR     FILE(STDOUT) LVL(*JOB)

         /* OVRDBF STDOUT to QPRINT, to print the conversion log */
             OVRDBF     FILE(STDOUT) TOFILE(QPRINT)
         /* Call the REXX log printer program */
             STRREXPRC  SRCMBR(WBPRNCONVR) +
                          SRCFILE(WAGONBASIC/TRANSLATOR)

             ENDPGM
