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
TILE_NONE             = $2C

SPRITE_STOPPER        = $10
SPRITE_ELECTRIC       = $0C

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

SLASH_CHARACTER       = $29
SPACE_CHARACTER       = $2C

TEXT_SCORE_Y_OFFSET   = $22
TEXT_SCORE_X_OFFSET   = $14
SCORE_Y_OFFSET        = $22
SCORE_X_OFFSET        = $31
SCORE_DIGITS          = $03

TEXT_LEVELS_Y_OFFSET  = $22
TEXT_LEVELS_X_OFFSET  = $74
LEVELS_Y_OFFSET       = $22
LEVELS_X_OFFSET       = $93
LEVELS_DIGITS         = $01

TEXT_TOTAL_Y_OFFSET   = $22
TEXT_TOTAL_X_OFFSET   = $D4
TOTAL_Y_OFFSET        = $22
TOTAL_X_OFFSET        = $F2
TOTAL_DIGITS          = $02

TEXT_LSET_Y_OFFSET    = $21
TEXT_LSET_X_OFFSET    = $A2

LEVEL_SETS            = $06
LEVELS                = $30
LEVEL_SET_SWITCH      = $03
LEVEL_POINTER_OFFSET  = $02
SWITCH_POINTER_VALUE  = $BE

GLOBAL_STATISTICS_OFF = 2 * (LEVELS_DIGITS + 1) * LEVEL_SETS

NMI_HORIZONTAL        = %10010000
NMI_VERTICAL          = %10010100

SPR_ADDRESS_START     = $0210
SPR_ADDRESS_END       = $0220
SPR_ADDRESS_BOX       = $0230
SPR_ADDRESS_BLOCKADE  = $0240
SPR_ADDRESS_CURSOR    = $0230
SPR_ADDRESS_STOPPER   = $02F8
SPR_ADDRESS_ELECTRIC  = $02FC

    .inesprg 2   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 3   ; mapper 0 = NROM, no bank swapping
    .inesmir 1   ; background mirroring

;;;;;;;   variables   ;;;;;;;

    .rsset $0000

remainder              .rs   2
dividend               .rs   2
divisor                .rs   2
decimal                .rs   4
digits                 .rs   1
result                 .rs   2
score                  .rs   2

digit_target_lo        .rs   1
digit_target_hi        .rs   1

game                   .rs   1
text_length            .rs   1

text_pointer_lo        .rs   1
text_pointer_hi        .rs   1

input                  .rs   1
button_pressed         .rs   1

attribute              .rs   1
tile_attribute         .rs   1

draw_counter           .rs   1
increase_counter       .rs   1
move_counter           .rs   4
move_counter_limit     .rs   1

next_level             .rs   1
level_set              .rs   1
level_set_counter      .rs   1
level_lo               .rs   1
level_hi               .rs   1
levels_cleared         .rs   1 * LEVEL_SETS
level_cleared          .rs   1
total_levels           .rs   1
total_levels_cleared   .rs   1

tiles_lo               .rs   1
tiles_hi               .rs   1

pointer_lo             .rs   1
pointer_hi             .rs   1

palette_lo             .rs   1
palette_hi             .rs   1

starting_position_x    .rs   1
starting_position_y    .rs   1

direction              .rs   1
grounded               .rs   1

speed                  .rs   1
real_speed             .rs   1

position_x             .rs   1
position_y             .rs   1
position               .rs   1
px                     .rs   1
py                     .rs   1

current_tile           .rs   1
index                  .rs   1
index_temp             .rs   1

target                 .rs   1
offset                 .rs   1
offset_x               .rs   1
offset_y               .rs   1

temp_x                 .rs   1
temp_y                 .rs   1

check_x_offset         .rs   1
check_y_offset         .rs   1

metasprite_low         .rs   1
metasprite_high        .rs   1
metasprite_offset      .rs   1

starting_point_x       .rs   1
starting_point_y       .rs   1
ending_point_real_x    .rs   1
ending_point_real_y    .rs   1

animation_cycle        .rs   1
animation_direction    .rs   1
blockade_flicker       .rs   1

box_animation          .rs   1
box_animation_x        .rs   1
box_animation_y        .rs   1
box_direction          .rs   1

boxes                  .rs   1

blockades              .rs   1
blockade_removers      .rs   1

blockade               .rs   1
blockade_x             .rs   1
blockade_y             .rs   1

source_box             .rs   1
source_box_x           .rs   1
source_box_y           .rs   1
source_box_z           .rs   1
source_box_offset      .rs   1

target_box             .rs   1
target_box_x           .rs   1
target_box_y           .rs   1
target_box_z           .rs   1
target_box_offset      .rs   1

portals_a              .rs   1
portals_b              .rs   1

trap_doors             .rs   1
trap_door              .rs   1
trap_door_x            .rs   1
trap_door_y            .rs   1

target_tile            .rs   1
target_temp            .rs   1

ppu_shift              .rs   1
ppu_address            .rs   1

level_loading          .rs   1
screen_movement        .rs   1
screen_offset          .rs   1
screen_mode            .rs   1
screen_x               .rs   1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .rsset $6000
box_x                  .rs  64
box_y                  .rs  64
blockades_on           .rs  16
blockades_x            .rs  16
blockades_y            .rs  16
blockade_removers_x    .rs  16
blockade_removers_y    .rs  16
portals_a_x            .rs  40
portals_a_y            .rs  40
portals_b_x            .rs  40
portals_b_y            .rs  40
trap_doors_on          .rs  16
trap_doors_x           .rs  16
trap_doors_y           .rs  16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .rsset $6200
scores                 .rs   2 * LEVELS
completed              .rs   1 * LEVELS
counters               .rs   2 * (LEVELS_DIGITS + 1) * (LEVEL_SETS + 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 0
    .org $8000
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
ResetScroll:
	LDA #$00
	STA PPUSCROLL
	STA PPUSCROLL

    JSR InitializeMenu
    JSR _LoadPalettes
    JSR _LoadBackgroundsAndAttributes
    JSR _DrawMenu
    JSR _EnableNMI

    JSR _EnableSound
    JSR _PlaySound
Forever:
    JMP Forever

;; NMI ;;
NMI:
    LDA #$00
    STA OAMADDR
    LDA #$02
    STA OAMDMA

    LDA game
    BNE JumpToGameLogic
    JSR MenuLogic
    JMP MainLoopEnd
JumpToGameLogic:
    JSR GameLogic
    JMP MainLoopEnd

MainLoopEnd:
    JSR FamiToneUpdate
    RTI

;;;;;;;;;;;;;;
    .include "menu.asm"
    .include "game.asm"
    .include "subroutines.asm"
    .include "hex2dec.asm"
    .include "levels.asm"
    .include "famitone2.asm"
    .include "music.asm"
    .include "constants.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .org $FFFA
    .dw NMI
    .dw Reset
    .dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 4
    .org $8000
    .incbin "magnetizer.chr"