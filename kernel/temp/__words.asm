; =========== ! xmacro ===========

start_21:
    call COMUCopyCode
 ld a,end_21-start_21-5
    ld   (hl),e
    inc  hl
    ld   (hl),d
    dec  hl
end_21:
    ret

; =========== * word ===========

start_2a:
    call COMUCompileCallToSelf
    call  MULTMultiply16
    ret

; =========== + xmacro ===========

start_2b:
    call COMUCopyCode
 ld a,end_2b-start_2b-5
    add  hl,de
end_2b:
    ret

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

; =========== ++ xmacro ===========

start_2b_2b:
    call COMUCopyCode
 ld a,end_2b_2b-start_2b_2b-5
    inc  hl
end_2b_2b:
    ret

; =========== +++ xmacro ===========

start_2b_2b_2b:
    call COMUCopyCode
 ld a,end_2b_2b_2b-start_2b_2b_2b-5
    inc  hl
    inc  hl
end_2b_2b_2b:
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

; =========== - xmacro ===========

start_2d:
    call COMUCopyCode
 ld a,end_2d-start_2d-5
    ld   a,h
    cpl
    ld   h,a
    ld   a,l
    cpl
    ld   l,a
end_2d:
    ret

; =========== -- xmacro ===========

start_2d_2d:
    call COMUCopyCode
 ld a,end_2d_2d-start_2d_2d-5
    dec  hl
end_2d_2d:
    ret

; =========== --- xmacro ===========

start_2d_2d_2d:
    call COMUCopyCode
 ld a,end_2d_2d_2d-start_2d_2d_2d-5
    dec  hl
    dec  hl
end_2d_2d_2d:
    ret

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
    ex  de,hl
    ret

; =========== 1, word ===========

start_31_2c:
    call COMUCompileCallToSelf
    ld   a,l
    call  FARCompileByte
    ret

; =========== 2* xmacro ===========

start_32_2a:
    call COMUCopyCode
 ld a,end_32_2a-start_32_2a-5
    add  hl,hl
end_32_2a:
    ret

; =========== 2, word ===========

start_32_2c:
    call COMUCompileCallToSelf
    call FARCompileWord
    ret

; =========== 2/ xmacro ===========

start_32_2f:
    call COMUCopyCode
 ld a,end_32_2f-start_32_2f-5
    sra  h
    rr   l
end_32_2f:
    ret

; =========== ; macro ===========

start_3b:
    nop
    call COMUCopyCode
 ld a,end_3b-start_3b-5
    ret
end_3b:
    ret

; =========== < word ===========

start_3c:
    call COMUCompileCallToSelf
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

start_3d:
    call COMUCompileCallToSelf
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

; =========== @ xmacro ===========

start_40:
    call COMUCopyCode
 ld a,end_40-start_40-5
    ld   a,(hl)
    inc  hl
    ld   h,(hl)
    ld   l,a
end_40:
    ret

; =========== a>b xmacro ===========

start_61_3e_62:
    call COMUCopyCode
 ld a,end_61_3e_62-start_61_3e_62-5
    ld   e,l
    ld   d,h
end_61_3e_62:
    ret

; =========== a>r macro ===========

start_61_3e_72:
    nop
    call COMUCopyCode
 ld a,end_61_3e_72-start_61_3e_72-5
    push  hl
end_61_3e_72:
    ret

; =========== ab>r macro ===========

start_61_62_3e_72:
    nop
    call COMUCopyCode
 ld a,end_61_62_3e_72-start_61_62_3e_72-5
    push  hl
    push  de
end_61_62_3e_72:
    ret

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

; =========== b! xmacro ===========

start_62_21:
    call COMUCopyCode
 ld a,end_62_21-start_62_21-5
    ld   (hl),e
end_62_21:
    ret

; =========== b>a xmacro ===========

start_62_3e_61:
    call COMUCopyCode
 ld a,end_62_3e_61-start_62_3e_61-5
    ld   l,e
    ld   h,d
end_62_3e_61:
    ret

; =========== b>r macro ===========

start_62_3e_72:
    nop
    call COMUCopyCode
 ld a,end_62_3e_72-start_62_3e_72-5
    push  de
end_62_3e_72:
    ret

; =========== b@ xmacro ===========

start_62_40:
    call COMUCopyCode
 ld a,end_62_40-start_62_40-5
    ld   l,(hl)
    ld   h,$00
end_62_40:
    ret

; =========== break macro ===========

start_62_72_65_61_6b:
    nop
    call COMUCopyCode
 ld a,end_62_72_65_61_6b-start_62_72_65_61_6b-5
    db   $DD,$01
end_62_72_65_61_6b:
    ret

; =========== bswap xmacro ===========

start_62_73_77_61_70:
    call COMUCopyCode
 ld a,end_62_73_77_61_70-start_62_73_77_61_70-5
    ld   a,h
    ld   h,l
    ld   l,a
end_62_73_77_61_70:
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

; =========== p! xmacro ===========

start_70_21:
    call COMUCopyCode
 ld a,end_70_21-start_70_21-5
    ld   c,l
    ld   b,h
    out  (c),e
end_70_21:
    ret

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

; =========== pop macro ===========

start_70_6f_70:
    nop
    call COMUCopyCode
 ld a,end_70_6f_70-start_70_6f_70-5
    ex   de,hl
    pop  hl
end_70_6f_70:
    ret

; =========== push macro ===========

start_70_75_73_68:
    nop
    call COMUCopyCode
 ld a,end_70_75_73_68-start_70_75_73_68-5
    push  hl
end_70_75_73_68:
    ret

; =========== r>a macro ===========

start_72_3e_61:
    nop
    call COMUCopyCode
 ld a,end_72_3e_61-start_72_3e_61-5
    pop  hl
end_72_3e_61:
    ret

; =========== r>ab macro ===========

start_72_3e_61_62:
    nop
    call COMUCopyCode
 ld a,end_72_3e_61_62-start_72_3e_61_62-5
    pop  de
    pop  hl
end_72_3e_61_62:
    ret

; =========== r>b macro ===========

start_72_3e_62:
    nop
    call COMUCopyCode
 ld a,end_72_3e_62-start_72_3e_62-5
    pop  de
end_72_3e_62:
    ret

; =========== swap xmacro ===========

start_73_77_61_70:
    call COMUCopyCode
 ld a,end_73_77_61_70-start_73_77_61_70-5
    ex   de,hl         ; 2nd now TOS
end_73_77_61_70:
    ret

