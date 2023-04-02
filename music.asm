;this file for FamiTone2 library generated by text2data tool

magnetizer_music_data:
	.db 1
	.dw .instruments
	.dw .samples-3
	.dw .song0ch0,.song0ch1,.song0ch2,.song0ch3,.song0ch4,307,256

.instruments:
	.db $f0 ;instrument $00
	.dw .env1,.env0,.env11
	.db $00
	.db $f0 ;instrument $02
	.dw .env2,.env0,.env11
	.db $00
	.db $30 ;instrument $03
	.dw .env4,.env9,.env0
	.db $00
	.db $30 ;instrument $04
	.dw .env5,.env10,.env0
	.db $00
	.db $30 ;instrument $05
	.dw .env3,.env0,.env12
	.db $00
	.db $30 ;instrument $06
	.dw .env6,.env0,.env0
	.db $00
	.db $f0 ;instrument $07
	.dw .env7,.env0,.env11
	.db $00
	.db $30 ;instrument $08
	.dw .env8,.env0,.env12
	.db $00
	.db $30 ;instrument $09
	.dw .env4,.env9,.env0
	.db $00
	.db $70 ;instrument $0a
	.dw .env6,.env0,.env0
	.db $00

.samples:
.env0:
	.db $c0,$00,$00
.env1:
	.db $ca,$ca,$c7,$c7,$c6,$c5,$c3,$c2,$c2,$c1,$00,$09
.env2:
	.db $cf,$ce,$cd,$cc,$ca,$c7,$c4,$00,$06
.env3:
	.db $c2,$c5,$c7,$c8,$00,$03
.env4:
	.db $cf,$00,$00
.env5:
	.db $cb,$cc,$cc,$cb,$c9,$c5,$c4,$c2,$00,$07
.env6:
	.db $ca,$c6,$c3,$c1,$c1,$c0,$00,$05
.env7:
	.db $c4,$c4,$c3,$c3,$c2,$c2,$c1,$00,$06
.env8:
	.db $c1,$c1,$c2,$c2,$00,$03
.env9:
	.db $cc,$c7,$c7,$c0,$b4,$00,$04
.env10:
	.db $c0,$b4,$00,$01
.env11:
	.db $c0,$c1,$c1,$c0,$00,$03
.env12:
	.db $c0,$08,$be,$be,$c0,$00,$02


.song0ch0:
	.db $fb,$05
.song0ch0loop:
.ref0:
	.db $80,$21,$35,$39,$21,$35,$39,$21,$35,$39,$21,$35,$39,$3f,$39,$3f
	.db $42,$81
.ref1:
	.db $21,$35,$39,$21,$35,$39,$21,$35,$39,$21,$35,$39,$2f,$35,$2f,$2a
	.db $81
.ref2:
	.db $21,$35,$39,$21,$35,$39,$21,$35,$39,$21,$35,$39,$3f,$39,$3f,$42
	.db $81
.ref3:
	.db $21,$35,$39,$21,$35,$39,$21,$43,$47,$43,$35,$3d,$3f,$3d,$2b,$34
	.db $81
	.db $ff,$11
	.dw .ref2
	.db $ff,$11
	.dw .ref1
	.db $ff,$11
	.dw .ref2
	.db $ff,$11
	.dw .ref3
	.db $ff,$11
	.dw .ref2
	.db $ff,$11
	.dw .ref1
	.db $ff,$11
	.dw .ref2
	.db $ff,$11
	.dw .ref3
	.db $ff,$11
	.dw .ref2
	.db $ff,$11
	.dw .ref1
	.db $ff,$11
	.dw .ref2
	.db $ff,$11
	.dw .ref3
.ref16:
	.db $86,$5f,$21,$21,$4d,$13,$2b,$57,$21,$21,$00,$99
.ref17:
	.db $51,$2b,$21,$51,$21,$21,$57,$21,$1d,$21,$51,$21,$51,$21,$51,$2a
	.db $81
.ref18:
	.db $5f,$21,$21,$4d,$13,$2b,$57,$21,$21,$00,$95,$20,$81
.ref19:
	.db $51,$2b,$21,$51,$21,$21,$4d,$47,$43,$2f,$51,$17,$4d,$1d,$43,$2a
	.db $81
.ref20:
	.db $5f,$21,$21,$4d,$13,$2b,$57,$21,$21,$00,$99
	.db $ff,$11
	.dw .ref17
	.db $ff,$0d
	.dw .ref18
	.db $ff,$11
	.dw .ref19
.ref24:
	.db $88,$21,$2f,$39,$47,$21,$2f,$39,$43,$2e,$00,$38,$00,$3e,$00,$38
	.db $00,$46,$00,$50,$00,$54,$00,$38,$81
