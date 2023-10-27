import argparse
import sys
import serial

argument_parser = argparse.ArgumentParser(prog="rpp", description="RISCV Processor Programmer")
argument_parser.add_argument("filename", type=str, help="Input Filename")
argument_parser.add_argument("-c", type=str, help="COM Port to Use for Programming.")
argument_parser.add_argument("-b", type=str, help="Baud Rate to Use for Programming.")
argument_parser.add_argument("-w", action="store_true", help="Supress Warnings.")

arguments = argument_parser.parse_args()

warning_flag = arguments.w

if arguments.c != None:
    com_port = arguments.c
else:
    com_port = "COM3"

if arguments.b != None:
    baud_rate = int(arguments.b)
else:
    baud_rate = 115200

with open(arguments.filename, "r") as f:
    instructions = f.readlines()

# Setting Up COM Port
# ser = serial.Serial(com_port, baud_rate)

for instruction in instructions:
    for i in range(3,-1,-1):
        mask = 0x000000FF << (i * 8)
        value = hex((mask & int(instruction,2)) >> (i * 8))
        # ser.write(value)
        print(value)
