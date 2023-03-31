;;;;;;;;;;;;;;;;;
;; subroutines ;;
;;;;;;;;;;;;;;;;;

;; x as arguments ;;
_LatchController
    LDA #$01
    STA JOY1
    LDA #$00
    STA JOY1
    RTS

_ReadController:
    LDA #$00
    STA input
    LDY #$08
_ReadControllerLoop:
    LDA JOY1
    LSR a
    ROL input
    DEY
    BNE _ReadControllerLoop
    RTS

_EnableNMI:
    LDA #NMI_HORIZONTAL
    STA PPUCTRL

    LDA #%00011110   ; enable sprites
    STA PPUMASK
    RTS

_DisableNMI:
    LDA #%00010000   ; enable NMI, sprites from Pattern Table 1
    STA PPUCTRL
    RTS

_PreparePPU:
    LDA PPUSTATUS
    LDA ppu_shift
    STA PPUADDR
    STX PPUADDR
    LDA #$00
    STA PPUADDR
    RTS

_ResetPPU:
    LDA #$20
    STA ppu_shift
    LDX #$00
    JSR _PreparePPU
    RTS

;; x as argument ;;
_ShiftPPU:
    CLC
    ADC #$20
    TAX
    JSR _PreparePPU
    RTS

_StartScreenRedraw:
    LDA #$01
    STA level_loading
    LDA #$20
    STA ppu_address
    JSR _ClearBasicSprites
    RTS

_StartScreenMovement:
    LDA #$01
    STA screen_movement
    LDA #$24
    STA ppu_address
    JSR _ClearBasicSprites
    RTS

; x, y arguments ;
_CopyDigits:
    LDA decimal, x
    STA [digit_target_lo], y
    INY
    DEX
    BPL _CopyDigits
    RTS

_DrawNumber:
    LDX digits
_DrawNumberStep:
    LDA [digit_target_lo], y
    STA PPUDATA
    INY
    DEX
    CPX #$FF
    BNE _DrawNumberStep
    RTS

_SetDigitTargetBox:
    LDA #LOW(box_x)
    STA digit_target_lo
    LDA #HIGH(box_x)
    STA digit_target_hi
    LDA offset_y
    CMP #$20
    BCS _IncrementDigitTargetHi
    RTS
_IncrementDigitTargetHi:
    INC digit_target_hi
    RTS

_SetDigitTargetCounters:
    LDA #LOW(counters)
    STA digit_target_lo
    LDA #HIGH(counters)
    STA digit_target_hi
    RTS

_ClearBasicSprites:
    JSR _HideStopper
    JSR _HideElectric
    LDY #$00
    STY blockade_flicker
_ClearBasicSpritesStep:
    TYA
    ASL a
    ASL a
    TAX
    LDA #$F0
    STA $0200, x
    INY
    CPY #$10
    BNE _ClearBasicSpritesStep
    RTS

_ChangeCounterAttributes:
    LDA #$23
    LDX #$F8
    LDY #$E0
    STA ppu_shift
    JSR _PreparePPU
    LDA #$0F
    STA PPUDATA
    RTS

_DrawText:
    STY temp_y
    LDY #$00
    LDA [text_pointer_lo], y
    CLC
    ADC #$01
    STA text_length

    LDY #$01
_DrawLevelText:
    LDA [text_pointer_lo], y
    STA PPUDATA

    INY
    CPY text_length
    BNE _DrawLevelText
    LDY temp_y
    RTS

_DrawAllLevelTexts:
    LDY #$00
    STY position_x
    LDY #$0A
    STY position_y
    JSR _DrawLevelTexts
    RTS

_DrawLevelTexts:
    LDY position_x
_DrawLevelLineLoop:
    JSR _DrawLevelLine
_DrawLevelIncrement:
    INY
    CPY position_y
    BNE _DrawLevelLineLoop
    RTS

_DrawLevelLine:
    LDA text_levels_y_offsets, y
    STA ppu_shift
    LDX text_levels_x_offsets, y
    JSR _PreparePPU

    TYA
    LDX level_set
    CMP level_set_count, x
    BCC _DrawLevelLineStart

    AND #%00000001
    BEQ _SetFakeLine1
_SetFakeLine2:
    LDA #LOW(text_fake_2)
    STA text_pointer_lo
    LDA #HIGH(text_fake_2)
    STA text_pointer_hi
    JMP _DrawLevelLineDrawText
_SetFakeLine1:
    LDA #LOW(text_fake_1)
    STA text_pointer_lo
    LDA #HIGH(text_fake_1)
    STA text_pointer_hi
_DrawLevelLineDrawText:
    JSR _DrawText
    RTS
_DrawLevelLineStart:
    LDA #LOW(text_level)
    STA text_pointer_lo
    LDA #HIGH(text_level)
    STA text_pointer_hi
    JSR _DrawText
    JSR _DrawLevelNumber
    JSR _DrawMedal
    RTS

_DrawMedal:
    STY temp_y
    LDA #TILE_NONE
    STA PPUDATA

    TYA
    CLC
    ADC offset
    TAY

    LDX completed, y
    LDA medal_tiles, x
    STA PPUDATA

    LDY temp_y
    RTS

_DrawLevelNumber:
    TYA
    CMP #$09
    BCC _SetZero
    LDA #$01
    STA PPUDATA
    TYA
    SEC
    SBC #$09
    JMP _DrawSecondDigit
_SetZero:
    LDA #$00
    STA PPUDATA
    TYA
    CLC
    ADC #$01
_DrawSecondDigit:
    STA PPUDATA
    RTS

_DrawScoreText:
    LDA #TEXT_SCORE_Y_OFFSET
    STA ppu_shift
    LDX #TEXT_SCORE_X_OFFSET
    JSR _PreparePPU

    LDA #LOW(text_score)
    STA text_pointer_lo
    LDA #HIGH(text_score)
    STA text_pointer_hi

    JSR _DrawText
    RTS

_DrawScores:
    LDA #SCORE_Y_OFFSET
    STA ppu_shift
    LDX #SCORE_X_OFFSET
    JSR _PreparePPU

    LDA #SCORE_DIGITS
    STA digits

    JSR _CalculateAbsoluteLevel
    STA offset_y
    ASL a
    ASL a
    ASL a
    TAY

    JSR _SetDigitTargetBox
    JSR _DrawNumber
    JSR _DrawSeparator
    JSR _DrawNumber
    RTS

_DrawSeparator:
    LDA #SPACE_CHARACTER
    STA PPUDATA
    LDA #SLASH_CHARACTER
    STA PPUDATA
    LDA #SPACE_CHARACTER
    STA PPUDATA
    RTS

_DrawLevelsText:
    LDA #TEXT_LEVELS_Y_OFFSET
    STA ppu_shift
    LDX #TEXT_LEVELS_X_OFFSET
    JSR _PreparePPU

    LDA #LOW(text_levels)
    STA text_pointer_lo
    LDA #HIGH(text_levels)
    STA text_pointer_hi

    JSR _DrawText
    RTS

_DrawLevels:
    LDA #LEVELS_Y_OFFSET
    STA ppu_shift
    LDX #LEVELS_X_OFFSET
    JSR _PreparePPU

    LDA level_set
    ASL a
    ASL a
    TAY
    LDA #LEVELS_DIGITS
    STA digits

    JSR _SetDigitTargetCounters
    JSR _DrawNumber
    JSR _DrawSeparator
    JSR _DrawNumber
    RTS

