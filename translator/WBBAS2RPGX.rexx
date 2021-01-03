/*********************************************************************/
/* Wagon BASIC - Convert BASIC to RPG IV                             */
/*   SYSTEM      : V4R5                                              */
/*   PROGRAMMER  : David Asta                                        */
/*   DATE-WRITTEN: 29/DEC/2020                                       */
/*   (C) 2020 David Asta under MIT License                           */
/*********************************************************************/
/* Translates a Wagon BASIC source code into an RPG IV source code   */
/*                                                                   */
/* PARAMETERS:                                                       */
/*  reccnt: Number of records in BASIC source code                   */
/*          Obtained from RTVMBRD NBRCURRCD in the calling CLP       */
/*********************************************************************/
ARG reccnt

/* Global variables                                                  */
wIndent = "                "   /* 16 spaces */
wIfclause = 0

/*********************************************************************/
/* Main Routine                                                      */
/* Read all records of BASIC source code                             */
/*  and for each line call subroutine that makes the corresponding   */
/*  translation into RPGLE                                           */
/*********************************************************************/
PARSE VERSION vernam vernum verdat
IF vernum < 3.48 THEN DO
  SAY 'This program must run on REXX version 3.48 or greater'
  EXIT 99
  END
PARSE VERSION ver
QUEUE '****************************************************'
QUEUE 'Wagon BASIC to RPGIV conversion started at' TIME()
QUEUE '****************************************************'
SAY wIndent " ********************************************"
SAY wIndent " * Program translated from Wagon BASIC"
SAY wIndent " * with: " vernam vernum verdat
SAY wIndent " ********************************************"

SAY wIndent " * Uncomment next line for full RPGLE optimisation"
SAY wIndent "H*OPTIMIZE(*FULL)"

DO reccnt
  PARSE LINEIN line
  PARSE VAR line rubbish 13 basline

  /* Store original line for later usage */
  origline = basline

  /* Parse basline into an array of compound variables */
  DO count = 1 until basline = ''
    PARSE VAR basline word.count basline
  END

  /* Identify the BASIC keyword and call corresponding subroutine */
  rpgline = ''
  SELECT
    WHEN word.1 == "BREAK"   THEN CALL trans_BREAK
    WHEN word.1 == "DIM"     THEN rpgline = WBTRANSDIM(origline)
    WHEN word.1 == "DO"      THEN CALL trans_DO
    WHEN word.1 == "LOOP"    THEN CALL trans_LOOP
    WHEN word.1 == "END"     THEN CALL trans_END
    WHEN word.1 == "FOR"     THEN rpgline = WBTRANSFOR(origline)
    WHEN word.1 == "NEXT"    THEN rpgline = WBTRANSFOR(origline)
    WHEN word.1 == "GOSUB"   THEN CALL trans_GOSUB
    WHEN word.1 == "IF"      THEN CALL WBTRANSIFE origline
    WHEN word.1 == "ELSE"    THEN CALL WBTRANSIFE origline
    WHEN word.1 == "ENDIF"   THEN CALL trans_ENDIF
    WHEN word.1 == "ITERATE" THEN CALL trans_ITERATE
    WHEN word.1 == "LET"     THEN rpgline = WBTRANSLET(origline)
    WHEN word.1 == "PRINT"   THEN CALL trans_PRINT
    WHEN word.1 == "REM"     THEN CALL trans_REM
    WHEN word.1 == "STOP"    THEN CALL trans_STOP
    WHEN word.1 == "SUB"     THEN CALL trans_SUB
    WHEN word.1 == "ENDSUB"  THEN CALL trans_ENDSUB
    WHEN word.1 == "VAR"     THEN rpgline = WBTRANSVAR(origline)
    WHEN word.1 == "" THEN NOP
    OTHERWISE SAY wIndent "ERROR: Not understood" word.1
  END
  IF rpgline \= '' THEN DO
    SAY wIndent rpgline
    QUEUE 'BASIC: ' || STRIP(origline)
    QUEUE 'RPGIV: ' || STRIP(rpgline)
    QUEUE '-----------------------------------------------------------'
    END
END

/* End this program                                                  */
QUEUE '****************************************************'
QUEUE 'Wagon BASIC to RPGIV conversion finished at' TIME()
QUEUE '****************************************************'
EXIT

/*********************************************************************/
/* BASIC to RPGLE translation subroutines                            */
/*********************************************************************/

trans_BREAK:
  SAY wIndent "C                   LEAVE"
RETURN

trans_DO:
  PARSE VAR origline . expr
  expr = STRIP(expr)
  len  = POS(')', expr) - POS('(', expr) - 1
  cond = SUBSTR(expr, POS('(', expr) + 1, len)
  IF POS('WHILE', expr) \= 0 THEN
    SAY wIndent "C                   DOW       " || cond
  ELSE
    SAY wIndent "C                   DOU       " || cond
RETURN

trans_END:
  SAY wIndent "C                   EXSR      ENDPGM"
  SAY wIndent "C     ENDPGM        BEGSR"
  SAY wIndent "C                   EVAL      *INLR = *ON"
  SAY wIndent "C                   RETURN"
  SAY wIndent "C                   ENDSR"
RETURN

trans_ENDIF:
  SAY wIndent "C                   ENDIF"
RETURN

trans_ENDSUB:
  SAY wIndent "C                   ENDSR"
RETURN

trans_GOSUB:
  SAY wIndent "C                   EXSR     " word.2
RETURN

trans_ITERATE:
  SAY wIndent "C                   ITER"
RETURN

trans_LOOP:
  SAY wIndent "C                   ENDDO"
RETURN

trans_PRINT:
  PARSE VAR origline . expr
  expr = STRIP(expr)
  /* The length of <expr> can be of 14 characters maximum */
  IF LENGTH(expr) > 14 THEN SAY wIndent "Syntax Error: <expr> too long"
  ELSE
    output = "C                   DSPLY"
    SAY wIndent OVERLAY(expr, output, 7)
RETURN

trans_REM:
  PARSE VAR origline rem comment   /* Remove word REM */
  SAY wIndent " *" STRIP(comment)
RETURN

trans_STOP:
  SAY wIndent "C                   EXSR      ENDPGM"
RETURN

trans_SUB:
  output = wIndent "C                   BEGSR"
  SAY OVERLAY(STRIP(word.2), output, LENGTH(wIndent) + 8)
RETURN

