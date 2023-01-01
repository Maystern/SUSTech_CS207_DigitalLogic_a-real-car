onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib UART_opt

do {wave.do}

view wave
view structure
view signals

do {UART.udo}

run -all

quit -force
