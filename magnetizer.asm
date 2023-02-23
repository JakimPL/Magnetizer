
    .inesprg 1   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 0   ; mapper 0 = NROM, no bank swapping
    .inesmir 1   ; background mirroring

;;;;;;;;;;;;;;;
    .rsset $0000

draw_boxes            .rs 1
boxes                 .rs 1
box_x                 .rs 1
box_y                 .rs 1

level_lo              .rs 1
level_hi              .rs 1

tiles_lo              .rs 1
tiles_hi              .rs 1

pointer_lo            .rs 1
pointer_hi            .rs 1

starting_position_lo  .rs 1
starting_position_hi  .rs 1

direction             .rs 1
grounded              .rs 1
speed                 .rs 1
real_speed            .rs 1

position              .rs 1
position_x            .rs 1
position_y            .rs 1
px                    .rs 1
py                    .rs 1

current_tile          .rs 1
index                 .rs 1

target                .rs 1
offset                .rs 1
offset_x              .rs 1
offset_y              .rs 1

temp_y                .rs 1

check_x_offset        .rs 1
check_y_offset        .rs 1

metasprite_low        .rs 1
metasprite_high       .rs 1
metasprite_offset     .rs 1

starting_point_x      .rs 1
starting_point_y      .rs 1
animation_cycle       .rs 1
animation_direction   .rs 1

ending_point_real_x   .rs 1
ending_point_real_y   .rs 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;


    .bank 0
    .org $C000
Reset:
    SEI          ; disable IRQs
    CLD          ; disable decimal mode
    LDX #$40
    STX $4017    ; disable APU frame IRQ
    LDX #$FF
    TXS          ; Set up stack
    INX          ; now X = 0
    STX $2000    ; disable NMI
    STX $2001    ; disable rendering
    STX $4010    ; disable DMC IRQs


InitialVBlank:
    BIT $2002
    BPL InitialVBlank

ClearMemory:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    LDA #$FE
ClearGraphics:
    STA $0200, x
    INX
    BNE ClearMemory

;; setting pointers ;;
SetTilesPointer:
    LDA #LOW(tiles)
    STA tiles_lo
    LDA #HIGH(tiles)
    STA tiles_hi

SetLevelPointer:
    LDA #LOW(levels)
    STA level_lo
    LDA #HIGH(levels)
    STA level_hi

SetStartingPositionPointer:
    LDA #LOW(starting_positions)
    STA starting_position_lo
    LDA #HIGH(starting_positions)
    STA starting_position_hi

LoadSprites:
    LDX #$00
LoadSpritesLoop:
    LDA sprites, x
    STA $0200, x
    INX
    CPX #$30
    BNE LoadSpritesLoop

VBlank:
    BIT $2002
    BPL VBlank

;; load graphics ;;
LoadPalettes:
    LDA $2002
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006
    LDX #$00
LoadPalettesLoop:
    LDA palette, x
    STA $2007
    INX
    CPX #$20
    BNE LoadPalettesLoop

InitializeBoxes:
    LDA #$00
    STA boxes
    LDA #$01
    STA draw_boxes
LoadBackground:
    LDA $2002
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006
    LDA #$00
    STA pointer_lo

    LDA level_hi
    STA pointer_hi

    LDX #$00
    LDY #$00
OutsideLoop:

InsideLoop:
    LDA [pointer_lo], y
CheckIfEndingPoint:
    CMP #$03
    BEQ SaveEndingPointPosition
CheckIfBox:
    CMP #$05
    BEQ AddBox
    JMP LoadTilePart
SaveEndingPointPosition:
    JSR _GetYPosition
    STA ending_point_real_y

    JSR _GetXPosition
    STA ending_point_real_x
    JMP LoadTilePart
AddBox:
    INC boxes
    TXA
    LSR a
    STA box_y
    TYA
    STY box_x

LoadTilePart:
    CLC
    LDA [pointer_lo], y
    STY temp_y
    TAY
    LDA tiles, y
    STA current_tile
    LDY temp_y

ProcessTile:
    JSR _ShiftVertically

DrawTile:
    LDA current_tile
    STA $2007
    ADC #$01
    STA $2007

    INY
    CPY #$10
    BNE InsideLoop

    TXA
    AND #%00000001
    BEQ PostLoop

