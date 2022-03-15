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
ENEMY_COUNT       EQU 200    INITIAL ENEMY COUNT
MONEY_COUNT       EQU 150    INITIAL MONEY COUNT


*START OF GAME
START:
    MOVE.W  #EMISSION_COUNT,$6000 EMISSION COUNT PLACED IN MEMORY 6000
    MOVE.W  #ENEMY_COUNT,$5000    ENEMIES COUNT PLACED IN MEMORY 5000
    LEA     $6000,A4        LOAD THE ADDRESS REGISTERS
    LEA     $5000,A3

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
    LEA     STARTER_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     DECORATE
    LEA     FIGHTING_STYLE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
                         *** DISPLAY THE INITIAL FIGTHING STYLE             
    CLR     D1
    MOVE.B  $4100,D1
    CMP     #2,D1       IS D1 == 2?
    BEQ     PICK_2      
    
    CMP     #2,D1       IS D1 < 2?
    BLT     PICK_1
    
    CMP     #2,D1       IS D1 > 2?
    BGT     PICK_3
    
    BSR     DECORATE
    BSR     ENDL
    MOVE.B  #4,D0
    TRAP    #15 
    BSR     DECORATE
                         *** DISPLAY THE INITIAL EMISSION 
    CLR     D1
    BSR     ENDL
    MOVE.W  (A4),D6
    MOVE.W  D6,D1
    LEA     EMISSION,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #3,D0
    TRAP    #15
                         *** DISPLAY THE INITIAL ENEMY COUNT 
    CLR     D1
    BSR     ENDL
    MOVE.W  (A3),D5
    MOVE.W  D5,D1
    LEA     ENEMIES_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #3,D0
    TRAP    #15
    RTS
    
PICK_1:
    LEA     FIRST_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS
PICK_2:
    LEA     SECOND_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS
PICK_3:
    LEA     THIRD_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
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
                DC.B    '                                Wan mission '
                DC.B    $0D,$0A
                DC.B    '       ************************************************************'
                DC.B    $0D,$0A
                DC.B    '                           PRESS <ENTER> TO START',0
STARTING_INFO:  DC.B    ''
                DC.B    $0D,$0A
                DC.B    '     Welcome swordsman-gozaru,'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     the Wano kingdom has been attacked by the Amanto, extraterrestrial'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     beings from space, that are a threat, not even to the Wano kingdom,  '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     but the world itself!'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     Amanto feeds off the oxygen of the earths atmosphere, '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '     leaving the air with pure Carbon Dioxide.  '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '     Your (E)mission is to fight the Amanto using the swordstyles'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     you have honed throughout the years,      '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     by using the mythical swords made out of Di-shards,'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     the mixture of Amanto brought metal and ancient shards.        '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     With the combination of combat skills and mythical swords,'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     you have a chance to bring the tidings, all rests on your shoulders-gozaru.   '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '*Encountering a dialog, to continue press key <ENTER>',0
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
FIRST_PICK:             DC.B        'Three swords style(///Santoryu)',0
SECOND_PICK:            DC.B        'Two swords style(//Nitoryu)',0
THIRD_PICK:             DC.B        'One sword style(/Ittoryu)',0                       
EMISSION:               DC.B    'EMISSION: ',0
STARTER_MSG:            DC.B    '      Your starter: ',0
ENEMIES_MSG:            DC.B    'ENEMIES ALIVE: ',0
    END START






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
