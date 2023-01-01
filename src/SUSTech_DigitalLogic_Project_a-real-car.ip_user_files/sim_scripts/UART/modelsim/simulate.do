onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L axi_lite_ipif_v3_0_4 -L lib_pkg_v1_0_2 -L lib_srl_fifo_v1_0_2 -L lib_cdc_v1_0_2 -L axi_uartlite_v2_0_19 -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.UART

do {wave.do}

view wave
view structure
view signals

do {UART.udo}

run -all

quit -force
