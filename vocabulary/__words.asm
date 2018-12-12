; =========== ! both ===========

start_21_3a_6d:
 call COMUCopyCode
 db end_21_3a_6d-start_21_3a_6d-4
    ld   (hl),e
    inc  hl
    ld   (hl),d
    dec  hl
end_21_3a_6d:

start_21_3a_66:
    ld   (hl),e
    inc  hl
    ld   (hl),d
    dec  hl
    ret

; =========== * word ===========

start_2a_3a_66:
    call  MULTMultiply16
    ret

; =========== + both ===========

start_2b_3a_6d:
 call COMUCopyCode
 db end_2b_3a_6d-start_2b_3a_6d-4
    add  hl,de
end_2b_3a_6d:

start_2b_3a_66:
    add  hl,de
    ret

; =========== +! word ===========

start_2b_21_3a_66:
    ld   a,(hl)
    add  a,e
    ld   (hl),a
    inc  hl
    ld   a,(hl)
    adc  a,d
    ld   (hl),a
    dec  hl
    ret

; =========== ++ both ===========

start_2b_2b_3a_6d:
 call COMUCopyCode
 db end_2b_2b_3a_6d-start_2b_2b_3a_6d-4
    inc  hl
end_2b_2b_3a_6d:

start_2b_2b_3a_66:
    inc  hl
    ret

; =========== +++ both ===========

start_2b_2b_2b_3a_6d:
 call COMUCopyCode
 db end_2b_2b_2b_3a_6d-start_2b_2b_2b_3a_6d-4
    inc  hl
    inc  hl
end_2b_2b_2b_3a_6d:

start_2b_2b_2b_3a_66:
    inc  hl
    inc  hl
    ret

; =========== +or word ===========

start_2b_6f_72_3a_66:
    ld   a,h
    or   d
    ld   h,a
    ld   a,l
    or   e
    ld   l,a
    ret

; =========== - both ===========

start_2d_3a_6d:
 call COMUCopyCode
 db end_2d_3a_6d-start_2d_3a_6d-4
    ld   a,h
    cpl
    ld   h,a
    ld   a,l
    cpl
    ld   l,a
end_2d_3a_6d:

start_2d_3a_66:
    ld   a,h
    cpl
    ld   h,a
    ld   a,l
    cpl
    ld   l,a
    ret

; =========== -- both ===========

start_2d_2d_3a_6d:
 call COMUCopyCode
 db end_2d_2d_3a_6d-start_2d_2d_3a_6d-4
    dec  hl
end_2d_2d_3a_6d:

start_2d_2d_3a_66:
    dec  hl
    ret

; =========== --- both ===========

start_2d_2d_2d_3a_6d:
 call COMUCopyCode
 db end_2d_2d_2d_3a_6d-start_2d_2d_2d_3a_6d-4
    dec  hl
    dec  hl
end_2d_2d_2d_3a_6d:

start_2d_2d_2d_3a_66:
    dec  hl
    dec  hl
    ret

; =========== / word ===========

start_2f_3a_66:
    push  de
    call  DIVDivideMod16
    ex   de,hl
    pop  de
    ret

; =========== /mod word ===========

start_2f_6d_6f_64_3a_66:
    call  DIVDivideMod16
    ex  de,hl
    ret

; =========== 1, word ===========

start_31_2c_3a_66:
    ld   a,l
    call  FARCompileByte
    ret

; =========== 2* both ===========

start_32_2a_3a_6d:
 call COMUCopyCode
 db end_32_2a_3a_6d-start_32_2a_3a_6d-4
    add  hl,hl
end_32_2a_3a_6d:

start_32_2a_3a_66:
    add  hl,hl
    ret

; =========== 2, word ===========

start_32_2c_3a_66:
    call FARCompileWord
    ret

; =========== 2/ both ===========

start_32_2f_3a_6d:
 call COMUCopyCode
 db end_32_2f_3a_6d-start_32_2f_3a_6d-4
    sra  h
    rr   l
end_32_2f_3a_6d:

start_32_2f_3a_66:
    sra  h
    rr   l
    ret

; =========== ; macro ===========

start_3b_3a_6d:
 call COMUCopyCode
 db end_3b_3a_6d-start_3b_3a_6d-4
    ret
end_3b_3a_6d:

; =========== < word ===========

start_3c_3a_66:
    ; checking if B < A
    ld   a,h         ; signs different ??
    xor  d
    jp   m,__Less_DiffSigns
    push  de
    ex   de,hl         ; HL = B, DE = A
    sbc  hl,de         ; calculate B-A, CS if -ve e.g. B < A
    pop  de
    ld   hl,$0000        ; so return 0 if B-A doesn't generate a borrow
    ret  nc
    dec  hl
    ret