_DrawTotalText:
    LDA #TEXT_TOTAL_Y_OFFSET
    STA ppu_shift
    LDX #TEXT_TOTAL_X_OFFSET
    JSR _PreparePPU

    LDA #LOW(text_total)
    STA text_pointer_lo
    LDA #HIGH(text_total)
    STA text_pointer_hi

    JSR _DrawText
    RTS

_DrawTotal:
    LDA #TOTAL_Y_OFFSET
    STA ppu_shift
    LDX #TOTAL_X_OFFSET
    JSR _PreparePPU

    LDY #GLOBAL_STATISTICS_OFF
    LDA #TOTAL_DIGITS
    STA digits

    JSR _DrawNumber
    JSR _DrawSeparator
    JSR _DrawNumber
    RTS

_DrawLevelSetText:
    LDA #TEXT_LSET_Y_OFFSET
    STA ppu_shift
    LDX #TEXT_LSET_X_OFFSET
    JSR _PreparePPU

    LDX level_set
    LDA labels_offsets, x
    CLC
    ADC #LOW(level_set_labels)
    STA text_pointer_lo
    LDA #HIGH(level_set_labels)
    STA text_pointer_hi

    JSR _DrawText
    RTS

_LoadCursor:
    LDX #$00
_LoadCursorLoop:
    LDA cursor, x
    STA SPR_ADDRESS_CURSOR, x
    INX
    CPX #$04
    BNE _LoadCursorLoop
    RTS

_DrawMenu:
    JSR _DrawLogo
    JSR _DrawLevelSetText
    JSR _DrawAllLevelTexts
    JSR _DrawScoreText
    JSR _DrawScores
    JSR _DrawLevelsText
    JSR _DrawLevels
    JSR _DrawTotalText
    JSR _DrawTotal
    JSR _LoadCursor
    JSR _CalculateAndSetCursorPosition
    RTS

_DrawPartialMenu:
    JSR _DrawLogo
    JSR _DrawAllLevelTexts
    JSR _DrawScoreText
    JSR _DrawLevelsText
    JSR _DrawTotalText
    JSR _DrawTotal
    JSR _LoadCursor
    JSR _CalculateAndSetCursorPosition
    RTS

_DrawLogo:
    LDA #LOGO_Y_OFFSET
    STA ppu_shift
    LDX #LOGO_X_OFFSET
    JSR _PreparePPU

    LDX #$80
    LDY #$00
_DrawLogoTile:
    STX PPUDATA
    INX
    TXA
    AND #%00011111
    CMP #$1A
    BNE _DrawLogoTile
_DrawLogoNewLine:
    TXA
    CLC
    ADC #$06
    STA temp_x

    INY
    CPY #$04

    LDX logo_offsets, y
    JSR _PreparePPU
    LDX temp_x

    BNE _DrawLogoTile
    RTS

_DrawSingleTilePart:
    LDA target_tile
    STA PPUDATA
    INC target_tile
    RTS

_DrawSingleTile
    JSR _DrawSingleTilePart
    JSR _DrawSingleTilePart
    RTS

_ClearSprites:
    JSR _HideStopper
    JSR _HideElectric
    LDY #$00
    STY blockade_flicker
_ClearSpritesStep:
    TYA
    JSR _Multiply
    TAX

    LDA #$F0
    STA $0240, x
    STA $0244, x
    STA $0248, x
    STA $024C, x

    INY
    CPY #$0A
    BNE _ClearSpritesStep
    RTS

_DrawLeftArrow:
    LDA #ARROW_Y + $00
    STA SPR_ADDRESS_LARROW + $00
    LDA #ARROW_Y + $08
    STA SPR_ADDRESS_LARROW + $04

    LDA speed
    LSR a
    LSR a
    AND #%00000111
    STA temp_x
    LDA #$08
    SEC
    SBC temp_x
    STA SPR_ADDRESS_LARROW + $03
    STA SPR_ADDRESS_LARROW + $07
    RTS

_DrawRightArrow:
    LDA #ARROW_Y + $00
    STA SPR_ADDRESS_RARROW + $00
    LDA #ARROW_Y + $08
    STA SPR_ADDRESS_RARROW + $04
    LDA speed

    LSR a
    LSR a
    AND #%00000111
    CLC
    ADC #$F0
    STA SPR_ADDRESS_RARROW + $03
    STA SPR_ADDRESS_RARROW + $07
    RTS

_UpdateStopper:
    LDA screen_x
    LSR a
    LSR a
    LSR a
    AND #%00000011
    CLC
    ADC #SPRITE_STOPPER
    STA SPR_ADDRESS_STOPPER + $01
    RTS

_UpdateElectric:
    LDA screen_x
    LSR a
    LSR a
    AND #%00000011
    LDX direction
    CLC
    ADC electric_sprite - 1, x
    STA SPR_ADDRESS_ELECTRIC + $01

    LDA #$02
    STA SPR_ADDRESS_ELECTRIC + $02
    RTS

_DrawStopper:
    LDA position_x
    SEC
    SBC #$04
    STA SPR_ADDRESS_STOPPER + $03
    LDA position_y
    SEC
    SBC #$05
    STA SPR_ADDRESS_STOPPER + $00

    LDA #$03
    STA SPR_ADDRESS_STOPPER + $02
    RTS

_HideStopper:
    LDA #$F8
    STA SPR_ADDRESS_STOPPER + $00
    RTS

_DrawElectric:
    STX temp_x
    LDX direction
    DEX

    LDA position_x
    CLC
    ADC electric_offset_x, x
    STA SPR_ADDRESS_ELECTRIC + $03

    LDA position_y
    CLC
    ADC electric_offset_y, x
    STA SPR_ADDRESS_ELECTRIC + $00

    LDX temp_x
    RTS

_HideElectric:
    LDA #$F8
    STA SPR_ADDRESS_ELECTRIC + $00
    RTS

_EnterLevel:
    LDA #$01
    STA game
    STA draw_counter
    STA next_level
    JSR InitializeGame

    JSR _PlaySound
    JSR _CalculateNextLevelPointer
    JSR _CalculatePalettePointer
_EnterLevelInitialize:
    JSR _ResetMoveCounter
    JSR InitializeSprites
    JMP EndLevelReset
    RTS

_CalculatePalettePointer:
    LDA #LOW(palettes)
    STA palette_lo
    LDA #HIGH(palettes)
    STA palette_hi

    LDX level_set
    CPX #$00
    BEQ _CalculatePalettePointerEnd
_CalculatePalettePointerStep:
    JSR _IncrementPalettePointer
    DEX
    CPX #$00
    BNE _CalculatePalettePointerStep
_CalculatePalettePointerEnd:
    RTS

_NextLevel:
    LDA next_level
    BNE _GoToNextLevel
    RTS
_GoToNextLevel:
    LDA #$00
    STA next_level
    INC level_set_counter
    LDX level_set
    LDA level_set_count, x
    CMP level_set_counter
    BEQ _NextLevelSet
    JSR _CalculateNextLevelPointer
    RTS

