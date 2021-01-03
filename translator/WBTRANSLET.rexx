/*********************************************************************/
/* Wagon BASIC - SUBROUTINE for LET                                  */
/*   SYSTEM      : V4R5                                              */
/*   PROGRAMMER  : David Asta                                        */
/*   DATE-WRITTEN: 30/DEC/2020                                       */
/*   (C) 2020 David Asta under MIT License                           */
/*********************************************************************/
/* LET = Assign value to a variable.                                 */
/*                                                                   */
/* PARAMETERS:                                                       */
/*  basline: original BASIC line containing the LET                  */
/*********************************************************************/
PARSE ARG basline
PARSE VAR basline . varname . expr

/* Compose RPG IV line */
SELECT
  WHEN POS('ABS', expr)    \= 0 THEN output = WBTRANSBUF(basline)
  WHEN POS('CONCAT', expr) \= 0 THEN output = WBTRANSBUF(basline)
  WHEN POS('LEN', expr)    \= 0 THEN output = WBTRANSBUF(basline)
  WHEN POS('MID', expr)    \= 0 THEN output = WBTRANSBUF(basline)
  WHEN POS('MOD', expr)    \= 0 THEN output = WBTRANSBUF(basline)
  WHEN POS('SQR', expr)    \= 0 THEN output = WBTRANSBUF(basline)
  OTHERWISE
    output = "C                   EVAL      "
    output = output || varname || " = " || STRIP(expr)
END

RETURN output
