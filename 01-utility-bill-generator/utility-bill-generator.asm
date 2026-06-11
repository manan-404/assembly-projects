; ============================================================
; PROJECT  : BILL GENERATOR APP (Gas + Electricity)
; LANGUAGE : 8086 Assembly Language
; AUTHORS  : Abdul Manan, Safiullah
; ============================================================

.model small
.stack 100h

.data

    ; ---- LABELS / HEADINGS ----
    newline     db 0Ah, 0Dh, '$'
    separator   db "================================$"
    appTitle    db "===  UTILITY BILL GENERATOR  ===$"
    gasLabel    db "Enter Gas Units Consumed (1-9): $"
    elecLabel   db "Enter Electricity Units (1-9): $"

    ; ---- BILL DISPLAY LABELS ----
    gasRateMsg  db "Gas Rate  : Rs.10 per unit$"
    elecRateMsg db "Elec Rate : Rs.15 per unit (slab)$"
    gasBillMsg  db "Gas Bill  : Rs.$"
    elecBillMsg db "Elec Bill : Rs.$"
    taxMsg      db "Tax (10%) : Rs.$"
    totalMsg    db "TOTAL BILL: Rs.$"
    thankMsg    db "Thank you! Pay before due date.$"
    slabMsg     db "(Slab: 1-3 units @10, 4+ @15)$"
    validErr    db "Invalid! Enter digit 1-9 only.$"

    ; ---- STORED VALUES ----
    gasUnits    db 0
    elecUnits   db 0
    gasBill     db 0
    elecBill    db 0
    totalBill   db 0
    taxAmount   db 0

; ============================================================
.code
; ============================================================

; ============================================================
; PROCEDURE: printNewLine
; PURPOSE  : Print a blank new line
; ============================================================
printNewLine proc
    push ax
    push dx
    mov ah, 09h
    mov dx, offset newline
    int 21h
    pop dx
    pop ax
    ret
printNewLine endp

; ============================================================
; PROCEDURE: printSeparator
; PURPOSE  : Print "===" separator line
; ============================================================
printSeparator proc
    push ax
    push dx
    mov ah, 09h
    mov dx, offset separator
    int 21h
    call printNewLine
    pop dx
    pop ax
    ret
printSeparator endp

; ============================================================
; PROCEDURE: printNumber
; PURPOSE  : Print a multi-digit number stored in bl
;            Divides by 10 repeatedly, pushes remainders on stack,
;            then pops and prints each digit (handles 0-255)
; ============================================================
printNumber proc
    push ax
    push bx
    push cx
    push dx
    mov al, bl
    xor ah, ah
    xor cx, cx

    cmp al, 0
    jne extractDigits
    mov ah, 02h
    mov dl, '0'
    int 21h
    jmp doneprint

extractDigits:
    mov bl, 10
digitLoop:
    cmp al, 0
    je printDigits
    xor ah, ah
    div bl
    push ax
    inc cx
    jmp digitLoop

printDigits:
    cmp cx, 0
    je doneprint
    pop ax
    mov dl, ah
    add dl, 48
    mov ah, 02h
    int 21h
    dec cx
    jmp printDigits

doneprint:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
printNumber endp

; ============================================================
; PROCEDURE: validateInput
; PURPOSE  : Check input is digit 1-9
;            If invalid, print error and jump to end
;            Returns: al = digit value (number, not ASCII)
; ============================================================
validateInput proc
    cmp al, '1'
    jl  invalidInput
    cmp al, '9'
    jge validInput
    cmp al, '9'
    jle validInput

    invalidInput:
        call printNewLine
        mov ah, 09h
        mov dx, offset validErr
        int 21h
        call printNewLine
        jmp exitProgram

    validInput:
        sub al, 48
        ret
validateInput endp

; ============================================================
; PROCEDURE: calcGasBill
; PURPOSE  : Gas rate = Rs. 10 per unit
; ============================================================
calcGasBill proc
    push ax
    push bx
    mov al, gasUnits
    mov bl, 10
    mul bl
    mov gasBill, al
    pop bx
    pop ax
    ret
