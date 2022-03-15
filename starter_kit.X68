
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
NEXT_DAY          EQU 4      USED TO CYCLE TO THE NEXT DAY
STATISTICS        EQU 1
SHOP              EQU 2
ATTACK            EQU 3

EMISSION_COUNT    EQU 30000  CARBON EMISSION COUNT
ENEMY_COUNT       EQU 200    INITIAL ENEMY COUNT
MONEY_COUNT       EQU 150    INITIAL MONEY COUNT
STAMINA_COUNT     EQU 100    INITIAL STAMINA COUNT
DAYS_COUNT        EQU 0      INITIAL DAYS PASSED COUNT
ENEMIES_DEFEATED  EQU 0      INITIAL DEFEAT COUNT FOR THE DAY
EMISSION_SLASHED  EQU 0      INITIAL EMISSION SLASHED COUNT FOR THE DAY

*--------------------------INCREMENTS----------------------------------*
DAMAGE_EMISSION_ONE   EQU 75     BASE DAMAGE MULTIPLIER FOR EMISSION ONE SWORD
DAMAGE_EMISSION_TWO   EQU 150    BASE DAMAGE MULTIPLIER FOR EMISSION TWO SWORDS
DAMAGE_EMISSION_THREE   EQU 250  BASE DAMAGE MULTIPLIER FOR EMISSION THREE SWORDS
EMISSION_INC      EQU 40     EMISSION INCREMENT FOR EACH ENEMY
MONEY_INC         EQU 5      MONEY INCREMENT FOR EACH KILL
STAMINA_INC       EQU 10     STAMINA INCREMENT FOR EACH 5 DAY CYCLES
STAMINA_DEC       EQU 5      STAMINA DEDUCTED ON A KILL

*START OF GAME
START:
    MOVE.W  #EMISSION_COUNT,$6000      EMISSION COUNT PLACED IN MEMORY 6000
    MOVE.W  #ENEMY_COUNT,$5000         ENEMIES COUNT PLACED IN MEMORY 5000
    MOVE.B  #STAMINA_COUNT,$7000       STAMINA COUNT PLACED IN 7000
    MOVE.W  #MONEY_COUNT,$8000         MONEY COUNT PLACED IN 8000
    MOVE.W  #DAYS_COUNT,$9000          DAYS COUNT PLACED IN MEMORY 9000
    MOVE.W  #ENEMIES_DEFEATED,$10000   ENEMIES DEFEATED COUNT PLACED IN MEMORY 10000
    MOVE.W  #EMISSION_SLASHED,$11000   EMISSION SLASHED COUNT PLACED IN MEMORY 11000
    LEA     $6000,A4        LOAD THE ADDRESS REGISTERS
    LEA     $5000,A3
    LEA     $7000,A2
    LEA     $8000,A5
    LEA     $9000,A6

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
    BSR     UPDATE
    BSR     CLEAR_SCREEN
    BSR     REPLAY          BRANCH TO REPLAY GAME SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    RTS                     RETURN FROM GAMELOOP: SUBROUTINE

*-------------------------------------------------------
*----------------STATS (DISPLAYS STATS)-------------------
*------------------------------------------------------- 
STATS:
    BSR     ENDL
    BSR     DECORATE
    BSR     CLEAR_SCREEN
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
    
INITIALS_D:
    BSR     EMISSION_DISPLAY
    BSR     ENEMY_DISPLAY
    BSR     STAMINA_DISPLAY
    BSR     MONEY_DISPLAY
    BSR     DAYS_DISPLAY
    BSR     HALT
    JMP     REPLAY
   
EMISSION_DISPLAY:                         *** DISPLAY THE INITIAL EMISSION 
    CLR     D1
    BSR     ENDL
    MOVE.W  (A4),D6
    MOVE.W  D6,D1
    LEA     EMISSION,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #3,D0
    TRAP    #15
    RTS
    
ENEMY_DISPLAY:                         *** DISPLAY THE INITIAL ENEMY COUNT 
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
    
STAMINA_DISPLAY:
    CLR     D1
    BSR     ENDL
    MOVE.B  (A2),D4
    MOVE.B  D4,D1
    LEA     STAMINA_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #3,D0
    TRAP    #15
    RTS
MONEY_DISPLAY:
    CLR     D1
    BSR     ENDL
    MOVE.W  (A5),D3
    MOVE.W  D3,D1
    LEA     MONEY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #3,D0
    TRAP    #15
    RTS
