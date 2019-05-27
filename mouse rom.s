                  * = 0000
0000   2C 58 FF   BIT $FF58	; set overflow, clear carry
0003   70 1B      BVS $0020	; jump to $20
0005   38         SEC 		; Signature byte?
0006   90 18      BCC $0020
0008   B8         CLV		; Signature byte?
0009   50 15      BVC $0020
000B   01         ; Signature byte
000C   20         ; device signature XY-Input device
000D   F4         ???
000E   F4         ???
000F   F4         ???
0010   F4         ???
0011   00         BRK
0012   B3         ; SETMOUSE offset
0013   C4         ; SERVEMOUSE offset
0014   9B         ; READMOUSE offset
0015   A4         ; CLEARMOUSE offset
0016   C0         ; POSMOUSE offset
0017   8A         ; CLAMPMOUSE offset
0018   DD         ; HOMEMOUSE offset
0019   BC         ; INITMOUSE offset

; Startup
0020   08         PHP 		; P -> Stack
0021   78         SEI
0022   8D F8 07   STA $07F8	; $07F8 enthält den aktuellen Slot $Cn
0025   48         PHA		; A -> Stack
0026   98         TYA		; Y -> A
0027   48         PHA		
0028   8A         TXA		; X -> A
0029   48         PHA
002A   20 58 FF   JSR $FF58	; RTS
002D   BA         TSX
002E   BD 00 01   LDA $0100,X
0031   AA         TAX		; X = $Cs
0032   08         PHP
0033   0A         ASL A
0034   0A         ASL A
0035   0A         ASL A
0036   0A         ASL A
0037   28         PLP
0038   A8         TAY		; Y = $s0 slot*16
0039   AD F8 07   LDA $07F8
003C   8E F8 07   STX $07F8	; X = $Cs
003F   48         PHA
0040   A9 08      LDA #$08
0042   70 67      BVS $00AB
0044   90 4D      BCC $0093
0046   B0 55      BCS $009D
0048   29 01      AND #$01
004A   09 F0      ORA #$F0
004C   9D 38 06   STA $0638,X
004F   A9 02      LDA #$02
0051   D0 40      BNE $0093
0053   29 0F      AND #$0F
0055   09 90      ORA #$90
0057   D0 35      BNE $008E
0059   FF         ???
005A   FF         ???
005B   B9 83 C0   LDA $C083,Y
005E   29 FB      AND #$FB
0060   99 83 C0   STA $C083,Y	; enable DDRB
0063   A9 3E      LDA #$3E
0065   99 82 C0   STA $C082,Y	; set PB I/O
0068   B9 83 C0   LDA $C083,Y
006B   09 04      ORA #$04
006D   99 83 C0   STA $C083,Y	; enable ORB
0070   B9 82 C0   LDA $C082,Y
0073   29 C1      AND #$C1	;   
0075   1D B8 05   ORA $05B8,X
0078   99 82 C0   STA $C082,Y
007B   68         PLA
007C   F0 0A      BEQ $0088
007E   6A         ROR A
007F   90 75      BCC $00F6
0081   68         PLA
0082   AA         TAX
0083   68         PLA
0084   A8         TAY
0085   68         PLA
0086   28         PLP
0087   60         RTS
0088   18         CLC
0089   60         RTS

; CLAMPMOUSE
008A   29 01      AND #$01
008C   09 60      ORA #$60
008E   9D 38 06   STA $0638,X
0091   A9 0E      LDA #$0E
0093   9D B8 05   STA $05B8,X
0096   A9 01      LDA #$01
0098   48         PHA
0099   D0 C0      BNE $005B

; READMOUSE
009B   A9 0C      LDA #$0C
009D   9D B8 05   STA $05B8,X
00A0   A9 02      LDA #$02
00A2   D0 F4      BNE $0098

; CLEARMOUSE
00A4   A9 30      LDA #$30
00A6   9D 38 06   STA $0638,X
00A9   A9 06      LDA #$06
00AB   9D B8 05   STA $05B8,X
00AE   A9 00      LDA #$00
00B0   48         PHA
00B1   F0 A8      BEQ $005B

; SETMOUSE
00B3   C9 10      CMP #$10
00B5   B0 D2      BCS $0089
00B7   9D 38 07   STA $0738,X
00BA   90 EA      BCC $00A6

; INITMOUSE
00BC   A9 04      LDA #$04
00BE   D0 EB      BNE $00AB

; POSMOUSE
00C0   A9 40      LDA #$40
00C2   D0 CA      BNE $008E

; SERVEMOUSE
00C4   A4 06      LDY $06
00C6   A9 60      LDA #$60
00C8   85 06      STA $06
00CA   20 06 00   JSR $0006
00CD   84 06      STY $06
00CF   BA         TSX
00D0   BD 00 01   LDA $0100,X
00D3   AA         TAX
00D4   0A         ASL A
00D5   0A         ASL A
00D6   0A         ASL A
00D7   0A         ASL A
00D8   A8         TAY
00D9   A9 20      LDA #$20
00DB   D0 C9      BNE $00A6

; HOMEMOUSE
00DD   A9 70      LDA #$70
00DF   D0 C5      BNE $00A6
00E1   48         PHA
00E2   A9 A0      LDA #$A0
00E4   D0 A8      BNE $008E
00E6   29 0F      AND #$0F
00E8   09 B0      ORA #$B0
00EA   D0 BA      BNE $00A6
00EC   A9 C0      LDA #$C0
00EE   D0 B6      BNE $00A6
00F0   A9 02      LDA #$02
00F2   D0 B7      BNE $00AB
00F4   A2 03      LDX #$03
00F6   38         SEC
00F7   60         RTS