_SaveScore:
    JSR _CalculateAbsoluteLevel
    ASL a
    STA temp_x
    TAX

    JSR CounterToHex
    LDA score + 1
    BNE _CheckIfCurrentScoreIsZero
    LDA score
    BNE _CheckIfCurrentScoreIsZero
    RTS
_CheckIfCurrentScoreIsZero:
    LDX temp_x
    LDA scores, x
    BNE _SaveScoreCheck
    INX
    LDA scores, x
    BNE _SaveScoreCheck
    JMP _SaveScoreMain
_SaveScoreCheck:
    LDX temp_x
    INX
    LDA score + 1
    CMP scores, x
    BCC _SaveScoreMain

    DEX
    LDA score
    CMP scores, x
    BCC _SaveScoreMain
    RTS
_SaveScoreMain:
    LDX temp_x
    LDA score
    STA scores, x
    INX
    LDA score + 1
    STA scores, x
    RTS

_IncrementPalettePointer:
    LDA palette_lo
    CLC
    ADC #$20
    STA palette_lo
    RTS

_NextLevelSet:
    LDA #$00
    STA level_set_counter
    INC level_set
    LDA level_set
    CMP #LEVEL_SETS
    BEQ _RollBack
    JSR _IncrementPalettePointer
    JSR _CalculateNextLevelPointer
    RTS
_RollBack:
    LDA #LEVEL_SETS
    SEC
    SBC #$01
    STA level_set
    JSR _CalculateNextLevelPointer
    JSR GoToMenu
    RTS

_CalculateNextLevelPointer:
    LDA #HIGH(levels)
    CLC
    ADC level_set_counter
    STA level_hi

    LDY level_set
    CPY #LEVEL_SET_SWITCH
    BCC _EnterLeveLIncreasePointers

    CLC
    ADC #LEVEL_POINTER_OFFSET
    STA level_hi

_EnterLeveLIncreasePointers:
    LDX #$00
    LDY level_set
    BNE _EnterLevelIncreasePointer
    RTS
_EnterLevelIncreasePointer:
    LDA level_set_count, x
    ADC level_hi
    STA level_hi
    INX
    CPX level_set
    BNE _EnterLevelIncreasePointer
    RTS

_SetLevelPointer:
    LDA level_lo
    STA pointer_lo

    LDA level_hi
    STA pointer_hi
    RTS

_SetNextLevelPointer:
    LDA level_hi
    STA total_levels
    INC level_hi
    LDA level_hi
    CMP #SWITCH_POINTER_VALUE
    BNE _SetNextLevelPointerOffset
    CLC
    ADC #LEVEL_POINTER_OFFSET
    STA level_hi
_SetNextLevelPointerOffset:
    JSR _SetLevelPointer
_RestoreLevelPointer:
    LDA total_levels
    STA level_hi
    RTS

_Initialize:
_SetTilesPointer:
    LDA #LOW(tiles)
    STA tiles_lo
    LDA #HIGH(tiles)
    STA tiles_hi

_SetPalettePointer:
    LDA #LOW(palettes)
    STA palette_lo
    LDA #HIGH(palettes)
    STA palette_hi
    RTS

_LoadLevel:
    JSR _SetLevelPointer
    JSR _InitializeVariables
    JSR _ClearSprites

    LDX #$00
    LDY #$00
_LoadLevelInsideLoop:
    LDA [pointer_lo], y
_CheckIfStartingPoint:
    CMP #START
    BEQ _JumpToSaveStartingPosition
_CheckIfEndingPoint:
    CMP #END
    BEQ _JumpToSaveEndingPosition
_CheckIfBox:
    CMP #BOX
    BEQ _JumpToAddBox
_CheckIfPortalA:
    CMP #PORTAL_A
    BEQ _JumpToAddPortalA
_CheckIfPortalB:
    CMP #PORTAL_B
    BEQ _JumpToAddPortalB
_CheckIfBlockade:
    CMP #BLOCKADE
    BEQ _JumpToAddBlockade
_CheckIfBlockadeRemover:
    CMP #BLOCKADE_REMOVER
    BEQ _JumpToAddBlockadeRemover
_CheckIfTrapDoor:
    CMP #TRAP_DOOR
    BEQ _JumpToAddTrapDoor
    JMP _LoadLevelIncrement

_JumpToSaveStartingPosition:
    JSR _SaveStartingPointPosition
    JMP _LoadLevelIncrement

_JumpToSaveEndingPosition:
    JSR _SaveEndingPointPosition
    JMP _LoadLevelIncrement

_JumpToAddBox:
    JSR _AddBox
    JMP _LoadLevelIncrement

_JumpToAddPortalA:
    JSR _AddPortalA
    JMP _LoadLevelIncrement

_JumpToAddPortalB:
    JSR _AddPortalB
    JMP _LoadLevelIncrement

_JumpToAddBlockade:
    JSR _AddBlockade
    JMP _LoadLevelIncrement

_JumpToAddBlockadeRemover
    JSR _AddBlockadeRemover
    JMP _LoadLevelIncrement

_JumpToAddTrapDoor
    JSR _AddTrapDoor
    JMP _LoadLevelIncrement

_LoadLevelIncrement:
    INY
    CPY #$10
    BNE _LoadLevelInsideLoop

_LoadLevelIncrementPointer:
    LDA pointer_lo
    CLC
    ADC #$10
    STA pointer_lo

_LoadLevelPostLoop:
    LDY #$00
    INX
    CPX #$10
    BNE _LoadLevelInsideLoop
    RTS

_PrepareAndLoadPalettes:
    JSR _CalculateNextLevelPointer
    JSR _CalculatePalettePointer
    JSR _LoadPalettes
    RTS

_LoadPalettes:
    LDA PPUSTATUS
    LDA #$3F
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00
    LDY #$00
_LoadPalettesLoop:
    LDA [palette_lo], y
    STA PPUDATA
    INY
    CPY #$20
    BNE _LoadPalettesLoop
    RTS

_DrawTileVerticalPart:
    LDA current_tile
    STA PPUDATA
    CLC
    ADC #$02
    STA PPUDATA
    RTS

_DrawTileHorizontalPart:
    LDA current_tile
    STA PPUDATA
    CLC
    ADC #$01
    STA PPUDATA
    RTS

_LoadBackground:
    LDA ppu_address
    STA ppu_shift
    LDX #$00
    JSR _PreparePPU

    LDY #$00
_LoadBackgroundInsideLoop:
    JSR _LoadTile
    JSR _ShiftVertically
    JSR _DrawTileHorizontalPart

    INY
    CPY #$10
    BNE _LoadBackgroundInsideLoop

    TXA
    AND #%00000001
    BEQ _LoadBackgroundPostLoop

_LoadBackgroundIncPointer:
    LDA pointer_lo
    CLC
    ADC #$10
    STA pointer_lo

_LoadBackgroundPostLoop:
    LDY #$00
    INX
    CPX #$1E
    BNE _LoadBackgroundInsideLoop
    RTS

_LoadTile:
    CLC
    LDA [pointer_lo], y
    STY temp_y
    TAY
    LDA tiles, y
    STA current_tile
    LDY temp_y
    RTS

