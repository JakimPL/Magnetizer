    .bank 3
	.org $E000

;this file for FamiTone2 library generated by text2data tool

music_music_data:
	.db 3
	.dw .instruments
	.dw .samples-3
	.dw .song0ch0,.song0ch1,.song0ch2,.song0ch3,.song0ch4,389,324
	.dw .song1ch0,.song1ch1,.song1ch2,.song1ch3,.song1ch4,276,230
	.dw .song2ch0,.song2ch1,.song2ch2,.song2ch3,.song2ch4,337,281

.instruments:
	.db $70 ;instrument $00
	.dw .env1,.env0,.env16
	.db $00
	.db $70 ;instrument $01
	.dw .env9,.env0,.env0
	.db $00
	.db $F0 ;instrument $02
	.dw .env2,.env0,.env16
	.db $00
	.db $30 ;instrument $03
	.dw .env4,.env13,.env0
	.db $00
	.db $70 ;instrument $04
	.dw .env5,.env14,.env0
	.db $00
	.db $B0 ;instrument $05
	.dw .env3,.env0,.env17
	.db $00
	.db $30 ;instrument $06
	.dw .env6,.env0,.env0
	.db $00
	.db $70 ;instrument $07
	.dw .env7,.env0,.env16
	.db $00
	.db $F0 ;instrument $08
	.dw .env8,.env0,.env17
	.db $00
	.db $30 ;instrument $09
	.dw .env4,.env13,.env0
	.db $00
	.db $30 ;instrument $0A
	.dw .env6,.env0,.env0
	.db $00
	.db $30 ;instrument $0B
	.dw .env4,.env15,.env0
	.db $00
	.db $30 ;instrument $0C
	.dw .env10,.env0,.env19
	.db $00
	.db $B0 ;instrument $0D
	.dw .env11,.env0,.env0
	.db $00
	.db $B0 ;instrument $0E
	.dw .env3,.env0,.env18
	.db $00
	.db $B0 ;instrument $0F
	.dw .env12,.env0,.env0
	.db $00

.samples:
.env0:
	.db $C0, $00, $00
.env1:
	.db $CA, $C9, $C9, $C8, $C7, $C6, $C5, $C4, $C2, $C1, $00, $09
.env2:
	.db $CA, $C9, $C8, $C7, $C6, $C5, $C4, $00, $06
.env3:
	.db $C1, $C2, $C4, $C6, $C7, $00, $04
.env4:
	.db $CE, $CB, $C9, $C7, $C6, $00, $04
.env5:
	.db $C9, $CA, $CA, $C8, $C6, $C4, $C3, $00, $06
.env6:
	.db $C9, $C3, $C2, $C1, $C1, $C0, $00, $05
.env7:
	.db $C4, $C4, $C3, $C3, $C2, $C2, $C1, $00, $06
.env8:
	.db $C1, $C1, $C2, $C2, $00, $03
.env9:
	.db $C3, $C2, $C1, $C0, $00, $03
.env10:
	.db $CA, $CA, $C9, $C8, $C8, $C7, $C6, $C6, $C5, $C5, $C4, $C3, $C3, $C2, $C1, $00
	.db $0E
.env11:
	.db $C9, $C8, $C7, $C6, $C5, $C4, $C4, $C3, $C3, $C2, $C2, $C1, $00, $0B
.env12:
	.db $C2, $C1, $00, $01
.env13:
	.db $C7, $C2, $C0, $B9, $B6, $B4, $00, $05
.env14:
	.db $C0, $B4, $00, $01
.env15:
	.db $CC, $C7, $C0, $B9, $B4, $00, $00
.env16:
	.db $C0, $C1, $C1, $C0, $00, $03
.env17:
	.db $C0, $08, $BE, $BE, $C0, $00, $02
.env18:
	.db $BF, $BE, $BD, $BC, $BB, $BA, $B9, $B8, $B7, $B6, $B5, $B4, $B3, $B2, $B1, $AF
	.db $AD, $AB, $A9, $A7, $A7, $A5, $A7, $00, $14
.env19:
	.db $C1, $C3, $C4, $00, $00


.song0ch0:
	.db $FB, $06
.song0ch0loop:
.ref0:
	.db $80, $21, $35, $39, $21, $35, $39, $21, $35, $39, $21, $35, $39, $3F, $39, $3F
	.db $42, $81
.ref1:
	.db $21, $35, $39, $21, $35, $39, $21, $35, $39, $21, $35, $39, $2F, $35, $2F, $2A
	.db $81
.ref2:
	.db $21, $35, $39, $21, $35, $39, $21, $35, $39, $21, $35, $39, $3F, $39, $3F, $42
	.db $81
.ref3:
	.db $21, $35, $39, $21, $35, $39, $21, $43, $47, $43, $35, $3D, $3F, $3D, $2B, $34
	.db $81
	.db $FF, $11
	.dw .ref2
	.db $FF, $11
	.dw .ref1
	.db $FF, $11
	.dw .ref2
	.db $FF, $11
	.dw .ref3
	.db $FF, $11
	.dw .ref2
	.db $FF, $11
	.dw .ref1
	.db $FF, $11
	.dw .ref2
	.db $FF, $11
	.dw .ref3
	.db $FF, $11
	.dw .ref2
	.db $FF, $11
	.dw .ref1
	.db $FF, $11
	.dw .ref2
	.db $FF, $11
	.dw .ref3
.ref16:
	.db $88, $69, $21, $21, $5B, $13, $2B, $5F, $21, $21, $8A, $09, $21, $09, $21, $09
	.db $20, $83, $00
.ref17:
	.db $88, $51, $2B, $21, $51, $21, $21, $57, $21, $1D, $21, $51, $21, $51, $8A, $21
	.db $39, $2A, $81
.ref18:
	.db $88, $69, $21, $21, $6F, $2B, $2B, $69, $21, $21, $8A, $09, $21, $09, $21, $09
	.db $21, $88, $20, $81
.ref19:
	.db $5B, $2B, $21, $57, $21, $21, $55, $47, $43, $2F, $57, $84, $2F, $88, $55, $8A
	.db $1D, $35, $2A, $81
	.db $FF, $11
	.dw .ref16
	.db $FF, $11
	.dw .ref17
	.db $FF, $11
	.dw .ref18
	.db $FF, $11
	.dw .ref19