00FB   D6         ; Signature byte





C800   2C 58 FF   BIT $FF58	; set overflow, clear carry
C803   70 1B      BVS $0020	; jump to $20
C805   38         SEC 		; Signature byte
C806   90 18      BCC $0020
C808   B8         CLV		; Signature byte?
C809   50 15      BVC $0020
C80B   01         ; Signature byte
C80C   20         ; device signature XY-Input device
C80D   F4         ???
C80E   F4         ???
C80F   F4         ???
C810   F4         ???
C811   00         BRK
C812   B3         ; SETMOUSE offset
C813   C4         ; SERVEMOUSE offset
C814   9B         ; READMOUSE offset
C815   A4         ; CLEARMOUSE offset
C816   C0         ; POSMOUSE offset
C817   8A         ; CLAMPMOUSE offset
C818   DD         ; HOMEMOUSE offset
C819   BC         ; INITMOUSE offset

; Startup
C820   08         PHP
C821   78         SEI
C822   8D F8 07   STA $07F8
C825   48         PHA
C826   98         TYA
C827   48         PHA
C828   8A         TXA
C829   48         PHA
C82A   20 58 FF   JSR $FF58
C82D   BA         TSX
C82E   BD 00 01   LDA $0100,X
C831   AA         TAX
C832   08         PHP
C833   0A         ASL A
C834   0A         ASL A
C835   0A         ASL A
C836   0A         ASL A
C837   28         PLP
C838   A8         TAY
C839   AD F8 07   LDA $07F8
C83C   8E F8 07   STX $07F8
C83F   48         PHA
C840   A9 08      LDA #$08
C842   70 67      BVS $C8AB
C844   90 4D      BCC $C893
C846   B0 55      BCS $C89D
C848   29 01      AND #$01
C84A   09 F0      ORA #$F0
C84C   9D 38 06   STA $0638,X
C84F   A9 02      LDA #$02
C851   D0 40      BNE $C893
C853   29 0F      AND #$0F
C855   09 90      ORA #$90
C857   D0 35      BNE $C88E
C859   FF         ???
C85A   FF         ???
C85B   B9 83 C0   LDA $C083,Y
C85E   29 FB      AND #$FB
C860   99 83 C0   STA $C083,Y
C863   A9 3E      LDA #$3E
C865   99 82 C0   STA $C082,Y
C868   B9 83 C0   LDA $C083,Y
C86B   09 04      ORA #$04
C86D   99 83 C0   STA $C083,Y
C870   B9 82 C0   LDA $C082,Y
C873   29 C1      AND #$C1
C875   1D B8 05   ORA $05B8,X
C878   99 82 C0   STA $C082,Y
C87B   68         PLA
C87C   F0 0A      BEQ $C888
C87E   6A         ROR A
C87F   90 75      BCC $C8F6
C881   68         PLA
C882   AA         TAX
C883   68         PLA
C884   A8         TAY
C885   68         PLA
C886   28         PLP
C887   60         RTS
C888   18         CLC
C889   60         RTS

; CLAMPMOUSE
C88A   29 01      AND #$01
C88C   09 60      ORA #$60
C88E   9D 38 06   STA $0638,X
C891   A9 0E      LDA #$0E
C893   9D B8 05   STA $05B8,X
C896   A9 01      LDA #$01
C898   48         PHA
C899   D0 C0      BNE $C85B
; READMOUSE
C89B   A9 0C      LDA #$0C
C89D   9D B8 05   STA $05B8,X
C8A0   A9 02      LDA #$02
C8A2   D0 F4      BNE $C898
; CLEARMOUSE
C8A4   A9 30      LDA #$30
C8A6   9D 38 06   STA $0638,X
C8A9   A9 06      LDA #$06
C8AB   9D B8 05   STA $05B8,X
C8AE   A9 00      LDA #$00
C8B0   48         PHA
C8B1   F0 A8      BEQ $C85B
; SETMOUSE
C8B3   C9 10      CMP #$10
C8B5   B0 D2      BCS $C889
C8B7   9D 38 07   STA $0738,X
C8BA   90 EA      BCC $C8A6
; INITMOUSE
C8BC   A9 04      LDA #$04
C8BE   D0 EB      BNE $C8AB
; POSMOUSE
C8C0   A9 40      LDA #$40
C8C2   D0 CA      BNE $C88E
; SERVEMOUSE
C8C4   A4 06      LDY $06
C8C6   A9 60      LDA #$60
C8C8   85 06      STA $06
C8CA   20 06 00   JSR $0006
C8CD   84 06      STY $06
C8CF   BA         TSX
C8D0   BD 00 01   LDA $0100,X
C8D3   AA         TAX
C8D4   0A         ASL A
C8D5   0A         ASL A
C8D6   0A         ASL A
C8D7   0A         ASL A
C8D8   A8         TAY
C8D9   A9 20      LDA #$20
C8DB   D0 C9      BNE $C8A6
; HOMEMOUSE
C8DD   A9 70      LDA #$70
C8DF   D0 C5      BNE $C8A6
C8E1   48         PHA
C8E2   A9 A0      LDA #$A0
C8E4   D0 A8      BNE $C88E
C8E6   29 0F      AND #$0F
C8E8   09 B0      ORA #$B0
C8EA   D0 BA      BNE $C8A6
C8EC   A9 C0      LDA #$C0
C8EE   D0 B6      BNE $C8A6
C8F0   A9 02      LDA #$02
C8F2   D0 B7      BNE $C8AB
C8F4   A2 03      LDX #$03
C8F6   38         SEC
C8F7   60         RTS
C8F8   FF         ???
C8F9   FF         ???
C8FA   FF         ???
C8FB   D6 FF      DEC $FF,X
C8FD   FF         ???
C8FE   FF         ???
C8FF   01         ???

