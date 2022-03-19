
* NAME: LUKAS SUMKAUSKAS
* ID: C00263149
* DATE: 2022 Feb
* KNOWN BUGS: If in select mode no number is input and returned,
* the combat system fails
*
* Description: Emission fighting simulator with multiple I/O, 
* where you pick swords to fight the carbon emission instead of the standard.

*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $900
*-------------------------------------------------------
    
    ORG $800

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*ADD ADDITIONAL VALIDATION VALUES AS REQUIRED
*-------------------------------------------------------
EXIT              EQU 0      USED TO EXIT ASSEMBLY PROGRAM
NEXT_DAY          EQU 4      USED TO CYCLE TO THE NEXT DAY
STATISTICS        EQU 1      
SHOP              EQU 2      
ATTACK            EQU 3
REST              EQU 5

EMISSION_COUNT    EQU 30000  CARBON EMISSION COUNT
ENEMY_COUNT       EQU 200    INITIAL ENEMY COUNT
MONEY_COUNT       EQU 150    INITIAL MONEY COUNT
STAMINA_COUNT     EQU 100    INITIAL STAMINA COUNT
DAYS_COUNT        EQU 1      INITIAL DAYS PASSED COUNT
ENEMIES_DEFEATED  EQU 0      INITIAL DEFEAT COUNT FOR THE DAY
EMISSION_SLASHED  EQU 0      INITIAL EMISSION SLASHED COUNT FOR THE DAY
ABILITY_LEVEL     EQU 1      INITIAL ABILITY LEVEL
LEVEL_BOUGHT      EQU 1      VAR TO CMP BOUGHT LEVEL WITH OLD LEVEL
FATIGUE_COUNT     EQU 0      VAR TO CONTROL FATIGUE
FATIGUE_DEC       EQU 0      VAR TO DECREMENT THE STAMINA WITH
BONUS_COUNT_10    EQU 0      VAR TO CONTROL 10 DAYS BONUS
BONUS_COUNT_20    EQU 0      VAR TO CONTROL 20 DAYS BONUS

*--------------------------INCREMENTS----------------------------------*
DAMAGE_EMISSION_ONE   EQU 30     BASE DAMAGE MULTIPLIER FOR EMISSION ONE SWORD
DAMAGE_EMISSION_TWO   EQU 65    BASE DAMAGE MULTIPLIER FOR EMISSION TWO SWORDS
DAMAGE_EMISSION_THREE EQU 110  BASE DAMAGE MULTIPLIER FOR EMISSION THREE SWORDS
EMISSION_INC      EQU 300     EMISSION INCREMENT FOR EACH ENEMY
MONEY_INC         EQU 15      MONEY INCREMENT FOR EACH KILL
STAMINA_INC       EQU 10     STAMINA INCREMENT FOR EACH 5 DAY CYCLES
STAMINA_DEC_1     EQU 2      STAMINA DEDUCTED ON A KILL WITH 1 SWORD
STAMINA_DEC_2     EQU 4      STAMINA DEDUCTED ON A KILL WITH 2 SWORDS 
STAMINA_DEC_3     EQU 5      STAMINA DEDUCTED ON A KILL WITH 3 SWORDS
ABILITY_MLTPR     EQU 2      DAMAGE MULTIPLIED ON ABILITY USE
ENEMY_INC         EQU 5      ENEMY INCREMENT
      

*START OF GAME
START:
    MOVE.L  #EMISSION_COUNT,$13000      EMISSION COUNT PLACED IN MEMORY 13000
    MOVE.W  #ENEMY_COUNT,$5000         ENEMIES COUNT PLACED IN MEMORY 5000
    MOVE.B  #STAMINA_COUNT,$7000       STAMINA COUNT PLACED IN 7000
    MOVE.W  #MONEY_COUNT,$8000         MONEY COUNT PLACED IN 8000
    MOVE.W  #DAYS_COUNT,$9000          DAYS COUNT PLACED IN MEMORY 9000
    MOVE.W  #ENEMIES_DEFEATED,$10000   ENEMIES DEFEATED COUNT PLACED IN MEMORY 10000
    MOVE.W  #EMISSION_SLASHED,$11000   EMISSION SLASHED COUNT PLACED IN MEMORY 11000
    MOVE.B  #ABILITY_LEVEL,$4500       ABILITY LEVEL PLACED IN MEMORY 4500
    MOVE.B  #LEVEL_BOUGHT,$4700        ABILITY LEVEL BOUGHT PLACED IN MEMORY 4700
    MOVE.B  #ABILITY_MLTPR,$4800       ABILITY MULTIPLIER PLACED IN MEMORY 4800
    MOVE.B  #FATIGUE_COUNT,$4600       FATIGUE COUNT PLACED IN MEMORY 4600
    MOVE.B  #FATIGUE_DEC,$4650         FATIGUE DECREMENT PLACED IN MEMORY 4650
    MOVE.B  #MONEY_INC,$4400           MONEY INCREMENT PLACED IN MEMORY 4400
    MOVE.B  #BONUS_COUNT_10,$4350      BONUS COUNT PLACED IN MEMORY 4350
    MOVE.B  #BONUS_COUNT_20,$4370      BONUS COUNT PLACED IN MEMORY 4370
    MOVE.B  #ENEMY_INC,$3000           ENEMY INCREMENT PLACED IN MEMORY 9000
    LEA     $13000,A4        LOAD THE ADDRESS REGISTERS
    LEA     $5000,A3
    LEA     $7000,A2
    LEA     $8000,A5
    LEA     $9000,A6
    
    BSR     CLEAR_SCREEN
    BSR     WELCOME    BRANCH TO THE WELCOME SUBROUTINE
    BSR     DECORATE
    BSR     INPUT      BRANCH TO THE INPUT SUBROUTINE
    BSR     LORE
    BSR     STATS
    BSR     GAME       BRANCH TO THE GAME SUBROUTINE
