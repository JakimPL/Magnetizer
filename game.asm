GameLogic:
    LDX screen_movement
    BEQ CheckTrapDoor

DrawBackgroundPart:
    INC level_hi
    JSR _SetLevelPointer
    DEC level_hi

    LDA #%10010100   ; enable NMI, sprites from Pattern Table 1
    STA PPUCTRL
    JSR _LoadBackgroundPart

    INC screen_offset
MoveScreen:
    LDA #$20
    STA ppu_shift
    LDX screen_offset
    JSR _PreparePPU

    LDX screen_offset
    CPX #$20
    BNE JumpToLogicEnd
EndLevel:
    LDX #$00
    STX screen_movement
    STX screen_offset
    INC screen_mode
    LDA screen_mode
    AND #%00000001
    STA screen_mode
    JMP _StartNextLevel
JumpToLogicEnd:
    JMP GameLogicEnd

CheckTrapDoor:
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
    JMP PrepareMoveCounter
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
    BNE PrepareMoveCounter
    LDA box_animation_y
    AND #%00001111
    BNE PrepareMoveCounter
    LDA #$00
    STA box_direction
    STA box_animation

HideBoxSprite:
    JSR _HideBoxSprite

CheckIfBoxUnlocksBlockade:
    JSR _CheckIfBoxUnlocksBlockade

DrawTargetBox
    JSR _DrawTargetBox

PrepareMoveCounter:
    LDA #%10010000
    STA PPUCTRL
    LDA #$23
    LDX #$80
    LDY #$00
    STA ppu_shift
    JSR _PreparePPU

DrawMoveCounter:
    LDA #$18
    STA ppu_shift
    JSR _DrawMoveCounter

ChangeCounterAttributes:
    LDA #$23
    LDX #$F8
    LDY #$E0
    STA ppu_shift
    JSR _PreparePPU
    LDA #$0F
    STA PPUDATA

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
    LDA ending_point_real_x
    STA $0223
    STA $022B
    CLC
    ADC #$08
    STA $0227
    STA $022F

    LDA ending_point_real_y
    SBC #$00
    STA $0220
    STA $0224
    CLC
    ADC #$08
    STA $0228
    STA $022C

    LDA animation_cycle
    CLC
    JSR _Divide
    ADC #$03
    STA $0211
    STA $0215
    STA $0219
    STA $021D
    STA $0221
    STA $0225
    STA $0229
    STA $022D

DrawBlockades:
    LDA draw_blockades
    CMP #$01
    BNE LatchController

    LDA blockades
    CMP #$00
    BEQ LatchController

    LDY #$00
    STY draw_blockades
DrawBlockade:
    TYA
    JSR _Multiply
    TAX

    LDA blockades_x, y
    JSR _Multiply
    STA $0243, x
    STA $024B, x
    CLC
    ADC #$08
    STA $0247, x
    STA $024F, x

    LDA blockades_on, y
    CMP #$00
    BNE DrawBlockadeLoadYPosition
    LDA #$F0
    JMP DrawBlockadeSetYPosition

DrawBlockadeLoadYPosition:
    LDA blockades_y, y
    JSR _Multiply
    SEC
    SBC #$01

DrawBlockadeSetYPosition:
    STA $0240, x
    STA $0244, x
    CLC
    ADC #$08
    STA $0248, x
    STA $024C, x

DrawBlockadeIncrement:
    INY
    CPY blockades
    BNE DrawBlockade

    LDA #$01
    STA draw_blockades

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
    BEQ EndLevelReset
    CMP #$40
    BEQ RestartLevel
    CMP #$20
    BEQ GoToMenu
    CMP #$10
    BEQ JumpToMovement

    JSR _AssignDirection
    CPY #$00
    BEQ JumpToMovement
    JSR _CheckMovement
    JMP Movement

JumpToMovement:
    JMP Movement
GoToMenu:
    LDA #$00
    STA game
    JSR InitializeMenu
    JSR _PreparePPU
    LDX #$FF
    TXS          ; Set up stack
    INX          ; now X = 0
    STX PPUCTRL    ; disable NMI
    STX PPUMASK    ; disable rendering
    JMP GoToMenuVBlank
RestartLevel:
    DEC level_hi
    DEC level_set_counter
EndLevelReset:
    LDA #$00
    STA move_counter
    STA move_counter + 1
    STA move_counter + 2
    STA move_counter + 3
    JSR _StartScreenMovement

Movement:
    LDA grounded
    CMP #$01
    BNE Move
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
    RTS

GoToMenuVBlank:
    BIT PPUSTATUS
    BPL GoToMenuVBlank
    JSR _ClearBasicSprites
    JSR _LoadPalettes
    JSR _LoadBackgroundsAndAttributes
    JSR _DrawMenu
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
    STA $0213
    STA $021B
    CLC
    ADC #$08
    STA $0217
    STA $021F
    STA position_x

    LDA starting_position_y
    SEC
    SBC #$00
    STA $0210
    STA $0214
    CLC
    ADC #$08
    STA $0218
    STA $021C
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
    JSR Initialize

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
    STA $0231
    STA $0235
    STA $0239
    STA $023D

    LDA #$17
    STA $0232
    LDA #$57
    STA $0236
    LDA #$97
    STA $023A
    LDA #$D7
    STA $023E

    LDA #$F0
    STA $0230
    STA $0234
    STA $0238
    STA $023C

LoadBlockadeSprites:
    LDY #$00
LoadBlockadeSpritesStep:
    TYA
    JSR _Multiply
    TAX

    LDA #$09
    STA $0241, x
    STA $0245, x
    STA $0249, x
    STA $024D, x

    LDA #$14
    STA $0242, x
    LDA #$54
    STA $0246, x
    LDA #$94
    STA $024A, x
    LDA #$D4
    STA $024E, x

    INY
    CPY #$08
    BNE LoadBlockadeSpritesStep
    RTS
