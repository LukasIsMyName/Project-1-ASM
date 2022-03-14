* NAME: LUKAS SUMKAUSKAS
* ID: C00263149
* DATE: 2022 Feb
* KNOWN BUGS: None
* Description: Emission fighting simulator with multiple I/O, 
* where you pick swords to fight the carbon emission instead of the standard.

*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    
    ORG $1000

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*ADD ADDITIONAL VALIDATION VALUES AS REQUIRED
*-------------------------------------------------------
EXIT              EQU 0      USED TO EXIT ASSEMBLY PROGRAM

MAX_WEAPONS       EQU 3      MAX WEAPONS
WIN_POINT         EQU 5      POINTS ACCUMILATED ON WIN
LOSE_STAMINA      EQU 5      POINTS DEDUCTED ON A LOSS
DAMAGE_EMISSION   EQU 75     BASE DAMAGE MULTIPLIER FOR EMISSION
EMISSION_COUNT    EQU 30000  CARBON EMISSION COUNT



*START OF GAME
START:
    MOVE.B  #100,$4000 PUT SCORE/HEALTH IN MEMORY LOCATION $4000
    LEA     $4000,A3   ASSIGN ADDRESS A3 TO THAT MEMORY LOCATION


    BSR     WELCOME    BRANCH TO THE WELCOME SUBROUTINE
    BSR     INPUT      BRANCH TO THE INPUT SUBROUTINE
    BSR     STATS
    BSR     GAME       BRANCH TO THE GAME SUBROUTINE
*GAME LOOP
    ORG     $3000      THE REST OF THE PROGRAM IS TO BE LOCATED FROM 3000 ONWARDS

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:
    BSR     GAMELOOP   BRANCH TO GAMELOOP SUBROUTINE
    RTS                RETURN FROM GAME: SUBROUTINE
          
END:
    SIMHALT

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
    BSR     ENDL            BRANCH TO ENDL SUBROUTINE
    LEA     WELCOME_MSG,A1  ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          MOVE LITERAL 14 TO DO
    TRAP    #15             TRAP AND INTERPRET VALUE IN D0
    MOVE.B  #4,D0
    TRAP    #15
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    LEA     STARTING_INFO,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    RTS                     RETURN FROM WELCOME: SUBROUTINE

*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------    
INPUT:
    BSR     POTIONS         BRANCH TO POTION INPUT SUBROUTINE
    BSR     WEAPONS         BRANCH TO WEAPONSS INPUT SUBROUTINE
    RTS

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    BSR     UPDATE          BRANCH TO UPDATE GAME SUBROUTINE 
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN         
    BSR     DRAW            BRANCH TO DRAW SCREEN SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    BSR     GAMEPLAY        BRANCH TO GAMEPLAY SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    BSR     HUD             BRANCH TO DISPLAY HUD SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    BSR     REPLAY          BRANCH TO REPLAY GAME SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    RTS                     RETURN FROM GAMELOOP: SUBROUTINE

*-------------------------------------------------------
*----------------STATS (DISPLAYS STATS)-------------------
*------------------------------------------------------- 
STATS:
    BSR     ENDL
    BSR     DECORATE
    LEA     FIGHTING_STYLE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  $4100,D1
    CMP     #1,D1
    BSR     ENDL
    LEA     POTIONS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    CLR     D1
    MOVE.B  (A3),D7     RETRIEVE THE VALUE A3 POINT TO AND MOVE TO D1
    MOVE.B  D7,D1
    MOVE.B  #3,D0       MOVE LITERAL 3 TO D0
    TRAP    #15         INTREPRET VALUE IN D0, WHICH 3 WHICH DISPLAYS D1
    MOVE.B  #4,D0
    TRAP    #15 
    BSR     DECORATE
    RTS
*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*  COMPLETE QUEST
*------------------------------------------------------- 
UPDATE:
    BSR     ENDL            PRINT A CR AND LF
    BSR     DECORATE        DECORATE WITH DOTS USING A LOOP
    BSR     DECORATE
    RTS
*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
* DRAW THE GAME PROGRESS INFORMATION, STATUS REGARDING
* QUEST
*------------------------------------------------------- 
DRAW:
    BSR     ENDL
    BSR     DECORATE
    BSR     DECORATE
    RTS

*-------------------------------------------------------
*--------------------POTIONS INVENTORY---------------------
* NUMBER OF POTIONS TO BE USED IN A QUEST 
*------------------------------------------------------- 
POTIONS:
    BSR     ENDL
    BSR     DECORATE
    MOVE.B  #14,D0
    TRAP    #15
    LEA     POTION_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,$4000
    BSR     DECORATE
    RTS

