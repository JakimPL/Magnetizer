;;;;;;;;;;;;;;;;;
;; subroutines ;;
;;;;;;;;;;;;;;;;;

;; x as arguments ;;
_PreparePPU:
    LDA PPUSTATUS
    LDA ppu_shift
    STA PPUADDR
    STX PPUADDR
    LDA #$00
    STA PPUADDR
    RTS

;; x as argument ;;
_ShiftPPU:
    LDA PPUDATA
    DEX
    BNE _ShiftPPU
    RTS

;; x, y as arguments ;;
_MovePPU:
    LDA #%10010100
    STA PPUCTRL

    CPX #$00
    BEQ _MovePPUChangeFlag
_MovePPUX:
    JSR _ShiftPPU

_MovePPUChangeFlag:
    LDA #%10010000
    STA PPUCTRL

    TYA
    TAX
    CPX #$00
    BNE _MovePPUY
    RTS
_MovePPUY:
    JSR _ShiftPPU
    RTS

_DrawSingleTilePart:
    LDA target_tile
    STA PPUDATA
    INC target_tile
    RTS

_DrawSingleTile
    JSR _DrawSingleTilePart
    JSR _DrawSingleTilePart

    LDX #$1E
    JSR _ShiftPPU

    JSR _DrawSingleTilePart
    JSR _DrawSingleTilePart
    RTS

_SetLevelPointer:
    LDA level_lo
    STA pointer_lo

    LDA level_hi
    STA pointer_hi
    RTS

_LoadBackground:
    LDA #$20
    STA ppu_shift
    LDX #$00
    JSR _PreparePPU

    JSR _SetLevelPointer

    LDY #$00
_LoadBackgroundInsideLoop:
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

;; x as argument ;;
_PrepareAttributePPU:
    LDA PPUSTATUS
    LDA #$23
    STA PPUADDR
    LDX PPUADDR
    RTS

_LoadAttributes:
    LDX #$C0
    JSR _PrepareAttributePPU
    JSR _SetLevelPointer

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
    JSR _ResetMoveCounter
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
    ; subject for optimization (stack) ;
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

_BoxCheckEnd:
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


_ResetBoxSwap:
    LDA #$FF
    STA source_box
    STA target_box
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
    STY increase_counter
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

_DrawMoveCounter:
    LDX #$00
_DrawMoveCounterStep:
    DEC ppu_shift
    LDA move_counter, x
    STA PPUDATA
    INX
    CPX #COUNTER_DIGITS
    BNE _DrawMoveCounterStep
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
