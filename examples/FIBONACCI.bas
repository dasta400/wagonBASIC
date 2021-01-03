REM Print 10 numbers of the Fibonacci sequence

REM Variables Declaration
  VAR n1(3) AS INTEGER
  VAR n2(3) AS INTEGER
  VAR k(3) AS INTEGER
  VAR sum(3) AS INTEGER

REM Program
  LET n1 = 0
  LET n2 = 1

  FOR k = 1 TO 10
    LET sum = n1 + n2
    PRINT sum
    LET n1 = n2
    LET n2 = sum
  NEXT k
END
