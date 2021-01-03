REM Print each character of a given string

REM Variables Declaration
  VAR string(11) as String
  VAR letter(1) as String
  VAR i(3) as Integer
  VAR total(3) as Integer

  LET string = CONCAT('Wagon','BASIC',1)
  LET total = LEN(string)

REM Print the letters
  FOR i = 1 TO total
    LET letter = MID(string,i,1)
    PRINT letter
  NEXT i
END
