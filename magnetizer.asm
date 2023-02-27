
    .inesprg 1   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 0   ; mapper 0 = NROM, no bank swapping
    .inesmir 1   ; background mirroring

;;;;;;;;;;;;;;;
    .rsset $0000

PPUCTRL               = $2000
PPUMASK               = $2001
PPUSTATUS             = $2002
OAMADDR               = $2003
OAMDATA               = $2004
PPUSCROLL             = $2005
PPUADDR               = $2006
PPUDATA               = $2007
DMC_FREQ              = $4010
DMC_RAW               = $4011
DMC_START             = $4012
DMC_LEN               = $4013
OAMDMA                = $4014
SND_CHN               = $4015
JOY1                  = $4016

BLOCK                 = $00
FREE                  = $01
START                 = $02
END                   = $03
STOPPER               = $04
BOX                   = $05

ANIMATION_LENGTH      = $30

UP                    = $01
DOWN                  = $02
LEFT                  = $03
RIGHT                 = $04

POINT_X_OFFSET        = $08
POINT_Y_OFFSET        = $08

button                .rs 1

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
index_temp            .rs 1

target                .rs 1
offset                .rs 1
offset_x              .rs 1
offset_y              .rs 1

temp_x                .rs 1
temp_y                .rs 1

check_x_offset        .rs 1
check_y_offset        .rs 1

metasprite_low        .rs 1
metasprite_high       .rs 1
metasprite_offset     .rs 1

starting_point_x      .rs 1
starting_point_y      .rs 1
ending_point_real_x   .rs 1
ending_point_real_y   .rs 1

animation_cycle       .rs 1
animation_direction   .rs 1

boxes                 .rs 1
draw_boxes            .rs 1
box_x                 .rs 64
box_y                 .rs 64

move_counter          .rs 1

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
    STX PPUCTRL    ; disable NMI
    STX PPUMASK    ; disable rendering
    STX DMC_FREQ    ; disable DMC IRQs

InitialVBlank:
    BIT PPUSTATUS
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
    BIT PPUSTATUS
    BPL VBlank

;; load graphics ;;
LoadPalettes:
    LDA PPUSTATUS
    LDA #$3F
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00
LoadPalettesLoop:
    LDA palette, x
    STA PPUDATA
    INX
    CPX #$20
    BNE LoadPalettesLoop

InitializeBoxes:
    LDA #$00
    STA boxes
    LDA #$01
    STA draw_boxes

LoadLevel:
    LDA level_lo
    STA pointer_lo

    LDA level_hi
    STA pointer_hi

    LDX #$00
    LDY #$00
LoadLevelInsideLoop:
    LDA [pointer_lo], y
CheckIfEndingPoint:
    CMP #END
    BEQ SaveEndingPointPosition
CheckIfBox:
    CMP #BOX
    BEQ AddBox
    JMP LoadLevelIncrement

SaveEndingPointPosition:
    JSR _GetRealYPosition
    STA ending_point_real_y

    JSR _GetRealXPosition
    STA ending_point_real_x
    JMP LoadLevelIncrement
AddBox:
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

LoadLevelIncrement:
    INY
    CPY #$10
    BNE LoadLevelInsideLoop

LoadLevelIncrementPointer:
    LDA pointer_lo
    CLC
    ADC #$10
    STA pointer_lo

LoadLevelPostLoop:
    LDY #$00
    INX
    CPX #$10
    BNE LoadLevelInsideLoop

LoadBackground:
    JSR _LoadBackground

DrawMode:
    LDA #%10010100   ; enable NMI, sprites from Pattern Table 1
    STA PPUCTRL

    LDA #%00011110   ; enable sprites
    STA PPUMASK

InitializePosition:
    LDY #$00
    LDA [starting_position_lo], y
    STA position_x

    SBC #POINT_X_OFFSET
    STA $0213
    STA $021B
    CLC
    ADC #$08
    STA $0217
    STA $021F

    INY
    LDA [starting_position_lo], y
    STA position_y

    SBC #POINT_Y_OFFSET
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
    STA OAMADDR
    LDA #$02
    STA OAMDMA

    LDA PPUSTATUS
    LDA #$23
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    STA PPUADDR

LatchController:
    LDA #$01
    STA JOY1
    LDA #$00
    STA JOY1

PreRead:
    LDY #$00

ReadController:
    LDA #$01
    STA JOY1
    LDA #$00
    STA JOY1
    LDY #$08
ReadControllerLoop:
    LDA JOY1
    AND #%00000001
    BNE CheckButton

    DEY
    BNE ReadControllerLoop
    JMP Movement
CheckButton:
    JSR _AssignDirection
    JSR _CheckMovement

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

    LDA draw_boxes
    CMP #$01
    BEQ DrawBoxes
    JMP MainLoopEnd

DrawBoxes:
    LDA #$00
    STA draw_boxes

    LDA boxes
    CMP #$00
    BEQ MainLoopEnd

    LDY #$00
DrawBox:
    TYA
    JSR _Multiply
    TAX

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

    LDA box_x, y
    JSR _Multiply
    STA $0233, x
    STA $023B, x
    CLC
    ADC #$08
    STA $0237, x
    STA $023F, x

    LDA box_y, y
    JSR _Multiply
    SBC #$00
    STA $0230, x
    STA $0234, x
    CLC
    ADC #$08
    STA $0238, x
    STA $023C, x

    INY
    CPY boxes
    BNE DrawBox
