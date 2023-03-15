; code by Neil Parker;

Divide:
    LDA #$00
    STA remainder
    STA remainder + 1
    LDX #$10
DivideMainPart:
    ASL dividend
    ROL dividend + 1
    ROL remainder
    ROL remainder + 1
    LDA remainder
    SEC
    SBC divisor
    TAY
    LDA remainder + 1
    SBC divisor + 1
    BCC DivideShift
    STA remainder + 1
    STY remainder
    INC dividend
DivideShift:
    DEX
    BNE DivideMainPart
    RTS

Hex2Dec:
    LDA #$00
    STA temp_x
Hex2DecStep:
    JSR Divide
    LDA remainder

    LDX temp_x
    STA decimal, x
    INX
    STX temp_x
    CPX #$04
    BNE Hex2DecStep
    RTS

SetDivisor:
    LDA #$0A
    STA divisor
    RTS
