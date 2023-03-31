InitializeMenu:
    JSR _Initialize
    JSR _DisableNMI
    JSR PrecalculateCounters
    JSR PrecalculateAvailableSets
    LDA #LOW(menu)
    STA level_lo
    LDA #HIGH(menu)
    STA level_hi
    RTS

PrecalculateAvailableSets:
    LDX #$FF
    STX level_sets_unlocked
PrecalculateAvailableSetsStep:
    INX
    INC level_sets_unlocked
    LDA total_levels_cleared
    CMP levels_to_unlock, x
    BCS PrecalculateAvailableSetsStep
    RTS

PrecalculateCounters:
    LDX #$00
    LDA level_set_counter
    STA level_hi
    LDA level_set
    STA level_lo
    STX level_set_counter
    STX level_set
    STX total_levels
    STX total_levels_cleared
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

CopyMedalDigits:
    LDA offset_x
    CLC
    ADC #$04
    TAY

    JSR _SetDigitTargetBox
    LDX #SCORE_DIGITS
    JSR _CopyDigits

    LDA offset_y
    ASL a
    TAX
    LDA scores, x
    STA dividend
    INX
    LDA scores, x
    STA dividend + 1
    JSR _SaveMedal
    JSR SetDivisor
    JSR Hex2Dec
    JSR CopyScoreDigits

CheckIfLevelCleared:
    LDA level_cleared
    BEQ IncrementLevel
AddClearedLevel:
    INC levels_cleared
    INC total_levels_cleared

IncrementLevel:
    INC total_levels
    INC level_set_counter
    LDX level_set
    LDA level_set_count, x
    CMP level_set_counter
    BNE PrecalculateCountersStepEnd
    JSR SaveLevelSetStatistics
ResetLevelSetCounter:
    INC level_set
    LDA #$00
    STA level_set_counter
    STA levels_cleared

PrecalculateCountersStepEnd
    LDX offset_y
    INX
    CPX #LEVELS
    BNE PrecalculateCountersStep
    JSR SaveGlobalStatistics

RestoreVariables:
    LDA level_hi
    STA level_set_counter
    LDA level_lo
    STA level_set
    RTS

CopyScoreDigits:
    LDY offset_x
    LDX #SCORE_DIGITS
    LDA #$00
    STA level_cleared
CopyScoreDigit:
    LDA decimal, x
    STA [digit_target_lo], y
    BEQ CopyScoreDigitIncrement
    INC level_cleared
CopyScoreDigitIncrement:
    INY
    DEX
    BPL CopyScoreDigit
    RTS

SaveLevelSetStatistics:
    JSR _SetDigitTargetCounters
    LDA levels_cleared
    STA dividend
    JSR SetDivisor
    JSR Hex2Dec

    LDA level_set
    ASL a
    ASL a
    TAY
    STY index

    LDX #LEVELS_DIGITS
    JSR _CopyDigits

SaveLevelSetLevelCount:
    LDA level_set_counter
    STA dividend
    JSR SetDivisor
    JSR Hex2Dec

    LDA index
    CLC
    ADC #$02
    TAY

    LDX #LEVELS_DIGITS
    JSR _CopyDigits
    RTS

SaveGlobalStatistics:
    JSR _SetDigitTargetCounters
    LDA total_levels_cleared
    STA dividend
    JSR SetDivisor
    JSR Hex2Dec
    LDY #GLOBAL_STATISTICS_OFF
    LDX #TOTAL_DIGITS
    JSR _CopyDigits
CopyClearedLevelsCountDigits:
    LDA total_levels
    STA dividend
    JSR SetDivisor
    JSR Hex2Dec
    LDY #GLOBAL_STATISTICS_OFF + TOTAL_DIGITS + 1
    LDX #TOTAL_DIGITS
    JSR _CopyDigits
    RTS

MenuLogic:
    JSR _CalculateLevelSetOffset
    LDX screen_movement
    BEQ CheckIfLevelSelected
