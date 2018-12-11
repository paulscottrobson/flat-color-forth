; =========== ! macro ===========

start_21:
 call COMUCopyCode
 db end_21-start_21-4
    ld   (hl),e
    inc  hl
    ld   (hl),d
    dec  hl
end_21:

; =========== * word ===========

start_2a:
 call COMUCompileCallToSelf
    call  MULTMultiply16
    ret

; =========== + macro ===========

start_2b:
 call COMUCopyCode
 db end_2b-start_2b-4
    add  hl,de
end_2b:

; =========== +! word ===========

start_2b_21:
 call COMUCompileCallToSelf
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

start_2b_6f_72:
 call COMUCompileCallToSelf
    ld   a,h
    or   d
    ld   h,a
    ld   a,l
    or   e
    ld   l,a
    ret

; =========== , word ===========

start_2c:
 call COMUCompileCallToSelf
    call FARCompileWord
    ret

; =========== - macro ===========

start_2d:
 call COMUCopyCode
 db end_2d-start_2d-4
    ld   a,h
    cpl
    ld   h,a
    ld   a,l
    cpl
    ld   l,a
end_2d:

; =========== / word ===========

start_2f:
 call COMUCompileCallToSelf
    push  de
    call  DIVDivideMod16
    ex   de,hl
    pop  de
    ret

; =========== /mod word ===========

start_2f_6d_6f_64:
 call COMUCompileCallToSelf
    call  DIVDivideMod16
    ret

; =========== 2* macro ===========

start_32_2a:
 call COMUCopyCode
 db end_32_2a-start_32_2a-4
    add  hl,hl
end_32_2a:

; =========== 2/ macro ===========

start_32_2f:
 call COMUCopyCode
 db end_32_2f-start_32_2f-4
    sra  h
    rr   l
end_32_2f:

; =========== ; macro ===========

start_3b:
 call COMUCopyCode
 db end_3b-start_3b-4
    ret
end_3b:

; =========== @ macro ===========

start_40:
 call COMUCopyCode
 db end_40-start_40-4
    ld   a,(hl)
    inc  hl
    ld   h,(hl)
    ld   l,a
end_40:

; =========== a>b macro ===========

start_61_3e_62:
 call COMUCopyCode
 db end_61_3e_62-start_61_3e_62-4
    ld   e,l
    ld   d,h
end_61_3e_62:

; =========== a>r macro ===========

start_61_3e_72:
 call COMUCopyCode
 db end_61_3e_72-start_61_3e_72-4
    push  hl
end_61_3e_72:

; =========== ab>r macro ===========

start_61_62_3e_72:
 call COMUCopyCode
 db end_61_62_3e_72-start_61_62_3e_72-4
    push  hl
    push  de
end_61_62_3e_72:

; =========== abs word ===========

start_61_62_73:
 call COMUCompileCallToSelf
    bit  7,h
    jp   nz,__Negate
    ret

; =========== and word ===========

start_61_6e_64:
 call COMUCompileCallToSelf
    ld   a,h
    and  d
    ld   h,a
    ld   a,l
    and  e
    ld   l,a
    ret

; =========== b! macro ===========

start_62_21:
 call COMUCopyCode
 db end_62_21-start_62_21-4
    ld   (hl),e
end_62_21:

; =========== b>a macro ===========

start_62_3e_61:
 call COMUCopyCode
 db end_62_3e_61-start_62_3e_61-4
    ld   l,d
    ld   h,e
end_62_3e_61:

; =========== b>r macro ===========

start_62_3e_72:
 call COMUCopyCode
 db end_62_3e_72-start_62_3e_72-4
    push  de
end_62_3e_72:

; =========== b@ macro ===========

start_62_40:
 call COMUCopyCode
 db end_62_40-start_62_40-4
    ld   l,(hl)
    ld   h,$00
end_62_40:

; =========== break macro ===========

start_62_72_65_61_6b:
 call COMUCopyCode
 db end_62_72_65_61_6b-start_62_72_65_61_6b-4
    db   $DD,$01
end_62_72_65_61_6b:

; =========== bswap macro ===========

start_62_73_77_61_70:
 call COMUCopyCode
 db end_62_73_77_61_70-start_62_73_77_61_70-4
    ld   a,h
    ld   h,l
    ld   l,a
end_62_73_77_61_70:

; =========== c, word ===========

start_63_2c:
 call COMUCompileCallToSelf
    ld   a,l
    call  FARCompileByte
    ret

; =========== copy word ===========

start_63_6f_70_79:
 call COMUCompileCallToSelf
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

start_64_65_62_75_67:
 call COMUCompileCallToSelf
    call  DEBUGShow
    ret

; =========== fill word ===========

start_66_69_6c_6c:
 call COMUCompileCallToSelf
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

start_68:
 call COMUCompileCallToSelf
    ex   de,hl
    ld   hl,Here
    ret

; =========== halt word ===========

start_68_61_6c_74:
 call COMUCompileCallToSelf
__haltz80:
    di
    halt
    jr   __haltz80
    ret

; =========== here word ===========

start_68_65_72_65:
 call COMUCompileCallToSelf
    ex   de,hl
    ld   hl,(Here)
    ret

; =========== hex! word ===========

start_68_65_78_21:
 call COMUCompileCallToSelf
    ; DE = word, HL = pos
    call  GFXWriteHexWord      ; write out the word
    ret

; =========== mod word ===========

start_6d_6f_64:
 call COMUCompileCallToSelf
    push  de
    call  DIVDivideMod16
    pop  de
    ret

; =========== negate word ===========

start_6e_65_67_61_74_65:
 call COMUCompileCallToSelf
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

start_6f_72:
 call COMUCompileCallToSelf
    ld   a,h
    xor  d
    ld   h,a
    ld   a,l
    xor  e
    ld   l,a
    ret

; =========== or! word ===========

start_6f_72_21:
 call COMUCompileCallToSelf
    ld   a,(hl)
    or   e
    ld   (hl),a
    inc  hl
    ld   a,(hl)
    or   d
    ld   (hl),a
    dec  hl
    ret

; =========== p! macro ===========

start_70_21:
 call COMUCopyCode
 db end_70_21-start_70_21-4
    ld   c,l
    ld   b,h
    out  (c),e
end_70_21:

; =========== p@ word ===========

start_70_40:
 call COMUCompileCallToSelf
    ld   c,l
    ld   b,h
    in   l,(c)
    ld   h,0
    ret

; =========== param! word ===========

start_70_61_72_61_6d_21:
 call COMUCompileCallToSelf
    ld   (Parameter),hl
    ret

; =========== r>a macro ===========

start_72_3e_61:
 call COMUCopyCode
 db end_72_3e_61-start_72_3e_61-4
    pop  hl
end_72_3e_61:

; =========== r>ab macro ===========

start_72_3e_61_62:
 call COMUCopyCode
 db end_72_3e_61_62-start_72_3e_61_62-4
    pop  de
    pop  hl
end_72_3e_61_62:

; =========== r>b macro ===========

start_72_3e_62:
 call COMUCopyCode
 db end_72_3e_62-start_72_3e_62-4
    pop  de
end_72_3e_62:

; =========== swap macro ===========

start_73_77_61_70:
 call COMUCopyCode
 db end_73_77_61_70-start_73_77_61_70-4
    ex   de,hl         ; 2nd now TOS
end_73_77_61_70:

