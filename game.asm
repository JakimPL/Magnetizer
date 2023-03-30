GameLogic:
    LDA goto_menu
    BNE JumpGoToMenu

    LDX level_loading
    BEQ CheckScreenMovement
    JSR DrawNextLevel
    JMP GameLogicEnd
CheckScreenMovement:
    LDX screen_movement
    BEQ CheckBlockadeToDraw
    JSR DrawTransition
    JMP GameLogicEnd

JumpGoToMenu:
    JMP GoToMenu

CheckBlockadeToDraw:
    LDA blockade
    BEQ CheckTrapDoorToDraw
RemoveBlockade:
    JSR _RemoveBlockade
    JSR _ResetBlockade

CheckTrapDoorToDraw:
    LDA trap_door
    CMP #$FF
    BEQ CheckBoxesToDraw
DrawTrapDoor:
    JSR _DrawTrapDoor

CheckBoxesToDraw
    LDA box_animation
    CMP #$00
    BNE RemoveSourceBox

    LDA box_direction
    CMP #$00
    BNE BoxAnimationMovement

    LDA target_box
    CMP #$FF
    BNE JumpToDrawTargetBox
    JMP DrawMoveCounter
JumpToDrawTargetBox:
    JMP DrawTargetBox

RemoveSourceBox:
    JSR _RemoveSourceBox

BoxAnimationMovement:
    JSR _BoxAnimationMovement
    LDA #$01
    STA box_animation
DrawBox:
    JSR _DrawBox
    JSR _ResetTrapDoor

CheckIfBoxAnimationEnds:
    LDA box_animation_x
    AND #%00001111
    BNE DrawMoveCounter
    LDA box_animation_y
    AND #%00001111
    BNE DrawMoveCounter
    LDA #$00
    STA box_direction
    STA box_animation

HideBoxSprite:
    JSR _HideBoxSprite

CheckIfBoxUnlocksBlockade:
    JSR _CheckIfBoxUnlocksBlockade

DrawTargetBox
    JSR _DrawTargetBox

DrawMoveCounter:
    LDA draw_counter
    BEQ GameResetPPU
    JSR _PrepareMoveCounter
    JSR _DrawMoveCounter
    JSR _ChangeCounterAttributes
    LDA #$00
    STA draw_counter

GameResetPPU:
    JSR _ResetPPU

UpdatePosition:
    LDA position_x
    SEC
    SBC #POINT_X_OFFSET
    STA $0203
    STA $020B

    CLC
    ADC #$08
    STA $0207
    STA $020F

    LDA position_y
    SEC
    SBC #POINT_Y_OFFSET
    STA $0200
    STA $0204

    CLC
    ADC #$08
    STA $0208
    STA $020C

;; change sprite ;;
    LDA direction
    CMP #$00
    BNE UpdateSprite
    JMP UpdateAnimation

UpdateSprite:
    LDA direction
    SBC #$01
    ASL a
    ASL a
    STA metasprite_offset

    LDA #LOW(magnetizer_metasprite)
    CLC
    ADC metasprite_offset
    STA metasprite_low
    LDA #HIGH(magnetizer_metasprite)
    STA metasprite_high

    LDX #$00
    LDY #$00
UpdateSpriteStep:
    LDA [metasprite_low], y
    AND #%00000011
    STA $0201, x

    LDA [metasprite_low], y
    AND #%11000000
    CLC
    ADC #$01
    STA $0202, x

    INX
    INX
    INX
    INX

    INY
    CPY #$04
    BNE UpdateSpriteStep

UpdateAnimation:
    LDA animation_cycle
    CLC
    ADC animation_direction
    STA animation_cycle

    CMP #ANIMATION_LENGTH
    BEQ ReverseAnimationDirection

    CMP #$00
    BEQ ReverseAnimationDirection
    JMP DrawAnimation

ReverseAnimationDirection:
    JSR _ReverseAnimationDirection