ChangePalettes:
    DEC screen_movement
    JSR _PrepareAndLoadPalettes
    JSR _ResetPPU
    JMP MenuLogicEnd
CheckIfLevelSelected:
    LDX screen_offset
    BEQ ContinueMenuLogic
    JSR DrawUpcomingLevel
    JSR _ResetPPU
    JMP MenuLogicEnd
ContinueMenuLogic:
    LDA speed
    AND #%00000001
    BNE DrawStatistics
DrawLevelTexts:
    JSR _CalculateTextRange
    JSR _DrawLevelTexts
    JMP MenuDrawEnd
DrawStatistics:
    JSR _DrawScores
    JSR _DrawLevels
    JSR _DrawLevelSetText
MenuDrawEnd:
    INC speed
    JSR _ResetPPU

DrawArrows:
    LDA #$F0
    STA SPR_ADDRESS_LARROW + $00
    STA SPR_ADDRESS_LARROW + $04
    STA SPR_ADDRESS_RARROW + $00
    STA SPR_ADDRESS_RARROW + $04

    LDA #$18
    STA SPR_ADDRESS_RARROW + $01
    STA SPR_ADDRESS_RARROW + $05
    STA SPR_ADDRESS_LARROW + $01
    STA SPR_ADDRESS_LARROW + $05

    LDA #$03
    STA SPR_ADDRESS_RARROW + $02
    LDA #$83
    STA SPR_ADDRESS_RARROW + $06

    LDA #$43
    STA SPR_ADDRESS_LARROW + $02
    LDA #$C3
    STA SPR_ADDRESS_LARROW + $06
DrawLeftArrow:
    LDA level_set
    CMP #$01
    BCC DrawRightArrow
    JSR _DrawLeftArrow

DrawRightArrow:
    LDA level_set
    CLC
    ADC #$01
    CMP level_sets_unlocked
    BEQ ReadMenuController
    JSR _DrawRightArrow

ReadMenuController:
    JSR _LatchController
    JSR _ReadController

CheckIfButtonPressed:
    LDA button_pressed
    BNE CheckNoInput
    JMP CheckInput
CheckNoInput:
    LDA input
    BEQ JumpToReleaseController
    JMP MenuLogicEnd

JumpToReleaseController:
    JMP ReleaseController

CheckInput:
    LDA input
    CMP #$01
    BEQ MoveCursorRight
    CMP #$02
    BEQ MoveCursorLeft
    CMP #$04
    BEQ MoveCursorDown
    CMP #$08
    BEQ MoveCursorUp
    CMP #$10
    BEQ EnterLevel
    JMP ReleaseController
MoveCursorLeft:
    INC screen_movement
    INC button_pressed
    DEC level_set
    LDA #$00
    STA level_set_counter
    LDA level_set
    BMI SetLevelSetToZero
    JMP SetCursor
SetLevelSetToZero:
    LDA #$00
    STA level_set
    JMP SetCursor
MoveCursorRight:
    INC screen_movement
    INC button_pressed
    INC level_set
    LDA #$00
    STA level_set_counter
    LDA level_set
    CMP level_sets_unlocked
    BEQ SetLevelSetToMax
    JMP SetCursor
SetLevelSetToMax:
    LDA level_sets_unlocked
    SEC
    SBC #$01
    STA level_set
    JMP SetCursor
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
    INC screen_offset
    JSR _HideCursor
    JSR _CalculateNextLevelPointer
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
    RTS

DrawUpcomingLevel:
    LDA #$24
    STA ppu_address
    JSR _SetLevelPointer
    JSR _RedrawLevelStep
    BNE DrawUpcomingLevelEnd
    RTS
DrawUpcomingLevelEnd:
    LDA #$00
    STA level_loading
    STA screen_offset
    LDA #$01
    STA game
    JSR _DisableNMI
    JSR InitializeGame
    JSR _EnterLevel
    JSR _EnableNMI
DrawUpcomingLevelLoop:
    JMP DrawUpcomingLevelLoop
