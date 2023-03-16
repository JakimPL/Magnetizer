InitializeMenu:
    JSR Initialize
    JSR _DisableNMI
    JSR PrecalculateCounters
    LDA #LOW(menu)
    STA level_lo
    LDA #HIGH(menu)
    STA level_hi
    RTS

PrecalculateCounters:
    LDX #$00
    STX level_cleared
PrecalculateCountersStep:
    STX offset_y
    TXA
    ASL a
    ASL a
    ASL a
    STA offset_x

    LDA medals, x
    STA dividend
    LDA #$00
    STA dividend + 1
    JSR SetDivisor
    JSR Hex2Dec

CopyMedalDecimals:
    LDA offset_x
    CLC
    ADC #$04
    TAY
    LDX #SCORE_DIGITS
CopyMedalDigit:
    LDA decimal, x
    STA box_x, y
    INY
    DEX
    BPL CopyMedalDigit

    LDA offset_y
    ASL a
    TAX
    LDA scores, x
    STA dividend
    INX
    LDA scores, x
    STA dividend + 1
    JSR SetDivisor
    JSR Hex2Dec

CopyScoreDecimals:
    LDY offset_x
    LDX #SCORE_DIGITS
    LDA #$00
    STA level_cleared
CopyScoreDigit:
    LDA decimal, x
    STA box_x, y
    BNE CopyScoreDigitIncrement
    INC level_cleared
CopyScoreDigitIncrement:
    INY
    DEX
    BPL CopyScoreDigit

CheckIfLevelCleared:
    LDA level_cleared
    BNE PrecalculateCountersStepEnd
AddClearedLevel:
    INC levels_cleared

PrecalculateCountersStepEnd
    LDX offset_y
    INX
    CPX #LEVELS
    BNE PrecalculateCountersStep

    LDA levels_cleared
    STA dividend
    JSR SetDivisor
    JSR Hex2Dec
    STA portals_a_x
    RTS

MenuLogic:
    JSR _ResetPPU

ReadMenuController:
    JSR _LatchController
    JSR _ReadController

CheckIfButtonPressed:
    LDA button_pressed
    BNE CheckNoInput
    JMP CheckInput
CheckNoInput:
    LDA input
    BEQ ReleaseController
    JMP MenuLogicEnd

CheckInput:
    LDA input
    CMP #$04
    BEQ MoveCursorDown
    CMP #$08
    BEQ MoveCursorUp
    CMP #$10
    BEQ EnterLevel
    JMP ReleaseController
MoveCursorDown:
    INC button_pressed
    INC level_set_counter
    LDX level_set
    LDA level_set_count, x
    SEC
    SBC #$01
    CMP level_set_counter
    BCC SetLevelToMax
    JMP SetCursor
MoveCursorUp:
    INC button_pressed
    DEC level_set_counter
    LDA level_set_counter
    BMI SetLevelToZero
    JMP SetCursor
EnterLevel:
    JSR _EnterLevel
    JMP MenuLogicEnd
SetLevelToZero:
    LDA #$00
    STA level_set_counter
    JMP SetCursor
SetLevelToMax:
    LDA level_set_count, x
    STA level_set_counter
    DEC level_set_counter
SetCursor:
    JSR _CalculateAndSetCursorPosition
    JMP MenuLogicEnd

ReleaseController:
    LDA #$00
    STA button_pressed

MenuLogicEnd:
    JSR _DrawScores
    JSR _ResetPPU
    RTS
