InitializeMenu:
    JSR Initialize
    LDA #LOW(menu)
    STA level_lo
    LDA #HIGH(menu)
    STA level_hi
    RTS

MenuLogic:
    ;JSR _EnterLevel



MenuResetPPU:
    JSR _ResetPPU
    RTS
