InitializeMenu:
    JSR Initialize
    LDA #LOW(menu)
    STA level_lo
    LDA #HIGH(menu)
    STA level_hi
    RTS

LoadCursor:
    LDX #$00
LoadCursorLoop:
    LDA cursor, x
    STA $0230, x
    INX
    CPX #$10
    BNE LoadCursorLoop
    RTS

MenuLogic:
    JSR _EnterLevel
    RTS


MenuResetPPU:
    JSR _ResetPPU
    RTS
