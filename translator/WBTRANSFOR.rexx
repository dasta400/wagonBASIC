/*********************************************************************/
/* Wagon BASIC - SUBROUTINE for FOR...TO...STEP                      */
/*   SYSTEM      : V4R5                                              */
/*   PROGRAMMER  : David Asta                                        */
/*   DATE-WRITTEN: 01/JAN/2021                                       */
/*   (C) 2020 David Asta under MIT License                           */
/*********************************************************************/
/* FOR = Repeats a group of operations and controls the number of    */
/*       times the group will be processed.                          */
/*                                                                   */
/* PARAMETERS:                                                       */
/*  basline: original BASIC line containing the LET                  */
/*********************************************************************/
PARSE ARG basline
PARSE VAR basline kwrd index . expr

/* Compose RPG IV line */
IF kwrd = 'FOR' THEN DO
  /* If the STEP is in the expression, change it for BY */
  step = POS('STEP', expr)
  IF step \= 0 THEN DO
    expr = DELWORD(expr, WORDPOS('STEP', expr), 1)
    expr = INSERT('BY ', expr, step - 1)
    END
  output = "C                   FOR       "
  output = output || index || " = " || STRIP(expr)
  END
ELSE output = "C                   ENDFOR"

RETURN output