.ref24:
	.db $21, $2F, $39, $47, $21, $2F, $39, $43, $2E, $00, $38, $00, $3E, $00, $38, $00
	.db $46, $00, $50, $00, $54, $00, $38, $81
.ref25:
	.db $2F, $39, $47, $21, $2F, $39, $43, $21, $2E, $00, $38, $00, $4C, $00, $2E, $00
	.db $39, $3D, $01, $20, $81
.ref26:
	.db $2B, $2B, $35, $43, $1D, $2B, $35, $3F, $2A, $00, $34, $00, $3C, $00, $1C, $00
	.db $2A, $00, $34, $00, $38, $00, $1C, $81
.ref27:
	.db $2B, $35, $43, $1D, $2B, $35, $3F, $1D, $2A, $00, $34, $00, $3C, $00, $1C, $00
	.db $34, $00, $39, $90, $35, $38, $81
.ref28:
	.db $8A, $21, $2F, $39, $47, $21, $2F, $39, $43, $2E, $00, $38, $00, $3E, $00, $38
	.db $00, $46, $00, $50, $00, $54, $00, $38, $81
	.db $FF, $15
	.dw .ref25
	.db $FF, $18
	.dw .ref26
	.db $FF, $16
	.dw .ref27
	.db $FF, $18
	.dw .ref28
	.db $FF, $15
	.dw .ref25
	.db $FF, $18
	.dw .ref26
	.db $FF, $16
	.dw .ref27
	.db $FF, $18
	.dw .ref28
	.db $FF, $15
	.dw .ref25
	.db $FF, $18
	.dw .ref26
	.db $FF, $16
	.dw .ref27
	.db $FD
	.dw .song0ch0loop

.song0ch1:
.song0ch1loop:
.ref40:
	.db $00, $BD
.ref41:
	.db $00, $BD
.ref42:
	.db $84, $39, $21, $09, $51, $1D, $09, $8E, $21, $09, $00, $9D
.ref43:
	.db $00, $BD
	.db $FF, $0A
	.dw .ref42
.ref45:
	.db $00, $BD
.ref46:
	.db $84, $39, $21, $09, $51, $1D, $09, $8E, $21, $09, $01, $8A, $21, $39, $21, $39
	.db $21, $38, $83, $00
.ref47:
	.db $84, $39, $21, $09, $51, $1D, $09, $8E, $21, $09, $01, $8A, $43, $1D, $3D, $35
	.db $01, $43, $2A, $00
	.db $FF, $11
	.dw .ref46
.ref49:
	.db $84, $39, $21, $09, $51, $1D, $09, $8E, $21, $09, $01, $8A, $39, $3F, $21, $47
	.db $01, $39, $00, $81
	.db $FF, $11
	.dw .ref46
	.db $FF, $11
	.dw .ref47
	.db $FF, $11
	.dw .ref46
	.db $FF, $11
	.dw .ref49
	.db $FF, $11
	.dw .ref46
	.db $FF, $11
	.dw .ref47
.ref56:
	.db $88, $5F, $00, $85, $4D, $00, $85, $57, $00, $A1
.ref57:
	.db $5B, $00, $85, $57, $00, $85, $4D, $00, $89, $56, $85, $57, $01, $5B, $00, $81
.ref58:
	.db $5F, $00, $85, $4D, $00, $85, $57, $00, $A1
.ref59:
	.db $51, $00, $85, $51, $00, $85, $4D, $00, $89, $51, $01, $4D, $01, $43, $00, $81
	.db $FF, $09
	.dw .ref58
	.db $FF, $10
	.dw .ref57
	.db $FF, $09
	.dw .ref58
	.db $FF, $10
	.dw .ref59
.ref64:
	.db $81, $90, $21, $2F, $39, $47, $21, $2F, $39, $43, $2E, $00, $38, $00, $3E, $00
	.db $38, $00, $46, $00, $50, $00, $54, $00, $38
.ref65:
	.db $81, $2F, $39, $47, $21, $2F, $39, $43, $21, $2E, $00, $38, $00, $4C, $00, $2E
	.db $00, $39, $3D, $01, $20
.ref66:
	.db $81, $2B, $2B, $35, $43, $1D, $2B, $35, $3F, $2A, $00, $34, $00, $3C, $00, $1C
	.db $00, $2A, $00, $34, $00, $38, $00, $1C
.ref67:
	.db $81, $2B, $35, $43, $1D, $2B, $35, $3F, $1D, $2A, $00, $34, $00, $3C, $00, $1C
	.db $00, $34, $00, $39, $01, $1C
.ref68:
	.db $81, $21, $2F, $39, $47, $21, $2F, $39, $43, $2E, $00, $38, $00, $3E, $00, $38
	.db $00, $46, $00, $50, $00, $54, $00, $38
	.db $FF, $15
	.dw .ref65
	.db $FF, $18
	.dw .ref66
	.db $FF, $16
	.dw .ref67
.ref72:
	.db $84, $08, $89, $08, $89, $20, $85, $08, $89, $21, $17, $21, $25, $20, $81
.ref73:
	.db $00, $85, $09, $08, $89, $20, $85, $16, $89, $17, $21, $25, $01, $08, $81
.ref74:
	.db $12, $89, $12, $89, $1C, $85, $12, $89, $05, $13, $1D, $21, $1C, $81
.ref75:
	.db $00, $85, $09, $08, $89, $20, $85, $2B, $8A, $17, $2F, $17, $84, $1D, $39, $05
	.db $00, $81
.ref76:
	.db $08, $89, $08, $89, $20, $85, $08, $89, $21, $17, $21, $25, $20, $81
	.db $FF, $0F
	.dw .ref73
	.db $FF, $0E
	.dw .ref74
.ref79:
	.db $00, $85, $09, $08, $89, $20, $85, $2B, $8A, $17, $2F, $16, $00, $8F
	.db $FD
	.dw .song0ch1loop

.song0ch2:
.song0ch2loop:
.ref80:
	.db $00, $BD
.ref81:
	.db $00, $BD
.ref82:
	.db $00, $BD
.ref83:
	.db $00, $BD
.ref84:
	.db $00, $BD
.ref85:
	.db $00, $BD
.ref86:
	.db $00, $BD
.ref87:
	.db $00, $BD
