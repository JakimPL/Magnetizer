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
    LDY #$00
PrecalculateCountersStep:
    STY offset_y
    TYA
    ASL a
    ASL a
    ASL a
    STA offset_x

    LDA medals, y
    STA dividend
    LDA #$00
    STA dividend + 1
    JSR SetDivisor
    JSR Hex2Dec

CopyMedalDecimals:
    LDA offset_x
    CLC
    ADC #$04
    TAX
    LDY #SCORE_DIGITS
CopyMedalDigit:
    LDA decimal, y
    STA box_x, x
    INX
    DEY
    BPL CopyMedalDigit

    LDA offset_y
    ASL a
    TAY
    LDA scores, y
    STA dividend
    INY
    LDA scores, y
    STA dividend + 1
    JSR SetDivisor
    JSR Hex2Dec

CopyScoreDecimals:
    LDX offset_x
    LDY #SCORE_DIGITS
CopyScoreDigit:
    LDA decimal, y
    STA box_x, x
    INX
    DEY
    BPL CopyScoreDigit

    LDY offset_y
    INY
    CPY #$0A ; to replace by level_set_count
    BNE PrecalculateCountersStep
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
