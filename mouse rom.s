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
0031   AA         TAX		; X = $n0
0032   08         PHP
0033   0A         ASL A
0034   0A         ASL A
0035   0A         ASL A
0036   0A         ASL A
0037   28         PLP
0038   A8         TAY		; Y = $0n
0039   AD F8 07   LDA $07F8
003C   8E F8 07   STX $07F8	; X = $Cn
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
0060   99 83 C0   STA $C083,Y
0063   A9 3E      LDA #$3E
0065   99 82 C0   STA $C082,Y
0068   B9 83 C0   LDA $C083,Y
006B   09 04      ORA #$04
006D   99 83 C0   STA $C083,Y
0070   B9 82 C0   LDA $C082,Y
0073   29 C1      AND #$C1
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
C805   38         SEC 		; Signature byte?
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
C8FF   01 98      ORA ($98,X)