__Less_DiffSigns:
    bit  7,d         ; if B bit 7 is set, -ve B must be < A
    ld   hl,$0000
    ret  z          ; so return zero if not set
    dec  hl
    ret
    ret

; =========== = word ===========

start_3d_3a_66:
    ld   a,h         ; D = H^D
    xor  d
    ld   h,a
    ld   a,l         ; A = L^E | H^D
    xor  e
    or   h
    ld   hl,$0000        ; return 0 if any differences.
    ret  nz
    dec  hl
    ret

; =========== @ both ===========

start_40_3a_6d:
 call COMUCopyCode
 db end_40_3a_6d-start_40_3a_6d-4
    ld   a,(hl)
    inc  hl
    ld   h,(hl)
    ld   l,a
end_40_3a_6d:

start_40_3a_66:
    ld   a,(hl)
    inc  hl
    ld   h,(hl)
    ld   l,a
    ret

; =========== a>b both ===========

start_61_3e_62_3a_6d:
 call COMUCopyCode
 db end_61_3e_62_3a_6d-start_61_3e_62_3a_6d-4
    ld   e,l
    ld   d,h
end_61_3e_62_3a_6d:

start_61_3e_62_3a_66:
    ld   e,l
    ld   d,h
    ret

; =========== a>r macro ===========

start_61_3e_72_3a_6d:
 call COMUCopyCode
 db end_61_3e_72_3a_6d-start_61_3e_72_3a_6d-4
    push  hl
end_61_3e_72_3a_6d:

; =========== ab>r macro ===========

start_61_62_3e_72_3a_6d:
 call COMUCopyCode
 db end_61_62_3e_72_3a_6d-start_61_62_3e_72_3a_6d-4
    push  hl
    push  de
end_61_62_3e_72_3a_6d:

; =========== abs word ===========

start_61_62_73_3a_66:
    bit  7,h
    jp   nz,__Negate
    ret

; =========== and word ===========

start_61_6e_64_3a_66:
    ld   a,h
    and  d
    ld   h,a
    ld   a,l
    and  e
    ld   l,a
    ret

; =========== b! both ===========

start_62_21_3a_6d:
 call COMUCopyCode
 db end_62_21_3a_6d-start_62_21_3a_6d-4
    ld   (hl),e
end_62_21_3a_6d:

start_62_21_3a_66:
    ld   (hl),e
    ret

; =========== b>a both ===========

start_62_3e_61_3a_6d:
 call COMUCopyCode
 db end_62_3e_61_3a_6d-start_62_3e_61_3a_6d-4
    ld   l,e
    ld   h,d
end_62_3e_61_3a_6d:

start_62_3e_61_3a_66:
    ld   l,e
    ld   h,d
    ret

; =========== b>r macro ===========

start_62_3e_72_3a_6d:
 call COMUCopyCode
 db end_62_3e_72_3a_6d-start_62_3e_72_3a_6d-4
    push  de
end_62_3e_72_3a_6d:

; =========== b@ both ===========

start_62_40_3a_6d:
 call COMUCopyCode
 db end_62_40_3a_6d-start_62_40_3a_6d-4
    ld   l,(hl)
    ld   h,$00
end_62_40_3a_6d:

start_62_40_3a_66:
    ld   l,(hl)
    ld   h,$00
    ret

; =========== break macro ===========

start_62_72_65_61_6b_3a_6d:
 call COMUCopyCode
 db end_62_72_65_61_6b_3a_6d-start_62_72_65_61_6b_3a_6d-4
    db   $DD,$01
end_62_72_65_61_6b_3a_6d:

; =========== bswap both ===========

start_62_73_77_61_70_3a_6d:
 call COMUCopyCode
 db end_62_73_77_61_70_3a_6d-start_62_73_77_61_70_3a_6d-4
    ld   a,h
    ld   h,l
    ld   l,a
end_62_73_77_61_70_3a_6d:

start_62_73_77_61_70_3a_66:
    ld   a,h
    ld   h,l
    ld   l,a
    ret

; =========== commands word ===========

start_63_6f_6d_6d_61_6e_64_73_3a_66:
    call  DICTMakeLastCompiles     ; make the last word defined a 'commands' (e.g. immediate)
    ret

; =========== copy word ===========

start_63_6f_70_79_3a_66:
    ; B (DE) = source A (HL) = target
    ld   bc,(Parameter)       ; get count
    ld   a,b         ; zero check
    or   c
    jr   z,__copyExit
    push  de          ; save A/B
    push  hl
    xor  a          ; find direction.
    sbc  hl,de
    ld   a,h
    add  hl,de
    bit  7,a         ; if +ve use LDDR
    jr   z,__copy2
    ex   de,hl         ; LDIR etc do (DE) <- (HL)
    ldir
    jr   __copyExit