.ref25:
	.db $2f,$39,$47,$21,$2f,$39,$43,$21,$2e,$00,$38,$00,$4c,$00,$2e,$00
	.db $39,$3d,$01,$20,$81
.ref26:
	.db $2b,$2b,$35,$43,$1d,$2b,$35,$3f,$2a,$00,$34,$00,$3c,$00,$1c,$00
	.db $2a,$00,$34,$00,$38,$00,$1c,$81
.ref27:
	.db $2b,$35,$43,$1d,$2b,$35,$3f,$1d,$2a,$00,$34,$00,$3c,$00,$1c,$00
	.db $34,$00,$39,$8e,$35,$38,$81
	.db $ff,$18
	.dw .ref24
	.db $ff,$15
	.dw .ref25
	.db $ff,$18
	.dw .ref26
	.db $ff,$16
	.dw .ref27
	.db $ff,$18
	.dw .ref24
	.db $ff,$15
	.dw .ref25
	.db $ff,$18
	.dw .ref26
	.db $ff,$16
	.dw .ref27
	.db $ff,$18
	.dw .ref24
	.db $ff,$15
	.dw .ref25
	.db $ff,$18
	.dw .ref26
	.db $ff,$16
	.dw .ref27
	.db $fd
	.dw .song0ch0loop

.song0ch1:
.song0ch1loop:
.ref40:
	.db $00,$bd
.ref41:
	.db $00,$bd
.ref42:
	.db $82,$39,$21,$09,$51,$1d,$09,$8c,$21,$09,$00,$9d
.ref43:
	.db $00,$bd
	.db $ff,$0a
	.dw .ref42
.ref45:
	.db $00,$bd
.ref46:
	.db $82,$39,$21,$09,$51,$1d,$09,$8c,$21,$09,$01,$88,$21,$39,$21,$39
	.db $21,$38,$83,$00
.ref47:
	.db $82,$39,$21,$09,$51,$1d,$09,$8c,$21,$09,$01,$88,$43,$1d,$3d,$35
	.db $01,$43,$2a,$00
	.db $ff,$11
	.dw .ref46
.ref49:
	.db $82,$39,$21,$09,$51,$1d,$09,$8c,$21,$09,$01,$88,$39,$3f,$21,$47
	.db $01,$39,$00,$81
	.db $ff,$11
	.dw .ref46
	.db $ff,$11
	.dw .ref47
	.db $ff,$11
	.dw .ref46
	.db $ff,$11
	.dw .ref49
	.db $ff,$11
	.dw .ref46
	.db $ff,$11
	.dw .ref47
.ref56:
	.db $86,$69,$00,$85,$5b,$00,$85,$5f,$00,$85,$88,$09,$21,$09,$21,$09
	.db $20,$83,$00
.ref57:
	.db $86,$5b,$00,$85,$57,$00,$85,$4d,$00,$89,$56,$85,$57,$01,$5b,$00
	.db $81
.ref58:
	.db $69,$00,$85,$6f,$00,$85,$69,$00,$85,$88,$09,$21,$09,$21,$09,$20
	.db $83,$00
.ref59:
	.db $86,$5b,$00,$85,$57,$00,$85,$55,$00,$89,$56,$85,$55,$01,$4d,$00
	.db $81
.ref60:
	.db $69,$00,$85,$5b,$00,$85,$5f,$00,$85,$88,$09,$21,$09,$21,$09,$20
	.db $83,$00
	.db $ff,$10
	.dw .ref57
	.db $ff,$11
	.dw .ref58
	.db $ff,$10
	.dw .ref59
.ref64:
	.db $81,$8e,$21,$2f,$39,$47,$21,$2f,$39,$43,$2e,$00,$38,$00,$3e,$00
	.db $38,$00,$46,$00,$50,$00,$54,$00,$38
.ref65:
	.db $81,$2f,$39,$47,$21,$2f,$39,$43,$21,$2e,$00,$38,$00,$4c,$00,$2e
	.db $00,$39,$3d,$01,$20
.ref66:
	.db $81,$2b,$2b,$35,$43,$1d,$2b,$35,$3f,$2a,$00,$34,$00,$3c,$00,$1c
	.db $00,$2a,$00,$34,$00,$38,$00,$1c
.ref67:
	.db $81,$2b,$35,$43,$1d,$2b,$35,$3f,$1d,$2a,$00,$34,$00,$3c,$00,$1c
	.db $00,$34,$00,$39,$01,$1c
.ref68:
	.db $81,$21,$2f,$39,$47,$21,$2f,$39,$43,$2e,$00,$38,$00,$3e,$00,$38
	.db $00,$46,$00,$50,$00,$54,$00,$38
	.db $ff,$15
	.dw .ref65
	.db $ff,$18
	.dw .ref66
	.db $ff,$16
	.dw .ref67
