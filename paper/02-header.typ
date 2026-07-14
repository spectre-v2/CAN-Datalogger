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
  name: "TCAN4550-Q1",
  modern: 0,
  external_circuit: 1,
  can_rate: 1,
  spi_rate: 0,
  memory: 0,
  filtering: 0,
  interface: 0,
  cost: -1,
)

#let mcp2518fd_scores=(
  name: "MCP2518FD",
  modern: 0,
  external_circuit: -1,
  can_rate: 1,
  spi_rate: 1,
  memory: 0,
  filtering: 1,
  interface: 0,
  cost: 1,
)

#let mcp251863_scores=(
  name: "MCP251863",
  modern: 1,
  external_circuit: 1,
  can_rate: 1,
  spi_rate: 1,
  memory: 0,
  filtering: 1,
  interface: 1,
  cost: 0,
)

// Gewichtungen für die CAN-FD-Controller-Auswahl
#let can_multi=(
  modern: 1,
  external_circuit: 2,
  can_rate: 3,
  spi_rate: 2,
  memory: 3,
  filtering: 3,
  interface: 3,
  cost: 2,
)

#let can_score(controller)= (
  controller.modern * can_multi.modern +
  controller.external_circuit * can_multi.external_circuit +
  controller.can_rate * can_multi.can_rate +
  controller.spi_rate * can_multi.spi_rate +
  controller.memory * can_multi.memory +
  controller.filtering * can_multi.filtering +
  controller.interface * can_multi.interface +
  controller.cost * can_multi.cost
)

//----------------------Speicher-----------------------
#let spinand_scores=(
  name: "SPI-NAND-Flash",
  capacity: 0,
  write_speed: 0,
  interface: 0,
  flash_management: -1,
  pc_readability: -1,
  integration: 1,
  availability: 0,
  cost: -1,
)

#let emmc_scores=(
  name: "eMMC",
  capacity: 0,
  write_speed: 1,
  interface: -1,
  flash_management: 1,
  pc_readability: 0,
  integration: -1,
  availability: 0,
  cost: 0,
)

#let microsd_scores=(
  name: "microSD",
  capacity: 1,
  write_speed: 1,
  interface: 1,
  flash_management: 1,
  pc_readability: 1,
  integration: 1,
  availability: 1,
  cost: 1,
)

// Gewichtungen für die Speichermedien-Auswahl
#let storage_multi=(
  capacity: 1,
  write_speed: 3,
  interface: 2,
  flash_management: 3,
  pc_readability: 3,
  integration: 2,
  availability: 1,
  cost: 2,
)

#let storage_score(medium)= (
  medium.capacity * storage_multi.capacity +
  medium.write_speed * storage_multi.write_speed +
  medium.interface * storage_multi.interface +
  medium.flash_management * storage_multi.flash_management +
  medium.pc_readability * storage_multi.pc_readability +
  medium.integration * storage_multi.integration +
  medium.availability * storage_multi.availability +
  medium.cost * storage_multi.cost
)
