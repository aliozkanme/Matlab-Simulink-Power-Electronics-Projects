# Three-Phase Half-Wave Rectifier with Source Inductance

This project presents the simulation and mathematical analysis of a **Three-Phase Half-Wave Controlled Rectifier** considering the effect of **Source Inductance ($L_s$)**. The system feeds a large RL load.

## 🎓 Project Information
* **Course:** EEM312 Power Electronics
* **Institution:** Sakarya University
* **Term:** Spring 2016
* **Instructor:** Prof. Dr. U. Arifoğlu
* **Topic:** Term Project 5 - 3-Phase Rectifier with Commutation ($L_s$)

## 📄 Problem Statement
The rectifier is connected to a 3-phase grid through source inductances. The presence of $L_s$ causes **commutation overlap**, resulting in a voltage drop at the output.

**System Parameters:**
* **Grid Voltage:** $V_{rms} = 380 \text{ V}$ (Line-to-Line), $f = 50 \text{ Hz}$
* **Source Inductance:** $L_s = 10 \text{ mH}$ (per phase)
* **Load:** $R = 9.645 \, \Omega$, $L = 1 \text{ H}$ (High inductance ensures constant current)
* **Load Current:** $\approx 20 \text{ A}$ (Target Value)
* **Firing Angle:** $\alpha = 30^\circ$

**Objectives:**
1.  Observe the effect of source inductance on the load voltage (Commutation Notches).
2.  Calculate and simulate the Average Load Voltage ($V_{dc}$).
3.  Calculate and simulate the RMS Source Current.

## ⚙️ Simulation Settings (Simulink)
The Simulink model is configured with the following parameters:
* **Solver:** `ode23t (mod. stiff/Trapezoidal)`
* **Stop Time:** `0.6` s
* **Powergui:** Discrete, $T_s = 5e-6$ s

## 🔌 Simulink Model
The following circuit topology was implemented, including the $L_s$ inductors before the thyristors.

![Circuit Diagram](Circuit.png)

## 🧮 Mathematical Background
Due to the source inductance $L_s$, the current cannot change instantly from one phase to another. This overlap period is called the **Commutation Angle ($\mu$)**.

**1. Average Load Voltage ($V_{dc}$):**
The output voltage is reduced by the voltage drop across $L_s$ during commutation.
$$V_{dc} = V_{dc(\text{no-loss})} - \Delta V_x$$

$$V_{dc} = \frac{3\sqrt{2} V_{phase}}{\pi} \cos(\alpha) - \frac{3 \omega L_s I_d}{2\pi}$$
Where $I_d$ is the constant load current ($20 \text{ A}$).

**2. Commutation Overlap:**
During the interval $\mu$, two phases conduct simultaneously, and the output voltage follows the average of these two phase voltages, creating "notches" in the waveform.

## 💻 MATLAB Code
*(User provided script)*

## 📊 Simulation Results

The simulation clearly shows the effect of source inductance.

**1. Quantitative Measurements:**
* **Average Load Voltage:** 192.4 V
* **RMS Source Current:** 11.23 A

**2. Waveform Analysis:**
The scope output below demonstrates the **Commutation Notches** on the load voltage (bottom graph). Unlike ideal rectifiers, the voltage does not jump instantly; it transitions during the overlap period.
* **Row 1:** 3-Phase Source Voltages.
* **Row 2:** Load Current (Settles to approx 20A).
* **Row 3:** Source Current (Phase R).
* **Row 4:** Load Voltage (Note the momentary voltage drops/notches at firing points).

![Scope Results](Scope.jpg)

## 📂 Files
* [Matlab_Calculation.m](Matlab_Calculation.m)
* [Simulink_Simulation.mdl](Simulink_Simulation.mdl)