.ref72:
	.db $82,$08,$89,$08,$89,$20,$85,$08,$89,$21,$17,$21,$25,$20,$81
.ref73:
	.db $00,$85,$09,$08,$89,$20,$85,$16,$89,$17,$21,$25,$01,$08,$81
.ref74:
	.db $12,$89,$12,$89,$1c,$85,$12,$89,$05,$13,$1d,$21,$1c,$81
.ref75:
	.db $00,$85,$09,$08,$89,$20,$85,$2b,$88,$17,$2f,$17,$82,$1d,$39,$05
	.db $00,$81
.ref76:
	.db $08,$89,$08,$89,$20,$85,$08,$89,$21,$17,$21,$25,$20,$81
	.db $ff,$0f
	.dw .ref73
	.db $ff,$0e
	.dw .ref74
.ref79:
	.db $00,$85,$09,$08,$89,$20,$85,$2b,$88,$17,$2f,$16,$00,$8f
	.db $fd
	.dw .song0ch1loop

.song0ch2:
.song0ch2loop:
.ref80:
	.db $00,$bd
.ref81:
	.db $00,$bd
.ref82:
	.db $00,$bd
.ref83:
	.db $00,$bd
.ref84:
	.db $00,$bd
.ref85:
	.db $00,$bd
.ref86:
	.db $00,$bd
.ref87:
	.db $00,$bd
.ref88:
	.db $84,$38,$00,$8b,$38,$00,$8b,$38,$00,$8b,$38,$00,$8b
.ref89:
	.db $38,$00,$8b,$38,$00,$8b,$38,$00,$8b,$38,$00,$8b
	.db $ff,$0c
	.dw .ref89
.ref91:
	.db $38,$00,$8b,$38,$00,$8b,$38,$00,$83,$38,$00,$38,$89,$38,$00,$83
	.db $ff,$0c
	.dw .ref89
	.db $ff,$0c
	.dw .ref89
	.db $ff,$0c
	.dw .ref89
	.db $ff,$10
	.dw .ref91
.ref96:
	.db $38,$00,$8b,$38,$00,$8b,$38,$00,$9b
	.db $ff,$0c
	.dw .ref89
	.db $ff,$09
	.dw .ref96
	.db $ff,$10
	.dw .ref91
	.db $ff,$09
	.dw .ref96
	.db $ff,$0c
	.dw .ref89
	.db $ff,$09
	.dw .ref96
	.db $ff,$10
	.dw .ref91
.ref104:
	.db $00,$bd
.ref105:
	.db $00,$bd
.ref106:
	.db $00,$bd
.ref107:
	.db $ab,$34,$34,$35,$35,$34,$85
.ref108:
	.db $38,$8d,$90,$38,$85,$21,$21,$84,$39,$00,$85,$90,$38,$85,$21,$00
	.db $85
.ref109:
	.db $87,$84,$39,$90,$39,$38,$85,$21,$21,$84,$2e,$89,$90,$2e,$85,$17
	.db $01,$12,$81
.ref110:
	.db $84,$2a,$8d,$90,$2b,$01,$13,$13,$84,$39,$00,$85,$90,$34,$85,$1d
	.db $00,$85
.ref111:
	.db $87,$84,$35,$90,$35,$34,$85,$1d,$1d,$84,$2f,$90,$2f,$84,$34,$34
	.db $35,$00,$8d
	.db $ff,$0e
	.dw .ref108
	.db $ff,$0f
	.dw .ref109
	.db $ff,$0e
	.dw .ref110
.ref115:
	.db $87,$84,$35,$90,$35,$34,$85,$1d,$1d,$84,$2f,$90,$2e,$89,$84,$34
	.db $34,$35,$35,$34,$81
	.db $ff,$0e
	.dw .ref108
	.db $ff,$0f
	.dw .ref109
	.db $ff,$0e
	.dw .ref110
	.db $ff,$0e
	.dw .ref111
	.db $fd
	.dw .song0ch2loop

.song0ch3:
.song0ch3loop:
.ref120:
	.db $00,$bd
.ref121:
	.db $00,$bd
.ref122:
	.db $00,$bd
.ref123:
	.db $00,$a9,$8a,$17,$17,$17,$11,$0a,$81
.ref124:
	.db $00,$8d,$14,$00,$9b,$14,$00,$8b
	.db $ff,$08
	.dw .ref124
	.db $ff,$08
	.dw .ref124
.ref127:
	.db $00,$8d,$14,$00,$97,$17,$84,$10,$00,$8a,$13,$07,$0a,$81
.ref128:
	.db $01,$17,$19,$1b,$84,$10,$00,$8a,$17,$19,$1a,$85,$17,$19,$1b,$84
	.db $10,$00,$8a,$17,$86,$15,$14,$00