.ref88:
	.db $86, $38, $00, $8B, $38, $00, $8B, $38, $00, $8B, $38, $00, $8B
.ref89:
	.db $38, $00, $8B, $38, $00, $8B, $38, $00, $8B, $38, $00, $8B
	.db $FF, $0C
	.dw .ref89
.ref91:
	.db $38, $00, $8B, $38, $00, $8B, $38, $00, $83, $38, $00, $38, $89, $38, $00, $83
	.db $FF, $0C
	.dw .ref89
	.db $FF, $0C
	.dw .ref89
	.db $FF, $0C
	.dw .ref89
	.db $FF, $10
	.dw .ref91
.ref96:
	.db $38, $00, $8B, $38, $00, $8B, $38, $00, $9B
	.db $FF, $0C
	.dw .ref89
	.db $FF, $09
	.dw .ref96
	.db $FF, $10
	.dw .ref91
	.db $FF, $09
	.dw .ref96
	.db $FF, $0C
	.dw .ref89
	.db $FF, $09
	.dw .ref96
	.db $FF, $10
	.dw .ref91
.ref104:
	.db $00, $BD
.ref105:
	.db $00, $BD
.ref106:
	.db $00, $BD
.ref107:
	.db $AB, $34, $34, $35, $35, $34, $85
.ref108:
	.db $38, $8D, $92, $38, $85, $21, $21, $86, $39, $00, $85, $92, $38, $85, $21, $00
	.db $85
.ref109:
	.db $87, $86, $39, $92, $39, $38, $85, $21, $21, $86, $2E, $89, $92, $2E, $85, $17
	.db $01, $12, $81
.ref110:
	.db $86, $2A, $8D, $92, $2B, $01, $13, $13, $86, $39, $00, $85, $92, $34, $85, $1D
	.db $00, $85
.ref111:
	.db $87, $86, $35, $92, $35, $34, $85, $1D, $1D, $86, $2F, $92, $2F, $86, $34, $34
	.db $35, $00, $8D
	.db $FF, $0E
	.dw .ref108
	.db $FF, $0F
	.dw .ref109
	.db $FF, $0E
	.dw .ref110
.ref115:
	.db $87, $86, $35, $92, $35, $34, $85, $1D, $1D, $86, $2F, $92, $2E, $89, $86, $34
	.db $34, $35, $35, $34, $81
	.db $FF, $0E
	.dw .ref108
	.db $FF, $0F
	.dw .ref109
	.db $FF, $0E
	.dw .ref110
	.db $FF, $0E
	.dw .ref111
	.db $FD
	.dw .song0ch2loop

.song0ch3:
.song0ch3loop:
.ref120:
	.db $00, $BD
.ref121:
	.db $00, $BD
.ref122:
	.db $00, $BD
.ref123:
	.db $00, $A9, $8C, $17, $17, $17, $11, $0A, $81
.ref124:
	.db $00, $8D, $14, $00, $9B, $14, $00, $8B
	.db $FF, $08
	.dw .ref124
	.db $FF, $08
	.dw .ref124
.ref127:
	.db $00, $8D, $14, $00, $93, $15, $17, $96, $10, $00, $8C, $13, $07, $0A, $81
.ref128:
	.db $01, $82, $15, $8C, $19, $82, $15, $96, $10, $00, $8C, $17, $19, $1B, $01, $82
	.db $15, $8C, $19, $82, $15, $96, $10, $00, $8C, $17, $17, $96, $0E, $00
	.db $FF, $13
	.dw .ref128
	.db $FF, $13
	.dw .ref128
.ref131:
	.db $01, $82, $15, $8C, $19, $82, $15, $96, $10, $00, $8C, $17, $19, $1B, $01, $82
	.db $15, $8C, $19, $82, $15, $96, $10, $00, $8C, $17, $86, $0D, $8C, $06, $00
.ref132:
	.db $00, $BD
.ref133:
	.db $00, $BD
.ref134:
	.db $00, $BD
.ref135:
	.db $00, $BD
.ref136:
	.db $8F, $96, $12, $00, $97, $8C, $0B, $96, $10, $00, $8C, $10, $10, $11, $10, $81
.ref137:
	.db $00, $8D, $96, $12, $00, $83, $8C, $1B, $1B, $1B, $00, $85, $0B, $96, $10, $00
	.db $87, $18, $00
.ref138:
	.db $8F, $12, $00, $97, $8C, $0B, $96, $10, $00, $8C, $10, $10, $11, $10, $81
.ref139:
	.db $00, $89, $1B, $86, $12, $00, $8C, $17, $00, $85, $82, $15, $15, $8C, $12, $14
	.db $17, $17, $17, $11, $0A, $81
	.db $FF, $13
	.dw .ref128
	.db $FF, $13
	.dw .ref128
	.db $FF, $13
	.dw .ref128
	.db $FF, $13
	.dw .ref131
.ref144:
	.db $00, $BD
.ref145:
	.db $00, $BD
.ref146:
	.db $00, $BD
.ref147:
	.db $AB, $12, $14, $17, $17, $17, $10, $81
.ref148:
	.db $94, $06, $1E, $8C, $19, $15, $82, $15, $96, $17, $94, $11, $8C, $18, $00, $82
	.db $14, $85, $8C, $17, $94, $1F, $01, $96, $17, $82, $15, $8C, $18, $00, $92, $12
	.db $81
.ref149:
	.db $01, $8C, $10, $10, $11, $82, $15, $96, $17, $94, $11, $8C, $18, $00, $82, $14
	.db $85, $8C, $17, $94, $1F, $8C, $19, $96, $17, $94, $1F, $8C, $18, $00, $92, $12
	.db $81
	.db $FF, $14
	.dw .ref148
.ref151:
	.db $01, $8C, $10, $10, $11, $19, $96, $17, $94, $1F, $8C, $18, $00, $1B, $12, $14
	.db $17, $94, $1F, $1D, $84, $1C, $00, $8B
	.db $FF, $14
	.dw .ref148
	.db $FF, $14
	.dw .ref149
	.db $FF, $14
	.dw .ref148
.ref155:
	.db $01, $8C, $10, $10, $11, $19, $01, $82, $15, $8C, $18, $00, $1A, $85, $17, $94
	.db $1F, $8C, $12, $14, $17, $17, $17, $10, $81
	.db $FF, $14
	.dw .ref148
	.db $FF, $14
	.dw .ref149
	.db $FF, $14
	.dw .ref148
	.db $FF, $12
	.dw .ref151
	.db $FD
	.dw .song0ch3loop