*-------------------------------------------------------
*-------------------------WEAPONS-----------------------
* NUMBER OF WEAPONS
*-------------------------------------------------------   
WEAPONS:
    BSR     ENDL
    BSR     DECORATE
    LEA     STYLE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,$4100
    BSR     DECORATE
    RTS

*-------------------------------------------------------
*---GAME PLAY (QUEST PROGRESS)--------------------------
*------------------------------------------------------- 
GAMEPLAY:
    BSR     ENDL
    BSR     DECORATE
    BSR     DECORATE
    BSR     COLLISION
    RTS

*-------------------------------------------------------
*-----------------HEADS UP DISPLAY (SCORE)--------------
* RETRIEVES THE SCORE FROM MEMORY LOCATION
*-------------------------------------------------------   
HUD:

    BSR     ENDL
    BSR     DECORATE
    CLR     D1
    BSR     DECORATE
    RTS

*-------------------------------------------------------
*-----------------------BEING ATTACKED------------------
* THIS COULD BE USED FOR COLLISION DETECTION
*-------------------------------------------------------
COLLISION:
    MOVE.B  #MINE_LOC,D1
    CMP     #100,D1 IS( X == 100)?
	BNE     COLLISION_MISS IF X IS EQUAL TO 100, THEN HIT
COLLISION_HIT:
    *HIT
    RTS
    
COLLISION_MISS:
    *MISS
    RTS

*-------------------------------------------------------
*--------------------------LOOP-------------------------
*-------------------------------------------------------
LOOP:
    MOVE.B  #5, D3 LOOP COUNTER D3=5
NEXT:
    LEA     LOOP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
	SUB     #1,D3   DECREMENT LOOP COUNTER
    BNE     NEXT    REPEAT UNTIL D0=0

*-------------------------------------------------------
*------------------SCREEN DECORATION--------------------
*-------------------------------------------------------
DECORATE:
    MOVE.B  #60, D3
    BSR     ENDL
OUT:
    LEA     LOOP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
	SUB     #1,D3   DECREMENT LOOP COUNTER
    BNE     OUT	    REPEAT UNTIL D0=0
    BSR     ENDL
    RTS
    
CLEAR_SCREEN: 
    MOVE.B  #11,D0      CLEAR SCREEN
    MOVE.W  #$FF00,D1
    TRAP    #15
    RTS
*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR     ENDL
    LEA     REPLAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #4,D0
    TRAP    #15

    CMP     #EXIT,D1
    BEQ     END         IF SR Z REGISTER CONTAINS 1 BEQ => BRANCH EQUALS
    BSR     GAMELOOP

ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE    #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS
    
*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------

CRLF:           DC.B    $0D,$0A,0
WELCOME_MSG:    DC.B    '       ************************************************************'
                DC.B    $0D,$0A
                DC.B    '                                Last Wan Standing'
                DC.B    $0D,$0A
                DC.B    '       ************************************************************'
                DC.B    $0D,$0A
                DC.B    '                           PRESS <ENTER> TO START',0
STARTING_INFO:  DC.B    ''
                DC.B    $0D,$0A
                DC.B    '       Welcome to a text, turn based PVE fighting simulator,'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '       here you will have an opportunity to prove yourself worthy'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '       by fighting the mighty samurais of Wano kingdom that possesses'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '       unmatchable swordsman skills and techniques.'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '*Encountering a dialog, to continue press key <ENTER>',0
POTION_MSG:     DC.B    '                       HEALTH POTIONS'
                DC.B    $0D,$0A
                DC.B    '*ENTER STARTING POTION NUMBER : ',0
POTIONS_MSG:    DC.B    'NUMBER OF POTIONS : ',0
STYLE_MSG:      DC.B    'SELECT YOUR FIGHTING STYLE: '
                DC.B    $0D,$0A
                DC.B    '1: Three swords style(///Santoryu)'
                DC.B    $0D,$0A
                DC.B    '2: Two swords style(//Nitoryu)'
                DC.B    $0D,$0A
                DC.B    '3: One sword style(/Ittoryu)'
                DC.B    $0D,$0A,0
LOOP_MSG:       DC.B    '.',0
REPLAY_MSG:     DC.B    'ENTER 0 TO QUIT ANY OTHER NUMBER TO REPLAY : ',0
HUD_MSG:        DC.B    'SCORE : ',0
FIGHTING_STYLE_MSG:     DC.B    'Your fighting style is : ',0
                        
HEALTH:     DS.W    1   PLAYERS HEALTH
SCORE:      DS.W    1   RESERVE SPACE FOR SCORE


    END START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
