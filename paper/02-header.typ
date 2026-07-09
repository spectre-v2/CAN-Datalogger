//----------------------Mcu-----------------------
// Structs für den Komponenten- Bewertungsscore- MCU
#let avr64du_scores=(
  name: "AVR64DU",
  modern: 1,
  core_perf: 0,
  multicore: -1,
  ramsize: -1,
  interface: 0,
  signalrout: 0,
  canfdinteg: -1,
  software: 0,
)

#let stm32c5_scores=(
  name: "STM32C5",
  modern: 1,
  core_perf: 1,
  multicore: -1,
  ramsize: 0,
  interface: 0,
  signalrout: -1,
  canfdinteg: 1,
  software: -1,
)

#let rp2350_scores=(
  name: "RP2350",
  modern: 0,
  core_perf: 1,
  multicore: 1,
  ramsize: 1,
  interface: 1,
  signalrout: 1,
  canfdinteg: -1,
  software: 1,
)

// Struct mit den gewichtungs- Multiplikatoren für Mcu
#let mcu_multi=(
  modern: 1,
  core_perf: 1,
  multicore: 2,
  ramsize: 3,
  interface: 2,
  signalrout: 2,
  canfdinteg: 1,
  software: 3,
)

// funktion, die en gewichteten score berechnet. für Mcu
#let mcu_score(mcu)= (
  mcu.modern * mcu_multi.modern +
  mcu.core_perf * mcu_multi.core_perf +
  mcu.multicore * mcu_multi.multicore +
  mcu.ramsize * mcu_multi.ramsize +
  mcu.interface * mcu_multi.interface +
  mcu.signalrout * mcu_multi.signalrout +
  mcu.canfdinteg * mcu_multi.canfdinteg +
  mcu.software * mcu_multi.software
)

#let tcan4550_scores=(
  
)