DAYS_DISPLAY:
    CLR     D1
    BSR     ENDL
    MOVE.W  (A6),D1
    LEA     DAYS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #3,D0
    TRAP    #15
    RTS
    
PICK_1:
    LEA     FIRST_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     INITIALS_D
    RTS
PICK_2:
    LEA     SECOND_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     INITIALS_D
    RTS
PICK_3:
    LEA     THIRD_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     INITIALS_D
    RTS
 
*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*  COMPLETE QUEST
*------------------------------------------------------- 
UPDATE:
    BSR     ENDL            PRINT A CR AND LF
    BSR     DECORATE        DECORATE WITH DOTS USING A LOOP
    BSR     DECORATE
                             *INCREMENTS THE DAYS
    CLR     D1
    MOVE.W  (A6),D1
    ADD.W   #1,D1
    MOVE.W  D1,$9000
    LEA     $9000,A6
                             *INCREMENTS THE EMISSION
    CLR     D1
    MOVE.W  (A4),D1
    ADD.W   #EMISSION_INC,D1
    MOVE.W  D1,$6000
    LEA     $6000,A4
                             *INCREMENTS THE ENEMIES
    CLR     D1
    MOVE.W  (A3),D1
    ADD.W   #1,D1
    MOVE.W  D1,$5000
    LEA     $5000,A3
                             *RESETS THE STAMINA
    CLR     D1
    MOVE.B  $7000,D1
    MOVE.B  #100,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1
    RTS
*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
* DRAW THE GAME PROGRESS INFORMATION, STATUS REGARDING
* QUEST
*------------------------------------------------------- 
ATTACK_EMISSION:
    BSR     ENDL
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    LEA     BATTLEFIELD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    
    LEA     ENEMIES_KILLED_TODAY,A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     $10000,A1
    MOVE.W  (A1),D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL
    
    LEA     EMISSION_SLASHED_TODAY,A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     $11000,A1
    MOVE.W  (A1),D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     STAMINA_DISPLAY
    BSR     ENDL
    
    CLR     D1
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  #3,D0
    
    CMP     #0,D1
    BEQ     REPLAY
    
    CMP     #1,D1
    BEQ     ATTACK_ENEMY
    
    CMP     #2,D1
    BEQ     ATTACK_DIRECTLY
    
    BSR     HALT    
    JMP     ATTACK_EMISSION
    
ATTACK_ENEMY:
*---------------------------------------------------ATTACK ENEMY----------------------------------* 
    CLR     D1
    MOVE.B  $7000,D1
    CMP     #0,D1
    BEQ     NO_STAMINA
                            *IF OUT OF STAMINA, DISPLAY
                            *IF NOT, CONTINUE
                            
                            *DECREMENTS THE ENEMIES COUNT
    CLR     D1
    MOVE.W  (A3),D1
    SUB.W   #1,D1
    MOVE.W  D1,$5000
    LEA     $5000,A3
                            *INCREMENTS DEFEATED ENEMIES COUNT
    CLR     D1
    LEA     $10000,A1
    MOVE.W  (A1),D1
    ADD.W   #1,D1
    MOVE.W  D1,$10000
    LEA     $10000,A1
                            *INCREMENT THE MONEY COUNT FOR EACH KILL
    CLR     D1
    LEA     $8000,A1
    MOVE.W  (A1),D1
    ADD.W   #MONEY_INC,D1
    MOVE.W  D1,$8000
    LEA     $8000,A1
    
                            *DECREMENTS THE EMISSION COUNT
    CLR     D1
    LEA     $4100,A1
    MOVE.B  (A1),D1
    
    CMP     #1,D1
    BEQ     SUB_THREE_SWORDS
    
    CMP     #2,D1
    BEQ     SUB_TWO_SWORDS
    
    CMP     #3,D1
    BEQ     SUB_ONE_SWORD
    RTS
SUB_THREE_SWORDS:
                                *DECREMENTS EMISSION TOTAL    
    MOVE.W  (A4),D1
    SUB.W   #DAMAGE_EMISSION_THREE,D1
    MOVE.W  D1,$6000
    LEA     $6000,A4
                                *INCREMENTS EMISSION SLASHED COUNT    
    MOVE.W  $11000,D1
    ADD.W   #DAMAGE_EMISSION_THREE,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
    
                                 *DECREMENTS STAMINA
    MOVE.B  $7000,D1
    SUB.B   #STAMINA_DEC,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1

    
    JMP     ATTACK_EMISSION
