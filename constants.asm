    .bank 3
    .org $FE00

sprites:
    ;; magnetizer ;;
    .db $F0, $00, $01, $E0
    .db $F0, $01, $01, $E8
    .db $F8, $00, $81, $E0
    .db $F8, $01, $81, $E8

    ;; start ;;
    .db $F0, $04, $03, $E0
    .db $F0, $04, $43, $E8
    .db $F8, $04, $83, $E0
    .db $F8, $04, $C3, $E8

    ;; end ;;
    .db $F0, $04, $02, $00
    .db $F0, $04, $42, $08
    .db $F8, $04, $82, $00
    .db $F8, $04, $C2, $08

cursor:
    .db $80, $0B, $00, $16

tiles:
    .db $30, $24, $24, $24, $38, $3C, $40, $44, $48, $4C, $50, $50, $54, $58, $5C, $68, $60, $70

attributes:
    .db $00, $00, $00, $00, $00, $03, $00, $00, $00, $00, $01, $02, $00, $00, $02, $01, $00, $00

solid
    .db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

box_solid
    .db $01, $00, $00, $00, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $01


logo_offsets:
    .db $83, $A3, $C3, $E3


attribute_offsets:
    .db $11, $10, $01, $00

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

electric_sprite:
    .db $14, $14, $0C, $0C

electric_offset_x:
    .db $FC, $FC, $F8, $01

electric_offset_y:
    .db $F8, $01, $FC, $FC


medal_sprites:
    .db $1C, $1D, $1E


text_ranges:
    .db $00, $04, $08, $0A, $0B

text_levels_y_offsets:
    .db $21, $22, $22, $22, $22, $22, $22, $22, $22, $23

text_levels_x_offsets:
    .db $E4, $04, $24, $44, $64, $84, $A4, $C4, $E4, $04

texts:
text_level:
    .db $06, $15, $0E, $1F, $0E, $15, $2C

text_score:
    .db $06, $1C, $0C, $18, $1B, $0E, $2A

text_levels:
    .db $07, $15, $0E, $1F, $0E, $15, $1C, $2A

text_total:
    .db $06, $1D, $18, $1D, $0A, $15, $2A

text_fake_1:
    .db $0C, $26, $27, $26, $27, $26, $27, $26, $27, $26, $27, $26, $27

text_fake_2:
    .db $0C, $24, $25, $24, $25, $24, $25, $24, $25, $24, $25, $24, $25

songs:
    .db $00, $00, $00, $01, $01, $01

level_set_count:
    .db $0A, $09, $0A, $06, $07, $06

levels_to_unlock:
    .db $00, $05, $0A, $14, $1A, $24

medals:
    .db $0F, $12, $11, $10, $10, $16, $07, $24, $22, $48
    .db $17, $19, $23, $4F, $25, $50, $52, $47, $0C
    .db $29, $51, $15, $60, $42, $18, $76, $29, $3D, $1E
    .db $43, $50, $23, $44, $4D, $40
    .db $13, $34, $22, $15, $40, $57, $28
    .db $7C, $66, $6E, $78, $C2, $89

labels_offsets:
    .db $00, $0F, $1E, $2D, $3C, $4B, $5A

level_set_labels:
    .db $0E, $1D, $11, $0E, $25, $0B, $0E, $10, $12, $17, $17, $12, $17, $10, $1C
    .db $0E, $0F, $0A, $17, $0C, $22, $25, $0B, $15, $18, $0C, $14, $1C, $24, $25
    .db $0E, $17, $0A, $1B, $1B, $18, $20, $24, $1D, $1E, $17, $17, $0E, $15, $1C
    .db $0E, $1C, $0A, $17, $0D, $1C, $1D, $18, $1B, $16, $25, $24, $25, $24, $25
    .db $0E, $10, $11, $18, $1C, $1D, $15, $22, $25, $1B, $18, $18, $16, $1C, $25
    .db $0E, $16, $0A, $1C, $1D, $0E, $1B, $16, $12, $17, $0D, $24, $25, $24, $25