.song0ch4:
.song0ch4loop:
.ref160:
	.db $BF
.ref161:
	.db $BF
.ref162:
	.db $BF
.ref163:
	.db $BF
.ref164:
	.db $BF
.ref165:
	.db $BF
.ref166:
	.db $BF
.ref167:
	.db $BF
.ref168:
	.db $BF
.ref169:
	.db $BF
.ref170:
	.db $BF
.ref171:
	.db $BF
.ref172:
	.db $BF
.ref173:
	.db $BF
.ref174:
	.db $BF
.ref175:
	.db $BF
.ref176:
	.db $BF
.ref177:
	.db $BF
.ref178:
	.db $BF
.ref179:
	.db $BF
.ref180:
	.db $BF
.ref181:
	.db $BF
.ref182:
	.db $BF
.ref183:
	.db $BF
.ref184:
	.db $BF
.ref185:
	.db $BF
.ref186:
	.db $BF
.ref187:
	.db $BF
.ref188:
	.db $BF
.ref189:
	.db $BF
.ref190:
	.db $BF
.ref191:
	.db $BF
.ref192:
	.db $BF
.ref193:
	.db $BF
.ref194:
	.db $BF
.ref195:
	.db $BF
.ref196:
	.db $BF
.ref197:
	.db $BF
.ref198:
	.db $BF
.ref199:
	.db $BF
	.db $FD
	.dw .song0ch4loop


.song1ch0:
	.db $FB, $06
.song1ch0loop:
.ref200:
	.db $9A, $51, $47, $4D, $47, $3E, $85, $43, $4D, $51, $47, $4D, $43, $47, $3F, $43
	.db $46, $81
.ref201:
	.db $51, $47, $4D, $47, $3E, $85, $43, $4D, $51, $47, $4D, $43, $47, $35, $39, $3C
	.db $81
.ref202:
	.db $51, $47, $4D, $47, $3E, $85, $43, $4D, $51, $47, $4D, $43, $47, $3F, $43, $46
	.db $81
.ref203:
	.db $51, $47, $4D, $47, $3E, $85, $43, $4D, $51, $47, $4D, $43, $31, $35, $39, $3C
	.db $81
	.db $FF, $11
	.dw .ref202
	.db $FF, $11
	.dw .ref201
	.db $FF, $11
	.dw .ref202
	.db $FF, $11
	.dw .ref203
	.db $FF, $11
	.dw .ref202
	.db $FF, $11
	.dw .ref201
	.db $FF, $11
	.dw .ref202
	.db $FF, $11
	.dw .ref203
	.db $FF, $11
	.dw .ref202
	.db $FF, $11
	.dw .ref201
	.db $FF, $11
	.dw .ref202
	.db $FF, $11
	.dw .ref203
.ref216:
	.db $00, $BD
.ref217:
	.db $81, $8E, $50, $80, $51, $51, $00, $50, $00, $4C, $50, $00, $90, $4C, $50, $00
	.db $83, $8E, $50, $80, $51, $51, $00, $50, $00, $4C, $50, $00, $56, $8E, $56, $00
	.db $81
.ref218:
	.db $81, $50, $80, $51, $51, $00, $50, $00, $4C, $50, $00, $90, $4C, $50, $00, $83
	.db $8E, $50, $80, $47, $4D, $00, $4C, $00, $46, $56, $00, $54, $8E, $42, $80, $46
	.db $00
	.db $FF, $1B
	.dw .ref217
.ref220:
	.db $81, $50, $80, $51, $51, $00, $50, $00, $4C, $50, $00, $90, $4C, $50, $00, $83
	.db $8E, $50, $80, $51, $51, $00, $50, $00, $4C, $50, $00, $87
	.db $FF, $1B
	.dw .ref217
	.db $FF, $1B
	.dw .ref218
	.db $FF, $1B
	.dw .ref217
	.db $FF, $18
	.dw .ref220
.ref225:
	.db $00, $BD
.ref226:
	.db $9C, $08, $83, $00, $08, $00, $83, $08, $83, $00, $08, $00, $83, $08, $83, $00
	.db $08, $00, $83, $08, $83, $00, $08, $00, $83
.ref227:
	.db $0E, $83, $00, $0E, $00, $83, $0E, $83, $00, $0E, $00, $83, $16, $83, $00, $16
	.db $00, $83, $16, $83, $00, $16, $00, $83
.ref228:
	.db $08, $83, $00, $08, $00, $83, $08, $83, $00, $08, $00, $83, $08, $83, $00, $08
	.db $00, $83, $08, $83, $00, $08, $00, $83
.ref229:
	.db $0E, $83, $00, $0E, $00, $83, $0E, $83, $00, $0E, $00, $83, $18, $83, $00, $18
	.db $00, $83, $18, $83, $00, $18, $00, $83
.ref230:
	.db $9A, $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $47, $3F, $94, $50, $4C, $9A
	.db $43, $4C, $94, $46, $9A, $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $43, $47
	.db $3E, $94, $38, $9A, $43, $46, $81
.ref231:
	.db $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $47, $3F, $94, $50, $4C, $9A, $43
	.db $4C, $94, $46, $9A, $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $43, $47, $34
	.db $94, $38, $9A, $39, $3C, $81
.ref232:
	.db $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $47, $3F, $94, $50, $4C, $9A, $43
	.db $4C, $94, $46, $9A, $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $43, $47, $3E
	.db $94, $38, $9A, $43, $46, $81
.ref233:
	.db $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $47, $3F, $94, $50, $4C, $9A, $43
	.db $4C, $94, $46, $9A, $51, $46, $94, $08, $9A, $4C, $94, $38, $9A, $43, $47, $90
	.db $47, $47, $00, $81
	.db $FD
	.dw .song1ch0loop

.song1ch1:
.song1ch1loop:
.ref234:
	.db $00, $83, $9E, $51, $47, $4D, $47, $3E, $85, $43, $4D, $51, $47, $4D, $43, $47
	.db $3F, $42
.ref235:
	.db $81, $47, $51, $47, $4D, $47, $3E, $85, $43, $4D, $51, $47, $4D, $43, $47, $35
	.db $38