SUB_TWO_SWORDS:     
    MOVE.W  (A4),D1
    SUB.W   #DAMAGE_EMISSION_TWO,D1
    MOVE.W  D1,$6000
    LEA     $6000,A4
    
    MOVE.W  $11000,D1
    ADD.W   #DAMAGE_EMISSION_TWO,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
    
                                    *DECREMENTS STAMINA
    MOVE.B  $7000,D1
    SUB.B   #STAMINA_DEC,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1
    
    JMP     ATTACK_EMISSION
SUB_ONE_SWORD:     
    MOVE.W  (A4),D1
    SUB.W   #DAMAGE_EMISSION_ONE,D1
    MOVE.W  D1,$6000
    LEA     $6000,A4
    
    MOVE.W  $11000,D1
    ADD.W   #DAMAGE_EMISSION_ONE,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
                                    *DECREMENTS STAMINA
    MOVE.B  $7000,D1
    SUB.B   #STAMINA_DEC,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1
    
    JMP     ATTACK_EMISSION
NO_STAMINA:
    BSR     ENDL
    LEA     OUT_STAMINA_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     HALT
    JMP     ATTACK_EMISSION
    
*---------------------------------------------------ATTACK DIRECTLY----------------------------------*    
ATTACK_DIRECTLY:
    CLR     D1
    MOVE.B  $7000,D1
    CMP     #0,D1
    BEQ     NO_STAMINA
                            *IF OUT OF STAMINA, DISPLAY
                            *IF NOT, CONTINUE

    CLR     D1
    LEA     $4100,A1
    MOVE.B  (A1),D1
    
    CMP     #1,D1
    BEQ     SUB_THREE_SWORDS_DI
    
    CMP     #2,D1
    BEQ     SUB_TWO_SWORDS_DI
    
    CMP     #3,D1
    BEQ     SUB_ONE_SWORD_DI
    
    BSR     ATTACK_EMISSION
SUB_THREE_SWORDS_DI:
                                 *DECREMENTS STAMINA
    CLR     D2
    CLR     D3
    MOVE.B  #STAMINA_DEC,D2
    MOVE.B  #4,D3
    MULU    D2,D3
    MOVE.B  $7000,D1
    CMP     D1,D3
    BGT     NO_STAMINA           *IF STAMINA COST GREATER THAN STAMINA LEFT = NO STAMINA
    SUB.B   D3,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1
                                *DECREMENTS EMISSION TOTAL
    CLR     D2
    CLR     D3
    MOVE.B  #DAMAGE_EMISSION_THREE,D2
    MOVE.B  #2,D3
    MULU    D2,D3    
    MOVE.W  (A4),D1
    SUB.W   D3,D1
    MOVE.W  D1,$6000
    LEA     $6000,A4
                                *INCREMENTS EMISSION SLASHED COUNT
    CLR     D2
    CLR     D3
    MOVE.B  #DAMAGE_EMISSION_THREE,D2
    MOVE.B  #2,D3
    MULU    D2,D3    
    MOVE.W  $11000,D1
    ADD.W   D3,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
    JMP     ATTACK_EMISSION
    
SUB_TWO_SWORDS_DI:     
                                   *DECREMENTS STAMINA
    CLR     D2
    CLR     D3
    MOVE.B  #STAMINA_DEC,D2
    MOVE.B  #3,D3
    MULU    D2,D3
    MOVE.B  $7000,D1
    CMP     D1,D3
    BGT     NO_STAMINA           *IF STAMINA COST GREATER THAN STAMINA LEFT = NO STAMINA
    SUB.B   D3,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1
                                *DECREMENTS EMISSION TOTAL
    CLR     D2
    CLR     D3
    MOVE.B  #DAMAGE_EMISSION_TWO,D2
    MOVE.B  #2,D3
    MULU    D2,D3    
    MOVE.W  (A4),D1
    SUB.W   D3,D1
    MOVE.W  D1,$6000
    LEA     $6000,A4
                                *INCREMENTS EMISSION SLASHED COUNT
    CLR     D2
    CLR     D3
    MOVE.B  #DAMAGE_EMISSION_TWO,D2
    MOVE.B  #2,D3
    MULU    D2,D3    
    MOVE.W  $11000,D1
    ADD.W   D3,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
    
    JMP     ATTACK_EMISSION
    