IncrementPointer:
    LDA pointer_lo
    CLC
    ADC #$10
    STA pointer_lo


PostLoop:
    LDY #$00
    INX
    CPX #$1E
    BNE OutsideLoop


DrawMode:
    LDA #%10010000   ; enable NMI, sprites from Pattern Table 1
    STA $2000

    LDA #%00011110   ; enable sprites
    STA $2001


InitializePosition:
    LDY #$00
    LDA [starting_position_lo], y
    STA position_x

    SBC #$08
    STA $0213
    STA $021B
    CLC
    ADC #$08
    STA $0217
    STA $021F

    INY
    LDA [starting_position_lo], y
    STA position_y

    SBC #$0A
    STA $0210
    STA $0214
    CLC
    ADC #$08
    STA $0218
    STA $021C

InitializeAnimation:
    LDA #$01
    STA animation_direction
    LDA #$00
    STA animation_cycle

Forever:
    JMP Forever


;; NMI ;;
NMI:
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014


LatchController:
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016

PreRead:
    LDY #$00

ReadA:
    LDA $4016
    AND #%10000000
    BEQ ReadADone
ReadADone:


ReadB:
    LDA $4016
    AND #%00000001
    BEQ ReadBDone
ReadBDone:


ReadSelect:
    LDA $4016
    AND #%00000001
ReadSelectDone:

ReadStart:
    LDA $4016
    AND #%00000001
    BEQ ReadStartDone
ReadStartDone:

ReadUp:
    LDA $4016
    AND #%00000001
    BEQ ReadUpDone

    LDY #$01
    JSR _CheckMovement
ReadUpDone:


ReadDown:
    LDA $4016
    AND #%00000001
    BEQ ReadDownDone

    LDY #$02
    JSR _CheckMovement
ReadDownDone:

ReadLeft:
    LDA $4016
    AND #%00000001
    BEQ ReadLeftDone

    LDY #$03
    JSR _CheckMovement
ReadLeftDone:

ReadRight:
    LDA $4016
    AND #%00000001
    BEQ ReadRightDone

    LDY #$04
    JSR _CheckMovement
ReadRightDone:

    LDA grounded
    CMP #$01
    BNE Move
CalculateSpeed:
    JSR _CalculateRealSpeed
    JSR _IncreaseSpeed
Move:
    LDX direction
    CPX #$01
    BEQ MoveUp
    CPX #$02
    BEQ MoveDown
    CPX #$03
    BEQ MoveLeft
    CPX #$04
    BEQ MoveRight
    JMP UpdatePosition

MoveUp:
    DEC position_y
    JSR _AfterStep
    BNE MoveUp
    JMP UpdatePosition

MoveDown:
    INC position_y
    JSR _AfterStep
    BNE MoveDown
    JMP UpdatePosition

MoveLeft:
    DEC position_x
    JSR _AfterStep
    BNE MoveLeft
    JMP UpdatePosition

MoveRight:
    INC position_x
    JSR _AfterStep
    BNE MoveRight
    JMP UpdatePosition

UpdatePosition:
    LDA position_x
    SEC
    SBC #$07
    STA $0203
    STA $020B

    CLC
    ADC #$08
    STA $0207
    STA $020F

    LDA position_y
    SEC
    SBC #$0A
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

    CMP #$30
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
    SBC #$02
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

    LDA draw_boxes
    CMP #$01
    BEQ DrawBoxes
    JMP MainLoopEnd

DrawBoxes:
    LDX #$00
DrawBox:
    LDA #$08
    STA $0231, x
    STA $0235, x
    STA $0239, x
    STA $023D, x

    LDA #$17
    STA $0232, x
    LDA #$57
    STA $0236, x
    LDA #$97
    STA $023A, x
    LDA #$D7
    STA $023E, x

    LDA box_x
    JSR _Multiply
    STA $0233, x
    STA $023B, x
    CLC
    ADC #$08
    STA $0237, x
    STA $023F, x

    LDA box_y
    JSR _Multiply
    SBC #$02
    STA $0230, x
    STA $0234, x
    CLC
    ADC #$08
    STA $0238, x
    STA $023C, x

    LDA #$00
    STA draw_boxes
