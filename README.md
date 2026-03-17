<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" alt="Verilog"/>
  <img src="https://img.shields.io/badge/Design-FSM-ff6600?style=for-the-badge" alt="FSM"/>
  <img src="https://img.shields.io/badge/Category-VLSI%20Design-green?style=for-the-badge" alt="VLSI"/>
  <img src="https://img.shields.io/badge/FPGA-Ready-purple?style=for-the-badge" alt="FPGA"/>
</p>

# ðŸš¦ Traffic Light Controller â€” Verilog HDL

> An FSM-based traffic light controller for a 4-way intersection with pedestrian crossing support, configurable timing, and emergency vehicle override mode.

---

## ðŸ” Overview

This project implements a **Finite State Machine (FSM)-based traffic light controller** for a 4-way intersection. It manages North-South and East-West traffic flows with proper yellow transitions, pedestrian crossing support, and an emergency override mode.

### Key Highlights
- ðŸš— **4-Way Intersection** â€” NS and EW directional control
- ðŸš¶ **Pedestrian Crossing** â€” Button-triggered walk signals
- ðŸš‘ **Emergency Override** â€” All-red mode for emergency vehicles
- â±ï¸ **Configurable Timing** â€” Parameterized green, yellow, and pedestrian durations
- ðŸ”„ **7 FSM States** â€” Complete state coverage
- âœ… **Self-Checking TB** â€” Automated verification

---

## ðŸ—ï¸ State Diagram

```
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
     â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”‚ EMERGENCY   â”‚â—„â”€â”€â”€â”€â”€ emergency=1
     â”‚              â”‚ (ALL RED)   â”‚
     â”‚              â””â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”˜
     â”‚                     â”‚ emergency=0
     â”‚                     â–¼
     â”‚              â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
     â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”‚  NS_GREEN   â”‚â—„â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
     â”‚              â””â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”˜                        â”‚
     â”‚                     â”‚ timer >= GREEN_TIME            â”‚
     â”‚                     â–¼                                â”‚
     â”‚              â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                        â”‚
     â”‚              â”‚ NS_YELLOW   â”‚                        â”‚
     â”‚              â””â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”˜                        â”‚
     â”‚                     â”‚ timer >= YELLOW_TIME           â”‚
     â”‚              â”Œâ”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”                        â”‚
     â”‚         ped? â”‚YES          â”‚NO                      â”‚
     â”‚              â–¼             â–¼                        â”‚
     â”‚       â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                   â”‚
     â”‚       â”‚  NS_PED  â”‚  â”‚ EW_GREEN â”‚                   â”‚
     â”‚       â”‚ (WALK)   â”‚  â”‚          â”‚                   â”‚
     â”‚       â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜                   â”‚
     â”‚            â”‚             â”‚ timer >= GREEN_TIME       â”‚
     â”‚            â”‚             â–¼                          â”‚
     â”‚            â”‚      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                     â”‚
     â”‚            â”‚      â”‚EW_YELLOW â”‚                     â”‚
     â”‚            â”‚      â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜                     â”‚
     â”‚            â”‚      ped? â”‚                           â”‚
     â”‚            â”‚    â”Œâ”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”                    â”‚
     â”‚            â”‚    â”‚YES          â”‚NO                   â”‚
     â”‚            â”‚    â–¼             â”‚                     â”‚
     â”‚            â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”‚                     â”‚
     â”‚            â”‚ â”‚  EW_PED  â”‚    â”‚                     â”‚
     â”‚            â”‚ â”‚ (WALK)   â”‚    â”‚                     â”‚
     â”‚            â”‚ â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜    â”‚                     â”‚
     â”‚            â”‚      â”‚          â”‚                     â”‚
     â”‚            â””â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
     â”‚
     â””â”€â”€â”€â”€ (from any state)
```

---

## ðŸ“ File Structure

```
VLSI-Traffic-Light-Controller/
â”œâ”€â”€ src/
â”‚   â””â”€â”€ traffic_light_fsm.v   # FSM controller module
â”œâ”€â”€ testbench/
â”‚   â””â”€â”€ traffic_light_tb.v    # Self-checking testbench
â”œâ”€â”€ docs/
â”œâ”€â”€ .gitignore
â”œâ”€â”€ LICENSE
â””â”€â”€ README.md
```

---

## ðŸš€ Simulation Guide

```bash
# Compile
iverilog -o traffic_sim src/traffic_light_fsm.v testbench/traffic_light_tb.v

# Run
vvp traffic_sim

# View waveforms
gtkwave traffic_light_tb.vcd
```

---

## ðŸ’¡ Applications

- ðŸ™ï¸ **Smart City Infrastructure** â€” Adaptive traffic management
- ðŸŽ“ **Digital Design Labs** â€” FSM design methodology
- ðŸ”¬ **FPGA Demo** â€” Visual output with LEDs on FPGA boards

---

## ðŸ‘¨â€ðŸ’» Author

**Daggolu Hari Krishna** â€” B.Tech ECE | JNTUA College of Engineering, Kalikiri

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/contacthari88/)
[![GitHub](https://img.shields.io/badge/GitHub-Harikrishna__08-black?style=flat-square&logo=github)](https://github.com/Harikrishna_08)

---

<p align="center">â­ Star this repo if you found it useful! â­</p>