SUB_ONE_SWORD_DI:     
                                       *DECREMENTS STAMINA
    CLR     D2
    CLR     D3
    MOVE.B  #STAMINA_DEC,D2
    MOVE.B  #2,D3
    MULU    D2,D3
    MOVE.B  $7000,D1
    CMP     D1,D3
    BGT     NO_STAMINA           *IF STAMINA COST GREATER THAN STAMINA LEFT = NO STAMINA
    SUB.B   D3,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1
                                *DECREMENTS EMISSION TOTAL
    CLR     D2
    CLR     D3
    MOVE.B  #DAMAGE_EMISSION_ONE,D2
    MOVE.B  #2,D3
    MULU    D2,D3    
    MOVE.W  (A4),D1
    SUB.W   D3,D1
    MOVE.W  D1,$6000
    LEA     $6000,A4
                                *INCREMENTS EMISSION SLASHED COUNT
    CLR     D2
    CLR     D3
    MOVE.B  #DAMAGE_EMISSION_ONE,D2
    MOVE.B  #2,D3
    MULU    D2,D3    
    MOVE.W  $11000,D1
    ADD.W   D3,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
    JMP     ATTACK_EMISSION
    

           
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
    CLR     D3
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
HALT:
    MOVE.B  #4,D0
    TRAP    #15
    RTS
ASK_PLAY:
    BSR     ENDL
    BSR     DECORATE
    BSR     ENDL
    LEA     ASK_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    BSR     DECORATE
    BSR     HALT
    CMP     #EXIT,D1
    BEQ     END
    RTS
*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR     ENDL
    BSR     CLEAR_SCREEN
    LEA     REPLAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #4,D0
    TRAP    #15
    
    CMP     #EXIT,D1
    BEQ     END
    
    CMP     #STATISTICS,D1
    BEQ     INITIALS_D
    
    CMP     #ATTACK,D1
    BEQ     ATTACK_EMISSION
    
    CMP     #NEXT_DAY,D1
    BEQ     GAMELOOP
    
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
REPLAY_MSG:


                DC.B    '   ----------       What do you wish to do?       ----------                                       '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '               *Input: 1 to display the current statistics                                                 '
                DC.B    $0D,$0A
                DC.B    '               *Input: 2 to open the shop menu                                                 '
                DC.B    $0D,$0A
                DC.B    '               *Input: 3 to fight the enemies                                                 '
                DC.B    $0D,$0A
                DC.B    '               *Input: 4 to get to the next day'
                DC.B    $0D,$0A
                DC.B    '               *Input: 0 to EXIT the game                                                 '
                DC.B    '                             ',0

HUD_MSG:        DC.B    'SCORE : ',0
FIGHTING_STYLE_MSG:     DC.B    'Your fighting style is : ',0
FIRST_PICK:             DC.B        'Three swords style(///Santoryu)',0
SECOND_PICK:            DC.B        'Two swords style(//Nitoryu)',0
THIRD_PICK:             DC.B        'One sword style(/Ittoryu)',0                       
EMISSION:               DC.B    'EMISSION: ',0
STARTER_MSG:            DC.B    '      INFO: ',0
ENEMIES_MSG:            DC.B    'ENEMIES ALIVE: ',0
STAMINA_MSG:            DC.B    'STAMINA: ',0
MONEY_MSG:              DC.B    'BALANCE: ',0
ASK_MSG:                DC.B    '                        Play?'
                        DC.B    $0D,$0A
                        DC.B    '                 To Play enter any number            '
                        DC.B    $0D,$0A
                        DC.B    '                    To EXIT enter 0           ',0
DAYS_MSG:               DC.B    'Day: ',0
BATTLEFIELD_MSG:        DC.B    '   ----------       THE BATTLEFIELD       ----------                 '
                        DC.B    $0D,$0A
                        DC.B    '                                                 '
                        DC.B    $0D,$0A
                        DC.B    '      - You have entered the battlefield, prepare to battle  '
                        DC.B    $0D,$0A
                        DC.B    '      the Amanto and slash through the Carbon Dioxide with   '
                        DC.B    $0D,$0A
                        DC.B    '           your mighty swords to save the earth  '
                        DC.B    $0D,$0A
                        DC.B    '                                                 '
                        DC.B    $0D,$0A
                        DC.B    '           *To attack Amanto:             input 1'
                        DC.B    $0D,$0A
                        DC.B    '           *To attack Emission directly:  input 2'
                        DC.B    $0D,$0A
                        DC.B    '           *To return to the menu:        input 0',0
ENEMIES_KILLED_TODAY:   DC.B    'Enemies defeated: ',0
EMISSION_SLASHED_TODAY: DC.B    'Carbon Dioxide slashed: ',0
OUT_STAMINA_MSG         DC.B    '      You are out of stamina, retreat warrior,'
                        DC.B    $0D,$0A
                        DC.B    '         you have done enough, for today..',0


    END START









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
