/*********************************************************************/
/* Wagon BASIC - SUBROUTINE for IF...THEN...ELSE                     */
/*   SYSTEM      : V4R5                                              */
/*   PROGRAMMER  : David Asta                                        */
/*   DATE-WRITTEN: 31/DEC/2020                                       */
/*   (C) 2020 David Asta under MIT License                           */
/*********************************************************************/
/* IF <condition> THEN <expression1>                                 */
/* <expression> can be a GOSUB, DO or a full expression.             */
/* If <expression> is a DO, the IF must be terminated with an ENDIF. */
/*                                                                   */
/* PARAMETERS:                                                       */
/*  basline: original BASIC line containing the IF                   */
/*********************************************************************/
PARSE ARG basline
PARSE VAR basline keyword rest

wIndent = "                "   /* 16 spaces */

IF keyword = 'ELSE' THEN SAY wIndent "C                   ELSE"
ELSE DO
  /* is an IF, therefore it must have a THEN */
  thenpos = POS('THEN', rest)
  IF thenpos \= 0 THEN DO
    cond = SUBSTR(rest, 1, thenpos - 1)
    SAY wIndent "C                   IF       " STRIP(cond)
    expr = SUBSTR(rest, thenpos + 5)
    END
  ELSE
    /* Syntax error: THEN missing */
    NOP
  END

/* Check if <expression> is a GOSUB, DO, or an expression */
IF POS('GOSUB', rest) \= 0 THEN CALL do_gosub
ELSE
  IF POS('DO', rest) = 0 THEN
    SAY wIndent "C                   EVAL     " STRIP(expr)

RETURN

/*********************************************************************/
/* FUNCTIONS                                                         */
/*********************************************************************/
do_gosub:
  /* Parse expr into an array of compound variables */
  DO count = 1 until rest = ''
    PARSE VAR rest word.count rest
  END
  SAY wIndent "C                   EXSR     " word.2
RETURN