C900   98         TYA
C901   48         PHA
C902   A5 06      LDA $06
C904   48         PHA
C905   A5 07      LDA $07
C907   48         PHA
C908   86 07      STX $07
C90A   A9 27      LDA #$27
C90C   85 06      STA $06
C90E   20 58 FC   JSR $FC58
C911   A0 00      LDY #$00
C913   B1 06      LDA ($06),Y
C915   F0 06      BEQ $C91D
C917   20 ED FD   JSR $FDED
C91A   C8         INY
C91B   D0 F6      BNE $C913
C91D   68         PLA
C91E   85 07      STA $07
C920   68         PLA
C921   85 06      STA $06
C923   68         PLA
C924   A8         TAY
C925   D0 5B      BNE $C982
C927   C1 F0      CMP ($F0,X)
C929   F0 EC      BEQ $C917
C92B   E5 CD      SBC $CD
C92D   EF         ???
C92E   F5 F3      SBC $F3,X
C930   E5 8D      SBC $8D
C932   C3         ???
C933   EF         ???
C934   F0 F9      BEQ $C92F
C936   F2         ???
C937   E9 E7      SBC #$E7
C939   E8         INX
C93A   F4         ???
C93B   A0 B1      LDY #$B1
C93D   B9 B8 B3   LDA $B3B8,Y
C940   A0 E2      LDY #$E2
C942   F9 A0 C1   SBC $C1A0,Y
C945   F0 F0      BEQ $C937
C947   EC E5 A0   CPX $A0E5
C94A   C3         ???
C94B   EF         ???
C94C   ED F0 F5   SBC $F5F0
C94F   F4         ???
C950   E5 F2      SBC $F2
C952   AC A0 C9   LDY $C9A0
C955   EE E3 AE   INC $AEE3
C958   8D 8D C2   STA $C28D
C95B   E1 E3      SBC ($E3,X)
C95D   E8         INX
C95E   ED E1 EE   SBC $EEE1
C961   AF         ???
C962   CD E1 F2   CMP $F2E1
C965   EB         ???
C966   F3         ???
C967   AF         ???
C968   CD E1 E3   CMP $E3E1
C96B   CB         ???
C96C   E1 F9      SBC ($F9,X)
C96E   8D 00 B9   STA $B900
C971   82         ???
C972   C0 29      CPY #$29
C974   F1 1D      SBC ($1D),Y
C976   B8         CLV
C977   05 99      ORA $99
C979   82         ???
C97A   C0 68      CPY #$68
C97C   30 0C      BMI $C98A
C97E   F0 80      BEQ $C900
C980   D0 09      BNE $C98B
C982   A9 00      LDA #$00
C984   9D B8 05   STA $05B8,X
C987   48         PHA
C988   F0 E6      BEQ $C970
C98A   60         RTS
C98B   BD 38 07   LDA $0738,X
C98E   29 0F      AND #$0F
C990   09 20      ORA #$20
C992   9D 38 07   STA $0738,X
C995   8A         TXA
C996   48         PHA
C997   48         PHA
C998   48         PHA
C999   48         PHA
C99A   A9 AA      LDA #$AA
C99C   48         PHA
C99D   BD 38 06   LDA $0638,X
C9A0   48         PHA
C9A1   A9 0C      LDA #$0C
C9A3   9D B8 05   STA $05B8,X
C9A6   A9 00      LDA #$00
C9A8   48         PHA
C9A9   F0 C5      BEQ $C970
C9AB   A9 B3      LDA #$B3
C9AD   48         PHA
C9AE   AD 78 04   LDA $0478
C9B1   18         CLC
C9B2   90 EC      BCC $C9A0
C9B4   A9 BC      LDA #$BC
C9B6   48         PHA
C9B7   AD F8 04   LDA $04F8
C9BA   18         CLC
C9BB   90 E3      BCC $C9A0
C9BD   A9 81      LDA #$81
C9BF   48         PHA
C9C0   7E 38 06   ROR $0638,X
C9C3   90 05      BCC $C9CA
C9C5   AD 78 05   LDA $0578
C9C8   B0 D6      BCS $C9A0
C9CA   8A         TXA
C9CB   48         PHA
C9CC   A9 D8      LDA #$D8
C9CE   48         PHA
C9CF   A9 0C      LDA #$0C
C9D1   9D B8 05   STA $05B8,X
C9D4   A9 01      LDA #$01
C9D6   48         PHA
C9D7   D0 97      BNE $C970
C9D9   BD 38 06   LDA $0638,X
C9DC   8D 78 05   STA $0578
C9DF   60         RTS
C9E0   FF         ???
C9E1   FF         ???
C9E2   FF         ???
C9E3   FF         ???
C9E4   FF         ???
C9E5   FF         ???
C9E6   FF         ???
C9E7   FF         ???
C9E8   FF         ???
C9E9   FF         ???
C9EA   FF         ???
C9EB   FF         ???
C9EC   FF         ???
C9ED   FF         ???
C9EE   FF         ???
C9EF   FF         ???
C9F0   FF         ???
C9F1   FF         ???
C9F2   FF         ???
C9F3   FF         ???
C9F4   FF         ???
C9F5   FF         ???
C9F6   FF         ???
C9F7   FF         ???
C9F8   FF         ???
C9F9   FF         ???
C9FA   FF         ???
C9FB   FF         ???
C9FC   FF         ???
C9FD   FF         ???
C9FE   FF         ???
C9FF   C2         ???