.ref236:
	.db $94, $51, $21, $34, $38, $69, $20, $38, $21, $00, $38, $00, $20, $51, $21, $34
	.db $38, $69, $20, $38, $21, $3E, $26, $26, $56
.ref237:
	.db $51, $21, $34, $38, $69, $20, $38, $21, $00, $38, $00, $20, $50, $80, $08, $18
	.db $00, $18, $30, $18, $18, $30, $18, $00, $18, $00, $85
	.db $FF, $18
	.dw .ref236
.ref239:
	.db $51, $21, $34, $38, $69, $20, $38, $21, $00, $38, $00, $20, $51, $2F, $46, $2E
	.db $77, $5E, $2E, $47, $16, $2E, $16, $46
.ref240:
	.db $51, $21, $34, $38, $69, $20, $38, $21, $00, $38, $00, $20, $51, $21, $34, $38
	.db $69, $20, $38, $21, $3E, $26, $26, $56
	.db $FF, $1A
	.dw .ref237
.ref242:
	.db $94, $50, $80, $08, $20, $00, $08, $20, $08, $20, $00, $20, $94, $21, $00, $38
	.db $00, $20, $50, $80, $08, $21, $08, $20, $08, $20, $08, $20, $94, $20, $80, $20
	.db $94, $3E, $80, $0E, $26, $0E
.ref243:
	.db $94, $50, $80, $08, $20, $00, $08, $20, $08, $20, $00, $20, $94, $21, $00, $38
	.db $00, $20, $50, $80, $08, $17, $16, $2E, $16, $16, $2E, $16, $94, $46, $80, $16
	.db $94, $16, $80, $1C, $16, $16
	.db $FF, $1E
	.dw .ref242
.ref245:
	.db $94, $50, $80, $08, $20, $00, $08, $20, $08, $20, $00, $20, $94, $21, $00, $38
	.db $00, $20, $50, $80, $08, $18, $00, $18, $30, $18, $18, $30, $18, $00, $18, $00
	.db $85
	.db $FF, $1E
	.dw .ref242
	.db $FF, $1E
	.dw .ref243
	.db $FF, $1E
	.dw .ref242
	.db $FF, $1D
	.dw .ref245
.ref250:
	.db $94, $50, $80, $08, $20, $00, $08, $20, $08, $20, $94, $50, $80, $08, $20, $00
	.db $08, $20, $08, $20, $94, $50, $80, $08, $20, $00, $08, $20, $08, $20, $94, $50
	.db $80, $08, $20, $00, $08, $20, $08, $20
	.db $FF, $1E
	.dw .ref242
	.db $FF, $1E
	.dw .ref243
	.db $FF, $1E
	.dw .ref242
	.db $FF, $1D
	.dw .ref245
	.db $FF, $1E
	.dw .ref242
	.db $FF, $1E
	.dw .ref243
	.db $FF, $1E
	.dw .ref242
	.db $FF, $1D
	.dw .ref245
	.db $FF, $20
	.dw .ref250
	.db $FF, $20
	.dw .ref250
.ref261:
	.db $94, $56, $80, $0E, $26, $00, $0E, $26, $0E, $26, $94, $56, $80, $0E, $26, $00
	.db $0E, $26, $0E, $26, $94, $54, $80, $0C, $24, $00, $0C, $24, $0C, $24, $94, $54
	.db $80, $0C, $24, $00, $0C, $24, $0C, $24
	.db $FF, $20
	.dw .ref250
.ref263:
	.db $94, $56, $80, $0E, $26, $00, $0E, $26, $0E, $26, $94, $56, $80, $0E, $26, $00
	.db $0E, $26, $0E, $26, $94, $48, $80, $18, $18, $00, $18, $18, $18, $18, $94, $48
	.db $80, $18, $18, $00, $18, $18, $18, $18
	.db $FF, $20
	.dw .ref250
	.db $FF, $20
	.dw .ref261
	.db $FF, $20
	.dw .ref250
.ref267:
	.db $94, $56, $80, $0E, $26, $00, $0E, $26, $0E, $26, $94, $56, $80, $0E, $26, $00
	.db $0E, $26, $0E, $26, $94, $48, $80, $18, $18, $00, $18, $18, $18, $18, $94, $48
	.db $80, $18, $18, $00, $87
	.db $FD
	.dw .song1ch1loop

.song1ch2:
.song1ch2loop:
.ref268:
	.db $00, $BD
.ref269:
	.db $00, $BD
.ref270:
	.db $00, $BD
.ref271:
	.db $80, $20, $A1, $30, $8D, $92, $31, $30, $85
.ref272:
	.db $80, $20, $B5, $26, $85
.ref273:
	.db $20, $A1, $2E, $99
.ref274:
	.db $20, $B5, $26, $85
.ref275:
	.db $20, $A1, $30, $8D, $92, $31, $30, $85
.ref276:
	.db $38, $85, $38, $85, $38, $85, $38, $85, $38, $85, $38, $85, $38, $85, $84, $26
	.db $85
.ref277:
	.db $92, $38, $85, $38, $85, $38, $85, $38, $85, $39, $84, $2F, $92, $2E, $85, $2E
	.db $85, $2E, $85
	.db $FF, $10
	.dw .ref276
.ref279:
	.db $92, $38, $85, $38, $85, $38, $85, $38, $85, $39, $84, $31, $92, $30, $85, $30
	.db $85, $30, $85
	.db $FF, $10
	.dw .ref276
	.db $FF, $10
	.dw .ref277
	.db $FF, $10
	.dw .ref276
	.db $FF, $10
	.dw .ref279
.ref284:
	.db $39, $00, $89, $39, $00, $89, $39, $01, $39, $01, $38, $00, $38, $00, $38, $38
	.db $38, $38
	.db $FF, $10
	.dw .ref276
	.db $FF, $10
	.dw .ref277
	.db $FF, $10
	.dw .ref276
	.db $FF, $10
	.dw .ref279
	.db $FF, $10
	.dw .ref276
	.db $FF, $10
	.dw .ref277
	.db $FF, $10
	.dw .ref276
	.db $FF, $10
	.dw .ref279
	.db $FF, $12
	.dw .ref284
.ref294:
	.db $38, $00, $8B, $38, $00, $8B, $38, $00, $8B, $38, $00, $83, $84, $08, $85
