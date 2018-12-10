; =========== ! both ===========

start_21_2e_6d:
 ld a,end_21_2e_6d-start_21_2e_6d-5
 call COMUCopyCode
    ld   (hl),e
    inc  hl
    ld   (hl),d
    dec  hl
end_21_2e_6d:

start_21_2e_66:
    ld   (hl),e
    inc  hl
    ld   (hl),d
    dec  hl
    ret

; =========== * word ===========

start_2a_2e_66:
    call  MULTMultiply16
    ex   de,hl
    ret

; =========== + both ===========

start_2b_2e_6d:
 ld a,end_2b_2e_6d-start_2b_2e_6d-5
 call COMUCopyCode
    add  hl,de
end_2b_2e_6d:

start_2b_2e_66:
    add  hl,de
    ret

; =========== +! word ===========

start_2b_21_2e_66:
    ld   a,(hl)
    add  a,e
    ld   (hl),a
    inc  hl
    ld   a,(hl)
    adc  a,d
    ld   (hl),a
    dec  hl
    ret

; =========== +or word ===========

start_2b_6f_72_2e_66:
    ld   a,h
    or   d
    ld   h,a
    ld   a,l
    or   e
    ld   l,a
    ret

; =========== , word ===========

start_2c_2e_66:
    call FARCompileWord
    ret

; =========== - both ===========

start_2d_2e_6d:
 ld a,end_2d_2e_6d-start_2d_2e_6d-5
 call COMUCopyCode
    ld   a,h
    cpl
    ld   h,a
    ld   a,l
    cpl
    ld   l,a
end_2d_2e_6d:

start_2d_2e_66:
    ld   a,h
    cpl
    ld   h,a
    ld   a,l
    cpl
    ld   l,a
    ret

; =========== / word ===========

start_2f_2e_66:
    push  de
    call  DIVDivideMod16
    ex   de,hl
    pop  de
    ret

; =========== /mod word ===========

start_2f_6d_6f_64_2e_66:
    call  DIVDivideMod16
    ret

; =========== 2* both ===========

start_32_2a_2e_6d:
 ld a,end_32_2a_2e_6d-start_32_2a_2e_6d-5
 call COMUCopyCode
    add  hl,hl
end_32_2a_2e_6d:

start_32_2a_2e_66:
    add  hl,hl
    ret

; =========== 2/ both ===========

start_32_2f_2e_6d:
 ld a,end_32_2f_2e_6d-start_32_2f_2e_6d-5
 call COMUCopyCode
    sra  h
    rr   l
end_32_2f_2e_6d:

start_32_2f_2e_66:
    sra  h
    rr   l
    ret

; =========== ; macro ===========

start_3b_2e_6d:
 ld a,end_3b_2e_6d-start_3b_2e_6d-5
 call COMUCopyCode
    ret
end_3b_2e_6d:

; =========== @ both ===========

start_40_2e_6d:
 ld a,end_40_2e_6d-start_40_2e_6d-5
 call COMUCopyCode
    ld   a,(hl)
    inc  hl
    ld   h,(hl)
    ld   l,a
end_40_2e_6d:

start_40_2e_66:
    ld   a,(hl)
    inc  hl
    ld   h,(hl)
    ld   l,a
    ret

; =========== a>b both ===========

start_61_3e_62_2e_6d:
 ld a,end_61_3e_62_2e_6d-start_61_3e_62_2e_6d-5
 call COMUCopyCode
    ld   e,l
    ld   d,h
end_61_3e_62_2e_6d:

start_61_3e_62_2e_66:
    ld   e,l
    ld   d,h
    ret

; =========== a>r macro ===========

start_61_3e_72_2e_6d:
 ld a,end_61_3e_72_2e_6d-start_61_3e_72_2e_6d-5
 call COMUCopyCode
    push  hl
end_61_3e_72_2e_6d:

; =========== ab>r macro ===========

start_61_62_3e_72_2e_6d:
 ld a,end_61_62_3e_72_2e_6d-start_61_62_3e_72_2e_6d-5
 call COMUCopyCode
    push  hl
    push  de
end_61_62_3e_72_2e_6d:

; =========== abs word ===========

start_61_62_73_2e_66:
    bit  7,h
    jp   nz,__Negate
    ret

; =========== and word ===========

start_61_6e_64_2e_66:
    ld   a,h
    and  d
    ld   h,a
    ld   a,l
    and  e
    ld   l,a
    ret

; =========== b>a both ===========

start_62_3e_61_2e_6d:
 ld a,end_62_3e_61_2e_6d-start_62_3e_61_2e_6d-5
 call COMUCopyCode
    ld   l,d
    ld   h,e
end_62_3e_61_2e_6d:

start_62_3e_61_2e_66:
    ld   l,d
    ld   h,e
    ret

; =========== b>r macro ===========

start_62_3e_72_2e_6d:
 ld a,end_62_3e_72_2e_6d-start_62_3e_72_2e_6d-5
 call COMUCopyCode
    push  de
end_62_3e_72_2e_6d:

; =========== break macro ===========