DrawAnimation:
    JSR _UpdateElectric
    JSR _UpdateStopper

    LDA ending_point_real_x
    STA SPR_ADDRESS_END + $03
    STA SPR_ADDRESS_END + $0B
    CLC
    ADC #$08
    STA SPR_ADDRESS_END + $07
    STA SPR_ADDRESS_END + $0F

    LDA ending_point_real_y
    SBC #$00
    STA SPR_ADDRESS_END + $00
    STA SPR_ADDRESS_END + $04
    CLC
    ADC #$08
    STA SPR_ADDRESS_END + $08
    STA SPR_ADDRESS_END + $0C

    LDA animation_cycle
    CLC
    JSR _Divide
    ADC #$03
    STA SPR_ADDRESS_START + $01
    STA SPR_ADDRESS_START + $05
    STA SPR_ADDRESS_START + $09
    STA SPR_ADDRESS_START + $0D
    STA SPR_ADDRESS_END + $01
    STA SPR_ADDRESS_END + $05
    STA SPR_ADDRESS_END + $09
    STA SPR_ADDRESS_END + $0D

LatchController:
    JSR _LatchController

PreRead:
    LDY #$00
    STA increase_counter
    LDA box_direction
    CMP #$00
    BEQ ReadController
    JMP IncrementCounterCheck

ReadController:
    JSR _ReadController
CheckButton:
    LDA input
    CMP #$80
    BEQ EndLevel
    CMP #$40
    BEQ RestartLevel
    CMP #$20
    BEQ PrepareGoToMenu
    CMP #$10
    BEQ JumpToMovement

    JSR _AssignDirection
    CPY #$00
    BEQ JumpToMovement
    JSR _CheckMovement
    JMP Movement

PrepareGoToMenu:
    LDA #01
    STA goto_menu
    JSR _PauseMusic

JumpToMovement:
    JMP Movement
GoToMenu:
    LDA #$00
    STA game
    STA goto_menu
    LDA #$01
    STA screen_movement
    JSR _ClearBasicSprites
    JSR _ResetPPU
    LDX #$00
    STX PPUMASK
    JSR _DisableNMI
    JSR InitializeMenu
    JMP GoToMenuVBlank
RestartLevel:
    JSR _StartScreenRedraw
    JMP GameLogicEnd
EndLevel:
    LDA #$01
    STA next_level
    JSR _NextLevel
EndLevelReset:
    JSR _ResetMoveCounter
    JSR _StartScreenMovement

Movement:
    JSR _HideElectric
    LDA grounded
    CMP #$01
    BNE Move
    JSR _DrawElectric
CalculateSpeed:
    JSR _CalculateRealSpeed
    JSR _IncreaseSpeed
Move:
    LDX direction
    CPX #UP
    BEQ MoveUp
    CPX #DOWN
    BEQ MoveDown
    CPX #LEFT
    BEQ MoveLeft
    CPX #RIGHT
    BEQ MoveRight
    JMP IncrementCounterCheck

MoveUp:
    DEC position_y
    JSR _AfterStep
    BNE Move
    JMP IncrementCounterCheck

MoveDown:
    INC position_y
    JSR _AfterStep
    BNE Move
    JMP IncrementCounterCheck

MoveLeft:
    DEC position_x
    JSR _AfterStep
    BNE Move
    JMP IncrementCounterCheck

MoveRight:
    INC position_x
    JSR _AfterStep
    BNE Move
    JMP IncrementCounterCheck

IncrementCounterCheck:
    LDA increase_counter
    CMP #$01
    BNE GameLogicEnd
    JSR _IncreaseMoveCounter
    LDA #$00
    STA increase_counter

GameLogicEnd:
    INC screen_x
    RTS

GoToMenuVBlank:
    BIT PPUSTATUS
    BPL GoToMenuVBlank
    LDA #$20
    STA ppu_shift
    JSR _LoadBackgroundAndAttribute
    JSR _DrawPartialMenu
    JSR _ResetPPU
    JSR _EnableNMI

GoToMenuVBlankLoop:
    JMP GoToMenuVBlankLoop

VBlank:
    BIT PPUSTATUS
    BPL VBlank

AfterVBLank:
    JSR _LoadPalettes
    JSR _LoadBackgroundsAndAttributes
    JSR _EnableNMI

InitializePosition:
    LDA starting_position_x
    SEC
    SBC #$00
    STA SPR_ADDRESS_START + $03
    STA SPR_ADDRESS_START + $0B
    CLC
    ADC #$08
    STA SPR_ADDRESS_START + $07
    STA SPR_ADDRESS_START + $0F
    STA position_x

    LDA starting_position_y
    SEC
    SBC #$00
    STA SPR_ADDRESS_START + $00
    STA SPR_ADDRESS_START + $04
    CLC
    ADC #$08
    STA SPR_ADDRESS_START + $08
    STA SPR_ADDRESS_START + $0C
    STA position_y