.ref129:
	.db $01,$8a,$17,$19,$1b,$84,$10,$00,$8a,$17,$19,$1a,$85,$17,$19,$1b
	.db $84,$10,$00,$8a,$17,$86,$15,$14,$00
	.db $ff,$13
	.dw .ref129
.ref131:
	.db $01,$8a,$17,$19,$1b,$84,$10,$00,$8a,$17,$19,$1a,$85,$17,$19,$1b
	.db $84,$10,$00,$8a,$17,$84,$0d,$8a,$06,$00
.ref132:
	.db $00,$bd
.ref133:
	.db $00,$bd
.ref134:
	.db $00,$bd
.ref135:
	.db $00,$bd
.ref136:
	.db $8f,$84,$12,$00,$97,$8a,$0b,$84,$10,$00,$8a,$10,$10,$11,$10,$81
.ref137:
	.db $00,$a9,$17,$17,$17,$11,$0a,$81
	.db $ff,$0c
	.dw .ref136
.ref139:
	.db $00,$89,$1b,$84,$12,$00,$8a,$16,$91,$12,$14,$17,$17,$17,$11,$0a
	.db $81
	.db $ff,$13
	.dw .ref128
	.db $ff,$13
	.dw .ref129
	.db $ff,$13
	.dw .ref129
	.db $ff,$13
	.dw .ref131
.ref144:
	.db $00,$bd
.ref145:
	.db $00,$bd
.ref146:
	.db $00,$bd
.ref147:
	.db $ab,$12,$14,$17,$17,$17,$10,$81
.ref148:
	.db $92,$06,$1e,$8a,$19,$92,$1f,$8a,$19,$90,$17,$92,$1f,$8a,$18,$00
	.db $1a,$85,$17,$92,$1f,$8a,$19,$90,$17,$92,$1f,$8a,$18,$00,$90,$12
	.db $81
.ref149:
	.db $01,$8a,$10,$10,$11,$19,$90,$17,$92,$1f,$8a,$18,$00,$1a,$85,$17
	.db $92,$1f,$8a,$19,$90,$17,$92,$1f,$8a,$18,$00,$90,$12,$81
	.db $ff,$14
	.dw .ref148
.ref151:
	.db $01,$8a,$10,$10,$11,$19,$90,$17,$92,$1f,$8a,$18,$00,$1b,$12,$14
	.db $17,$92,$1f,$1d,$1d,$1d,$00,$85
.ref152:
	.db $06,$1e,$8a,$19,$92,$1f,$8a,$19,$90,$17,$92,$1f,$8a,$18,$00,$1a
	.db $85,$17,$92,$1f,$8a,$19,$90,$17,$92,$1f,$8a,$18,$00,$90,$12,$81
	.db $ff,$14
	.dw .ref149
	.db $ff,$14
	.dw .ref148
.ref155:
	.db $01,$8a,$10,$10,$11,$19,$90,$17,$92,$1f,$8a,$18,$00,$1a,$85,$17
	.db $92,$1f,$8a,$12,$14,$17,$17,$17,$10,$81
	.db $ff,$14
	.dw .ref148
	.db $ff,$14
	.dw .ref149
	.db $ff,$14
	.dw .ref148
	.db $ff,$13
	.dw .ref151
	.db $fd
	.dw .song0ch3loop

.song0ch4:
.song0ch4loop:
.ref160:
	.db $bf
.ref161:
	.db $bf
.ref162:
	.db $bf
.ref163:
	.db $bf
.ref164:
	.db $bf
.ref165:
	.db $bf
.ref166:
	.db $bf
.ref167:
	.db $bf
.ref168:
	.db $bf
.ref169:
	.db $bf
.ref170:
	.db $bf
.ref171:
	.db $bf
.ref172:
	.db $bf
.ref173:
	.db $bf
.ref174:
	.db $bf
.ref175:
	.db $bf
.ref176:
	.db $bf
.ref177:
	.db $bf
.ref178:
	.db $bf
.ref179:
	.db $bf
.ref180:
	.db $bf
.ref181:
	.db $bf
.ref182:
	.db $bf
.ref183:
	.db $bf
.ref184:
	.db $bf
.ref185:
	.db $bf
.ref186:
	.db $bf
.ref187:
	.db $bf
.ref188:
	.db $bf
.ref189:
	.db $bf
.ref190:
	.db $bf
.ref191:
	.db $bf
.ref192:
	.db $bf
.ref193:
	.db $bf
.ref194:
	.db $bf
.ref195:
	.db $bf
.ref196:
	.db $bf
.ref197:
	.db $bf
.ref198:
	.db $bf
.ref199:
	.db $bf
	.db $fd
	.dw .song0ch4loop