MainLoopEnd:
    RTI

;;;;;;;;;;;;;;
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
    LDA direction
    CMP #$01
    BEQ _SetOffsetUp
    CMP #$02
    BEQ _SetOffsetDown
    CMP #$03
    BEQ _SetOffsetLeft
    CMP #$04
    BEQ _SetOffsetRight
    RTS
_SetOffsetUp:
    LDA #$FF
    STA offset_y
    LDA #$00
    STA offset_x
    RTS
_SetOffsetDown:
    LDA #$01
    STA offset_y
    LDA #$00
    STA offset_x
    RTS
_SetOffsetLeft:
    LDA #$FF
    STA offset_x
    LDA #$00
    STA offset_y
    RTS
_SetOffsetRight:
    LDA #$01
    STA offset_x
    LDA #$00
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
    CPY #$FF
    BNE _IncreaseSpeedStep
    RTS
_IncreaseSpeedStep:
    INC speed
    RTS

_Stop:
    LDA #$00
    STA grounded
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
    BEQ __GetPositionWithOffset
    RTS
_CheckX:
    LDA position_x
    AND #%00001111
    CMP #$08
    BEQ __GetPositionWithOffset
    RTS

__GetPositionWithOffset:
    JSR _GetPositionWithOffset

__BoxCheck:
    JSR _BoxCheck

__CollisionCheck:
    LDA index
    JSR _CheckCollision
    CMP #$00
    BNE __GetPositionWithoutOffset
    JSR _Stop

__GetPositionWithoutOffset:
    JSR _GetPositionWithoutOffset

_StopperCheck:
    JSR _CheckCollision

    CMP #$04
    BNE _EndCheck
    JSR _Stop

_EndCheck:
    CMP #$03
    BNE __UpdatePosition
    JSR _Stop

_EndLevelReset:
    TXS          ; Set up stack
    INX          ; now X = 0
    STX $2000    ; disable NMI
    STX $2001    ; disable rendering
    STX $4010    ; disable DMC IRQ
_EndLevelVBlank:
    BIT $2002
    BPL _StartNextLevel
_StartNextLevel:
    INC level_hi
    INC starting_position_lo
    INC starting_position_lo
    JMP VBlank
__UpdatePosition:
    RTS

;; box logic ;;
_BoxCheck:
    LDA index
    AND #%00001111
    CMP box_x
    BNE _BoxCheckEnd

    LDA index
    JSR _Divide
    CMP box_y
    BNE _BoxCheckEnd
_BoxAction:
    ; move box if possible
    ; check if
    LDX direction
    LDA movement, x
    STA offset
    JSR _Stop

    LDA index
    CLC
    ADC offset
    STA target
    TAY

    LDA [level_lo], y
    TAY
    LDA solid, y
    CMP #$01
    BNE _MoveBox
    RTS
_MoveBox:
    LDA target
    AND #%00001111
    STA box_x

    LDA target
    JSR _Divide
    STA box_y

    LDA #$01
    STA draw_boxes
_BoxCheckEnd:
    RTS

;; collision logic ;;
_CheckCollision:
    TAY
    LDA [level_lo], y
    RTS

_CheckMovement:
    LDX grounded
    CPX #$00
    BEQ _CheckObstacle
    RTS
_CheckObstacle:
    STY direction
    JSR _GetPositionWithOffset
    JSR _CheckCollision
    CMP #$00
    BNE _SetDirection
    JMP _Stop

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

; Y as argument ;
_SetDirection:
    LDY #$01
    STY grounded
    RTS

_ShiftVertically:
    TXA
    AND #%00000001
    BEQ _AfterShift

    LDA current_tile
    ADC #$02
    STA current_tile
_AfterShift:
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

_GetXPosition:
    TYA
    JSR _Multiply
    RTS

_GetYPosition:
    TXA
    LSR a
    JSR _Multiply
    RTS

;;;;;;;;;;;;;;

    .bank 1
    .org $E000

