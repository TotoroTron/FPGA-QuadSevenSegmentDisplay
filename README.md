# FPGA-QuadSevenSegmentDisplay

Environment: Quartus II

A simple VHDL machine to drive a quad seven segment LED display. This particular display requires you to strobe through the four digits, as only one digit can be enabled at any given time. This design simply counts upwards from 0000 to 9999, then resets to 0000.
