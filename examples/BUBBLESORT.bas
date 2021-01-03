REM Generates 10 random numbers
REM and then sorts them using Bubble Sorting

REM Variables Declaration
  DIM 10 aNums(3) as Integer
  VAR c1(3) as Integer
  VAR c2(3) as Integer
  VAR changed(3) as Integer
  VAR tmp(3) as Integer

REM Fill array with 10 numbers
  LET aNums(1) = 10
  LET aNums(2) = 54
  LET aNums(3) = 78
  LET aNums(4) = 49
  LET aNums(5) = 67
  LET aNums(6) = 14
  LET aNums(7) = 40
  LET aNums(8) = 47
  LET aNums(9) = 87
  LET aNums(10) = 39

REM Bubble sort
  FOR c1 = 1 TO 9
    FOR c2 = c1 + 1 TO 10
      IF aNums(c1) > aNums(c2) THEN DO
        LET tmp = aNums(c1)
        LET aNums(c1) = aNums(c2)
        LET aNums(c2) = tmp
      ENDIF
    NEXT c2
  NEXT c1

REM Print the sorted numbers in order
    FOR c1 = 1 TO 10
      PRINT aNums(c1)
    NEXT c1
END