.ref295:
	.db $92, $38, $00, $8B, $38, $00, $8B, $38, $00, $83, $84, $17, $01, $92, $38, $00
	.db $83, $84, $16, $85
.ref296:
	.db $92, $38, $00, $8B, $38, $00, $8B, $38, $00, $8B, $38, $00, $83, $84, $08, $85
.ref297:
	.db $92, $38, $00, $8B, $38, $00, $8B, $38, $00, $83, $84, $19, $01, $92, $38, $00
	.db $83, $84, $30, $85
	.db $FF, $0E
	.dw .ref296
	.db $FF, $10
	.dw .ref295
	.db $FF, $0E
	.dw .ref296
.ref301:
	.db $92, $38, $00, $8B, $38, $00, $8B, $38, $00, $83, $84, $19, $01, $92, $38, $00
	.db $8B
	.db $FD
	.dw .song1ch2loop

.song1ch3:
.song1ch3loop:
.ref302:
	.db $BF
.ref303:
	.db $BF
.ref304:
	.db $BF
.ref305:
	.db $B3, $8C, $0A, $0A, $98, $0A, $0A, $8C, $12, $81
.ref306:
	.db $BF
.ref307:
	.db $BF
.ref308:
	.db $BF
.ref309:
	.db $B3, $0A, $0A, $98, $0A, $0A, $8C, $12, $81
.ref310:
	.db $94, $1C, $1C, $82, $1C, $1C, $96, $1C, $01, $82, $1C, $94, $1C, $1C, $82, $1C
	.db $1C, $96, $1C, $01, $82, $1C, $94, $1C, $1C, $82, $1C, $1C, $96, $1C, $01, $82
	.db $1C, $94, $1C, $1C, $82, $1C, $1C, $96, $1C, $01, $82, $1C
.ref311:
	.db $94, $1C, $1C, $82, $1C, $1C, $96, $1C, $01, $82, $1C, $94, $1C, $1C, $82, $1C
	.db $1C, $96, $1C, $01, $82, $1C, $94, $1C, $1C, $82, $1C, $1C, $96, $1C, $01, $82
	.db $1C, $94, $1C, $1C, $8C, $0A, $0A, $98, $0A, $0A, $8C, $12, $81
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
.ref326:
	.db $94, $1C, $1C, $82, $1C, $1C, $96, $1C, $94, $1C, $8C, $0A, $0A, $94, $1C, $1C
	.db $82, $1C, $1C, $96, $1C, $94, $1C, $8C, $0A, $0A, $94, $1C, $1C, $82, $1C, $1C
	.db $96, $1C, $8C, $0A, $0A, $82, $1C, $8C, $0A, $0A, $98, $0A, $0A, $8C, $13, $00
	.db $81
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
	.db $FF, $1D
	.dw .ref311
	.db $FF, $1C
	.dw .ref310
.ref335:
	.db $94, $1C, $1C, $82, $1C, $1C, $96, $1C, $01, $82, $1C, $94, $1C, $1C, $82, $1C
	.db $1C, $96, $1C, $01, $82, $1C, $94, $1C, $1C, $82, $1C, $1C, $00, $83, $1C, $00
	.db $94, $1C, $8C, $0A, $0A, $98, $0A, $0A, $00, $81
	.db $FD
	.dw .song1ch3loop

.song1ch4:
.song1ch4loop:
.ref336:
	.db $BF
.ref337:
	.db $BF
.ref338:
	.db $BF
.ref339:
	.db $BF
.ref340:
	.db $BF
.ref341:
	.db $BF
.ref342:
	.db $BF
.ref343:
	.db $BF
.ref344:
	.db $BF
.ref345:
	.db $BF
.ref346:
	.db $BF
.ref347:
	.db $BF
.ref348:
	.db $BF
.ref349:
	.db $BF
.ref350:
	.db $BF
.ref351:
	.db $BF
.ref352:
	.db $BF
.ref353:
	.db $BF
.ref354:
	.db $BF
.ref355:
	.db $BF
.ref356:
	.db $BF
.ref357:
	.db $BF
.ref358:
	.db $BF
.ref359:
	.db $BF
.ref360:
	.db $BF
.ref361:
	.db $BF
.ref362:
	.db $BF
.ref363:
	.db $BF
.ref364:
	.db $BF
.ref365:
	.db $BF
.ref366:
	.db $BF
.ref367:
	.db $BF
.ref368:
	.db $BF
.ref369:
	.db $BF
	.db $FD
	.dw .song1ch4loop


.song2ch0:
	.db $FB, $06
.song2ch0loop:
.ref370:
	.db $9A, $39, $51, $38, $85, $4C, $85, $39, $46, $85, $39, $43, $39, $3F, $43, $3F
	.db $38, $81
.ref371:
	.db $39, $51, $38, $85, $4C, $85, $39, $46, $85, $47, $43, $3F, $43, $3F, $39, $00
	.db $81
.ref372:
	.db $39, $51, $38, $85, $4C, $85, $39, $46, $85, $39, $43, $39, $3F, $43, $3F, $38
	.db $81
.ref373:
	.db $39, $51, $38, $85, $2F, $35, $4D, $2E, $85, $47, $2F, $35, $39, $3F, $3D, $34
	.db $81
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref371
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref373
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref371
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref373
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref371
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref373
.ref386:
	.db $8A, $39, $01, $39, $01, $2B, $2F, $35, $39, $3F, $3D, $2F, $3F, $3D, $47, $39
	.db $90, $38, $00
.ref387:
	.db $81, $9E, $39, $39, $51, $38, $83, $8A, $38, $00, $3F, $42, $00, $9C, $42, $85
	.db $8A, $46, $8D, $90, $47, $00, $81
.ref388:
	.db $8A, $21, $35, $39, $3F, $3D, $39, $51, $57, $54, $00, $4C, $9E, $54, $8A, $46
	.db $9E, $4C, $8A, $4C, $9E, $46, $8A, $46, $9E, $4C, $8A, $38, $9E, $46, $8A, $50
	.db $9E, $38, $90, $50, $9E, $50
.ref389:
	.db $81, $39, $39, $51, $38, $83, $8A, $4C, $00, $4D, $50, $00, $47, $54, $85, $00
	.db $91
