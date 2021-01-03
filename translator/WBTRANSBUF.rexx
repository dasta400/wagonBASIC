/*********************************************************************/
/* Wagon BASIC - Translate Built-In Functions                        */
/*   SYSTEM      : V4R5                                              */
/*   PROGRAMMER  : David Asta                                        */
/*   DATE-WRITTEN: 30/DEC/2020                                       */
/*   (C) 2020 David Asta under MIT License                           */
/*********************************************************************/
/* Translation for Wagon BASIC Built-In Functions:                   */
/*   ABS, SQR                                                        */
/*                                                                   */
/* PARAMETERS:                                                       */
/*  basline: original BASIC line                                     */
/*********************************************************************/
PARSE ARG basline
PARSE VAR basline let var equal expr

output = ''
expr = STRIP(expr)

SELECT
  WHEN POS('ABS', expr)    \= 0 THEN CALL func_ABS
  WHEN POS('CONCAT', expr) \= 0 THEN CALL func_CONCAT
  WHEN POS('LEN', expr)    \= 0 THEN CALL func_LEN
  WHEN POS('MID', expr)    \= 0 THEN CALL func_MID
  WHEN POS('MOD', expr)    \= 0 THEN CALL func_MOD
  WHEN POS('SQR', expr)    \= 0 THEN CALL func_SQR
  OTHERWISE SAY "                ERROR: Not understood" basline
END
RETURN output

/*********************************************************************/
/* BASIC to RPGLE translation subroutines                            */
/*********************************************************************/

func_ABS:
  output = "C                   EVAL      " || var || " = %" || expr
RETURN

func_CONCAT:
  expr = TRANSLATE(expr,' ', '(')
  expr = TRANSLATE(expr, ' ', ')')
  expr = TRANSLATE(expr, ' ', ',')
  PARSE VAR expr concat string1 string2 blanks
  IF LENGTH(blanks) > 0 THEN factor2 = string2 || ":" || blanks
  ELSE factor2 = string2 || ":0"
  output = "C                   CAT                    " var
  output = OVERLAY(string1, output, 7)
  output = OVERLAY(factor2, output, 31)
RETURN

func_LEN:
  output = "C                   EVAL      " || var || " = %" || expr
RETURN

func_MID:
  expr = TRANSLATE(expr,' ', '(')
  expr = TRANSLATE(expr, ' ', ')')
  expr = TRANSLATE(expr, ' ', ',')
  PARSE VAR expr mid string start length
  output = "C                   EVAL      " || var || " = "
  output = output || "%SUBST(" || string || ":" || start
  IF LENGTH(length) > 0 THEN output = output || ":" || length
  output = STRIP(output) || ")"
RETURN

func_MOD:
  PARSE VAR expr divend mod divsor
  output = "C                   EVAL      " || var || " = %REM("
  output = output || divend || ":" || divsor || ")"
RETURN

func_SQR:
 /* I'm using an AS/400 with OS/400 V4R5 and some ILERPG functions   */
 /* are not available in my compiler. For example %SQRT.             */
 /* So I'm translating it to the RPG/400 (a.k.a. RPGIII) format.     */
 output = "C                   SQRT                   " var
 len = LENGTH(expr) - POS('(', expr) - 1
 pos = POS('(', expr)
 expr = SUBSTR(expr, POS('(', expr) + 1, len)
 output = OVERLAY(expr, output, 31)

 /* Below is the translation for %SQRT. I've not tested it.          */
 /* output = "C                   EVAL      " || var || " = %" ||expr*/
 /* output = INSERT('T', output, POS('(', output) - 1, 1)            */
RETURN