_LoadBackgroundHorizontalPart:
    LDA #NMI_HORIZONTAL
    STA PPUCTRL

    LDA screen_offset
    AND #%11111100
    ASL a
    ASL a
    STA pointer_lo

    LDA screen_offset
    AND #%00000001
    ASL a
    ASL a
    ASL a
    CLC
    ADC pointer_lo
    STA pointer_lo

    LDA screen_offset
    JSR _Divide
    CLC
    ADC ppu_address
    STA ppu_shift
    LDA screen_offset
    AND #%00001111
    ASL a
    ASL a
    ASL a
    ASL a
    TAX
    JSR _PreparePPU

    LDA screen_offset
    AND #%00000010
    LSR a
    TAX

    LDY #$00
_LoadBackgroundHorizontalLoop:
    JSR _LoadTile
    JSR _ShiftVertically
    JSR _DrawTileHorizontalPart

    INY
    CPY #$08
    BNE _LoadBackgroundHorizontalLoop
    RTS

_LoadBackgroundVerticalPart:
    LDA #NMI_VERTICAL
    STA PPUCTRL

    LDA #$20
    STA ppu_shift
    LDX screen_x
    LDA screen_offset
    LSR a
    AND #%00000001
    BNE _LoadBackgroundPartPPU
_BackgroundOffset:
    LDA #$22
    STA ppu_shift
    LDA pointer_lo
    CLC
    ADC #$80
    STA pointer_lo
_LoadBackgroundPartPPU:
    JSR _PreparePPU

    LDA screen_x
    LSR a
    TAY
_LoadBackgroundSetXOffset:
    LDA screen_offset
    LSR a
    CLC
    ADC #$01
    AND #%00000001
    TAX
_LoadBackgroundPartInsideLoop:
    JSR _LoadTile
    JSR _ShiftHorizontally
    JSR _DrawTileVerticalPart

    LDA pointer_lo
    CLC
    ADC #$10
    STA pointer_lo

    INX
    CPX #$08
    BNE _LoadBackgroundPartInsideLoop
    RTS

_LoadAttributeVerticalPart:
    LDA #NMI_HORIZONTAL
    STA PPUCTRL
    LDA #$23
    STA ppu_shift

    LDA screen_offset
    JSR _TransformA
    STA offset_x
    CLC
    ADC #$C0
    TAX
    JSR _PreparePPU

    LDA screen_offset
    JSR _TransformB
    TAY
    JSR _LoadTileAttribute
    STA PPUDATA
    RTS

_LoadAttributeHorizontalPart:
    LDA screen_offset
    AND #%00000001
    ASL a
    ASL a
    ASL a
    STA pointer_lo

    LDA screen_offset
    SEC
    SBC #$3C
    AND #%00001110
    JSR _Multiply
    ADC pointer_lo
    STA pointer_lo

    LDA screen_offset
    SEC
    SBC #$3C
    ASL a
    ASL a
    ADC #$C0
    TAX

    LDA ppu_address
    CLC
    ADC #$03
    STA ppu_shift
    JSR _PreparePPU

    LDY #$00
_LoadAttributeHorizontalLoop:
    JSR _LoadTileAttribute
    STA PPUDATA

    INY
    INY
    CPY #$08
    BNE _LoadAttributeHorizontalLoop
    RTS

_LoadBackgroundsAndAttributes:
    JSR _DisableNMI
    LDA #$20
    STA ppu_shift
    JSR _LoadBackgroundAndAttribute

    INC level_hi
    LDA #$24
    STA ppu_shift
    JSR _LoadBackgroundAndAttribute
    DEC level_hi
    RTS

_LoadBackgroundAndAttribute:
    JSR _SetLevelPointer
    LDA ppu_shift
    STA ppu_address
    JSR _LoadBackground
    JSR _SetLevelPointer
    LDA ppu_shift
    CLC
    ADC #$03
    STA ppu_address
    LDX #$C0
    JSR _PrepareAttributePPU
    JSR _LoadAttribute
    RTS

_PrepareAttributePPU:
    LDA PPUSTATUS
    LDA ppu_address
    STA PPUADDR
    LDX PPUADDR
    RTS

_LoadAttribute:
    LDX #$00
    LDY #$00
_LoadAttributeLoop:
    JSR _LoadTileAttribute
    STA PPUDATA

    INY
    INY
    TYA
    AND #%00001111
    BNE _LoadAttributeLoopNextStep
_LoadAttributeLoopNextLine:
    TYA
    ADC #$10
    TAY
_LoadAttributeLoopNextStep:
    INX
    CPX #$40
    BNE _LoadAttributeLoop
    RTS


;; y as argument ;;
_LoadSingleTileAttribute:
    LDA [pointer_lo], y
    TAY
    LDA attributes, y
    STA tile_attribute

    LDA attribute
    ASL a
    ASL a
    ADC tile_attribute
    STA attribute
    RTS

_LoadTileAttribute:
    STX temp_x
    STY temp_y

    LDA #$00
    STA attribute
    STA tile_attribute

    LDA temp_y
    CLC
    ADC #$11
    TAY
    JSR _LoadSingleTileAttribute

    LDA temp_y
    ADC #$10
    TAY
    JSR _LoadSingleTileAttribute

    LDY temp_y
    INY
    JSR _LoadSingleTileAttribute

    LDY temp_y
    JSR _LoadSingleTileAttribute

    LDX temp_x
    LDY temp_y
    RTS

_RedrawLevelStep:
    INC screen_offset
    LDA screen_offset
    CMP #$3C
    BCC _RedrawBackgroundPart
    CMP #$4C
    BCC _RedrawAttributePart
    LDA #$01
    RTS
_RedrawBackgroundPart:
    JSR _LoadBackgroundHorizontalPart
    LDA #$00
    RTS
_RedrawAttributePart:
    JSR _LoadAttributeHorizontalPart
    LDA #$00
    RTS

;; level loading ;;
_InitializeVariables:
    LDA #$00
    STA boxes
    STA portals_a
    STA portals_b
    STA blockades
    STA blockade_removers
    STA trap_doors
    JSR _ResetTrapDoor
    JSR _ResetBlockade
    JSR _ResetBoxSwap
    RTS

_SaveStartingPointPosition:
    JSR _GetRealYPosition
    STA starting_position_y

    JSR _GetRealXPosition
    STA starting_position_x
    RTS

_SaveEndingPointPosition:
    JSR _GetRealYPosition
    STA ending_point_real_y

    JSR _GetRealXPosition
    STA ending_point_real_x
    RTS

_AddBox:
    STY temp_x
    STX temp_y

    LDX boxes
    LDA temp_y
    STA box_y, x

    LDA temp_x
    STA box_x, x

    INC boxes
    LDY temp_x
    LDX temp_y
    RTS

_AddPortalA:
    STY temp_x
    STX temp_y

    LDX portals_a
    LDA temp_y
    JSR _MultiplyAndShift
    STA portals_a_y, x

    LDA temp_x
    JSR _MultiplyAndShift
    STA portals_a_x, x

    INC portals_a
    LDY temp_x
    LDX temp_y
    RTS

_AddPortalB:
    STY temp_x
    STX temp_y

    LDX portals_b
    LDA temp_y
    JSR _MultiplyAndShift
    STA portals_b_y, x

    LDA temp_x
    JSR _MultiplyAndShift
    STA portals_b_x, x

    INC portals_b
    LDY temp_x
    LDX temp_y
    RTS