*GAME LOOP
    ORG     $950      THE REST OF THE PROGRAM IS TO BE LOCATED FROM 1100 ONWARDS

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
    LEA     WELCOME_MSG,A1  ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          MOVE LITERAL 14 TO DO
    TRAP    #15             TRAP AND INTERPRET VALUE IN D0
    MOVE.B  #4,D0
    TRAP    #15
    BSR     CLEAR_SCREEN
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
    BSR     INCREMENT_FATIGUE_COUNTER
    BSR     CLEAR_SCREEN
    BSR     UPDATE
    BSR     CLEAR_SCREEN
    BSR     REPLAY          BRANCH TO REPLAY GAME SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    RTS                     RETURN FROM GAMELOOP: SUBROUTINE

*-------------------------------------------------------
*----------------STATS (DISPLAYS STATS)-------------------
*------------------------------------------------------- 
STATS:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     STARTER_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
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
    BSR     STAMINA_DISPLAY
    BSR     ENDL
    BSR     FATIGUE_DISPLAY
    BSR     ENDL
    BSR     ENDL
    BSR     EMISSION_DISPLAY
    BSR     ENDL
    BSR     ENEMY_DISPLAY
    BSR     ENDL
    BSR     ENDL
    BSR     MONEY_DISPLAY
    BSR     ENDL
    BSR     DAYS_DISPLAY
    BSR     HALT
    JMP     REPLAY
   
EMISSION_DISPLAY:                         *** DISPLAY THE INITIAL EMISSION 
    CLR     D1
    BSR     ENDL
    LEA     $13000,A1
    MOVE.L  (A1),D6
    MOVE.L  D6,D1
    LEA     EMISSION,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #3,D0
    TRAP    #15
    RTS
    
ENEMY_DISPLAY:                         *** DISPLAY THE INITIAL ENEMY COUNT 
    CLR     D1
    BSR     ENDL
    LEA     $5000,A1
    MOVE.W  (A1),D5
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
    LEA     $7000,A1
    MOVE.B  (A1),D4
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
    LEA     $8000,A1
    MOVE.W  (A1),D3
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
    LEA     $9000,A1
    MOVE.W  (A1),D1
    LEA     DAYS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #3,D0
    TRAP    #15
    RTS
FATIGUE_DISPLAY:
    CLR     D1
    BSR     ENDL
    LEA     FATIGUE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     $4600,A1
    MOVE.B  (A1),D1
    MOVE.B  #3,D0
    TRAP    #15
    RTS
    
PICK_1:
    LEA     FIRST_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    LEA     STYLE_DAMAGE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  #DAMAGE_EMISSION_THREE,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    LEA     STAMINA_NORMAL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #STAMINA_DEC_3,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL 
    
    LEA     STAMINA_USE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #5*4,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL

    CLR     D2
    CLR     D3
    LEA     $4800,A1
    MOVE.W  #DAMAGE_EMISSION_THREE,D3
    MOVE.B  (A1),D2
    LEA     ABILITY_DAMAGE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MULU    D2,D3
    MOVE.W  D3,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    CLR     D1
    LEA     ABILITY_LEVEL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     $4500,A1
    MOVE.B  (A1),D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    BSR     ENDL   
    BSR     INITIALS_D
    
    
