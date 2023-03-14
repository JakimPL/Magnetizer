
    .inesprg 1   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 0   ; mapper 0 = NROM, no bank swapping
    .inesmir 1   ; background mirroring

;;;;;;;;;;;;;;;
    .rsset $0000

;;;;;;;   constants   ;;;;;;;

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
ARROW_UP              = $06
ARROW_DOWN            = $07
ARROW_LEFT            = $08
ARROW_RIGHT           = $09
PORTAL_A              = $0A
PORTAL_B              = $0B
ARROW_VERTICAL        = $0C
ARROW_HORIZONTAL      = $0D
BLOCKADE_REMOVER      = $0E
BLOCKADE              = $0F
TRAP_DOOR             = $10

TILE_EMPTY            = $24
TILE_BOX              = $3C
TILE_TRAP_DOOR_ACTIVE = $64

MAX_SPEED             = $30
ANIMATION_LENGTH      = $30
BOX_SPEED             = $02

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

;;;;;;;   variables   ;;;;;;;

attribute              .rs  1
tile_attribute         .rs  1
button                 .rs  1

increase_counter       .rs  1
move_counter           .rs  4
move_counter_limit     .rs  1

level_set              .rs  1
level_set_counter      .rs  1
level_lo               .rs  1
level_hi               .rs  1

tiles_lo               .rs  1
tiles_hi               .rs  1

pointer_lo             .rs  1
pointer_hi             .rs  1

palette_lo             .rs  1
palette_hi             .rs  1

starting_position_x    .rs  1
starting_position_y    .rs  1

direction              .rs  1
grounded               .rs  1

speed                  .rs  1
real_speed             .rs  1

position_x             .rs  1
position_y             .rs  1
position               .rs  1
px                     .rs  1
py                     .rs  1

current_tile           .rs  1
index                  .rs  1
index_temp             .rs  1

target                 .rs  1
offset                 .rs  1
offset_x               .rs  1
offset_y               .rs  1

temp_x                 .rs  1
temp_y                 .rs  1

check_x_offset         .rs  1
check_y_offset         .rs  1

metasprite_low         .rs  1
metasprite_high        .rs  1
metasprite_offset      .rs  1

starting_point_x       .rs  1
starting_point_y       .rs  1
ending_point_real_x    .rs  1
ending_point_real_y    .rs  1

animation_cycle        .rs  1
animation_direction    .rs  1

box_animation          .rs  1
box_animation_x        .rs  1
box_animation_y        .rs  1
box_direction          .rs  1

boxes                  .rs  1

draw_blockades         .rs  1
blockades              .rs  1
blockade_removers      .rs  1

source_box             .rs  1
source_box_x           .rs  1
source_box_y           .rs  1
source_box_z           .rs  1
source_box_offset      .rs  1

target_box             .rs  1
target_box_x           .rs  1
target_box_y           .rs  1
target_box_z           .rs  1
target_box_offset      .rs  1

portals_a              .rs  1
portals_b              .rs  1

trap_doors             .rs  1
trap_door              .rs  1
trap_door_x            .rs  1
trap_door_y            .rs  1

target_tile            .rs  1
target_temp            .rs  1

ppu_shift              .rs  1

box_x                  .rs 64
box_y                  .rs 64
blockades_on           .rs 12
blockades_x            .rs 12
blockades_y            .rs 12
blockade_removers_x    .rs 12
blockade_removers_y    .rs 12
portals_a_x            .rs 40
portals_a_y            .rs 40
portals_b_x            .rs 40
portals_b_y            .rs 40
trap_doors_on          .rs 16
trap_doors_x           .rs 16
trap_doors_y           .rs 16
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

SetPalettePointer:
    LDA #LOW(palettes)
    STA palette_lo
    LDA #HIGH(palettes)
    STA palette_hi

SetBoxSwap:
    JSR _ResetBoxSwap

SetTrapDoor:
    JSR _ResetTrapDoor

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

LoadLevel:
    JSR _LoadLevel

VBlank:
    BIT PPUSTATUS
    BPL VBlank

;; load graphics ;;
LoadPalettes:
    JSR _LoadPalettes

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

Forever:
    JMP Forever


;; NMI ;;
NMI:
    JSR GameLogic

MainLoopEnd:
    RTI

;;;;;;;;;;;;;;
    .include "game.asm"
    .include "subroutines.asm"

    .bank 1
    .org $E000

    .include "levels.asm"
    .include "constants.asm"

;;;;;;;;;;;;;;

    .org $FFFA
    .dw NMI
    .dw Reset
    .dw 0

;;;;;;;;;;;;;;

    .bank 2
    .org $0000
    .incbin "magnetizer.chr"