_AddBlockade:
    STY temp_x
    STX temp_y

    LDX blockades
    LDA temp_y
    STA blockades_y, x

    LDA temp_x
    STA blockades_x, x

    LDA #$01
    STA blockades_on, x

    INC blockades
    LDY temp_x
    LDX temp_y
    RTS

_AddBlockadeRemover:
    STY temp_x
    STX temp_y

    LDX blockade_removers
    LDA temp_x
    STA blockade_removers_x, x

    LDA temp_y
    STA blockade_removers_y, x

    INC blockade_removers
    LDY temp_x
    LDX temp_y
    RTS

_AddTrapDoor:
    STY temp_x
    STX temp_y

    LDX trap_doors
    LDA temp_x
    STA trap_doors_x, x

    LDA temp_y
    STA trap_doors_y, x

    LDA #$00
    STA trap_doors_on, x

    INC trap_doors
    LDY temp_x
    LDX temp_y
    RTS

;; portals ;;
_FindPortalAID:
    LDX #$00
_FindPortalAIDStep:
    LDA portals_a_x, x
    CMP position_x
    BNE _FindPortalAIDIncrement
    LDA portals_a_y, x
    CMP position_y
    BNE _FindPortalAIDIncrement
    RTS
_FindPortalAIDIncrement
    INX
    CPX portals_a
    BNE _FindPortalAIDStep
    RTS

_FindPortalBID:
    LDX #$00
_FindPortalBIDStep:
    LDA portals_b_x, x
    CMP position_x
    BNE _FindPortalBIDIncrement
    LDA portals_b_y, x
    CMP position_y
    BNE _FindPortalBIDIncrement
    RTS
_FindPortalBIDIncrement
    INX
    CPX portals_b
    BNE _FindPortalBIDStep
    RTS

;; animation ;;
_ReverseAnimationDirection:
    LDA animation_direction
    CMP #$01
    BEQ _SetNegativeAnimationDirection
    LDA #$01
    STA animation_direction
    RTS

_SetNegativeAnimationDirection:
    LDA #$FF
    STA animation_direction
    RTS

; u d l r
_GetOffset:
    LDX direction
    LDA movement_x, x
    STA offset_x

    LDA movement_y, x
    STA offset_y
    RTS

;; movement ;;
_AfterStep:
    JSR _CheckPosition
    DEC real_speed
    LDA real_speed
    CMP #$00
    RTS

;; speed subroutines ;;
_CalculateRealSpeed:
    LDA speed
    JSR _Divide
    ADC #$01
    STA real_speed
    RTS

_IncreaseSpeed:
    LDY speed
    CPY #MAX_SPEED
    BNE _IncreaseSpeedStep
    RTS
_IncreaseSpeedStep:
    INC speed
    RTS

_Stop:
    JSR _HideElectric
    LDA #$00
    STA grounded
    STA increase_counter
    STA direction
    STA speed
    LDA #$01
    STA real_speed
    RTS

;; collision routine ;;
_CheckPosition:
    LDA direction
    CMP #$03
    BCC _CheckY

    LDA direction
    CMP #$03
    BCS _CheckX
    RTS

_CheckY:
    LDA position_y
    AND #%00001111
    CMP #$08
    BEQ _CheckIfPositionIsFree
    RTS
_CheckX:
    LDA position_x
    AND #%00001111
    CMP #$08
    BEQ _CheckIfPositionIsFree
    RTS

_CheckIfPositionIsFree:
    JSR _GetPositionWithoutOffset

_PortalACheck:
    JSR _GetTile
    CMP #PORTAL_A
    BNE _PortalBCheck
_PortalATeleport:
    JSR _FindPortalAID
    JSR _Stop
    LDA portals_b_x, x
    STA position_x
    LDA portals_b_y, x
    STA position_y
    JMP _CheckIfNextPositionIsFree
_PortalBCheck:
    JSR _GetTile
    CMP #PORTAL_B
    BNE _ArrowUpCheck
_PortalBTeleport:
    JSR _FindPortalBID
    JSR _Stop
    LDA portals_a_x, x
    STA position_x
    LDA portals_a_y, x
    STA position_y
    JMP _CheckIfNextPositionIsFree

_ArrowUpCheck:
    JSR _GetTile
    CMP #ARROW_UP
    BNE _ArrowDownCheck
    LDX #UP
    STX direction
    JMP _CheckIfNextPositionIsFree

_ArrowDownCheck:
    JSR _GetTile
    CMP #ARROW_DOWN
    BNE _ArrowLeftCheck
    LDX #DOWN
    STX direction
    JMP _CheckIfNextPositionIsFree

_ArrowLeftCheck:
    JSR _GetTile
    CMP #ARROW_LEFT
    BNE _ArrowRightCheck
    LDX #LEFT
    STX direction
    JMP _CheckIfNextPositionIsFree

_ArrowRightCheck:
    JSR _GetTile
    CMP #ARROW_RIGHT
    BNE _ArrowVerticalCheck
    LDX #RIGHT
    STX direction
    JMP _CheckIfNextPositionIsFree

_ArrowVerticalCheck:
    JSR _GetTile
    CMP #ARROW_VERTICAL
    BNE _ArrowHorizontalCheck
    JSR _Stop
    JMP _CheckIfNextPositionIsFree

_ArrowHorizontalCheck:
    JSR _GetTile
    CMP #ARROW_HORIZONTAL
    BNE _TrapDoorCheck
    JSR _Stop
    JMP _CheckIfNextPositionIsFree

_TrapDoorCheck:
    JSR _GetTile
    CMP #TRAP_DOOR
    BNE _StopperCheck
    JSR _ActivateTrapDoor
    JMP _CheckIfNextPositionIsFree

_StopperCheck:
    JSR _GetTile
    CMP #STOPPER
    BNE _EndCheck
    JSR _Stop
    JSR _DrawStopper

_EndCheck:
    JSR _GetTile
    CMP #END
    BNE _CheckIfNextPositionIsFree
    LDA #$01
    STA next_level
    JSR _SaveScore
    JSR _NextLevel
    JSR _StartScreenMovement
    JMP _CheckIfNextPositionIsFree
_StartLevel:
    JSR _ResetPPU
    JSR InitializeSprites
    JSR _DisableNMI
    JSR _Stop
    JSR _ResetMoveCounter
    JSR _LoadLevel
    JSR _EnableNMI
    JMP InitializePosition

_CheckIfNextPositionIsFree:
    JSR _GetPositionWithOffset
    JSR _TrapDoorCheckLoop
    JSR _BlockadeCheckLoop
    JSR _BoxCheckLoop
    LDA index
    JSR _CheckCollision
    CMP #$01
    BNE _CheckIfPositionIsFreeEnd
    JSR _Stop

_CheckIfPositionIsFreeEnd:
    RTS

;; trap door logic, y - index ;;
_TrapDoorCheckLoop:
    LDA #$00
    JSR _TrapDoorCheckIfOnPosition
    CMP #$01
    BNE _TrapDoorCheckLoopEnd
_IsTrapDoorActive:
    LDA trap_doors_on, y
    CMP #$01
    BNE _TrapDoorCheckLoopEnd
    JSR _Stop
_TrapDoorCheckLoopEnd:
    RTS

