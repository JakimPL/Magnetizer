
    .inesprg 1   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 0   ; mapper 0 = NROM, no bank swapping
    .inesmir 1   ; background mirroring

;;;;;;;;;;;;;;;
    .rsset $0000

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

position_x            .rs 1
position_y            .rs 1
px                    .rs 1
py                    .rs 1

current_tile          .rs 1
index                 .rs 1

offset_x              .rs 1
offset_y              .rs 1

sprite                .rs 1
flip                  .rs 1

temp_y                .rs 1

check_x_offset        .rs 1
check_y_offset        .rs 1

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


InitialVBlank:       ; First wait for vblank to make sure PPU is ready
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

InitializeSprite:
    LDA #$41
    STA flip

    LDA #$01
    STA sprite

VBlank:
    BIT $2002
    BPL VBlank

;; load graphics ;;
LoadPalettes:
    LDA $2002             ; read PPU status to reset the high/low latch
    LDA #$3F
    STA $2006             ; write the high byte of $3F00 address
    LDA #$00
    STA $2006             ; write the low byte of $3F00 address
    LDX #$00              ; start out at 0
LoadPalettesLoop:
    LDA palette, x        ; load data from address (palette + the value in x)
                            ; 1st time through loop it will load palette+0
                            ; 2nd time through loop it will load palette+1
                            ; 3rd time through loop it will load palette+2
                            ; etc
    STA $2007             ; write to PPU
    INX                   ; X = X + 1
    CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
    BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                          ; if compare was equal to 32, keep going down

LoadSprites:
    LDX #$00              ; start at 0
LoadSpritesLoop:
    LDA sprites, x        ; load data from address (sprites +  x)
    STA $0200, x          ; store into RAM address ($0200 + x)
    INX                   ; X = X + 1
    CPX #$04              ; Compare X to hex $20, decimal 32
    BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                          ; if compare was equal to 32, keep going down


LoadBackground:
    LDA $2002             ; read PPU status to reset the high/low latch
    LDA #$20
    STA $2006             ; write the high byte of $2000 address
    LDA #$00
    STA $2006             ; write the low byte of $2000 address

    LDA #$00
    STA pointer_lo       ; put the low byte of the address of background into pointer

    LDA level_hi
    STA pointer_hi       ; put the high byte of the address into pointer

    LDX #$00            ; start at pointer + 0
    LDY #$00
OutsideLoop:

InsideLoop:
    LDA [pointer_lo], y  ; copy one background byte from address in pointer plus Y

LoadTilePart:
    STY temp_y
    TAY
    LDA [tiles_lo], y
    STA current_tile
    LDY temp_y
ProcessTile:
    JSR _ShiftVertically
    LDA current_tile

DrawTile:
    STA $2007
    ADC #$01
    STA $2007

    INY                 ; inside loop counter
    CPY #$10
    BNE InsideLoop      ; run the inside loop 256 times before continuing down

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
    BNE OutsideLoop     ; run the outside loop 256 times before continuing down


DrawMode:
    LDA #%10010000   ; enable NMI, sprites from Pattern Table 1
    STA $2000

    LDA #%00011110   ; enable sprites
    STA $2001


InitializePosition:
    LDY #$00
    LDA [starting_position_lo], y
    STA position_x

    INY
    LDA [starting_position_lo], y
    STA position_y


Forever:
    JMP Forever     ;jump back to Forever, infinite loop


;; NMI ;;
NMI:
    LDA #$00
    STA $2003       ; set the low byte (00) of the RAM address
    LDA #$02
    STA $4014       ; set the high byte (02) of the RAM address, start the transfer


LatchController:
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016       ; tell both the controllers to latch buttons

PreRead:
    LDY #$00

ReadA:
    LDA $4016       ; player 1 - A
    AND #%10000000  ; only look at bit 0
    BEQ ReadADone   ; branch to ReadADone if button is NOT pressed (0)
ReadADone:        ; handling this button is done


ReadB:
    LDA $4016       ; player 1 - B
    AND #%00000001  ; only look at bit 0
    BEQ ReadBDone   ; branch to ReadBDone if button is NOT pressed (0)
ReadBDone:        ; handling this button is done


ReadSelect:
    LDA $4016       ; player 1 - B
    AND #%00000001  ; only look at bit 0
ReadSelectDone:        ; handling this button is done

ReadStart:
    LDA $4016       ; player 1 - B
    AND #%00000001  ; only look at bit 0
    BEQ ReadStartDone   ; branch to ReadBDone if button is NOT pressed (0)
ReadStartDone:        ; handling this button is done

ReadUp:
    LDA $4016       ; player 1 - A
    AND #%00000001  ; only look at bit 0
    BEQ ReadUpDone   ; branch to ReadADone if button is NOT pressed (0)
                    ; add instructions here to do something when button IS pressed (1)
    LDY #$01
    JSR _CheckMovement
ReadUpDone:        ; handling this button is done


ReadDown:
    LDA $4016       ; player 1 - B
    AND #%00000001  ; only look at bit 0
    BEQ ReadDownDone   ; branch to ReadBDone if button is NOT pressed (0)
                    ; add instructions here to do something when button IS pressed (1)
    LDY #$02
    JSR _CheckMovement
ReadDownDone:        ; handling this button is done

ReadLeft:
    LDA $4016       ; player 1 - B
    AND #%00000001  ; only look at bit 0
    BEQ ReadLeftDone   ; branch to ReadBDone if button is NOT pressed (0)

    LDY #$03
    JSR _CheckMovement
ReadLeftDone:        ; handling this button is done

ReadRight:
    LDA $4016       ; player 1 - B
    AND #%00000001  ; only look at bit 0
    BEQ ReadRightDone   ; branch to ReadBDone if button is NOT pressed (0)
                    ; add instructions here to do something when button IS pressed (1)
    LDY #$04
    JSR _CheckMovement
ReadRightDone:        ; handling this button is done

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
    LDA #$41
    STA flip
    LDA #$02
    STA sprite
MoveUpStep:
    DEC position_y
    JSR _AfterStep
    BNE MoveUpStep
    JMP UpdatePosition

MoveDown:
    LDA #$C1
    STA flip
    LDA #$02
    STA sprite
MoveDownStep:
    INC position_y
    JSR _AfterStep
    BNE MoveDownStep
    JMP UpdatePosition

MoveLeft:
    LDA #$41
    STA flip
    LDA #$01
    STA sprite
MoveLeftStep:
    DEC position_x
    JSR _AfterStep
    BNE MoveLeftStep
    JMP UpdatePosition

MoveRight:
    LDA #$01
    STA flip
    LDA #$01
    STA sprite
MoveRightStep:
    INC position_x
    JSR _AfterStep
    BNE MoveRightStep
    JMP UpdatePosition

UpdatePosition:
    LDA sprite
    STA $0201
    LDA flip
    STA $0202

    LDA position_x
    SEC
    SBC #$04
    STA $0203

    LDA position_y
    SEC
    SBC #$07
    STA $0200

MainLoopEnd:
    RTI             ; return from interrupt

;;;;;;;;;;;;;;


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
; if direction = 1, 2, check y collision
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

__CollisionCheck:
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

;;;;;;;;;;;;;;;;
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
    ;STY direction
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
    JSR _Divide
    JSR _Multiply
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
    .db $19,$02,$04,$1D,  $22,$36,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F ; background
    .db $01,$1C,$15,$24,  $22,$02,$12,$3C,  $22,$1C,$15,$14,  $22,$02,$38,$3C ; sprites


sprites:
    .db $80, $01, $00, $80

tiles:
    .db $30, $24, $34, $34, $38, $3C

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
