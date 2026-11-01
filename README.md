# Design and Verification of a Traffic Light Controller FSM (Moore + Mealy Comparison)

## 📌 Overview
This repository contains the complete RTL design, functional simulation, synthesis, and FPGA implementation of a **Two-Way Traffic Light Controller** using **Verilog HDL**. 

The project implements both **Moore** and **Mealy** Finite State Machine (FSM) architectures side-by-side on the same hardware, driven by a shared parameterizable timer. A `mode_sel` input allows real-time switching between the two architectures, providing a fair and measurable comparison of resource utilization, timing behavior, and glitch risk.

The design is simulated in **AMD Vivado 2026.1** and implemented on the **Digilent Arty S7-25 (Spartan-7 XC7S25)** FPGA.

## ✨ Key Features
*   **Dual FSM Architecture:**
    *   **Moore FSM (4 States):** `A_GREEN → A_YELLOW → B_GREEN → B_YELLOW`. Outputs are registered (glitch-free).
    *   **Mealy FSM (2 States):** `A_GREEN_PHASE ↔ B_GREEN_PHASE`. Yellow is generated combinationally on transition (faster response).
*   **Safety Invariant:** Hard-coded complementary red signal guarantees both directions are **never green simultaneously**.
*   **Fail-Safe Recovery:** Default `case` statements force both directions to Red if an illegal state is entered.
*   **Parameterizable Timer:** `MAX_COUNT` parameter adjusts phase durations without modifying FSM logic.
*   **Real-time Mode Selection:** `mode_sel` switch selects between Moore (`0`) and Mealy (`1`) outputs.

## 🛠️ Tools & Hardware
*   **HDL:** Verilog (IEEE 1364-2001)
*   **EDA Tool:** AMD Vivado 2026.1
*   **Target Board:** Digilent Arty S7-25 (Spartan-7 XC7S25CSGA324-1)
*   **Hardware Verification:** On-board LEDs (LD2-LD5) and switches (SW0-SW3) for real-time observation.

## 📂 Repository Structure
```text

│   ├── traffic_light_top.v           
│   ├── timer_counter.v               
│   ├── moore_traffic_controller.v    
│   └── mealy_traffic_controller.v    



📊 Results & Comparison
1. Moore vs. Mealy Trade-off
Metric	Moore FSM	Mealy FSM	Winner
States	4	2	Mealy
Flip-Flops	4	1	Mealy (75% reduction)
LUTs	2	3	Moore (33% reduction)
Yellow Latency	1 clock cycle	0 clock cycles	Mealy
Glitch Risk	None (Registered)	Higher (Combinational)	Moore
2. Simulation Result
The testbench verifies:

Reset: FSM enters safe A_GREEN state.

Moore Timing: A_yellow rises one cycle after timer_done.

Mealy Timing: A_yellow rises in the same cycle as timer_done.

Safety: A_green && B_green == 0 at all times.


3. FPGA Implementation
Power: Total on-chip power = 0.05 W (0.012 W dynamic, 0.038 W static).

Timing: All constraints met. WNS = +6.315 ns, WHS = +0.221 ns, TNS = 0.000 ns.

Device Layout: Placed optimally on the Spartan-7 fabric.


4. Hardware Output
The design was programmed onto the Arty S7-25 board. The mode_sel switch successfully toggles between Moore and Mealy behavior in real-time.


🚀 Future Scope
Extend to four-way intersections with left-turn arrows.

Implement pedestrian crossing request buttons (natural Mealy input).

Add adaptive traffic sensing (inductive loops, cameras).

Integrate night mode (blinking yellow) and emergency vehicle override.

Formal verification (SymbiYosys/JasperGold) to mathematically prove safety invariants.

👨‍💻 Authors
M. Suresh (Roll No: 2411EC010111)

P. Sandeep (Roll No: 2411EC010114)

Department of Electronics and Communication Engineering
School of Engineering, Malla Reddy University, Hyderabad, Telangana, India

Project Guide: Mrs. C. Sheeba Thangapushpam (Assistant Professor)