MainLoopEnd:
    RTI

;;;;;;;;;;;;;;;;;
;; subroutines ;;
;;;;;;;;;;;;;;;;;

_LoadBackground:
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDA #$00
    STA pointer_lo

    LDA level_hi
    STA pointer_hi

    LDX #$00
    LDY #$00
_LoadBackgroundInsideLoop:
    LDA [pointer_lo], y

_LoadTilePart:
    CLC
    LDA [pointer_lo], y
    STY temp_y
    TAY
    LDA tiles, y
    STA current_tile
    LDY temp_y

_ProcessTile:
    JSR _ShiftVertically

_DrawTile:
    LDA current_tile
    STA PPUDATA
    ADC #$01
    STA PPUDATA

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
    JSR _BoxCheckLoop

__CollisionCheck:
    LDA index
    JSR _CheckCollision
    CMP #$01
    BNE __GetPositionWithoutOffset
    JSR _Stop

__GetPositionWithoutOffset:
    JSR _GetPositionWithoutOffset

_StopperCheck:
    JSR _GetTile
    CMP #STOPPER
    BNE _EndCheck
    JSR _Stop

_EndCheck:
    CMP #END
    BNE __UpdatePosition
    JSR _Stop

_EndLevelReset:
    LDX #$FF
    TXS          ; Set up stack
    INX          ; now X = 0
    STX PPUCTRL    ; disable NMI
    STX PPUMASK    ; disable rendering
    STX DMC_FREQ    ; disable DMC IRQ
_StartNextLevel:
    INC level_hi
    INC starting_position_lo
    INC starting_position_lo
    JMP VBlank
__UpdatePosition:
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
    BNE _BoxCheckEnd
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

    LDA #$01
    STA draw_boxes
_BoxCheckEnd:
    RTS

;; y as argument ;;
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
    TAY
    LDA [level_lo], y
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

    JSR _GetTile
    TAY
    LDA box_solid, y
    CMP #$01
    BNE _CheckIfBoxIsBlocking
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
    JSR _RestoreIndex
    LDA #$00
    RTS
_CheckIfBoxIsBlockingTrue:
    JSR _RestoreIndex
    LDA #$01
    RTS

_SaveIndex:
    LDA index
    STA index_temp
    RTS
_RestoreIndex:
    LDA index_temp
    STA index
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
    CMP #$01
    BEQ _Ground
_CheckBoxObstacle:
    TYA
    JSR _SetDirection
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

; Y as argument ;
_AssignDirection:
    TYA
    STA button
    LDA #$05
    SEC
    SBC button
    STA button
    TAY
    RTS

_SetDirection:
    LDY #$01
    STY grounded
    INC move_counter
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

_GetRealXPosition:
    TYA
    JSR _Multiply
    RTS

_GetRealYPosition:
    TXA
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
    .db $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $01, $01, $01, $01, $00, $00
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
    .db $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $05, $01, $01, $01, $00, $00
    .db $00, $00, $00, $01, $00, $01, $00, $01, $04, $01, $00, $01, $00, $01, $00, $00
    .db $00, $01, $04, $01, $01, $01, $00, $00, $01, $00, $00, $01, $01, $01, $00, $00
    .db $00, $01, $01, $00, $00, $05, $00, $00, $05, $00, $00, $00, $00, $00, $00, $00
    .db $00, $01, $00, $01, $01, $01, $01, $01, $01, $01, $00, $01, $01, $01, $00, $00
    .db $00, $01, $01, $04, $01, $01, $01, $01, $01, $01, $01, $01, $05, $01, $00, $00
    .db $00, $01, $05, $01, $01, $00, $00, $00, $00, $01, $01, $04, $00, $01, $00, $00
    .db $00, $00, $01, $01, $01, $01, $04, $01, $01, $01, $00, $01, $01, $01, $00, $00
    .db $00, $01, $01, $00, $00, $01, $01, $01, $05, $01, $01, $04, $00, $01, $00, $00
    .db $00, $01, $04, $01, $01, $05, $01, $05, $01, $05, $01, $01, $00, $01, $00, $00
    .db $00, $01, $01, $01, $05, $05, $01, $01, $05, $01, $01, $01, $00, $01, $00, $00
    .db $00, $00, $00, $01, $05, $01, $01, $00, $01, $01, $00, $00, $00, $01, $00, $00
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

box_solid
    .db $01, $00, $00, $00, $01, $00

movement:
    .db $00, $F0, $10, $FF, $01

movement_x:
    .db $00, $00, $00, $FF, $01

movement_y:
    .db $00, $FF, $01, $00, $00

magnetizer_metasprite:
    .db $C2, $82, $80, $C0
    .db $00, $40, $42, $02
    .db $41, $40, $C1, $C0
    .db $00, $01, $80, $81

;;;;;;;;;;;;;;

    .org $FFFA
    .dw NMI
    .dw Reset
    .dw 0

;;;;;;;;;;;;;;

  .bank 2
  .org $0000
  .incbin "magnetizer.chr"
