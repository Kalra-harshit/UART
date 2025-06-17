# UART (Universal Asynchronous Receiver Transmitter) in Verilog

This project implements a fully functional UART system in Verilog, including:
- **Baud rate generator**
- **UART Transmitter (TX)**
- **UART Receiver (RX)**
- **Testbench** to simulate transmission and reception

---

## 🔧 Features

- Configurable **clock frequency** and **baud rate**
- 8-bit data frame with 1 start bit, 1 stop bit
- 1-clock-cycle wide `tick` generator for precise timing
- Designed for FPGA and simulation environments
- Clean modular design (`uart_tx.v`, `uart_rx.v`, `uart_baud_gen.v`)

---