_TrapDoorCheckIfOnPosition:
    LDY trap_doors
    CPY #$00
    BNE _TrapDoorCheckStep
    RTS
_TrapDoorCheckStep:
    DEY
    JSR _IsTrapDoorOnIndex
    CMP #$01
    BNE _TrapDoorCheckIncrement
    RTS
_TrapDoorCheckIncrement
    CPY #$00
    BNE _TrapDoorCheckStep
    RTS

;; y as argument ;;
_IsTrapDoorOnIndex:
    LDA index
    AND #%00001111
    CMP trap_doors_x, y
    BEQ _IsTrapDoorOnYIndex
    JMP _IsTrapDoorOnIndexReturnFalse
_IsTrapDoorOnYIndex:
    LDA index
    JSR _Divide
    CMP trap_doors_y, y
    BEQ _IsTrapDoorOnIndexReturnTrue
    JMP _IsTrapDoorOnIndexReturnFalse
_IsTrapDoorOnIndexReturnTrue:
    LDA #$01
    RTS
_IsTrapDoorOnIndexReturnFalse:
    LDA #$00
    RTS

_ActivateTrapDoor:
    JSR _TrapDoorCheckLoop
    LDX index
    STX trap_door
    JSR _CalculateBoxX
    STA trap_door_x

    JSR _CalculateBoxY
    STA trap_door_y

    LDA #$01
    STA trap_doors_on, y
    RTS

_RemoveBlockade:
    LDA blockade_x
    STA ppu_shift
    LDX blockade_y
    JSR _PreparePPU

    LDA #TILE_NONE
    STA target_tile

    JSR _DrawSingleTile
    LDA blockade_y
    JSR _ShiftPPU
    JSR _DrawSingleTile
    RTS

_DrawTrapDoor:
    LDA trap_door_x
    STA ppu_shift
    LDX trap_door_y
    JSR _PreparePPU

    LDA #TILE_TRAP_DOOR_ACTIVE
    STA target_tile

    JSR _DrawSingleTile
    LDA trap_door_y
    JSR _ShiftPPU
    JSR _DrawSingleTile
    RTS

;; blockade logic, y - index ;;
_BlockadeCheckLoop:
    LDY blockades
    CPY #$00
    BNE _BlockadeCheckStep
    RTS
_BlockadeCheckStep:
    DEY
    JSR _IsBlockadeOnIndex
    CMP #$01
    BNE _BlockadeCheckIncrement
    JSR _Stop
    RTS
_BlockadeCheckIncrement
    CPY #$00
    BNE _BlockadeCheckStep
    RTS

_CheckIfBoxUnlocksBlockade:
    LDA box_animation_x
    JSR _Divide
    STA temp_x

    LDA box_animation_y
    JSR _Divide
    STA temp_y

    JSR _BlockadeRemoverCheckLoop
    CMP #$00
    BNE _UnlockBlockade
    RTS
_UnlockBlockade:
    LDA #$00
    STA blockades_on, y
    JSR _SaveBlockadeToRemove
    RTS

_SaveBlockadeToRemove:
    LDA blockades_y, y
    JSR _Multiply
    CLC
    ADC blockades_x, y
    STA blockade
    TAX

    JSR _CalculateBoxX
    STA blockade_x

    JSR _CalculateBoxY
    STA blockade_y
    RTS

_BlockadeRemoverCheckLoop:
    LDY blockade_removers
    CPY #$00
    BNE _BlockadeRemoverCheckStep
    RTS
_BlockadeRemoverCheckStep:
    DEY
    JSR _IsBlockadeRemoverOnPosition
    CMP #$01
    BNE _BlockadeRemoverCheckIncrement
    RTS
_BlockadeRemoverCheckIncrement
    CPY #$00
    BNE _BlockadeRemoverCheckStep
    RTS

_IsBlockadeRemoverOnPosition:
    LDA blockade_removers_x, y
    CMP temp_x
    BEQ _IsBlockadeRemoverOnY
    JMP _IsBlockadeRemoverReturnFalse
_IsBlockadeRemoverOnY:
    LDA blockade_removers_y, y
    CMP temp_y
    BEQ _IsBlockadeRemoverReturnTrue
    JMP _IsBlockadeOnIndexReturnFalse
_IsBlockadeRemoverReturnTrue:
    LDA #$01
    RTS
_IsBlockadeRemoverReturnFalse:
    LDA #$00
    RTS

;; box logic, y - index ;;
_BoxCheckLoop:
    LDY boxes
    CPY #$00
    BNE _BoxCheckLoopStep
    RTS
_BoxCheckLoopStep:
    DEY
    JSR _BoxCheck

    CPY #$00
    BNE _BoxCheckLoopStep
    RTS

_BoxCheck:
    STY temp_y
    JSR _IsBoxOnIndex
    CMP #$01
    BEQ _BoxAction
    RTS
_BoxAction:
    LDX direction
    LDA movement, x
    STA offset
    JSR _Stop

    LDA index
    CLC
    ADC offset
    STA target

    JSR _CheckBoxCollision
    CMP #$00
    BEQ _MoveBox
    RTS
_MoveBox:
    LDY temp_y
    LDA target
    AND #%00001111
    STA box_x, y

    LDA target
    JSR _Divide
    STA box_y, y

_MarkBoxesForSwap:
    LDX index
    STX source_box
    JSR _CalculateBoxX
    STA source_box_x

    JSR _CalculateBoxY
    STA source_box_y

    JSR _CalculateBoxOffset
    STA source_box_offset

    LDY #%11111100
    JSR _CalculateBoxZ
    STA source_box_z

    LDX target
    STX target_box
    JSR _CalculateBoxX
    STA target_box_x

    JSR _CalculateBoxY
    STA target_box_y

    JSR _CalculateBoxOffset
    STA target_box_offset

    LDY #%00000011
    JSR _CalculateBoxZ
    STA target_box_z

    LDA target
    SEC
    SBC index
    STA box_direction

    LDA index
    AND #%00001111
    JSR _Multiply
    STA box_animation_x

    LDA index
    AND #%11110000
    STA box_animation_y

_BoxCheckEnd:
    RTS

_RemoveSourceBox:
    LDA source_box_x
    STA ppu_shift
    LDX source_box_y
    JSR _PreparePPU

    LDA #TILE_EMPTY
    STA target_tile

    JSR _DrawSingleTile
    LDA source_box_y
    JSR _ShiftPPU
    JSR _DrawSingleTile
_GetSourceBoxAttribute:
    LDA #$23
    STA ppu_shift
    LDX source_box_offset
    JSR _PreparePPU
    LDA PPUDATA
    LDA PPUDATA
    STA target_tile
_DrawSourceBoxAttribute:
    JSR _PreparePPU
    LDA target_tile
    AND source_box_z
    STA PPUDATA
_ResetSourceBox:
    LDA #$FF
    STA source_box
    RTS

_DrawTargetBox:
    LDA target_box_x
    STA ppu_shift
    LDX target_box_y
    JSR _PreparePPU

    LDA #TILE_BOX
    STA target_tile

    JSR _DrawSingleTile
    LDA target_box_y
    JSR _ShiftPPU
    JSR _DrawSingleTile
_GetTargetBoxAttribute:
    LDA #$23
    STA ppu_shift
    LDX target_box_offset
    JSR _PreparePPU
    LDA PPUDATA
    LDA PPUDATA
    STA target_tile