CA00   BD 38 07   LDA $0738,X
CA03   29 0F      AND #$0F
CA05   09 40      ORA #$40
CA07   9D 38 07   STA $0738,X
CA0A   8A         TXA
CA0B   48         PHA
CA0C   48         PHA
CA0D   48         PHA
CA0E   A9 11      LDA #$11
CA10   D0 27      BNE $CA39
CA12   A9 1E      LDA #$1E
CA14   48         PHA
CA15   A9 0C      LDA #$0C
CA17   9D B8 05   STA $05B8,X
CA1A   A9 01      LDA #$01
CA1C   48         PHA
CA1D   D0 51      BNE $CA70
CA1F   AD B3 FB   LDA $FBB3
CA22   C9 06      CMP #$06
CA24   D0 21      BNE $CA47
CA26   AD 19 C0   LDA $C019
CA29   30 FB      BMI $CA26
CA2B   AD 19 C0   LDA $C019
CA2E   10 FB      BPL $CA2B
CA30   AD 19 C0   LDA $C019
CA33   30 FB      BMI $CA30
CA35   A9 7F      LDA #$7F
CA37   D0 00      BNE $CA39
CA39   48         PHA
CA3A   A9 50      LDA #$50
CA3C   48         PHA
CA3D   A9 0C      LDA #$0C
CA3F   9D B8 05   STA $05B8,X
CA42   A9 00      LDA #$00
CA44   48         PHA
CA45   F0 29      BEQ $CA70
CA47   A5 06      LDA $06
CA49   48         PHA
CA4A   A5 07      LDA $07
CA4C   48         PHA
CA4D   98         TYA
CA4E   48         PHA
CA4F   A9 20      LDA #$20
CA51   85 07      STA $07
CA53   A0 00      LDY #$00
CA55   84 06      STY $06
CA57   A9 00      LDA #$00
CA59   91 06      STA ($06),Y
CA5B   C8         INY
CA5C   D0 FB      BNE $CA59
CA5E   E6 07      INC $07
CA60   A5 07      LDA $07
CA62   C9 40      CMP #$40
CA64   D0 F1      BNE $CA57
CA66   68         PLA
CA67   A8         TAY
CA68   A5 08      LDA $08
CA6A   48         PHA
CA6B   A9 00      LDA #$00
CA6D   F0 1C      BEQ $CA8B
CA6F   FF         ???
CA70   B9 82 C0   LDA $C082,Y
CA73   29 F1      AND #$F1
CA75   1D B8 05   ORA $05B8,X
CA78   99 82 C0   STA $C082,Y
CA7B   68         PLA
CA7C   30 0A      BMI $CA88
CA7E   F0 80      BEQ $CA00
CA80   A9 00      LDA #$00
CA82   9D B8 05   STA $05B8,X
CA85   48         PHA
CA86   F0 E8      BEQ $CA70
CA88   60         RTS
CA89   D0 AE      BNE $CA39
CA8B   A9 01      LDA #$01
CA8D   8D D0 3F   STA $3FD0
CA90   8D E0 3F   STA $3FE0
CA93   AD 57 C0   LDA $C057
CA96   AD 54 C0   LDA $C054
CA99   AD 52 C0   LDA $C052
CA9C   AD 50 C0   LDA $C050
CA9F   EA         NOP
CAA0   85 06      STA $06
CAA2   85 07      STA $07
CAA4   85 08      STA $08
CAA6   E6 06      INC $06
CAA8   D0 0E      BNE $CAB8
CAAA   E6 07      INC $07
CAAC   D0 0C      BNE $CABA
CAAE   E6 08      INC $08
CAB0   A5 08      LDA $08
CAB2   C9 01      CMP #$01
CAB4   90 0A      BCC $CAC0
CAB6   B0 1F      BCS $CAD7
CAB8   08         PHP
CAB9   28         PLP
CABA   08         PHP
CABB   28         PLP
CABC   A9 00      LDA #$00
CABE   A5 00      LDA $00
CAC0   AD FF CF   LDA $CFFF
CAC3   B9 82 C0   LDA $C082,Y
CAC6   4A         LSR A
CAC7   EA         NOP
CAC8   EA         NOP
CAC9   B0 DB      BCS $CAA6
CACB   AD FF CF   LDA $CFFF
CACE   B9 82 C0   LDA $C082,Y
CAD1   4A         LSR A
CAD2   A5 00      LDA $00
CAD4   EA         NOP
CAD5   B0 CF      BCS $CAA6
CAD7   68         PLA
CAD8   85 08      STA $08
CADA   68         PLA
CADB   85 07      STA $07
CADD   68         PLA
CADE   85 06      STA $06
CAE0   A9 E3      LDA #$E3
CAE2   D0 A5      BNE $CA89
CAE4   AD 51 C0   LDA $C051
CAE7   AD 56 C0   LDA $C056
CAEA   18         CLC
CAEB   90 93      BCC $CA80
CAED   FF         ???
CAEE   FF         ???
CAEF   FF         ???
CAF0   FF         ???
CAF1   FF         ???
CAF2   FF         ???
CAF3   FF         ???
CAF4   FF         ???
CAF5   FF         ???
CAF6   FF         ???
CAF7   FF         ???
CAF8   FF         ???
CAF9   FF         ???
CAFA   FF         ???
CAFB   FF         ???
CAFC   FF         ???
CAFD   FF         ???
CAFE   FF         ???
CAFF   C1         ???


