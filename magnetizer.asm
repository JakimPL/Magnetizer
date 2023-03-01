
    .inesprg 1   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 0   ; mapper 0 = NROM, no bank swapping
    .inesmir 1   ; background mirroring

;;;;;;;;;;;;;;;
    .rsset $0000

;; constants ;;
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

TILE_EMPTY            = $24
TILE_BOX              = $3C

ANIMATION_LENGTH      = $30

UP                    = $01
DOWN                  = $02
LEFT                  = $03
RIGHT                 = $04

POINT_X_OFFSET        = $08
POINT_Y_OFFSET        = $08

TEN                   = $0A
LAST_DIGIT            = TEN - 1
COUNTER_DIGITS        = $04
COUNTER_LAST_DIGIT    = COUNTER_DIGITS - 1

;; variables ;;

source_box            .rs 1
source_box_x          .rs 1
source_box_y          .rs 1
source_box_z          .rs 1
source_box_offset     .rs 1

target_box            .rs 1
target_box_x          .rs 1
target_box_y          .rs 1
target_box_z          .rs 1
target_box_offset     .rs 1

target_tile           .rs 1
target_temp           .rs 1


attribute             .rs 1
tile_attribute        .rs 1
button                .rs 1

increase_counter      .rs 1
move_counter          .rs 4
move_counter_limit    .rs 1

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

ppu_shift             .rs 1

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

SetBoxSwap:
    JSR _ResetBoxSwap

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

LoadAttributes:
    JSR _LoadAttributes

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

    LDA source_box
    CMP #$FF
    BNE RemoveSourceBox

    LDA target_box
    CMP #$FF
    BEQ PrepareMoveCounter
    JMP DrawTargetBox
RemoveSourceBox:
    LDA source_box_x
    STA ppu_shift
    LDX source_box_y
    JSR _PreparePPU

    LDA #TILE_EMPTY
    STA target_tile
    JSR _DrawSingleTile

GetSourceBoxAttribute:
    LDA #$23
    STA ppu_shift
    LDX source_box_offset
    JSR _PreparePPU
    LDA PPUDATA
    LDA PPUDATA
    STA target_tile

DrawSourceBoxAttribute:
    JSR _PreparePPU
    LDA target_tile
    AND source_box_z
    STA PPUDATA

ResetSourceBox:
    LDA #$FF
    STA source_box
    JMP PrepareMoveCounter

DrawTargetBox:
    LDA target_box_x
    STA ppu_shift
    LDX target_box_y
    JSR _PreparePPU

    LDA #TILE_BOX
    STA target_tile
    JSR _DrawSingleTile

GetTargetBoxAttribute:
    LDA #$23
    STA ppu_shift
    LDX target_box_offset
    JSR _PreparePPU
    LDA PPUDATA
    LDA PPUDATA
    STA target_tile

DrawTargetBoxAttribute:
    JSR _PreparePPU
    LDA target_tile
    ORA target_box_z
    STA PPUDATA

ResetTargetBox:
    LDA #$FF
    STA target_box

PrepareMoveCounter:
    LDA #$23
    LDX #$00
    LDY #$00
    STA ppu_shift
    JSR _PreparePPU

DrawMoveCounterOffset:
    LDA #%10010100
    STA PPUCTRL

    LDX #$04
    JSR _ShiftPPU

    LDA #%10010000
    STA PPUCTRL

    LDA #$18
    STA ppu_shift
DrawMoveCounter:
    JSR _DrawMoveCounter

    LDA #%10010100
    STA PPUCTRL

    LDX #$03
    JSR _ShiftPPU

    LDA #%10010000
    STA PPUCTRL

    LDX ppu_shift
    JSR _ShiftPPU

    LDA #$0F
    STA PPUDATA

LatchController:
    LDA #$01
    STA JOY1
    LDA #$00
    STA JOY1

PreRead:
    LDY #$00
    STA increase_counter

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

IncrementCounterCheck:
    LDA increase_counter
    CMP #$01
    BNE MainLoopEnd
    JSR _IncreaseMoveCounter

MainLoopEnd:
    RTI

;;;;;;;;;;;;;;
    .include "subroutines.asm"

    .bank 1
    .org $E000

    .include "levels.asm"


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
    .db $30, $24, $24, $24, $38, $3C

attributes:
    .db $00, $00, $00, $00, $00, $03

attribute_offsets:
    .db $11, $10, $01, $00

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