PICK_2:
    LEA     SECOND_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    LEA     STYLE_DAMAGE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  #DAMAGE_EMISSION_TWO,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    LEA     STAMINA_NORMAL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #STAMINA_DEC_2,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL 
    
    LEA     STAMINA_USE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #4*3,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    CLR     D2
    CLR     D3
    LEA     $4800,A1
    MOVE.W  #DAMAGE_EMISSION_TWO,D3
    MOVE.B  (A1),D2
    LEA     ABILITY_DAMAGE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MULU    D2,D3
    MOVE.W  D3,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    CLR     D1
    LEA     ABILITY_LEVEL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     $4500,A1
    MOVE.B  (A1),D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    BSR     ENDL
    BSR     INITIALS_D
PICK_3:
    LEA     THIRD_PICK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    LEA     STYLE_DAMAGE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  #DAMAGE_EMISSION_ONE,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    LEA     STAMINA_NORMAL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #STAMINA_DEC_1,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL 
    
    LEA     STAMINA_USE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  #2*3,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    CLR     D2
    CLR     D3
    LEA     $4800,A1
    MOVE.W  #DAMAGE_EMISSION_ONE,D3
    MOVE.B  (A1),D2
    LEA     ABILITY_DAMAGE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MULU    D2,D3
    MOVE.W  D3,D1
    MOVE.W  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    
    CLR     D1
    LEA     ABILITY_LEVEL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     $4500,A1
    MOVE.B  (A1),D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENDL
    BSR     ENDL
    BSR     INITIALS_D
 
*-------------------------------------------------------
*----------------UPDATE------------------
* 
*------------------------------------------------------- 
UPDATE:
    BSR     ENDL            PRINT A CR AND LF
    BSR     DECORATE        DECORATE WITH DOTS USING A LOOP
    BSR     DECORATE  
                             *RESETS THE STAMINA
    CLR     D1
    CLR     D2
    LEA     $4650,A1
    MOVE.B  (A1),D2
    MOVE.B  $7000,D1
    MOVE.B  #100,D1
    SUB.B   D2,D1           *SUBTRACT THE FATIGUE COUNTER FROM RESETED STAMINA
    MOVE.B  D1,$7000
    LEA     $7000,A2
                            *IF BONUS ACTIVATED ONCE, DON'T PROCEED TO THE NEXT BLOCK
    CLR     D1
    LEA     $4350,A1
    MOVE.B  (A1),D1
    CMP     #1,D1
    BEQ     REPLAY
                            *IF 10 OR MORE DAYS PASSED, DAY_10 INCREASE
    CLR     D1
    LEA     $9000,A1
    MOVE.W  (A1),D1
    CMP     #10,D1
    BGE     DAY_10
    
    RTS
DAY_10:
                           *ADD TO THE COUNTER TO CONTROL
    CLR     D1
    LEA     $4350,A1
    MOVE.B  (A1),D1
    ADD.B   #1,D1
    MOVE.B  D1,$4350
    LEA     $4350,A1
                           *DOUBLE COIN INCREASE
    CLR     D1
    LEA     $4400,A1
    MOVE.B  (A1),D1
    MULU    #2,D1
    MOVE.B  D1,$4400
    LEA     $4400,A1
    
                            *1000 GOLD BONUS
    CLR     D1
    LEA     $8000,A1
    MOVE.W  (A1),D1
    ADD.W   #1000,D1
    MOVE.W  D1,$8000
    LEA     $8000,A1
                            *ENEMY INC INCREASE
    CLR     D1
    LEA     $3000,A1
    MOVE.B  (A1),D1
    MULU    #2,D1
    MOVE.B  D1,$3000
    LEA     $3000,A1
    
    BSR     CLEAR_SCREEN
    LEA     BONUS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    
    RTS
    
INCREMENT_FATIGUE_COUNTER:
                            *INCREASE COUNTER BY 1 EACH DAY CYCLE
    CLR     D1
    LEA     $4600,A1
    MOVE.B  (A1),D1
    ADD.B   #1,D1
    MOVE.B  D1,$4600
    LEA     $4600,A1
                            *IF D1 IS 5 DAYS IN A ROW
    CMP     #5,D1
    BEQ     FATIGUE_DE

    RTS
FATIGUE_DE:

    CLR     D1
    CLR     D2
    LEA     $4650,A2
    LEA     $7000,A1
                        
    MOVE.B  (A2),D2         *INCREASE DECREMENT VALUE BY 10
    ADD.B   #10,D2
    MOVE.B  D2,$4650
    LEA     $4650,A2
    
    MOVE.W  (A1),D1         *DECREASE MAX STAMINA BY 10
    SUB.W   D2,D1
    MOVE.W  D1,$7000
    LEA     $7000,A1
                            *RESET FATIGUE COUNTER
    CLR     D1
    LEA     $4600,A1
    MOVE.B  (A1),D1
    MOVE.B  #0,D1
    MOVE.B  D1,$4600
    LEA     $4600,A1
    
    RTS
    
