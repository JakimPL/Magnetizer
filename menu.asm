InitializeMenu:
    JSR Initialize
    LDA #LOW(menu)
    STA level_lo
    LDA #HIGH(menu)
    STA level_hi
    RTS

MenuLogic:
    JSR _ResetPPU
    JSR _LatchController

ReadMenuController:
    LDA #$00
    STA input
    LDY #$08
ReadMenuControllerLoop:
    LDA JOY1
    LSR A
    ROL input
    DEY
    BNE ReadMenuControllerLoop

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
    INC level
    LDX level_set
    LDA level_set_count, x
    SEC
    SBC #$01
    CMP level
    BCC SetLevelToMax
    JMP SetCursor
MoveCursorUp:
    INC button_pressed
    DEC level
    LDA level
    BMI SetLevelToZero
    JMP SetCursor
EnterLevel:
    JSR _EnterLevel
    JMP MenuLogicEnd
SetLevelToZero:
    LDA #$00
    STA level
    JMP SetCursor
SetLevelToMax:
    LDA level_set_count, x
    STA level
    DEC level
SetCursor:
    JSR _CalculateCursorPosition
    STA $0230
    JMP MenuLogicEnd

ReleaseController:
    LDA #$00
    STA button_pressed

MenuLogicEnd:
    RTS