.ref390:
	.db $39, $01, $39, $01, $2B, $2F, $35, $39, $3F, $3D, $2F, $3F, $3D, $47, $39, $90
	.db $38, $00
	.db $FF, $12
	.dw .ref387
	.db $FF, $18
	.dw .ref388
	.db $FF, $10
	.dw .ref389
.ref394:
	.db $9E, $2E, $BD
.ref395:
	.db $2A, $BD
.ref396:
	.db $26, $BD
.ref397:
	.db $24, $BD
	.db $FF, $11
	.dw .ref370
	.db $FF, $11
	.dw .ref371
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref373
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref371
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref373
	.db $FD
	.dw .song2ch0loop

.song2ch1:
.song2ch1loop:
.ref406:
	.db $00, $83, $9E, $39, $51, $38, $85, $4C, $85, $39, $46, $85, $39, $43, $39, $3F
	.db $43, $3E
.ref407:
	.db $81, $39, $39, $51, $38, $85, $4C, $85, $39, $46, $85, $47, $43, $3F, $43, $3F
	.db $38
.ref408:
	.db $81, $01, $39, $51, $38, $85, $4C, $85, $39, $46, $85, $39, $43, $39, $3F, $43
	.db $3E
.ref409:
	.db $81, $39, $39, $51, $38, $85, $2F, $35, $4D, $2E, $85, $47, $2F, $35, $39, $3F
	.db $3C
.ref410:
	.db $00, $83, $39, $51, $38, $85, $4C, $85, $39, $46, $85, $39, $43, $39, $3F, $43
	.db $3E
	.db $FF, $11
	.dw .ref407
	.db $FF, $11
	.dw .ref408
	.db $FF, $11
	.dw .ref409
.ref414:
	.db $8A, $39, $90, $39, $8A, $39, $90, $39, $8A, $35, $90, $35, $8A, $35, $2E, $00
	.db $90, $2F, $8A, $2E, $00, $2A, $00, $27, $2B, $27, $20, $00, $90, $20, $00
.ref415:
	.db $81, $9E, $39, $39, $51, $38, $85, $4C, $85, $39, $46, $85, $47, $43, $3F, $43
	.db $3F, $38
.ref416:
	.db $8A, $39, $90, $39, $8A, $39, $90, $39, $8A, $35, $90, $35, $8A, $35, $2E, $00
	.db $90, $2F, $8A, $16, $00, $20, $00, $1D, $17, $0D, $08, $00, $90, $0C, $00
.ref417:
	.db $81, $9E, $39, $39, $51, $38, $85, $2F, $35, $4D, $2E, $85, $47, $2F, $35, $39
	.db $3F, $3C
	.db $FF, $15
	.dw .ref414
	.db $FF, $11
	.dw .ref415
	.db $FF, $15
	.dw .ref416
	.db $FF, $11
	.dw .ref417
	.db $FF, $11
	.dw .ref370
	.db $FF, $11
	.dw .ref371
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref373
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref371
	.db $FF, $11
	.dw .ref372
	.db $FF, $11
	.dw .ref373
.ref430:
	.db $9E, $34, $BD
.ref431:
	.db $34, $BD
.ref432:
	.db $20, $BD
.ref433:
	.db $20, $BD
.ref434:
	.db $84, $09, $09, $8E, $08, $00, $8B, $84, $09, $13, $8E, $08, $00, $8B, $90, $68
	.db $83, $00, $69, $00, $81
.ref435:
	.db $84, $09, $09, $8E, $08, $00, $8B, $84, $09, $13, $8E, $08, $00, $8B, $90, $5B
	.db $5F, $69, $00, $81
	.db $FF, $10
	.dw .ref434
.ref437:
	.db $84, $09, $09, $8E, $08, $00, $8B, $84, $09, $13, $8E, $08, $00, $83, $84, $2F
	.db $17, $17, $17, $17, $00, $81
.ref438:
	.db $09, $09, $8E, $08, $00, $8B, $84, $09, $13, $8E, $08, $00, $8B, $90, $68, $83
	.db $00, $69, $00, $81
	.db $FF, $0F
	.dw .ref435
	.db $FF, $10
	.dw .ref434
.ref441:
	.db $84, $09, $09, $8E, $08, $00, $8B, $84, $09, $13, $8E, $08, $00, $85, $9E, $47
	.db $2F, $35, $39, $3F, $3C
	.db $FD
	.dw .song2ch1loop

.song2ch2:
.song2ch2loop:
.ref442:
	.db $00, $BD
.ref443:
	.db $00, $BD
.ref444:
	.db $00, $BD
.ref445:
	.db $00, $BD
.ref446:
	.db $84, $20, $83, $00, $20, $83, $00, $27, $01, $20, $00, $2A, $85, $00, $99
.ref447:
	.db $20, $83, $00, $20, $83, $00, $27, $01, $20, $00, $2A, $85, $00, $99
	.db $FF, $0E
	.dw .ref447
.ref449:
	.db $20, $83, $00, $20, $83, $00, $27, $01, $20, $00, $2A, $85, $01, $16, $83, $00
	.db $20, $83, $00, $1C, $85
.ref450:
	.db $92, $38, $83, $00, $84, $20, $83, $00, $27, $01, $20, $00, $92, $42, $85, $00
	.db $99
.ref451:
	.db $38, $83, $00, $84, $20, $83, $00, $27, $01, $20, $00, $92, $42, $85, $00, $99
	.db $FF, $0E
	.dw .ref451
.ref453:
	.db $38, $83, $00, $84, $20, $83, $00, $27, $01, $20, $00, $92, $42, $85, $01, $84
	.db $16, $83, $00, $20, $83, $00, $92, $34, $85
	.db $FF, $0E
	.dw .ref451
	.db $FF, $0E
	.dw .ref451
	.db $FF, $0E
	.dw .ref451
	.db $FF, $15
	.dw .ref453
	.db $FF, $0E
	.dw .ref451
	.db $FF, $0E
	.dw .ref451
	.db $FF, $0E
	.dw .ref451
	.db $FF, $15
	.dw .ref453
	.db $FF, $0E
	.dw .ref451
	.db $FF, $0E
	.dw .ref451
	.db $FF, $0E
	.dw .ref451
	.db $FF, $15
	.dw .ref453
	.db $FF, $0E
	.dw .ref446
	.db $FF, $0E
	.dw .ref447
	.db $FF, $0E
	.dw .ref447
	.db $FF, $15
	.dw .ref449