calcGasBill endp

; ============================================================
; PROCEDURE: calcElecBill (SLAB SYSTEM)
; PURPOSE  : Slab 1: units 1-3 => Rs.10 per unit
;            Slab 2: units 4-9 => Rs.15 per unit
; ============================================================
calcElecBill proc
    push ax
    push bx
    mov al, elecUnits
    cmp al, 4
    jl  slab1

    slab2:
        mov bl, 15
        mul bl
        mov elecBill, al
        jmp doneElec

    slab1:
        mov bl, 10
        mul bl
        mov elecBill, al

    doneElec:
    pop bx
    pop ax
    ret
calcElecBill endp

; ============================================================
; PROCEDURE: calcTotal
; PURPOSE  : totalBill = gasBill + elecBill
;            taxAmount = totalBill / 10 (10% tax)
; ============================================================
calcTotal proc
    push ax
    push bx
    push dx
    mov al, gasBill
    add al, elecBill
    mov totalBill, al
    xor ah, ah
    mov bl, 10
    div bl
    mov taxAmount, al
    mov al, totalBill
    add al, taxAmount
    mov totalBill, al
    pop dx
    pop bx
    pop ax
    ret
calcTotal endp

; ============================================================
; PROCEDURE: printBillSummary
; PURPOSE  : Display complete formatted receipt
; ============================================================
printBillSummary proc
    call printNewLine
    call printSeparator
    mov ah, 09h
    mov dx, offset appTitle
    int 21h
    call printNewLine
    call printSeparator
    mov ah, 09h
    mov dx, offset gasRateMsg
    int 21h
    call printNewLine
    mov ah, 09h
    mov dx, offset elecRateMsg
    int 21h
    call printNewLine
    mov ah, 09h
    mov dx, offset slabMsg
    int 21h
    call printNewLine
    call printSeparator

    ; ---- GAS BILL ----
    mov ah, 09h
    mov dx, offset gasBillMsg
    int 21h
    mov bl, gasBill
    call printNumber
    call printNewLine

    ; ---- ELECTRICITY BILL ----
    mov ah, 09h
    mov dx, offset elecBillMsg
    int 21h
    mov bl, elecBill
    call printNumber
    call printNewLine

    ; ---- TAX ----
    mov ah, 09h
    mov dx, offset taxMsg
    int 21h
    mov bl, taxAmount
    call printNumber
    call printNewLine
    call printSeparator

    ; ---- TOTAL ----
    mov ah, 09h
    mov dx, offset totalMsg
    int 21h
    mov bl, totalBill
    call printNumber
    call printNewLine
    call printSeparator

    ; ---- THANK YOU ----
    mov ah, 09h
    mov dx, offset thankMsg
    int 21h
    call printNewLine
    call printSeparator
    ret
printBillSummary endp

; ============================================================
; MAIN PROCEDURE
; ============================================================
main proc
    mov ax, @data
    mov ds, ax

    call printNewLine
    call printSeparator
    mov ah, 09h
    mov dx, offset appTitle
    int 21h
    call printNewLine
    call printSeparator

    ; ----- INPUT GAS UNITS -----
    call printNewLine
    mov ah, 09h
    mov dx, offset gasLabel
    int 21h
    mov ah, 01h
    int 21h
    call validateInput
    mov gasUnits, al

    ; ----- INPUT ELECTRICITY UNITS -----
    call printNewLine
    mov ah, 09h
    mov dx, offset elecLabel
    int 21h
    mov ah, 01h
    int 21h
    call validateInput
    mov elecUnits, al

    ; ----- CALCULATE -----
    call calcGasBill
    call calcElecBill
    call calcTotal

    ; ----- DISPLAY -----
    call printBillSummary

    exitProgram:
    mov ah, 4ch
    int 21h

main endp
end main

; ============================================================
; END OF PROGRAM
; ============================================================