start_62_72_65_61_6b_2e_6d:
 ld a,end_62_72_65_61_6b_2e_6d-start_62_72_65_61_6b_2e_6d-5
 call COMUCopyCode
    db   $DD,$01
end_62_72_65_61_6b_2e_6d:

; =========== bswap both ===========

start_62_73_77_61_70_2e_6d:
 ld a,end_62_73_77_61_70_2e_6d-start_62_73_77_61_70_2e_6d-5
 call COMUCopyCode
    ld   a,h
    ld   h,l
    ld   l,a
end_62_73_77_61_70_2e_6d:

start_62_73_77_61_70_2e_66:
    ld   a,h
    ld   h,l
    ld   l,a
    ret

; =========== c! both ===========

start_63_21_2e_6d:
 ld a,end_63_21_2e_6d-start_63_21_2e_6d-5
 call COMUCopyCode
    ld   (hl),e
end_63_21_2e_6d:

start_63_21_2e_66:
    ld   (hl),e
    ret

; =========== c, word ===========

start_63_2c_2e_66:
    ld   a,l
    call  FARCompileByte
    ret

; =========== c@ both ===========

start_63_40_2e_6d:
 ld a,end_63_40_2e_6d-start_63_40_2e_6d-5
 call COMUCopyCode
    ld   l,(hl)
    ld   h,$00
end_63_40_2e_6d:

start_63_40_2e_66:
    ld   l,(hl)
    ld   h,$00
    ret

; =========== debug word ===========

start_64_65_62_75_67_2e_66:
    call  DEBUGShow
    ret

; =========== fill word ===========

start_66_69_6c_6c_2e_66:
    ex   de,hl         ; B = value (DE) A = target (HL)
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

; =========== forth word ===========

start_66_6f_72_74_68_2e_66:
    xor  a          ; set dictionary flag to $00
    ld   (__DICTSelector),a
    ret

; =========== h word ===========

start_68_2e_66:
    ex   de,hl
    ld   hl,Here
    ret

; =========== halt word ===========

start_68_61_6c_74_2e_66:
__haltz80:
    di
    halt
    jr   __haltz80
    ret

; =========== here word ===========

start_68_65_72_65_2e_66:
    ex   de,hl
    ld   hl,(Here)
    ret

; =========== hex! word ===========

start_68_65_78_21_2e_66:
    ; DE = word, HL = pos
    call  GFXWriteHexWord      ; write out the word
    ret

; =========== macro word ===========

start_6d_61_63_72_6f_2e_66:
    ld  a,$80         ; set dictionary flag to $80
    ld   (__DICTSelector),a
    ret

; =========== mod word ===========

start_6d_6f_64_2e_66:
    push  de
    call  DIVDivideMod16
    pop  de
    ret

; =========== negate word ===========

start_6e_65_67_61_74_65_2e_66:
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

start_6f_72_2e_66:
    ld   a,h
    xor  d
    ld   h,a
    ld   a,l
    xor  e
    ld   l,a
    ret

; =========== or! word ===========

start_6f_72_21_2e_66:
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

start_70_21_2e_6d:
 ld a,end_70_21_2e_6d-start_70_21_2e_6d-5
 call COMUCopyCode
    ld   c,l
    ld   b,h
    out  (c),e
end_70_21_2e_6d:

start_70_21_2e_66:
    ld   c,l
    ld   b,h
    out  (c),e
    ret

; =========== p@ both ===========

start_70_40_2e_6d:
 ld a,end_70_40_2e_6d-start_70_40_2e_6d-5
 call COMUCopyCode
    ld   c,l
    ld   b,h
    in   l,(c)
    ld   h,0
end_70_40_2e_6d:

start_70_40_2e_66:
    ld   c,l
    ld   b,h
    in   l,(c)
    ld   h,0
    ret

; =========== r>a macro ===========

start_72_3e_61_2e_6d:
 ld a,end_72_3e_61_2e_6d-start_72_3e_61_2e_6d-5
 call COMUCopyCode
    pop  hl
end_72_3e_61_2e_6d:

; =========== r>ab macro ===========

start_72_3e_61_62_2e_6d:
 ld a,end_72_3e_61_62_2e_6d-start_72_3e_61_62_2e_6d-5
 call COMUCopyCode
    pop  de
    pop  hl
end_72_3e_61_62_2e_6d:

; =========== r>b macro ===========

start_72_3e_62_2e_6d:
 ld a,end_72_3e_62_2e_6d-start_72_3e_62_2e_6d-5
 call COMUCopyCode
    pop  de
end_72_3e_62_2e_6d:

; =========== swap both ===========

start_73_77_61_70_2e_6d:
 ld a,end_73_77_61_70_2e_6d-start_73_77_61_70_2e_6d-5
 call COMUCopyCode
    ex   de,hl         ; 2nd now TOS
end_73_77_61_70_2e_6d:

start_73_77_61_70_2e_66:
    ex   de,hl         ; 2nd now TOS
    ret

; =========== target word ===========

start_74_61_72_67_65_74_2e_66:
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