.ref470:
	.db $92, $38, $83, $00, $84, $21, $92, $38, $00, $84, $27, $01, $20, $00, $92, $42
	.db $85, $01, $42, $00, $8B, $38, $00, $83
.ref471:
	.db $38, $83, $00, $84, $21, $92, $38, $00, $84, $27, $01, $20, $00, $92, $42, $85
	.db $01, $42, $00, $8B, $38, $00, $83
	.db $FF, $13
	.dw .ref471
.ref473:
	.db $38, $83, $00, $84, $21, $92, $38, $00, $84, $27, $01, $20, $00, $92, $42, $85
	.db $43, $84, $16, $83, $00, $20, $83, $00, $92, $34, $85
	.db $FF, $13
	.dw .ref471
	.db $FF, $13
	.dw .ref471
	.db $FF, $13
	.dw .ref471
.ref477:
	.db $38, $83, $00, $84, $21, $92, $38, $00, $84, $27, $01, $20, $00, $92, $42, $85
	.db $00, $99
	.db $FD
	.dw .song2ch2loop

.song2ch3:
.song2ch3loop:
.ref478:
	.db $00, $BD
.ref479:
	.db $00, $BD
.ref480:
	.db $00, $BD
.ref481:
	.db $00, $BD
.ref482:
	.db $00, $BD
.ref483:
	.db $00, $BD
.ref484:
	.db $00, $BD
.ref485:
	.db $00, $BD
.ref486:
	.db $8C, $02, $85, $82, $1D, $8C, $07, $92, $04, $00, $83, $82, $1D, $8C, $07, $00
	.db $85, $82, $1D, $8C, $07, $92, $04, $00, $83, $82, $1D, $8C, $06, $81
.ref487:
	.db $02, $85, $82, $1D, $8C, $07, $92, $04, $00, $83, $82, $1D, $8C, $07, $00, $85
	.db $82, $1D, $8C, $07, $92, $04, $00, $94, $1D, $82, $1D, $8C, $06, $81
.ref488:
	.db $02, $85, $82, $1D, $8C, $07, $92, $04, $00, $83, $82, $1D, $8C, $07, $00, $85
	.db $82, $1D, $8C, $07, $92, $04, $00, $83, $82, $1D, $8C, $06, $81
	.db $FF, $13
	.dw .ref487
	.db $FF, $13
	.dw .ref488
	.db $FF, $13
	.dw .ref487
	.db $FF, $13
	.dw .ref488
.ref493:
	.db $02, $85, $82, $1D, $8C, $07, $92, $04, $00, $83, $82, $1D, $8C, $07, $00, $85
	.db $82, $1D, $8C, $07, $92, $04, $00, $8E, $03, $94, $19, $18, $00
	.db $FF, $13
	.dw .ref486
	.db $FF, $13
	.dw .ref487
	.db $FF, $13
	.dw .ref488
	.db $FF, $13
	.dw .ref493
	.db $FF, $13
	.dw .ref486
	.db $FF, $13
	.dw .ref487
	.db $FF, $13
	.dw .ref488
	.db $FF, $13
	.dw .ref493
.ref502:
	.db $8C, $02, $85, $82, $1D, $8C, $07, $00, $89, $07, $00, $85, $82, $1F, $8C, $07
	.db $82, $1F, $01, $1D, $8C, $06, $81
.ref503:
	.db $02, $85, $82, $1D, $8C, $07, $00, $89, $07, $00, $85, $82, $1F, $8C, $07, $82
	.db $1F, $01, $1D, $8C, $06, $81
	.db $FF, $10
	.dw .ref503
.ref505:
	.db $02, $85, $82, $1D, $8C, $07, $00, $89, $07, $00, $85, $82, $1F, $8C, $07, $92
	.db $04, $00, $8E, $03, $94, $19, $18, $00
.ref506:
	.db $8C, $03, $1D, $1B, $07, $96, $13, $01, $82, $1D, $8C, $07, $01, $0A, $0C, $1B
	.db $07, $96, $13, $01, $82, $1D, $8C, $06, $81
.ref507:
	.db $03, $1D, $1B, $07, $96, $13, $01, $82, $1D, $8C, $07, $01, $0A, $0C, $1B, $07
	.db $96, $13, $8E, $0B, $0B, $96, $12, $81
	.db $FF, $12
	.dw .ref506
.ref509:
	.db $03, $1D, $1B, $07, $96, $13, $01, $82, $1D, $8C, $07, $01, $0A, $0C, $1B, $96
	.db $08, $0A, $13, $8E, $0B, $84, $0A, $00, $08, $00
	.db $FF, $12
	.dw .ref506
	.db $FF, $12
	.dw .ref507
	.db $FF, $12
	.dw .ref506
.ref513:
	.db $03, $1D, $1B, $07, $96, $13, $01, $82, $1D, $8C, $07, $00, $9D
	.db $FD
	.dw .song2ch3loop

.song2ch4:
.song2ch4loop:
.ref514:
	.db $BF
.ref515:
	.db $BF
.ref516:
	.db $BF
.ref517:
	.db $BF
.ref518:
	.db $BF
.ref519:
	.db $BF
.ref520:
	.db $BF
.ref521:
	.db $BF
.ref522:
	.db $BF
.ref523:
	.db $BF
.ref524:
	.db $BF
.ref525:
	.db $BF
.ref526:
	.db $BF
.ref527:
	.db $BF
.ref528:
	.db $BF
.ref529:
	.db $BF
.ref530:
	.db $BF
.ref531:
	.db $BF
.ref532:
	.db $BF
.ref533:
	.db $BF
.ref534:
	.db $BF
.ref535:
	.db $BF
.ref536:
	.db $BF
.ref537:
	.db $BF
.ref538:
	.db $BF
.ref539:
	.db $BF
.ref540:
	.db $BF
.ref541:
	.db $BF
.ref542:
	.db $BF
.ref543:
	.db $BF
.ref544:
	.db $BF
.ref545:
	.db $BF
.ref546:
	.db $BF
.ref547:
	.db $BF
.ref548:
	.db $BF
.ref549:
	.db $BF
	.db $FD
	.dw .song2ch4loop
