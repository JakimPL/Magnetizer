InitializeMenu:
    JSR Initialize

    LDA #LOW(menu)
    STA level_lo
    LDA #HIGH(menu)
    STA level_hi
    RTS

MenuLogic:
    ;JSR _EnterLevel
    LDA #$21
    STA ppu_shift
    TYA
    JSR _Multiply
    CLC
    ADC #$46
    TAX
    JSR _PreparePPU

    LDX #$01
    LDA text_level
    CLC
    ADC #$01
    STA text_length
DrawLevelText:
    LDA text_level, x
    STA PPUDATA

    INX
    CPX text_length
    BNE DrawLevelText

    JSR _ResetPPU
    RTS
