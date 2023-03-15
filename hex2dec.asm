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

MultiplyByTen:
    LDA dividend
    STA result
    LDA dividend + 1
    STA result + 1
    ASL result
    ROL result + 1
    ASL result
    ROL result + 1
    CLC
    LDA dividend
    ADC result
    STA result
    LDA dividend + 1
    ADC result + 1
    STA result + 1
    ASL result
    ROL result + 1
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
    LDA #TEN
    STA divisor
    RTS

CounterToHex:
    LDX #$00
    LDA #$00
    CLC
    STA dividend
    STA dividend + 1
CounterToHexStep:
    LDA move_counter, x
    ADC dividend
    STA dividend

    CPX #$03
    BEQ CounterIncrement
    JSR MultiplyByTen
    LDA result
    STA dividend
    LDA result + 1
    STA dividend + 1

CounterIncrement:
    INX
    CPX #$04
    BNE CounterToHexStep

SaveScore:
    LDA dividend
    STA score
    LDA dividend + 1
    STA score + 1
    RTS