_DrawTargetBoxAttribute:
    JSR _PreparePPU
    LDA target_tile
    ORA target_box_z
    STA PPUDATA
_ResetTargetBox:
    LDA #$FF
    STA target_box
    RTS

_CalculateBoxX:
    TXA
    STA target_temp
    JSR _Divide
    LSR a
    LSR a
    CLC
    ADC #$20
    STA target_temp
    RTS

_CalculateBoxY:
    TXA
    AND #%00001111
    ASL a
    STA target_temp

    TXA
    AND #%00110000
    ASL a
    ASL a
    CLC
    ADC target_temp
    STA target_temp
    RTS

_CalculateBoxOffset:
    TXA
    AND #%00001110
    LSR a
    CLC
    ADC #$C0
    STA target_temp

    TXA
    AND #%11100000
    LSR a
    LSR a
    CLC
    ADC target_temp
    STA target_temp
    RTS

_CalculateBoxZ:
    TXA
    AND #%00000001
    STA target_temp

    TXA
    AND #%00010000
    LSR a
    LSR a
    LSR a
    CLC
    ADC target_temp
    STA target_temp

    TAX
    CPX #$00
    BNE _PrepareTileAttribute
    STY target_temp
    LDA target_temp
    RTS

_BoxAnimationMovement:
_BoxAnimationCheckUp:
    LDA box_direction
    CMP #$F0
    BNE _BoxAnimationCheckDown
_BoxAnimationMoveUp:
    LDA box_animation_y
    SEC
    SBC #BOX_SPEED
    STA box_animation_y
    RTS
_BoxAnimationCheckDown:
    LDA box_direction
    CMP #$10
    BNE _BoxAnimationCheckLeft
_BoxAnimationMoveDown:
    LDA box_animation_y
    CLC
    ADC #BOX_SPEED
    STA box_animation_y
    RTS
_BoxAnimationCheckLeft:
    LDA box_direction
    CMP #$FF
    BNE _BoxAnimationMoveRight
_BoxAnimationMoveLeft:
    LDA box_animation_x
    SEC
    SBC #BOX_SPEED
    STA box_animation_x
    RTS
_BoxAnimationMoveRight:
    LDA box_animation_x
    CLC
    ADC #BOX_SPEED
    STA box_animation_x
    RTS

_DrawBox:
    LDA box_animation_x
    STA SPR_ADDRESS_BOX + $03
    STA SPR_ADDRESS_BOX + $0B
    CLC
    ADC #$08
    STA SPR_ADDRESS_BOX + $07
    STA SPR_ADDRESS_BOX + $0F

    LDA box_animation_y
    SBC #$00
    STA SPR_ADDRESS_BOX + $00
    STA SPR_ADDRESS_BOX + $04
    CLC
    ADC #$08
    STA SPR_ADDRESS_BOX + $08
    STA SPR_ADDRESS_BOX + $0C
    RTS

_HideBoxSprite:
    LDA #$F0
    STA SPR_ADDRESS_BOX + $00
    STA SPR_ADDRESS_BOX + $04
    STA SPR_ADDRESS_BOX + $08
    STA SPR_ADDRESS_BOX + $0C
    RTS

_PrepareTileAttribute:
    TYA
_PrepareTileAttributeStep:
    ASL a
    ADC #$00
    ASL a
    ADC #$00
    DEX
    BNE _PrepareTileAttributeStep
    STA target_temp
    RTS

_ResetTrapDoor:
    LDA #$FF
    STA trap_door
    RTS

_ResetBlockade:
    LDA #$00
    STA blockade
    RTS

_ResetBoxSwap:
    LDA #$FF
    STA source_box
    STA target_box
    RTS

;; y as argument ;;
_IsBlockadeOnIndex:
    LDA index
    AND #%00001111
    CMP blockades_x, y
    BEQ _IsBlockadeOnYIndex
    JMP _IsBlockadeOnIndexReturnFalse
_IsBlockadeOnYIndex:
    LDA index
    JSR _Divide
    CMP blockades_y, y
    BEQ _IsBlockadeActive
    JMP _IsBlockadeOnIndexReturnFalse
_IsBlockadeActive:
    LDA blockades_on, y
    RTS
_IsBlockadeOnIndexReturnFalse:
    LDA #$00
    RTS

_IsBoxOnIndex:
    LDA index
    AND #%00001111
    CMP box_x, y
    BEQ _IsBoxOnYIndex
    JMP _IsBoxOnIndexReturnFalse
_IsBoxOnYIndex:
    LDA index
    JSR _Divide
    CMP box_y, y
    BEQ _IsBoxOnIndexReturnTrue
    JMP _IsBoxOnIndexReturnFalse
_IsBoxOnIndexReturnTrue:
    LDA #$01
    RTS
_IsBoxOnIndexReturnFalse:
    LDA #$00
    RTS

;; collision logic ;;
_GetTile:
    LDY index
    LDA [level_lo], y
    RTS

_CheckDirectionalArrows:
    LDA index
    JSR _GetTile
    CMP #ARROW_VERTICAL
    BEQ _CheckVerticalArrow
    CMP #ARROW_HORIZONTAL
    BEQ _CheckHorizontalArrow
    LDA #$00
    RTS
_CheckVerticalArrow:
    LDA direction
    SEC
    SBC #$01
    AND #%00000110
    RTS
_CheckHorizontalArrow:
    LDA direction
    SEC
    SBC #$01
    AND #%00000010
    EOR #%00000010
    RTS

_CheckCollision:
    JSR _GetTile
    TAY
    LDA solid, y
    RTS

_CheckBoxCollision:
    JSR _SaveIndex
    LDA target
    STA index
    JSR _CheckBoxRoutine
    JSR _RestoreIndex
    RTS

_CheckBoxRoutine:
    JSR _GetTile
    TAY
    LDA box_solid, y
_CheckBoxes:
    BEQ _CheckIfBoxIsBlocking
_CheckBlockades:
    BEQ _CheckIfBlockIsBlocking
    RTS
_CheckIfBoxIsBlocking
    LDY boxes
    LDA #$00
_CheckIfBoxIsBlockingStep:
    DEY
    JSR _IsBoxOnIndex
    CMP #$01
    BEQ _CheckIfBoxIsBlockingTrue

    CPY #$00
    BNE _CheckIfBoxIsBlockingStep
_CheckIfBoxIsBlockingFalse:
    LDA #$00
    JMP _CheckBlockades
_CheckIfBoxIsBlockingTrue:
    LDA #$01
    JMP _CheckBlockades

_CheckIfBlockIsBlocking:
    LDY blockades
    CPY #$00
    BEQ _CheckIfBlockIsBlockingFalse
    LDA #$00
_CheckIfBlockIsBlockingStep:
    DEY
    JSR _IsBlockadeOnIndex
    CMP #$01
    BEQ _CheckIfBlockIsBlockingTrue

    CPY #$00
    BNE _CheckIfBlockIsBlockingStep
_CheckIfBlockIsBlockingFalse:
    LDA #$00
    RTS
_CheckIfBlockIsBlockingTrue:
    LDA #$01
    RTS

_SaveIndex:
    LDA index
    STA index_temp
    RTS

_RestoreIndex:
    LDX index_temp
    STX index
    RTS