RESTED:
    CLR     D1
    LEA     $4600,A1
    MOVE.B  (A1),D1
    MOVE.B  #0,D1
    MOVE.B  D1,$4600
    LEA     $4600,A1
    JMP     GAMELOOP
        
    
*-------------------------------------------------------
*-----------------ATTACK MODE--------------------
*------------------------------------------------------- 
ATTACK_EMISSION:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     BATTLEFIELD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
                            *IF EMISSION <=0, VICTORY SCREEN
    CLR     D1
    LEA     $13000,A1
    MOVE.L  (A1),D1
    CMP     #0,D1
    BLS     YOU_WIN
    
    
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
    CMP     #1,D1
    BEQ     NO_STAMINA
                            *IF OUT/OR CRITICALLY LOW STAMINA, DISPLAY
                            *IF NOT, CONTINUE
                            
                            *DECREMENTS THE ENEMIES COUNT
    CLR     D1
    LEA     $5000,A1
    MOVE.W  (A1),D1
    SUB.W   #1,D1
    MOVE.W  D1,$5000
    LEA     $5000,A1
                            *INCREMENTS DEFEATED ENEMIES COUNT
    CLR     D1
    LEA     $10000,A1
    MOVE.W  (A1),D1
    ADD.W   #1,D1
    MOVE.W  D1,$10000
    LEA     $10000,A1
                            *INCREMENT THE MONEY COUNT FOR EACH KILL
    CLR     D1
    CLR     D2
    LEA     $4400,A2
    LEA     $8000,A1
    MOVE.W  (A1),D1
    MOVE.B  (A2),D2
    ADD.W   D2,D1
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
    CLR     D1
    CLR     D3
    LEA     $7000,A1
    MOVE.B  STAMINA_DEC_3,D3
    MOVE.B  (A1),D1
    CMP     D3,D1
    BGT     NO_STAMINA           *IF STAMINA COST GREATER THAN STAMINA LEFT = NO STAMINA

                                *DECREMENTS EMISSION TOTAL
    CLR     D1
    LEA     $13000,A1    
    MOVE.L  (A1),D1
    SUB.L   #DAMAGE_EMISSION_THREE,D1
    MOVE.L  D1,$13000
    LEA     $13000,A1
                                *INCREMENTS EMISSION SLASHED COUNT
    CLR     D1
    LEA     $11000,A1    
    MOVE.W  (A1),D1
    ADD.W   #DAMAGE_EMISSION_THREE,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
    
                                 *DECREMENTS STAMINA
    CLR     D1
    LEA     $7000,A1
    MOVE.B  (A1),D1
    SUB.B   #STAMINA_DEC_3,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1

    
    JMP     ATTACK_EMISSION
SUB_TWO_SWORDS:
    CLR     D1
    CLR     D3
    MOVE.B  STAMINA_DEC_2,D3
    MOVE.B  $7000,D1
    CMP     D3,D1
    BGT     NO_STAMINA           *IF STAMINA COST GREATER THAN STAMINA LEFT = NO STAMINA
     
    MOVE.L  (A4),D1
    SUB.L   #DAMAGE_EMISSION_TWO,D1
    MOVE.L  D1,$13000
    LEA     $13000,A4
    
    MOVE.W  $11000,D1
    ADD.W   #DAMAGE_EMISSION_TWO,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
    
                                    *DECREMENTS STAMINA
    MOVE.B  $7000,D1
    SUB.B   #STAMINA_DEC_2,D1
    MOVE.B  D1,$7000
    LEA     $7000,A1
    
    JMP     ATTACK_EMISSION