InitializeAnimation:
    LDA #$01
    STA animation_direction
    LDA #$00
    STA animation_cycle

VBlankLoop:
    JMP VBlankLoop

;; setting pointers ;;
InitializeGame:
    JSR _Initialize

SetLevelPointer:
    LDA #LOW(levels)
    STA level_lo
    LDA #HIGH(levels)
    STA level_hi

SetBoxSwap:
    JSR _ResetBoxSwap

SetTrapDoor:
    JSR _ResetTrapDoor
    RTS

InitializeSprites:
LoadSprites:
    LDX #$00
LoadSpritesLoop:
    LDA sprites, x
    STA $0200, x
    INX
    CPX #$30
    BNE LoadSpritesLoop

LoadBoxSprites:
    LDA #$08
    STA SPR_ADDRESS_BOX + $01
    STA SPR_ADDRESS_BOX + $05
    STA SPR_ADDRESS_BOX + $09
    STA SPR_ADDRESS_BOX + $0D

    LDA #$17
    STA SPR_ADDRESS_BOX + $02
    LDA #$57
    STA SPR_ADDRESS_BOX + $06
    LDA #$97
    STA SPR_ADDRESS_BOX + $0A
    LDA #$D7
    STA SPR_ADDRESS_BOX + $0E

    LDA #$F0
    STA SPR_ADDRESS_BOX + $00
    STA SPR_ADDRESS_BOX + $04
    STA SPR_ADDRESS_BOX + $08
    STA SPR_ADDRESS_BOX + $0C

LoadBlockadeSprites:
    LDY #$00
LoadBlockadeSpritesStep:
    TYA
    JSR _Multiply
    TAX

    LDA #$09
    STA SPR_ADDRESS_BLOCKADE + $01, x
    STA SPR_ADDRESS_BLOCKADE + $05, x
    STA SPR_ADDRESS_BLOCKADE + $09, x
    STA SPR_ADDRESS_BLOCKADE + $0D, x

    LDA #$14
    STA SPR_ADDRESS_BLOCKADE + $02, x
    LDA #$54
    STA SPR_ADDRESS_BLOCKADE + $06, x
    LDA #$94
    STA SPR_ADDRESS_BLOCKADE + $0A, x
    LDA #$D4
    STA SPR_ADDRESS_BLOCKADE + $0E, x

    INY
    CPY #$08
    BNE LoadBlockadeSpritesStep
    RTS

DrawTransition:
    LDX screen_offset
    CPX #$80
    BNE DrawBackgroundPart
TransitionEndLevel:
    LDX #$24
    STX ppu_address
    LDX #$01
    STX level_loading
    LDX #$00
    STX screen_movement
    STX screen_offset
    INC screen_mode
    LDA screen_mode
    AND #%00000001
    STA screen_mode
    JMP _StartLevel
DrawBackgroundPart:
    JSR _SetLevelPointer

    LDA screen_offset
    LSR a
    LSR a
    STA screen_x

    LDA screen_offset
    AND #%00000001
    BEQ DrawAttributesPart
    JSR _LoadBackgroundVerticalPart
    JMP ScreenIncrement
DrawAttributesPart:
    JSR _LoadAttributeVerticalPart
ScreenIncrement:
    INC screen_offset
    INC screen_x
    INC screen_x
    LDA screen_x
    CMP #$20
    BCC DrawMovingScreen
    LDA #$00
    STA screen_x
DrawMovingScreen:
    LDA #$20
    STA ppu_shift
    JSR _ResetPPU
Scrolling:
    LDA #$00
    STA PPUSCROLL
    LDA screen_offset
    CLC
    ADC #$01
    CMP #$80
    BCC Scroll
    LDA #$80
Scroll:
    ASL a
    STA PPUSCROLL
    RTS

DrawNextLevel:
    LDA ppu_address
    CMP #$20
    BNE SetNextLevelPointer
    JSR _SetLevelPointer
    JMP DrawNextLevelIncrement
SetNextLevelPointer:
    JSR _SetNextLevelPointer
DrawNextLevelIncrement:
    JSR _RedrawLevelStep
    BNE DrawNextLevelEnd
    JMP DrawNextLevelFinish
DrawNextLevelEnd:
    LDA #$00
    STA level_loading
    STA screen_offset
    JSR _LoadPalettes
    LDA ppu_address
    CMP #$20
    BNE DrawNextLevelFinish
    JMP _StartLevel
DrawNextLevelFinish:
    JSR _ResetPPU
    RTS