_CheckMovement:
    LDX grounded
    CPX #$00
    BEQ _CheckObstacle
    RTS
_CheckObstacle:
    STY direction
    JSR _GetPositionWithoutOffset
    JSR _CheckDirectionalArrows
    CMP #$00
    BNE _Ground
_CollisionCheck:
    JSR _GetPositionWithOffset
    JSR _CheckCollision
    CMP #$01
    BEQ _Ground
_CheckBoxObstacle:
    TYA
    JSR _SetDirection
    JSR _TrapDoorCheckLoop
    JSR _BlockadeCheckLoop
    JSR _BoxCheckLoop
    RTS
_Ground:
    JSR _Stop
    RTS

_GetPositionWithOffset:
    LDX #$01
    STX check_x_offset
    LDX #$01
    STX check_y_offset
    JSR _GetPosition
    RTS

_GetPositionWithoutOffset:
    LDX #$00
    STX check_x_offset
    LDX #$00
    STX check_y_offset
    JSR _GetPosition
    RTS

_GetPosition:
    JSR _GetOffset
_GetX:
    LDA position_x
    JSR _Divide
    LDX check_x_offset
    CPX #$01
    BNE _SaveX
_AddOffsetX:
    CLC
    ADC offset_x
    AND #%00001111
_SaveX:
    STA px
_GetY:
    LDA position_y
    JSR _Divide
    LDX check_y_offset
    CPX #$01
    BNE _SaveY
_AddOffsetY:
    CLC
    ADC offset_y
    AND #%00001111
_SaveY:
    JSR _Multiply
    STA py
_LoadIndex:
    LDA py
    ADC px
    STA index
    RTS

_AssignDirection:
    LDA input
    AND #%00001111
    LDY #$04
_AssignDirectionStep:
    TAX
    AND #%00000001
    BNE _AssignDirectionReturn
    TXA
    LSR a
    DEY
    CPY #$00
    BNE _AssignDirectionStep
_AssignDirectionReturn:
    RTS

_SetDirection:
    JSR _HideStopper
    LDY #$01
    STY grounded
    STY increase_counter
    STY draw_counter
    RTS

;; move counter ;;
_ResetMoveCounter:
    LDA #$00
    STA move_counter_limit
    LDX #$00
_ResetMoveCounterStep:
    STA move_counter, x
    INX
    CPX #COUNTER_DIGITS
    BNE _ResetMoveCounterStep
    RTS

_IncreaseMoveCounter:
    LDX #COUNTER_LAST_DIGIT
_IncreaseMoveCounterCheck:
    LDA move_counter_limit
    CMP #$00
    BEQ _IncreaseMoveCounterStep
    RTS
_IncreaseMoveCounterStep:
    INC move_counter, x
    LDA move_counter, x
    CMP #TEN
    BEQ _IncreaseMoveCounterCarry
    RTS
_IncreaseMoveCounterCarry:
    LDA #$00
    STA move_counter, x
    DEX
    JSR _CheckMoveCounterLimit
    JMP _IncreaseMoveCounterCheck

_CheckMoveCounterLimit:
    CPX #$00
    BEQ _CheckMoveCounterFirstDigit
    RTS
_CheckMoveCounterFirstDigit:
    LDA move_counter
    CMP #LAST_DIGIT
    BEQ _CheckMoveCounterLimitTrue
    RTS
_CheckMoveCounterLimitTrue
    LDA #$01
    STA move_counter_limit

    LDA #LAST_DIGIT
    LDY #COUNTER_LAST_DIGIT
_SetMoveCounterMaxValue
    STA move_counter, y
    DEY
    BNE _SetMoveCounterMaxValue
    RTS

_PrepareMoveCounter:
    LDA #NMI_HORIZONTAL
    STA PPUCTRL
    LDA #$23
    LDX #$80
    LDY #$00
    STA ppu_shift
    JSR _PreparePPU
    RTS

_DrawMoveCounter:
    LDA #$18
    STA ppu_shift
    LDX #$00
_DrawMoveCounterStep:
    DEC ppu_shift
    LDA move_counter, x
    STA PPUDATA
    INX
    CPX #COUNTER_DIGITS
    BNE _DrawMoveCounterStep
    RTS

_ShiftHorizontally:
    LDA screen_x
    AND #%00000001
    BEQ _AfterShift

    LDA current_tile
    CLC
    ADC #$01
    STA current_tile
    RTS
_ShiftVertically:
    TXA
    AND #%00000001
    BEQ _AfterShift

    LDA current_tile
    CLC
    ADC #$02
    STA current_tile
_AfterShift:
    RTS

_CalculateTextRange:
    LDA speed
    LSR a
    AND #%00000011
    TAX
    LDY text_ranges, x
    STY position_x
    INX
    LDY text_ranges, x
    STY position_y
    RTS

_CalculateLevelSetOffset:
    LDY level_set_counter
    STY temp_y
    LDY #$00
    STY level_set_counter
    JSR _CalculateAbsoluteLevel
    STA offset
    LDY temp_y
    STY level_set_counter
    RTS

_CalculateAbsoluteLevel:
    LDA #$00
    LDY level_set
    BEQ _CalculateAbsoluteLevelEnd
    LDY #$00
_CalculateAbsoluteLevelStep:
    CLC
    ADC level_set_count, y
    INY
    CPY level_set
    BNE _CalculateAbsoluteLevelStep
_CalculateAbsoluteLevelEnd:
    CLC
    ADC level_set_counter
    RTS

_EnableSound:
    LDA #$80
    LDX #LOW(magnetizer_music_data)
    LDY #HIGH(magnetizer_music_data)
    JSR FamiToneInit
	RTS

_PauseMusic:
    LDA #$01
    JSR FamiToneMusicPause
    RTS

_PlaySound:
    LDA #$00
    LDX #LOW(magnetizer_music_data)
    LDY #HIGH(magnetizer_music_data)
    JSR FamiToneMusicPlay
    RTS

_Snap:
    AND #%11110000
    RTS

_Multiply:
    ASL a
    ASL a
    ASL a
    ASL a
    RTS

_Divide:
    LSR a
    LSR a
    LSR a
    LSR a
    RTS

_TransformA:
    JSR _Divide
    STA offset_x

    LDA screen_offset
    LSR a
    ASL a
    ASL a
    ASL a
    AND #%00111111
    CLC
    ADC offset_x
    RTS

_TransformB:
    JSR _Divide
    STA offset_x

    LDA screen_offset
    LSR a
    JSR _Multiply
    AND #%01111111
    CLC
    ADC offset_x

    ASL a
    RTS

_MultiplyAndShift:
    JSR _Multiply
    CLC
    ADC #$08
    RTS

_GetRealXPosition:
    TYA
    JSR _Multiply
    RTS

_GetRealYPosition:
    TXA
    JSR _Multiply
    RTS

_CalculateAndSetCursorPosition:
    LDA level_set_counter
    ASL a
    ASL a
    ASL a
    CLC
    ADC #$78
    STA SPR_ADDRESS_CURSOR
    RTS

_CalculateArrowOffset:
    LDA speed
    LSR a
    LSR a
    AND #%00000111
    RTS

_HideCursor:
    LDA #$F0
    STA SPR_ADDRESS_CURSOR
    RTS