SUB_ONE_SWORD:
    CLR     D1
    CLR     D3
    MOVE.B  STAMINA_DEC_1,D3
    MOVE.B  $7000,D1
    CMP     D3,D1
    BGT     NO_STAMINA           *IF STAMINA COST GREATER THAN STAMINA LEFT = NO STAMINA
         
    MOVE.L  (A4),D1
    SUB.L   #DAMAGE_EMISSION_ONE,D1
    MOVE.L  D1,$13000
    LEA     $13000,A4
    
    MOVE.W  $11000,D1
    ADD.W   #DAMAGE_EMISSION_ONE,D1
    MOVE.W  D1,$11000
    LEA     $11000,A1
                                    *DECREMENTS STAMINA
    MOVE.B  $7000,D1
    SUB.B   #STAMINA_DEC_1,D1
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
    MOVE.B  #STAMINA_DEC_3,D2
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
    LEA     $4800,A1
    MOVE.B  #DAMAGE_EMISSION_THREE,D2
    MOVE.B  (A1),D3
    MULU    D2,D3    
    MOVE.L  (A4),D1
    SUB.L   D3,D1
    MOVE.L  D1,$13000
    LEA     $13000,A4
                                *INCREMENTS EMISSION SLASHED COUNT
    CLR     D2
    CLR     D3
    LEA     $4800,A1
    MOVE.B  #DAMAGE_EMISSION_THREE,D2
    MOVE.B  (A1),D3
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
    MOVE.B  #STAMINA_DEC_2,D2
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
    LEA     $4800,A1
    MOVE.B  #DAMAGE_EMISSION_TWO,D2
    MOVE.B  (A1),D3
    MULU    D2,D3    
    MOVE.L  (A4),D1
    SUB.L   D3,D1
    MOVE.L  D1,$13000
    LEA     $13000,A4
                                *INCREMENTS EMISSION SLASHED COUNT
    CLR     D2
    CLR     D3
    LEA     $4800,A1
    MOVE.B  #DAMAGE_EMISSION_TWO,D2
    MOVE.B  (A1),D3
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
    MOVE.B  #STAMINA_DEC_1,D2
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
    LEA     $4800,A1
    MOVE.B  #DAMAGE_EMISSION_ONE,D2
    MOVE.B  (A1),D3
    MULU    D2,D3    
    MOVE.L  (A4),D1
    SUB.L   D3,D1
    MOVE.L  D1,$13000
    LEA     $13000,A4
                                *INCREMENTS EMISSION SLASHED COUNT
    CLR     D1
    CLR     D2
    CLR     D3
    LEA     $4800,A1
    MOVE.B  #DAMAGE_EMISSION_ONE,D2
    MOVE.B  (A1),D3
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
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     STYLE_TITLE,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    LEA     STYLE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,$4100
    JMP     LORE

*-------------------------------------------------------
*-------------------------SHOP--------------------------
*------------------------------------------------------- 
SHOP_ENTER:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     SHOP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     MONEY_DISPLAY
    BSR     ENDL
    BSR     ENDL
    BSR     ENDL
    LEA     SHOP_ITEM1_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    CLR     D1
    MOVE.B  #4,D0
    TRAP    #15
    CMP     #1,D1
    BEQ     BOUGHT_ABILITY_LEVEL
    
    BSR     DECORATE
    JMP     REPLAY
    
BOUGHT_ABILITY_LEVEL:
    CLR     D1
    CLR     D2
    LEA     $8000,A1
    MOVE.W  (A1),D1
    MOVE.W  #1000,D2
    CMP     D2,D1
    BLT     NOT_ENOUGH_MONEY
    
    CLR     D1
    CLR     D2
    CLR     D3
    LEA     $4800,A1
    LEA     $4500,A0
    MOVE.B  (A1),D1
    MOVE.B  (A0),D2
    ADD.B   #1,D1
    ADD.B   #1,D2
    MOVE.B  D1,$4800
    MOVE.B  D2,$4500
    LEA     $4800,A1
    LEA     $4500,A0
                            *MONEY DEDUCT
    LEA     $8000,A1
    MOVE.W  (A1),D3
    SUB.W   #1000,D3
    MOVE.W  D3,$8000
    LEA     $8000,A1
    
    JMP     SHOP_ENTER
NOT_ENOUGH_MONEY:
    BSR     ENDL
    BSR     ENDL
    LEA     NO_MONEY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     HALT
    JMP     SHOP_ENTER
          

*-------------------------------------------------------
*--------------------------LOOP-------------------------
*   -------------------------------------------------------
LOOP:
    MOVE.B  #5, D3 LOOP COUNTER D3=5


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
LORE:
    CLR     D1
    MOVE.B  $4100,D1
    CMP     #2,D1       IS D1 == 2?
    BEQ     LORE_2      
    
    CMP     #2,D1       IS D1 < 2?
    BLT     LORE_1
    
    CMP     #2,D1       IS D1 > 2?
    BGT     LORE_3
LORE_1:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     LORE1_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     HALT
    BSR     CONFIRM_STYLE
    RTS

LORE_2:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     LORE2_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     HALT
    BSR     CONFIRM_STYLE
    RTS

LORE_3:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     LORE3_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     HALT
    BSR     CONFIRM_STYLE
    RTS
CONFIRM_STYLE:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    LEA     RECONSIDER_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    
    CMP     #1,D1
    BEQ     STATS
    
    CMP     #0,D1
    BEQ     INPUT
