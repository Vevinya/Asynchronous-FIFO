# Robust Asynchronous FIFO in Verilog

This repository contains the Verilog source code for a robust, production-quality Asynchronous First-In, First-Out (FIFO) memory buffer. The design is specifically engineered to handle Clock Domain Crossing (CDC) safely, making it ideal for complex digital systems, SoCs, and FPGAs where multiple clock sources are present.

The implementation is based on the industry-proven principles detailed by Clifford E. Cummings, focusing on the use of Gray code pointers and a partitioned architecture to ensure reliable data transfer between unrelated clock domains.

## Key Features

- **FIFO Depth:** 128 locations
- **Data Width:** 16 bits (2 bytes)
- **Clock Domain Crossing:** Safely transfers data from a write clock domain to an asynchronous read clock domain.
- **Gray Code Pointers:** Eliminates metastability issues during pointer synchronization, preventing data corruption.
- **Pessimistic Full/Empty Flags:** Guarantees that the FIFO will never overflow or underflow by using a safe, pessimistic flag de-assertion scheme.
- **Modular and Partitioned Design:** The logic is cleanly separated into distinct clock domains to simplify synthesis, place-and-route, and static timing analysis (STA).

## Architecture

The FIFO is partitioned into several synchronous modules, which are then integrated into a top-level wrapper. This design style ensures that logic within each module is fully synchronous to a single clock, making it easy for synthesis tools to handle.

### Verilog Modules

| File | Module | Description |
|---|---|---|
| `async_fifo_top.v` | `async_fifo` | The top-level module that instantiates and connects all the sub-components. |
| `write_ptr_full_gen.v` | `write_ptr_full_gen` | Manages the write pointer (in the `w_clk` domain) and generates the `fifo_full` flag. |
| `read_ptr_empty_gen.v` | `read_ptr_empty_gen` | Manages the read pointer (in the `r_clk` domain) and generates the `fifo_empty` flag. |
| `wptr_to_rclk_sync.v` | `wptr_to_rclk_sync` | A two-stage synchronizer to safely pass the write pointer into the read clock domain. |
| `rptr_to_wclk_sync.v` | `rptr_to_wclk_sync` | A two-stage synchronizer to safely pass the read pointer into the write clock domain. |
| `fifo_memory.v` | `fifo_memory` | A dual-port synchronous RAM that acts as the data buffer. |
| `testbench.v` | `testbench` | Stimulus for functional verification of the top-level FIFO. |

## Simulation and Verification

The repository includes a comprehensive testbench (`testbench.v`) to verify the FIFO's functionality under asynchronous conditions.

### Simulation Setup

- **Write Clock Frequency:** 50 MHz (20ns period)
- **Read Clock Frequency:** 20 MHz (50ns period)
- **Test Scenarios:** The testbench simulates various conditions, including:
  - Writing to the FIFO until it becomes full.
  - Reading from the FIFO until it becomes empty.
  - Simultaneous read and write operations.
  - Verifying data integrity throughout the process.

### How to Run the Simulation

You can use any standard Verilog simulator (like Icarus Verilog, ModelSim, or Vivado's simulator) to run the test.

**Example using Icarus Verilog:**

Compile the Verilog files:

```bash
iverilog -o fifo_sim async_fifo_top.v write_ptr_full_gen.v read_ptr_empty_gen.v rptr_to_wclk_sync.v wptr_to_rclk_sync.v fifo_memory.v testbench.v
```

Run the simulation:

```bash
vvp fifo_sim
```

View the waveforms: Open the generated `.vcd` file (e.g., `test.vcd` if specified in the testbench) with a waveform viewer like GTKWave.

```bash
gtkwave test.vcd
```

## Core Design Principles

This design's robustness comes from two key principles:

1. **Gray Code Pointers:** To avoid metastability when passing multi-bit pointers across clock domains, all pointers are converted to Gray code before being sent through a two-stage synchronizer. Since only one bit changes between consecutive Gray code values, this ensures the synchronized pointer value is always valid.

2. **Pessimistic Flags:** The `fifo_full` and `fifo_empty` flags are designed to be "pessimistic." This means the `fifo_full` flag might stay asserted for a couple of write clock cycles after a read has occurred, and the `fifo_empty` flag might stay asserted for a couple of read clock cycles after a write has occurred. This slight delay is a safe margin that guarantees no writes occur when the FIFO is truly full and no reads occur when it is truly empty.

### Note

- `w_ptr` always points to the location where the next write will go (an empty slot).
- `r_ptr` always points to the location holding the next value to be read.
- **Full condition:** the write pointer chases the read pointer around the circular buffer. The next value of `w_ptr` (`w_gray_next`, computed combinationally in the sequential block) is compared against the synchronized read pointer (`w_sync_rptr`); if they match (with the two MSBs inverted, to distinguish a full wrap from an exact catch-up), the FIFO is full.
- **Empty condition:** the read pointer chases the write pointer. The next value of `r_ptr` (`r_gray_next`) is compared directly against the synchronized write pointer (`r_sync_wptr`); if they match, the FIFO is empty.

## Verification Notes

Functional equivalence to the reference implementation was confirmed with a self-checking testbench: every value accepted on the write side (`w_en & !fifo_full`) is recorded into a golden reference queue, and every value read out (`r_en & !fifo_empty`) is checked against that queue in order. Across a 600+ transaction stress run spanning multiple full/drain cycles, all reads matched their expected values with zero data-integrity errors and `fifo_full`/`fifo_empty` were never asserted simultaneously.