;; levels ;;
levels:
level_01_01:
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .db $00, $00, $00, $01, $01, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00, $00
    .db $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $01, $00, $00
    .db $00, $01, $01, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01, $01, $00, $00
    .db $00, $01, $01, $01, $00, $00, $00, $01, $01, $01, $01, $01, $00, $00, $00, $00
    .db $00, $00, $00, $01, $01, $00, $00, $00, $01, $01, $01, $01, $01, $01, $00, $00
    .db $00, $00, $00, $01, $01, $01, $00, $00, $00, $01, $00, $00, $01, $01, $00, $00
    .db $00, $00, $00, $00, $01, $01, $02, $00, $00, $01, $00, $01, $01, $01, $03, $00
    .db $00, $00, $00, $01, $01, $01, $00, $00, $00, $01, $01, $01, $00, $01, $00, $00
    .db $00, $00, $00, $01, $01, $00, $00, $00, $01, $01, $01, $01, $01, $01, $00, $00
    .db $00, $01, $01, $01, $00, $00, $00, $01, $01, $01, $00, $01, $01, $00, $00, $00
    .db $00, $01, $01, $00, $00, $00, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00
    .db $00, $00, $01, $01, $05, $01, $01, $01, $01, $00, $01, $01, $01, $01, $00, $00
    .db $00, $00, $00, $01, $01, $01, $01, $00, $01, $01, $01, $00, $00, $01, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

level_01_02:
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .db $00, $00, $00, $01, $01, $01, $04, $01, $01, $01, $00, $01, $00, $00, $00, $00
    .db $00, $00, $00, $01, $00, $00, $01, $01, $00, $01, $00, $01, $00, $00, $00, $00
    .db $00, $01, $01, $01, $00, $01, $00, $00, $01, $01, $00, $04, $01, $01, $00, $00
    .db $00, $01, $00, $01, $01, $01, $01, $00, $01, $00, $00, $01, $00, $01, $00, $00
    .db $00, $01, $01, $00, $01, $04, $01, $01, $01, $01, $00, $01, $00, $01, $00, $00
    .db $00, $00, $01, $01, $01, $01, $01, $00, $00, $00, $00, $01, $00, $01, $00, $00
    .db $02, $01, $01, $01, $00, $01, $01, $01, $01, $01, $01, $01, $00, $01, $00, $00
    .db $00, $00, $01, $01, $01, $00, $01, $00, $04, $00, $00, $01, $00, $01, $00, $00
    .db $00, $01, $01, $00, $04, $01, $00, $01, $01, $01, $01, $01, $00, $01, $00, $00
    .db $00, $01, $00, $01, $01, $01, $00, $00, $00, $01, $00, $01, $00, $01, $00, $00
    .db $00, $01, $01, $01, $00, $00, $01, $04, $01, $01, $01, $00, $01, $04, $00, $00
    .db $00, $00, $00, $01, $01, $00, $01, $01, $00, $01, $00, $00, $00, $01, $00, $00
    .db $00, $00, $00, $01, $01, $01, $01, $00, $01, $01, $00, $00, $00, $01, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

level_01_03:
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $00, $00
    .db $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $04, $01, $01, $01, $00, $00
    .db $00, $00, $00, $01, $00, $01, $00, $01, $05, $01, $00, $01, $00, $01, $00, $00
    .db $00, $01, $05, $01, $01, $01, $00, $00, $01, $00, $00, $01, $01, $01, $00, $00
    .db $00, $01, $01, $00, $00, $04, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00
    .db $00, $01, $00, $01, $01, $01, $01, $01, $01, $01, $00, $01, $01, $01, $00, $00
    .db $00, $01, $01, $05, $01, $01, $01, $01, $01, $01, $01, $01, $04, $01, $00, $00
    .db $00, $01, $04, $01, $01, $00, $00, $00, $00, $01, $01, $05, $00, $01, $00, $00
    .db $00, $00, $01, $01, $01, $01, $05, $01, $01, $01, $00, $01, $01, $01, $00, $00
    .db $00, $01, $01, $00, $00, $01, $01, $01, $04, $01, $01, $05, $00, $01, $00, $00
    .db $00, $01, $05, $01, $01, $04, $01, $04, $01, $04, $01, $01, $00, $01, $00, $00
    .db $00, $01, $01, $01, $04, $04, $01, $01, $04, $01, $01, $01, $00, $01, $00, $00
    .db $00, $00, $00, $01, $04, $01, $01, $00, $01, $01, $00, $00, $00, $01, $00, $00
    .db $00, $00, $00, $01, $01, $01, $00, $00, $01, $01, $00, $00, $00, $01, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