*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     REPLAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    
    MOVE.B  #4,D0
    TRAP    #15
    
    CMP     #EXIT,D1
    BEQ     END
    
    CMP     #STATISTICS,D1
    BEQ     STATS
    
    CMP     #SHOP,D1
    BEQ     SHOP_ENTER
    
    CMP     #ATTACK,D1
    BEQ     ATTACK_EMISSION
    
    CMP     #REST,D1
    BEQ     FULLY_REST
    
    CMP     #NEXT_DAY,D1
    BEQ     NAP
    
    JMP     REPLAY

ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE    #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS
FULLY_REST:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN

*ADD MORE ENEMIES AND EMISSION FOR FULL REST
         *DAYS AND RESET STAMINA
                              *INCREMENTS THE DAYS
    CLR     D1
    LEA     $9000,A1
    MOVE.W  (A1),D1
    ADD.W   #3,D1
    MOVE.W  D1,$9000
    LEA     $9000,A6

                            *IF THE EMISSION IS TOO HIGH, END GAME
    CLR     D1
    LEA     $13000,A1
    MOVE.L  (A1),D1
    CMP     #60000,D1
    BHS     YOU_LOST
                            *IF EMISSION IS <=0, VICTORY SCREEN
    CMP     #0,D1
    BLS     YOU_WIN
                            *INCREMENTS THE EMISSION

    CLR     D1
    CLR     D2
    MOVE.W  #EMISSION_INC,D2
    MULU    #10,D2
    MOVE.L  (A4),D1
    ADD.L   D2,D1
    MOVE.L  D1,$13000
    LEA     $13000,A4
                            *INCREMENTS THE ENEMIES
    CLR     D3
    LEA     $3000,A1
    MOVE.W  (A1),D3
    CLR     D1
    LEA     $5000,A3
    MOVE.W  (A3),D1
    ADD.W   D3,D1
    MOVE.W  D1,$5000
    LEA     $5000,A3
    
    *RESET FATIGUE
    JMP     RESTED
    
NAP:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    
                              *INCREMENTS THE DAYS
    CLR     D1
    LEA     $9000,A1
    MOVE.W  (A1),D1
    ADD.W   #1,D1
    MOVE.W  D1,$9000
    LEA     $9000,A6
    
                               *IF THE EMISSION IS TOO HIGH, END GAME
    CLR     D1
    CLR     D2
    LEA     $13000,A1
    MOVE.L  (A1),D1
    CMP     #60000,D1
    BHI     YOU_LOST
    
                              *IF EMISSION IS <=0, VICTORY SCREEN
    CMP     #0,D1
    BLS     YOU_WIN

    
                                *INCREMENTS THE EMISSION
    CLR     D1
    MOVE.L  (A4),D1
    ADD.L   #EMISSION_INC,D1
    MOVE.L  D1,$13000
    LEA     $13000,A4
                            *INCREMENTS THE ENEMIES
    CLR     D1
    CLR     D2
    LEA     $3000,A1
    LEA     $5000,A3
    MOVE.B  (A1),D2
    MOVE.W  (A3),D1
    ADD.W   D2,D1
    MOVE.W  D1,$5000
    LEA     $5000,A3
    
    *RESET FATIGUE
    JMP     GAMELOOP
    
YOU_LOST:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    LEA     LOST_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    
    CMP     #1,D1
    BEQ     START     
    
    BSR     END
YOU_WIN:
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    BSR     DECORATE
    BSR     CLEAR_SCREEN
    
    LEA     WON_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    
    CMP     #1,D1
    BEQ     START
    
    BSR     END


*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------

CRLF:           DC.B    $0D,$0A,0
WELCOME_MSG:    DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    '                                Wan(o) (e)mission '
                DC.B    $0D,$0A
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                             PRESS <ENTER> TO START',0
LOST_MSG:       DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    '                                Wan(o) (e)mission '
                DC.B    $0D,$0A
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                       - The emission levels were too high'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                               for you to handle..'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                   - Maybe we were wrong about you after all.'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                      >  Prove them wrong and try again?  <'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '    <ENTER>  < 1 > to restart                         <ENTER>  < 0 > to EXIT    '
                DC.B    $0D,$0A
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    '                                       ',0
WON_MSG:        DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    '                                Wan(o) (e)mission '
                DC.B    $0D,$0A
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                    - All hail the mightiest warrior in Wano!'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '  - You have succeeded in defending Wano kingdom and saved earth atmosphere'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '           - We hereby declare that you are one of us, samurai-gozaru.'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                   - Do you wish to re-live the nightmare again?'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '    <ENTER>  < 1 > to restart                         <ENTER>  < 0 > to EXIT    '
                DC.B    $0D,$0A
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    '                                       ',0