CB00   BD 38 06   LDA $0638,X
CB03   C9 20      CMP #$20
CB05   D0 06      BNE $CB0D
CB07   A9 7F      LDA #$7F
CB09   69 01      ADC #$01
CB0B   70 01      BVS $CB0E
CB0D   B8         CLV
CB0E   B9 82 C0   LDA $C082,Y
CB11   30 FB      BMI $CB0E
CB13   B9 81 C0   LDA $C081,Y
CB16   29 FB      AND #$FB
CB18   99 81 C0   STA $C081,Y
CB1B   A9 FF      LDA #$FF
CB1D   99 80 C0   STA $C080,Y
CB20   B9 81 C0   LDA $C081,Y
CB23   09 04      ORA #$04
CB25   99 81 C0   STA $C081,Y
CB28   BD 38 06   LDA $0638,X
CB2B   99 80 C0   STA $C080,Y
CB2E   B9 82 C0   LDA $C082,Y
CB31   09 20      ORA #$20
CB33   99 82 C0   STA $C082,Y
CB36   B9 82 C0   LDA $C082,Y
CB39   10 FB      BPL $CB36
CB3B   29 DF      AND #$DF
CB3D   99 82 C0   STA $C082,Y
CB40   70 44      BVS $CB86
CB42   BD 38 06   LDA $0638,X
CB45   C9 30      CMP #$30
CB47   D0 35      BNE $CB7E
CB49   A9 00      LDA #$00
CB4B   9D B8 04   STA $04B8,X
CB4E   9D B8 03   STA $03B8,X
CB51   9D 38 05   STA $0538,X
CB54   9D 38 04   STA $0438,X
CB57   F0 25      BEQ $CB7E
CB59   FF         ???
CB5A   FF         ???
CB5B   FF         ???
CB5C   FF         ???
CB5D   FF         ???
CB5E   FF         ???
CB5F   FF         ???
CB60   FF         ???
CB61   FF         ???
CB62   FF         ???
CB63   FF         ???
CB64   FF         ???
CB65   FF         ???
CB66   FF         ???
CB67   FF         ???
CB68   FF         ???
CB69   FF         ???
CB6A   FF         ???
CB6B   FF         ???
CB6C   FF         ???
CB6D   FF         ???
CB6E   FF         ???
CB6F   FF         ???
CB70   B9 82 C0   LDA $C082,Y
CB73   29 F1      AND #$F1
CB75   1D B8 05   ORA $05B8,X
CB78   99 82 C0   STA $C082,Y
CB7B   68         PLA
CB7C   F0 82      BEQ $CB00
CB7E   A9 00      LDA #$00
CB80   9D B8 05   STA $05B8,X
CB83   48         PHA
CB84   F0 EA      BEQ $CB70
CB86   B9 81 C0   LDA $C081,Y
CB89   29 FB      AND #$FB
CB8B   99 81 C0   STA $C081,Y
CB8E   A9 00      LDA #$00
CB90   99 80 C0   STA $C080,Y
CB93   B9 81 C0   LDA $C081,Y
CB96   09 04      ORA #$04
CB98   99 81 C0   STA $C081,Y
CB9B   B9 82 C0   LDA $C082,Y
CB9E   0A         ASL A
CB9F   10 FA      BPL $CB9B
CBA1   B9 80 C0   LDA $C080,Y
CBA4   9D 38 06   STA $0638,X
CBA7   B9 82 C0   LDA $C082,Y
CBAA   09 10      ORA #$10
CBAC   99 82 C0   STA $C082,Y
CBAF   B9 82 C0   LDA $C082,Y
CBB2   0A         ASL A
CBB3   30 FA      BMI $CBAF
CBB5   B9 82 C0   LDA $C082,Y
CBB8   29 EF      AND #$EF
CBBA   99 82 C0   STA $C082,Y
CBBD   BD B8 06   LDA $06B8,X
CBC0   29 F1      AND #$F1
CBC2   1D 38 06   ORA $0638,X
CBC5   9D B8 06   STA $06B8,X
CBC8   29 0E      AND #$0E
CBCA   D0 B2      BNE $CB7E
CBCC   A9 00      LDA #$00
CBCE   9D B8 05   STA $05B8,X
CBD1   A9 02      LDA #$02
CBD3   48         PHA
CBD4   D0 9A      BNE $CB70
CBD6   FF         ???
CBD7   FF         ???
CBD8   FF         ???
CBD9   FF         ???
CBDA   FF         ???
CBDB   FF         ???
CBDC   FF         ???
CBDD   FF         ???
CBDE   FF         ???
CBDF   FF         ???
CBE0   FF         ???
CBE1   FF         ???
CBE2   FF         ???
CBE3   FF         ???
CBE4   FF         ???
CBE5   FF         ???
CBE6   FF         ???
CBE7   FF         ???
CBE8   FF         ???
CBE9   FF         ???
CBEA   FF         ???
CBEB   FF         ???
CBEC   FF         ???
CBED   FF         ???
CBEE   FF         ???
CBEF   FF         ???
CBF0   FF         ???
CBF1   FF         ???
CBF2   FF         ???
CBF3   FF         ???
CBF4   FF         ???
CBF5   FF         ???
CBF6   FF         ???
CBF7   FF         ???
CBF8   FF         ???
CBF9   FF         ???
CBFA   FF         ???
CBFB   FF         ???
CBFC   FF         ???
CBFD   FF         ???
CBFE   FF         ???
CBFF   C3         ???
CC00   E4 37      CPX $37
CC02   D0 2D      BNE $CC31
CC04   A9 07      LDA #$07
CC06   C5 36      CMP $36
CC08   F0 27      BEQ $CC31
CC0A   85 36      STA $36
CC0C   68         PLA
CC0D   C9 8D      CMP #$8D
CC0F   F0 74      BEQ $CC85
CC11   29 01      AND #$01
CC13   09 80      ORA #$80
CC15   9D 38 07   STA $0738,X
CC18   8A         TXA
CC19   48         PHA
CC1A   A9 84      LDA #$84
CC1C   48         PHA
CC1D   BD 38 07   LDA $0738,X
CC20   4A         LSR A
CC21   A9 80      LDA #$80
CC23   B0 01      BCS $CC26
CC25   0A         ASL A
CC26   48         PHA
CC27   A9 0C      LDA #$0C
CC29   9D B8 05   STA $05B8,X
CC2C   A9 00      LDA #$00
CC2E   48         PHA
CC2F   F0 3F      BEQ $CC70
CC31   E4 39      CPX $39
CC33   D0 D7      BNE $CC0C
CC35   A9 05      LDA #$05
CC37   85 38      STA $38
CC39   BD 38 07   LDA $0738,X
CC3C   29 01      AND #$01
CC3E   D0 14      BNE $CC54
CC40   68         PLA
CC41   68         PLA
CC42   68         PLA
CC43   68         PLA
CC44   A9 00      LDA #$00
CC46   9D B8 03   STA $03B8,X
CC49   9D B8 04   STA $04B8,X
CC4C   9D 38 04   STA $0438,X
CC4F   9D 38 05   STA $0538,X
CC52   F0 3C      BEQ $CC90
CC54   BD 38 07   LDA $0738,X
CC57   29 01      AND #$01
CC59   09 80      ORA #$80
CC5B   9D 38 07   STA $0738,X
CC5E   8A         TXA
CC5F   48         PHA
CC60   A9 A1      LDA #$A1
CC62   48         PHA
CC63   A9 10      LDA #$10
CC65   48         PHA
CC66   A9 0C      LDA #$0C
CC68   D0 30      BNE $CC9A
CC6A   FF         ???
CC6B   FF         ???
CC6C   FF         ???
CC6D   FF         ???
CC6E   FF         ???
CC6F   FF         ???
CC70   B9 82 C0   LDA $C082,Y
CC73   29 F1      AND #$F1
CC75   1D B8 05   ORA $05B8,X
CC78   99 82 C0   STA $C082,Y
CC7B   68         PLA
CC7C   30 11      BMI $CC8F
CC7E   F0 80      BEQ $CC00
CC80   6A         ROR A
CC81   B0 89      BCS $CC0C
CC83   90 B4      BCC $CC39
CC85   A9 00      LDA #$00
CC87   9D B8 05   STA $05B8,X
CC8A   A9 01      LDA #$01
CC8C   48         PHA
CC8D   D0 E1      BNE $CC70
CC8F   60         RTS
CC90   A9 C0      LDA #$C0
CC92   9D B8 06   STA $06B8,X
CC95   8C 22 02   STY $0222
CC98   A9 0A      LDA #$0A
CC9A   9D B8 05   STA $05B8,X
CC9D   A9 00      LDA #$00
CC9F   48         PHA
CCA0   F0 CE      BEQ $CC70
CCA2   68         PLA
CCA3   68         PLA
CCA4   68         PLA
CCA5   68         PLA
CCA6   A9 05      LDA #$05
CCA8   9D 38 06   STA $0638,X
CCAB   B9 81 C0   LDA $C081,Y
CCAE   29 FB      AND #$FB
CCB0   99 81 C0   STA $C081,Y
CCB3   A9 00      LDA #$00
CCB5   99 80 C0   STA $C080,Y
CCB8   B9 81 C0   LDA $C081,Y
CCBB   09 04      ORA #$04
CCBD   99 81 C0   STA $C081,Y
CCC0   B9 82 C0   LDA $C082,Y
CCC3   0A         ASL A
CCC4   10 FA      BPL $CCC0
CCC6   B9 80 C0   LDA $C080,Y
CCC9   48         PHA
CCCA   B9 82 C0   LDA $C082,Y
CCCD   09 10      ORA #$10
CCCF   99 82 C0   STA $C082,Y
CCD2   B9 82 C0   LDA $C082,Y
CCD5   0A         ASL A
CCD6   30 FA      BMI $CCD2
CCD8   B9 82 C0   LDA $C082,Y
CCDB   29 EF      AND #$EF
CCDD   99 82 C0   STA $C082,Y
CCE0   DE 38 06   DEC $0638,X
CCE3   D0 DB      BNE $CCC0
CCE5   68         PLA
CCE6   9D B8 06   STA $06B8,X
CCE9   68         PLA
CCEA   9D 38 05   STA $0538,X
CCED   68         PLA
CCEE   9D 38 04   STA $0438,X
CCF1   68         PLA
CCF2   9D B8 04   STA $04B8,X
CCF5   68         PLA
CCF6   9D B8 03   STA $03B8,X
CCF9   18         CLC
CCFA   90 99      BCC $CC95
CCFC   FF         ???
CCFD   FF         ???
CCFE   FF         ???
CCFF   C8         INY
CD00   8A         TXA
CD01   48         PHA
CD02   48         PHA
CD03   48         PHA
CD04   A9 12      LDA #$12
CD06   48         PHA
CD07   BC B8 03   LDY $03B8,X
CD0A   BD B8 04   LDA $04B8,X
CD0D   AA         TAX
CD0E   98         TYA
CD0F   A0 05      LDY #$05
CD11   D0 6D      BNE $CD80
CD13   AE F8 07   LDX $07F8
CD16   A9 24      LDA #$24
CD18   48         PHA
CD19   BC 38 04   LDY $0438,X
CD1C   BD 38 05   LDA $0538,X
CD1F   AA         TAX
CD20   98         TYA
CD21   A0 0C      LDY #$0C
CD23   D0 5B      BNE $CD80
CD25   AE F8 07   LDX $07F8
CD28   A9 43      LDA #$43
CD2A   48         PHA
CD2B   AD 00 C0   LDA $C000
CD2E   0A         ASL A
CD2F   08         PHP
CD30   BD B8 06   LDA $06B8,X
CD33   2A         ROL A
CD34   2A         ROL A
CD35   2A         ROL A
CD36   29 03      AND #$03
CD38   49 03      EOR #$03
CD3A   38         SEC
CD3B   69 00      ADC #$00
CD3D   28         PLP
CD3E   A2 00      LDX #$00
CD40   A0 10      LDY #$10
CD42   D0 4D      BNE $CD91
CD44   A9 8D      LDA #$8D
CD46   8D 11 02   STA $0211
CD49   48         PHA
CD4A   A9 11      LDA #$11
CD4C   48         PHA
CD4D   48         PHA
CD4E   A9 00      LDA #$00
CD50   F0 12      BEQ $CD64
CD52   FF         ???
CD53   FF         ???
CD54   FF         ???
CD55   FF         ???
CD56   FF         ???
CD57   FF         ???
CD58   FF         ???
CD59   FF         ???
CD5A   FF         ???
CD5B   FF         ???
CD5C   FF         ???
CD5D   FF         ???
CD5E   FF         ???
CD5F   FF         ???
CD60   FF         ???
CD61   FF         ???
CD62   FF         ???
CD63   FF         ???
CD64   AE F8 07   LDX $07F8
CD67   AC 22 02   LDY $0222
CD6A   9D B8 05   STA $05B8,X
CD6D   A9 01      LDA #$01
CD6F   48         PHA
CD70   B9 82 C0   LDA $C082,Y
CD73   29 F1      AND #$F1
CD75   1D B8 05   ORA $05B8,X
CD78   99 82 C0   STA $C082,Y
CD7B   68         PLA
CD7C   30 4E      BMI $CDCC
CD7E   F0 80      BEQ $CD00
CD80   E0 80      CPX #$80
CD82   90 0D      BCC $CD91
CD84   49 FF      EOR #$FF
CD86   69 00      ADC #$00
CD88   48         PHA
CD89   8A         TXA
CD8A   49 FF      EOR #$FF
CD8C   69 00      ADC #$00
CD8E   AA         TAX
CD8F   68         PLA
CD90   38         SEC
CD91   8D 21 02   STA $0221
CD94   8E 20 02   STX $0220
CD97   A9 AB      LDA #$AB
CD99   90 02      BCC $CD9D
CD9B   A9 AD      LDA #$AD
CD9D   48         PHA
CD9E   A9 AC      LDA #$AC
CDA0   99 01 02   STA $0201,Y
CDA3   A2 11      LDX #$11
CDA5   A9 00      LDA #$00
CDA7   18         CLC
CDA8   2A         ROL A
CDA9   C9 0A      CMP #$0A
CDAB   90 02      BCC $CDAF
CDAD   E9 0A      SBC #$0A
CDAF   2E 21 02   ROL $0221
CDB2   2E 20 02   ROL $0220
CDB5   CA         DEX
CDB6   D0 F0      BNE $CDA8
CDB8   09 B0      ORA #$B0
CDBA   99 00 02   STA $0200,Y
CDBD   88         DEY
CDBE   F0 08      BEQ $CDC8
CDC0   C0 07      CPY #$07
CDC2   F0 04      BEQ $CDC8
CDC4   C0 0E      CPY #$0E
CDC6   D0 DB      BNE $CDA3
CDC8   68         PLA
CDC9   99 00 02   STA $0200,Y
CDCC   60         RTS
CDCD   FF         ???
CDCE   FF         ???
CDCF   FF         ???
CDD0   FF         ???
CDD1   FF         ???
CDD2   FF         ???
CDD3   FF         ???
CDD4   FF         ???
CDD5   FF         ???
CDD6   FF         ???
CDD7   FF         ???
CDD8   FF         ???
CDD9   FF         ???
CDDA   FF         ???
CDDB   FF         ???
CDDC   FF         ???
CDDD   FF         ???
CDDE   FF         ???
CDDF   FF         ???
CDE0   FF         ???
CDE1   FF         ???
CDE2   FF         ???
CDE3   FF         ???
CDE4   FF         ???
CDE5   FF         ???
CDE6   FF         ???
CDE7   FF         ???
CDE8   FF         ???
CDE9   FF         ???
CDEA   FF         ???
CDEB   FF         ???
CDEC   FF         ???
CDED   FF         ???
CDEE   FF         ???
CDEF   FF         ???
CDF0   FF         ???
CDF1   FF         ???
CDF2   FF         ???
CDF3   FF         ???
CDF4   FF         ???
CDF5   FF         ???
CDF6   FF         ???
CDF7   FF         ???
CDF8   FF         ???
CDF9   FF         ???
CDFA   FF         ???
CDFB   FF         ???
CDFC   FF         ???
CDFD   FF         ???
CDFE   FF         ???
CDFF   CD         ???


