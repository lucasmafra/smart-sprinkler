ghdl -a *.vhd
ghdl -e $1
ghdl -r $1 --vcd=$1.vcd