STARTING_INFO:  DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    '               - Welcome swordsman-gozaru,'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '     the Wano kingdom has been attacked by the Amanto, extraterrestrial'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '     beings from space, that are a threat, not even to the Wano kingdom,  '
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '     but the world itself!'
                DC.B    $0D,$0A
                DC.B    '     Amanto feeds off the oxygen of the earths atmosphere, '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '     leaving the air with pure Carbon Dioxide.  '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '.------------------------------------------------------------------------------.'
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '               - Your (E)mission is to fight the Amanto using the swordstyles'
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
                DC.B    '.-----------------------------------------------------------------------------.'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '               - With the combination of combat skills and mythical swords,'
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '     you have a chance to bring the tidings, all rests on your shoulders-gozaru.   '
                DC.B    $0D,$0A
                DC.B    '                                                   '
                DC.B    $0D,$0A
                DC.B    '                                                 '
                DC.B    $0D,$0A
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    '<ENTER> To continue..',0
STYLE_TITLE:    DC.B    ' ------------------------------- STYLE SELECTOR -------------------------------',0
STYLE_MSG:      DC.B    '                           SELECT YOUR FIGHTING STYLE '
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                     - 1: Three swords style(///Santoryu) -'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                      - 2: Two swords style(//Nitoryu) -'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '                       - 3: One sword style(/Ittoryu) -'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    '                                       ',0
LOOP_MSG:       DC.B    '.',0
REPLAY_MSG:     DC.B    '.------------------------------- PICK YOUR FATE -------------------------------.'
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '              - - > <ENTER>: 1 to display the stats GUI '
                DC.B    $0D,$0A
                DC.B    '              - - > <ENTER>: 2 to open the shop GUI    '
                DC.B    $0D,$0A
                DC.B    '              - - > <ENTER>: 3 to enter the battlefield  '
                DC.B    $0D,$0A
                DC.B    '              - - > <ENTER>: 4 to take a nap'
                DC.B    $0D,$0A
                DC.B    '              - - > <ENTER>: 5 to fully rest'
                DC.B    $0D,$0A
                DC.B    '              - - > <ENTER>: 0 to EXIT the game '
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    ''
                DC.B    $0D,$0A
                DC.B    '---------------------------------------.----------------------------------------'
                DC.B    $0D,$0A
                DC.B    '                                       ',0

FIGHTING_STYLE_MSG:     DC.B    '                 > - Your fighting style: ',0
STYLE_DAMAGE_MSG:       DC.B    '                            > - Your base damage: ',0
STAMINA_NORMAL_MSG:     DC.B    '                           > - Normal stamina use: ',0
STAMINA_USE_MSG:        DC.B    '                          > - Ability stamina use: ',0
ABILITY_DAMAGE_MSG:     DC.B    '                           > - Ability damage: ',0
ABILITY_LEVEL_MSG:      DC.B    '                            > - Ability level: ',0
FIRST_PICK:             DC.B        'Three swords style(///Santoryu)',0
SECOND_PICK:            DC.B        'Two swords style(//Nitoryu)',0
THIRD_PICK:             DC.B        'One sword style(/Ittoryu)',0                       
EMISSION:               DC.B    '                              > - C.EMISSION: ',0
STARTER_MSG:            DC.B    '.-----------------------------------. STATS .----------------------------------.'
                        DC.B    $0D,$0A
                        DC.B    '',0
ENEMIES_MSG:            DC.B    '                              > - AMANTO ALIVE: ',0
STAMINA_MSG:            DC.B    '                                > - STAMINA: ',0
MONEY_MSG:              DC.B    '                                > - BALANCE: ',0
FATIGUE_MSG:            DC.B    '                             > - FATIGUE LEVEL: ',0
SHOP_ITEM1_MSG:         DC.B    ' < 1 > - Ability upgrade: 1000 GOLD ',0
NO_MONEY_MSG:           DC.B    '          >>> Insuficient funds, try again after killing a few Amanto <<<',0
ASK_MSG:                DC.B    '                        Play?'
                        DC.B    $0D,$0A
                        DC.B    '                 To Play enter any number            '
                        DC.B    $0D,$0A
                        DC.B    '                    To EXIT enter 0           ',0
DAYS_MSG:               DC.B    '                                 > - Day: ',0
BATTLEFIELD_MSG:        DC.B    '.------------------------------- THE BATTLEFIELD ------------------------------.'
                        DC.B    $0D,$0A
                        DC.B    '                                                 '
                        DC.B    $0D,$0A
                        DC.B    '             - You have entered the battlefield, prepare to battle  '
                        DC.B    $0D,$0A
                        DC.B    '               the Amanto and slash through the Carbon Dioxide with   '
                        DC.B    $0D,$0A
                        DC.B    '               your mighty swords to save the earth  '
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '                  - - > <ENTER> 1: To attack Amanto'
                        DC.B    $0D,$0A
                        DC.B    '                  - - > <ENTER> 2: To attack Emission directly'
                        DC.B    $0D,$0A
                        DC.B    '                  - - > <ENTER> 0: To return to the menu'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    '---------------------------------------.----------------------------------------',0
ENEMIES_KILLED_TODAY:   DC.B    '                             > - Enemies defeated: ',0
EMISSION_SLASHED_TODAY: DC.B    '                       > - Carbon Dioxide slashed: ',0
OUT_STAMINA_MSG         DC.B    '               >>> You are out of stamina, retreat warrior <<<,'
                        DC.B    $0D,$0A
                        DC.B    '                    >>you have done enough, for today..<<',0
SHOP_MSG:               DC.B    '.--------------------------------- THE  SHOP ---------------------------------.'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '             - Here you can find the goods to ease the battle  '
                        DC.B    $0D,$0A
                        DC.B    '               with the Carbon emission and Amanto in the front.   '
                        DC.B    $0D,$0A
                        DC.B    '             - Take your time and spend your gold coins  '
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '                                     wisely..'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '---------------------------------------.----------------------------------------',0
LORE1_MSG:              DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    '                   -------I--  Three swords style  --I-------'
                        DC.B    $0D,$0A
                        DC.B    '                                       |'
                        DC.B    $0D,$0A
                        DC.B    '                                      -T-'
                        DC.B    $0D,$0A
                        DC.B    '                                       |'
                        DC.B    $0D,$0A
                        DC.B    '                                       |'
                        DC.B    $0D,$0A
                        DC.B    '                                       |'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '       - Legendary swordsman style, required immense strength and skill'
                        DC.B    $0D,$0A
                        DC.B    '              to utilize three swords at once - two in the palms,'
                        DC.B    $0D,$0A
                        DC.B    '          one in between theeth, clenched for grip and utilization of '
                        DC.B    $0D,$0A
                        DC.B    '              extreme jaw strength, following thoroughly trained'
                        DC.B    $0D,$0A
                        DC.B    '                  neck muscles to move the sword as pleased.'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '                            - Only for the worthy -'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    '<ENTER> To continue..',0
LORE2_MSG:              DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    '                    -------I--  Two swords style  --I-------                    '
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           - Not so widely utilized swordsman style, also as recalled '
                        DC.B    $0D,$0A
                        DC.B    '                 as dual wielding, use of two unsheathed swords'
                        DC.B    $0D,$0A
                        DC.B    '           at the same time to balance out offensive along the defensive. '
                        DC.B    $0D,$0A
                        DC.B    '                 Perfect combination to battle shielded opponents'
                        DC.B    $0D,$0A
                        DC.B    '           to place them out of balance by a strike and finish them off'
                        DC.B    $0D,$0A
                        DC.B    '                             with the second slash.'
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '   '
                        DC.B    $0D,$0A
                        DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    '<ENTER> To continue..',0
                        
LORE3_MSG:              DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    '                                One sword style'
                        DC.B    $0D,$0A
                        DC.B    '                                       |                      '
                        DC.B    $0D,$0A
                        DC.B    '                                      -T-  '
                        DC.B    $0D,$0A
                        DC.B    '                                       |'
                        DC.B    $0D,$0A
                        DC.B    '                                       |'
                        DC.B    $0D,$0A
                        DC.B    '                                       |'
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '         - The classic one sword, one man combo that would kneel many        '
                        DC.B    $0D,$0A
                        DC.B    '                 to the ground without even noticing the blade'
                        DC.B    $0D,$0A
                        DC.B    '                        being drawn out of the scabbard. '
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '           '
                        DC.B    $0D,$0A
                        DC.B    '   '
                        DC.B    $0D,$0A
                        DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    '<ENTER> To continue..',0
RECONSIDER_MSG:         DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ' --------------------- Do you wish to lock in this style? ---------------------'
                        DC.B    $0D,$0A
                        DC.B    ' ------------ Input: 1 to confirm ----------- Input: 0 to cancel -------------'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '---------------------------------------.----------------------------------------',0                 
BONUS_MSG:              DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '-                           -- 10 DAY BONUS UNLOCKED --                        -'
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    ''
                        DC.B    $0D,$0A
                        DC.B    '---------------------------------------.----------------------------------------'
                        DC.B    $0D,$0A
                        DC.B    '                                       ',0


                       
    END START











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
