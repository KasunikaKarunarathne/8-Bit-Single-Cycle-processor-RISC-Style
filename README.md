# 8-Bit Single-Cycle RISC-Style Processor
### Overview
This repository features the complete Verilog HDL implementation of an 8-bit single-cycle processor, developed for the **CO224: Computer Architecture** course at the Department of Computer Engineering, University of Peradeniya. 
The project outlines a bottom-up hardware design methodology—transitioning from discrete digital building blocks (ALU, Register File) to full datapath integration, instruction decoding, program counter flow control, and extended ISA execution.
Development was conducted modularly across distinct milestones, with dedicated test suites and waveform analyses validating each architectural stage.
---
## Architecture & Implementation Breakdown
### Part 1: Arithmetic Logic Unit (ALU)
* **Goal:** Implement an 8-bit modular ALU handling core arithmetic and boolean operations.
* **Supported Operations:** Addition (`add`), 2's complement subtraction (`sub`), logical bitwise operations (`and`, `or`), data transfer (`mov`), and immediate loading (`loadi`).
* **Design Details:** 
  * Parametric sub-modules for distinct functional units.
  * 3-bit control selection via low-latency multiplexers.
  * Simulated propagation delays to mimic physical gate-level timing.
* **Validation:** Verified across comprehensive corner cases using testbenches and GTKWave timing traces.
### Part 2: Register File
* **Goal:** Construct an $8 \times 8$-bit multi-port register bank for low-latency register-to-register staging.
* **Features:**
  * 8 general-purpose 8-bit registers ($R0$–$R7$).
  * Dual asynchronous read ports (`OUT1`, `OUT2`) and a single synchronous write port (`IN`).
  * Active-low/high synchronous reset and dedicated write-enable gating.
  * Modeled delay constraints (Read: `#2`, Write: `#1`).
* **Validation:** Verified multi-port simultaneous access, write-after-read consistency, and reset behavior.
### Part 3: Datapath Integration & Control Unit
* **Goal:** Couple datapath elements with instruction decode logic to execute single-cycle instruction flows.
* **Features:**
  * 32-bit instruction decoding unit driving control signals.
  * Integrated Program Counter (PC) with $+4$ sequential fetch addressing.
  * Hardcoded instruction memory simulation.
  * Single-cycle execution latency constraint (8 time units per instruction).
* **Validation:** Executed programmatic instruction sequences to verify timing closure and control hazard prevention.
### Part 4: Control Flow & Branching Logic
* **Goal:** Expand datapath architecture to accommodate non-linear program execution.
* **New Instructions:** Unconditional jump (`j`) and branch-on-equal (`beq`).
* **Hardware Modifications:**
  * Zero-flag flag detection integrated into the ALU comparator path.
  * Dedicated branch/jump target calculation adder.
  * Updated PC multiplexing logic driven by branch evaluation results.
* **Validation:** Evaluated target address calculation, conditional branch decisions, and pipeline timing through waveform inspection.
### Part 5: Extended Instruction Set (ISA Extension)
* **Goal:** Augment processing capability with complex arithmetic and bitwise shifting.
* **New Instructions:** Integer multiplication (`mult`), logical left shift (`sll`), and logical right shift (`srl`).
* **Enhancements:** Integrated dedicated shift and multiplier units without violating the single-cycle execution window.
---
## Toolchain & Simulation Stack
* **Hardware Description:** Verilog HDL
* **Simulation & Waveforms:** ModelSim, GTKWave
* **Assembly / Tooling:** Custom C-based Assembler (`CO224Assembler`)
* **Target Environment:** Linux
---
## Repository Structure
```
├── part1/                 # ALU Design and Testbench
├── part2/                 # Register File Implementation and Tests
├── part3/                 # CPU Integration and Control Logic
├── part4/                 # Flow Control Instructions (j, beq)
├── part5/                 # Extended ISA (mult, sll, srl)
├── LICENSE                # License file
├── README.md              # Project documentation
└── Report.pdf             # Detailed report of implementation and results
```

---
## Authors
* **Tharaka Dilshan**
* **Nethmini Karunarathne**  
*Department of Computer Engineering, University of Peradeniya*
