# Utility Bill Generator

A console-based 8086 Assembly Language program that computes gas and electricity bills based on user-provided unit consumption. Runs in a DOS-compatible environment using standard DOS interrupts (INT 21H) for all input and output operations.

---

## Features

- **Gas Bill Calculation** — Fixed rate of Rs. 10 per unit
- **Electricity Slab Pricing** — Rs. 10/unit for 1-3 units, Rs. 15/unit for 4-9 units
- **10% Tax Calculation** — Automatically applied to the total bill
- **Input Validation** — Accepts only digits 1-9, exits with error on invalid input
- **Formatted Receipt** — Displays a complete bill summary with separator lines
- **Multi-Digit Output** — Stack-based digit extraction for printing numbers correctly

---

## How to Run

### Requirements
- DOSBox or any DOS-compatible environment
- MASM or compatible 8086 assembler

### Steps
1. Open DOSBox
2. Assemble the file:

masm utility_bill_generator.asm
link utility_bill_generator.obj
utility_bill_generator.exe

---

## Program Flow

1. Display welcome title and separator
2. Prompt user to enter gas units consumed (1-9)
3. Prompt user to enter electricity units consumed (1-9)
4. Calculate gas bill, electricity bill, and 10% tax
5. Display complete formatted receipt

---

## Concepts Used

- Registers: AX, BX, CX, DX for arithmetic and parameter passing
- DOS Interrupt 21H for all I/O operations
- MUL and DIV instructions for bill and tax calculations
- CMP, JL, JGE for slab-based pricing logic
- PROC/ENDP, CALL, RET for modular procedure design
- PUSH/POP stack operations for multi-digit number output
- String variables with DB for all display labels

---

## Team

| Name | Role |
|---|---|
| Abdul Manan | I/O procedures, multi-digit number output, main control flow, formatted receipt display |
| Safiullah | Arithmetic logic, slab pricing, tax calculation, input validation |

---

## Semester

**4th Semester — BS Computer Science**
Sukkur IBA University