level_01_04:
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $00, $00
    .db $00, $00, $00, $01, $01, $01, $01, $01, $04, $01, $00, $01, $01, $01, $00, $00
    .db $00, $00, $00, $01, $00, $01, $04, $01, $01, $01, $01, $01, $05, $01, $00, $00
    .db $00, $01, $01, $01, $05, $01, $01, $05, $01, $00, $00, $01, $04, $01, $00, $00
    .db $00, $01, $00, $01, $01, $05, $05, $01, $01, $01, $01, $05, $05, $00, $00, $00
    .db $00, $05, $00, $01, $01, $01, $01, $01, $00, $01, $00, $01, $05, $01, $00, $00
    .db $00, $01, $01, $01, $01, $05, $05, $01, $04, $01, $01, $00, $00, $01, $00, $00
    .db $00, $00, $01, $01, $05, $01, $01, $01, $01, $05, $01, $01, $00, $01, $00, $00
    .db $00, $01, $01, $01, $01, $01, $00, $05, $00, $01, $01, $01, $00, $01, $00, $00
    .db $00, $01, $01, $04, $01, $04, $01, $01, $00, $00, $01, $01, $00, $01, $00, $00
    .db $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $05, $04, $00, $01, $00, $00
    .db $00, $01, $00, $01, $01, $01, $00, $01, $05, $01, $01, $01, $00, $01, $00, $00
    .db $00, $01, $01, $00, $00, $00, $01, $01, $05, $01, $00, $01, $05, $01, $00, $00
    .db $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $01, $00, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;; starting positions ;;
starting_positions:
    .db $68, $78
    .db $08, $78
    .db $D8, $08
    .db $D8, $08


attributes:
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
    .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000


    .db $24,$24,$24,$24, $47,$47,$24,$24
    .db $47,$47,$47,$47, $47,$47,$24,$24
    .db $24,$24,$24,$24 ,$24,$24,$24,$24
    .db $24,$24,$24,$24, $55,$56,$24,$24
    .db $47,$47,$47,$47, $47,$47,$24,$24
    .db $24,$24,$24,$24 ,$24,$24,$24,$24
    .db $24,$24,$24,$24, $55,$56,$24,$24


palette:
    .db $19,$02,$05,$1D,  $22,$36,$17,$0F,  $22,$10,$11,$0F,  $22,$27,$17,$0F ; background
    .db $01,$1C,$15,$24,  $22,$02,$12,$3C,  $22,$12,$30,$2C,  $16,$27,$2A,$2B ; sprites


sprites:
    ;; magnetizer ;;
    .db $70, $00, $01, $70
    .db $70, $01, $01, $78
    .db $78, $00, $81, $70
    .db $78, $01, $81, $78

    ;; start ;;
    .db $40, $04, $03, $40
    .db $40, $04, $43, $48
    .db $48, $04, $83, $40
    .db $48, $04, $C3, $48

    ;; end ;;
    .db $00, $04, $02, $00
    .db $00, $04, $42, $08
    .db $08, $04, $82, $00
    .db $08, $04, $C2, $08

tiles:
    .db $30, $24, $24, $24, $38, $24

solid
    .db $01, $00, $00, $00, $00, $00

movement:
    .db $00, $F0, $10, $FF, $01

magnetizer_metasprite:
    .db $C2, $82, $80, $C0
    .db $00, $40, $42, $02
    .db $41, $40, $C1, $C0
    .db $00, $01, $80, $81

;;;;;;;;;;;;;;

    .org $FFFA     ;first of the three vectors starts here
    .dw NMI        ;when an NMI happens (once per frame if enabled) the
                     ;processor will jump to the label NMI:
    .dw Reset      ;when the processor first turns on or is reset, it will jump
                     ;to the label RESET:
    .dw 0          ;external interrupt IRQ is not used in this tutorial


;;;;;;;;;;;;;;

  .bank 2
  .org $0000
  .incbin "magnetizer.chr"   ;includes 8KB graphics file from SMB1
