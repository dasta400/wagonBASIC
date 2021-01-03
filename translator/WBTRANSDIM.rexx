/*********************************************************************/
/* Wagon BASIC - SUBROUTINE for DIM                                  */
/*   SYSTEM      : V4R5                                              */
/*   PROGRAMMER  : David Asta                                        */
/*   DATE-WRITTEN: 02/JAN/2021                                       */
/*   (C) 2020 David Asta under MIT License                           */
/*********************************************************************/
/* DIM = Defines an array.                                           */
/*                                                                   */
/* PARAMETERS:                                                       */
/*  basline: original BASIC line containing the LET                  */
/*********************************************************************/
PARSE ARG basline
PARSE VAR basline kwrd elements var as datatype

var = STRIP(var)
obrkpos = POS('(', var)
cbrkpos = POS(')', var)
varname = SUBSTR(var, 1, obrkpos - 1)
varlen  = SUBSTR(var, obrkpos + 1, cbrkpos - obrkpos - 1)
datatype = TRANSLATE(datatype) /* Convert to uppercase */

SELECT
  WHEN datatype = 'STRING' THEN DO
    vartype = 'A'
    vardecp = ''
    END
  WHEN datatype = 'INTEGER' THEN DO
    vartype = 'I'
    vardecp = '0'
    END
  WHEN datatype = 'REAL' THEN DO
    vartype = 'P'
    commapos = POS(',', var)
    varlen  = SUBSTR(var, obrkpos + 1, commapos - obrkpos - 1)
    vardecp = SUBSTR(var, commapos + 1, cbrkpos - commapos - 1)
    END
END

/* Compose RPGLE line */
output = "D                 S"
output = OVERLAY(varname, output, 2)
output = OVERLAY(varlen, output, 35 - LENGTH(varlen))
output = OVERLAY(vartype, output, 35)
output = OVERLAY(vardecp, output, 37) || " DIM(" || elements || ")"

RETURN output
