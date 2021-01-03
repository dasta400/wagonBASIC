# Wagon BASIC REXX2RPG4 - Converts BASIC to RPG IV

**Wagon BASIC REXX2RPG4** is a translator of BASIC language into RPG IV (a.k.a. RPGLE). It is mainly a REXX/400 script (though a CLP is used to call it) that converts source code written in BASIC (my own dialect) to RPGLE source code, which then can be compiled on the AS/400.

**DISCLAIMERS**:

1. This is my first REXX program in 30 years, after my first encounter with ARexx for the Commodore Amiga, so do not expect high quality, super efficient and professional code here. I hope with time and practice I'll get better and I'll be able to improve the code if needed.

---

## Table of contents

- [Wagon BASIC language](#wagon-basic-language)
  - [Wagon BASIC Dialect specifications](#wagon-basic-dialect-specifications)
- [Steps to write and *execute* a *Wagon BASIC* program](#steps-to-write-and-execute-a-wagon-basic-program)
- [Frequently Asked Questions (F.A.Q.)](#frequently-asked-questions-faq)
- [Roadmap](#roadmap)
- [Changelog](#changelog)

---

## Wagon BASIC language

*Wagon BASIC* is a dialect of the [BASIC programming language](https://en.wikipedia.org/wiki/BASIC) that  can be used to write BASIC programs, which can then be translated into RPG IV and thus compiled on the AS/400.

The idea for *Wagon BASIC* came after I found out (thanks to my friend Patrik) that there is a BASIC for AS/400 but it cannot be used in OS/400 V4R5, which is the version I use. I learned software programming as a kid with BASIC, so somehow I owe to BASIC most of my professional career and now my hobby. I was looking for some project to learn REXX/400, and I thought these two ideas could fit together.

### Wagon BASIC Dialect specifications

- Source code is case insensitive. It can be entered all in lowercase, all in uppercase or a mix.
- Line numbers are not necessary.
  - hence, GOTO is not implemented.
  - and GOSUB, instead of transferring the control of the program to a line number, transfers the control to a subroutine, defined by SUB...ENDSUB. Therefore, RETURN is not implemented.
- Code can be indented. The translator will ignore any leading blanks on each line.
- Keywords, identifiers, operators and values MUST be separated by at least one space in between (LET A = B is correct, but LET A=B is not). The reason behind this is not other than I'm using the REXX built-in function PARSE in its most simple form, which is basically splitting strings into separated variables separated by space.
- Variables
  - All variables are Global.
  - In RPGLE, variables are case insensitve, so it's easier for me to keep it that way. Thus, *VAR1* and *var1* are the same variable.
  - Limitation from RPGLE: variable names can be a maximum of 15 characters.
  - Assignments MUST use the keyword LET (e.g. LET A = B is correct, A = B is not correct). Though the use of LET was dropped very early in BASIC versions, I decided to keep it for simplicity in my script. If every line starts with a keyword, it's easier to parse.
  - All variables MUST be declared (with VAR) at the beginning of the program. For simplicity, I'm just following the RPG order of pages here. It simplifies my REXX script. If variables were declared all over the code, I would have to keep inserting records at the beginning of the generated RPG or do some kind of multi-pass translation. I think it's actually good to have all declarations at the top, as it makes code clearer.

---

## Steps to write and *execute* a *Wagon BASIC* program

- Write a program in SEU, that follows the [Wagon BASIC's Dialect specifications](dialectspecifications).
- CALL WBBAS2RPGC with the following parameters (all *CHAR):
  - LIB where the PF-SRC with the BASIC programs is.
  - PF-SRC with the BASIC programs (e.g. QBASSRC).
  - MBR with the BASIC program.
  - LIB where the PF-SRC with the RPGLE programs is.
  - PF-SRC with the RPGLE programs (e.g. QRPGLESRC).
  - MBR for the RPGLE program.
  - Example: *CALL PGM(WAGONBASIC/WBBAS2RPGC) PARM('WAGONBASIC' 'QBASSRC' 'HELLOW' 'WAGONBASIC' 'QRPGLESRC' 'HELLOW')*
- Use CRTBNDRPG as usual to copile the generated RPGLE.

---

## Frequently Asked Questions (F.A.Q.)

- **Why is is called *Wagon BASIC*?**
  - My first ever interaction with a computer was with an [Amstrad CPC 464](https://en.wikipedia.org/wiki/Amstrad_CPC), which had a BASIC called *[Locomotive BASIC](https://en.wikipedia.org/wiki/Locomotive_BASIC)* written by [Locomotive Software](https://en.wikipedia.org/wiki/Locomotive_Software). I guess the name connection is clear now.
  - *Wagon BASIC* it is not based on *Locomotive BASIC* though. The name is just a homage to the first BASIC with which I learn programming, and made possible that nowadays I can write things like this.
- **What are the system requirements for *Wagon BASIC*?**
  - An AS/400 (I wrote and tested it on my OS/400 V4R5 with REXXSAA 3.48) with:
    - *IBM REXX for AS/400 system* (also known as REXX/400) version 3.48 or later.
    - Source Entry Utility (SEU), for editing BASIC source files
    - ILE RPG compiler, if you wish to compile the resulting files.
- **OK, so it is not *Locomotive BASIC*, so which BASIC is it?**
  - I guess it can be said that it is based on *[Dartmouth BASIC](https://en.wikipedia.org/wiki/Dartmouth_BASIC)*, but heavily modified to adapt to the AS/400 features and to add more *advanced* functions. See the section [Wagon BASIC language](WagonBASIClanguage).

---

## Roadmap

This is a non-exhaustive list of feaures I have currently in mind:

- Accept single quotes within PRINT and LET to allow contractions e.g. (there's, ain't).
- Syntax check before the translation happens.
- Write a report of the transalation from BASIC to RPGLE to QPRINT (using External Data Queue?).
- Add more built-in functions (Substring, Concatenate, SELECT CASE, Scan string)
- More data types (date, time, timestamp, indicator)?
- More control flow functions (CASE, SELECT...CASE)
- Reading/writting to PF files.
- Ability to use DSPF for interactive sessions.
- Write an interpreter that can run simpler (no PF files, no DSPF) but with PRINT and INPUT programs in interactive mode.

---

## Changelog

- **V0R0M0**:
  - Beta release. Proof Of Concept.