__copy2:
    add  hl,bc         ; add length to HL,DE, swap as LDDR does (DE) <- (HL)
    ex   de,hl
    add  hl,bc
    dec  de          ; -1 to point to last byte
    dec  hl
    lddr
__copyExit:
    pop  hl
    pop  de
    ret

; =========== debug word ===========

start_64_65_62_75_67_3a_66:
    call  DEBUGShow
    ret

; =========== fill word ===========

start_66_69_6c_6c_3a_66:
    ld   bc,(Parameter)       ; count to do.
    ld   a,b
    or   c
    jr   z,__fillExit       ; if count zero exit.
    push  de
    push  hl
__fillLoop:
    ld   (hl),e
    inc  hl
    dec  bc
    ld   a,b
    or   c
    jr   nz,__fillLoop
__fillExit:
    pop  hl
    pop  de
    ret

; =========== h word ===========

start_68_3a_66:
    ex   de,hl
    ld   hl,Here
    ret

; =========== halt word ===========

start_68_61_6c_74_3a_66:
__haltz80:
    di
    halt
    jr   __haltz80
    ret

; =========== here word ===========

start_68_65_72_65_3a_66:
    ex   de,hl
    ld   hl,(Here)
    ret

; =========== hex! word ===========

start_68_65_78_21_3a_66:
    ; DE = word, HL = pos
    call  GFXWriteHexWord      ; write out the word
    ret

; =========== mod word ===========

start_6d_6f_64_3a_66:
    push  de
    call  DIVDivideMod16
    pop  de
    ret

; =========== negate word ===========

start_6e_65_67_61_74_65_3a_66:
__Negate:
    ld   a,h
    cpl
    ld   h,a
    ld   a,l
    cpl
    ld   l,a
    inc  hl
    ret

; =========== or word ===========

start_6f_72_3a_66:
    ld   a,h
    xor  d
    ld   h,a
    ld   a,l
    xor  e
    ld   l,a
    ret

; =========== or! word ===========

start_6f_72_21_3a_66:
    ld   a,(hl)
    or   e
    ld   (hl),a
    inc  hl
    ld   a,(hl)
    or   d
    ld   (hl),a
    dec  hl
    ret

; =========== p! both ===========

start_70_21_3a_6d:
 call COMUCopyCode
 db end_70_21_3a_6d-start_70_21_3a_6d-4
    ld   c,l
    ld   b,h
    out  (c),e
end_70_21_3a_6d:

start_70_21_3a_66:
    ld   c,l
    ld   b,h
    out  (c),e
    ret

; =========== p@ word ===========

start_70_40_3a_66:
    ld   c,l
    ld   b,h
    in   l,(c)
    ld   h,0
    ret

; =========== param! word ===========

start_70_61_72_61_6d_21_3a_66:
    ld   (Parameter),hl
    ret

; =========== pop macro ===========

start_70_6f_70_3a_6d:
 call COMUCopyCode
 db end_70_6f_70_3a_6d-start_70_6f_70_3a_6d-4
    ex   de,hl
    pop  hl
end_70_6f_70_3a_6d:

; =========== push macro ===========

start_70_75_73_68_3a_6d:
 call COMUCopyCode
 db end_70_75_73_68_3a_6d-start_70_75_73_68_3a_6d-4
    push  hl
end_70_75_73_68_3a_6d:

; =========== r>a macro ===========

start_72_3e_61_3a_6d:
 call COMUCopyCode
 db end_72_3e_61_3a_6d-start_72_3e_61_3a_6d-4
    pop  hl
end_72_3e_61_3a_6d:

; =========== r>ab macro ===========

start_72_3e_61_62_3a_6d:
 call COMUCopyCode
 db end_72_3e_61_62_3a_6d-start_72_3e_61_62_3a_6d-4
    pop  de
    pop  hl
end_72_3e_61_62_3a_6d:

; =========== r>b macro ===========

start_72_3e_62_3a_6d:
 call COMUCopyCode
 db end_72_3e_62_3a_6d-start_72_3e_62_3a_6d-4
    pop  de
end_72_3e_62_3a_6d:

; =========== swap both ===========

start_73_77_61_70_3a_6d:
 call COMUCopyCode
 db end_73_77_61_70_3a_6d-start_73_77_61_70_3a_6d-4
    ex   de,hl         ; 2nd now TOS
end_73_77_61_70_3a_6d:

start_73_77_61_70_3a_66:
    ex   de,hl         ; 2nd now TOS
    ret

