<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" alt="Verilog"/>
  <img src="https://img.shields.io/badge/Design-FSM-ff6600?style=for-the-badge" alt="FSM"/>
  <img src="https://img.shields.io/badge/Category-VLSI%20Design-green?style=for-the-badge" alt="VLSI"/>
  <img src="https://img.shields.io/badge/FPGA-Ready-purple?style=for-the-badge" alt="FPGA"/>
</p>

# 🚦 Traffic Light Controller — Verilog HDL

> An FSM-based traffic light controller for a 4-way intersection with pedestrian crossing support, configurable timing, and emergency vehicle override mode.

---

## 🔍 Overview

This project implements a **Finite State Machine (FSM)-based traffic light controller** for a 4-way intersection. It manages North-South and East-West traffic flows with proper yellow transitions, pedestrian crossing support, and an emergency override mode.

### Key Highlights
- 🚗 **4-Way Intersection** — NS and EW directional control
- 🚶 **Pedestrian Crossing** — Button-triggered walk signals
- 🚑 **Emergency Override** — All-red mode for emergency vehicles
- ⏱️ **Configurable Timing** — Parameterized green, yellow, and pedestrian durations
- 🔄 **7 FSM States** — Complete state coverage
- ✅ **Self-Checking TB** — Automated verification

---

## 🏗️ State Diagram

```
                    ┌─────────────┐
     ┌──────────────│ EMERGENCY   │◄───── emergency=1
     │              │ (ALL RED)   │
     │              └──────┬──────┘
     │                     │ emergency=0
     │                     ▼
     │              ┌─────────────┐
     ├──────────────│  NS_GREEN   │◄──────────────────────┐
     │              └──────┬──────┘                        │
     │                     │ timer >= GREEN_TIME            │
     │                     ▼                                │
     │              ┌─────────────┐                        │
     │              │ NS_YELLOW   │                        │
     │              └──────┬──────┘                        │
     │                     │ timer >= YELLOW_TIME           │
     │              ┌──────┴──────┐                        │
     │         ped? │YES          │NO                      │
     │              ▼             ▼                        │
     │       ┌──────────┐  ┌──────────┐                   │
     │       │  NS_PED  │  │ EW_GREEN │                   │
     │       │ (WALK)   │  │          │                   │
     │       └────┬─────┘  └────┬─────┘                   │
     │            │             │ timer >= GREEN_TIME       │
     │            │             ▼                          │
     │            │      ┌──────────┐                     │
     │            │      │EW_YELLOW │                     │
     │            │      └────┬─────┘                     │
     │            │      ped? │                           │
     │            │    ┌──────┴──────┐                    │
     │            │    │YES          │NO                   │
     │            │    ▼             │                     │
     │            │ ┌──────────┐    │                     │
     │            │ │  EW_PED  │    │                     │
     │            │ │ (WALK)   │    │                     │
     │            │ └────┬─────┘    │                     │
     │            │      │          │                     │
     │            └──────┴──────────┴─────────────────────┘
     │
     └──── (from any state)
```

---

## 📁 File Structure

```
VLSI-Traffic-Light-Controller/
├── src/
│   └── traffic_light_fsm.v   # FSM controller module
├── testbench/
│   └── traffic_light_tb.v    # Self-checking testbench
├── docs/
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 Simulation Guide

```bash
# Compile
iverilog -o traffic_sim src/traffic_light_fsm.v testbench/traffic_light_tb.v

# Run
vvp traffic_sim

# View waveforms
gtkwave traffic_light_tb.vcd
```

---

## 💡 Applications

- 🏙️ **Smart City Infrastructure** — Adaptive traffic management
- 🎓 **Digital Design Labs** — FSM design methodology
- 🔬 **FPGA Demo** — Visual output with LEDs on FPGA boards

---

## 👨‍💻 Author

**Daggolu Hari Krishna** — B.Tech ECE | JNTUA College of Engineering, Kalikiri

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/harikrishnadaggolu)
[![GitHub](https://img.shields.io/badge/GitHub-Harikrishna__08-black?style=flat-square&logo=github)](https://github.com/Harikrishna_08)

---

<p align="center">⭐ Star this repo if you found it useful! ⭐</p>