CE00   B8         CLV
CE01   50 13      BVC $CE16
CE03   BD 38 07   LDA $0738,X
CE06   29 01      AND #$01
CE08   F0 47      BEQ $CE51
CE0A   A9 10      LDA #$10
CE0C   48         PHA
CE0D   A9 05      LDA #$05
CE0F   9D 38 06   STA $0638,X
CE12   A9 7F      LDA #$7F
CE14   69 01      ADC #$01
CE16   B9 82 C0   LDA $C082,Y
CE19   30 FB      BMI $CE16
CE1B   B9 81 C0   LDA $C081,Y
CE1E   29 FB      AND #$FB
CE20   99 81 C0   STA $C081,Y
CE23   A9 FF      LDA #$FF
CE25   99 80 C0   STA $C080,Y
CE28   B9 81 C0   LDA $C081,Y
CE2B   09 04      ORA #$04
CE2D   99 81 C0   STA $C081,Y
CE30   68         PLA
CE31   99 80 C0   STA $C080,Y
CE34   B9 82 C0   LDA $C082,Y
CE37   09 20      ORA #$20
CE39   99 82 C0   STA $C082,Y
CE3C   B9 82 C0   LDA $C082,Y
CE3F   10 FB      BPL $CE3C
CE41   29 DF      AND #$DF
CE43   99 82 C0   STA $C082,Y
CE46   70 3F      BVS $CE87
CE48   70 07      BVS $CE51
CE4A   BD 38 07   LDA $0738,X
CE4D   4A         LSR A
CE4E   4A         LSR A
CE4F   4A         LSR A
CE50   4A         LSR A
CE51   B8         CLV
CE52   9D B8 05   STA $05B8,X
CE55   F0 02      BEQ $CE59
CE57   A9 80      LDA #$80
CE59   48         PHA
CE5A   50 14      BVC $CE70
CE5C   FF         ???
CE5D   FF         ???
CE5E   FF         ???
CE5F   FF         ???
CE60   FF         ???
CE61   FF         ???
CE62   FF         ???
CE63   FF         ???
CE64   FF         ???
CE65   FF         ???
CE66   FF         ???
CE67   FF         ???
CE68   FF         ???
CE69   FF         ???
CE6A   FF         ???
CE6B   FF         ???
CE6C   FF         ???
CE6D   FF         ???
CE6E   FF         ???
CE6F   FF         ???
CE70   B9 82 C0   LDA $C082,Y
CE73   29 F1      AND #$F1
CE75   1D B8 05   ORA $05B8,X
CE78   99 82 C0   STA $C082,Y
CE7B   68         PLA
CE7C   F0 82      BEQ $CE00
CE7E   C9 02      CMP #$02
CE80   F0 81      BEQ $CE03
CE82   D0 02      BNE $CE86
CE84   F0 C2      BEQ $CE48
CE86   B8         CLV
CE87   B9 81 C0   LDA $C081,Y
CE8A   29 FB      AND #$FB
CE8C   99 81 C0   STA $C081,Y
CE8F   A9 00      LDA #$00
CE91   99 80 C0   STA $C080,Y
CE94   B9 81 C0   LDA $C081,Y
CE97   09 04      ORA #$04
CE99   99 81 C0   STA $C081,Y
CE9C   B9 82 C0   LDA $C082,Y
CE9F   0A         ASL A
CEA0   10 FA      BPL $CE9C
CEA2   B9 80 C0   LDA $C080,Y
CEA5   70 05      BVS $CEAC
CEA7   9D 38 06   STA $0638,X
CEAA   50 01      BVC $CEAD
CEAC   48         PHA
CEAD   B9 82 C0   LDA $C082,Y
CEB0   09 10      ORA #$10
CEB2   99 82 C0   STA $C082,Y
CEB5   B9 82 C0   LDA $C082,Y
CEB8   0A         ASL A
CEB9   30 FA      BMI $CEB5
CEBB   B9 82 C0   LDA $C082,Y
CEBE   29 EF      AND #$EF
CEC0   99 82 C0   STA $C082,Y
CEC3   50 19      BVC $CEDE
CEC5   DE 38 06   DEC $0638,X
CEC8   D0 D2      BNE $CE9C
CECA   68         PLA
CECB   9D B8 06   STA $06B8,X
CECE   68         PLA
CECF   9D 38 05   STA $0538,X
CED2   68         PLA
CED3   9D 38 04   STA $0438,X
CED6   68         PLA
CED7   9D B8 04   STA $04B8,X
CEDA   68         PLA
CEDB   9D B8 03   STA $03B8,X
CEDE   A9 00      LDA #$00
CEE0   F0 A2      BEQ $CE84
CEE2   FF         ???
CEE3   FF         ???
CEE4   FF         ???
CEE5   FF         ???
CEE6   FF         ???
CEE7   FF         ???
CEE8   FF         ???
CEE9   FF         ???
CEEA   FF         ???
CEEB   FF         ???
CEEC   FF         ???
CEED   FF         ???
CEEE   FF         ???
CEEF   FF         ???
CEF0   FF         ???
CEF1   FF         ???
CEF2   FF         ???
CEF3   FF         ???
CEF4   FF         ???
CEF5   FF         ???
CEF6   FF         ???
CEF7   FF         ???
CEF8   FF         ???
CEF9   FF         ???
CEFA   FF         ???
CEFB   FF         ???
CEFC   FF         ???
CEFD   FF         ???
CEFE   FF         ???
CEFF   C1         ???


