## This file is a general .xdc for the Nexys A7-100T

## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets STB];
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets WR];


# ALLOW COMBINATORIAL LOOPS :
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets Y1*];
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets Y2*];
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets Y3*];
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets D*];

##Pmod Headers
##Pmod Header JA

set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports { D[0] }]; #IO_L20N_T3_A19_15 Sch=ja[1]

set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { D[1] }]; #IO_L21N_T3_DQS_A18_15 Sch=ja[2]

set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { D[2] }]; #IO_L21P_T3_DQS_15 Sch=ja[3]

set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { D[3] }]; #IO_L18N_T2_A23_15 Sch=ja[4]

set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports { D[4] }]; #IO_L16N_T2_A27_15 Sch=ja[7]

set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports { D[5] }]; #IO_L16P_T2_A28_15 Sch=ja[8]

set_property -dict { PACKAGE_PIN F18 IOSTANDARD LVCMOS33 } [get_ports { D[6] }]; #IO_L22N_T3_A16_15 Sch=ja[9]

set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports { D[7] }]; #IO_L22P_T3_A17_15 Sch=ja[10]



##Pmod Header JB

set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [get_ports { P[0] }]; #IO_L1P_T0_AD0P_15 Sch=jb[1]

set_property -dict { PACKAGE_PIN F16 IOSTANDARD LVCMOS33 } [get_ports { P[1] }]; #IO_L14N_T2_SRCC_15 Sch=jb[2]

set_property -dict { PACKAGE_PIN G16 IOSTANDARD LVCMOS33 } [get_ports { P[2] }]; #IO_L13N_T2_MRCC_15 Sch=jb[3]

set_property -dict { PACKAGE_PIN H14 IOSTANDARD LVCMOS33 } [get_ports { P[3] }]; #IO_L15P_T2_DQS_15 Sch=jb[4]

set_property -dict { PACKAGE_PIN E16 IOSTANDARD LVCMOS33 } [get_ports { P[4] }]; #IO_L11N_T1_SRCC_15 Sch=jb[7]

set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33 } [get_ports { P[5] }]; #IO_L5P_T0_AD9P_15 Sch=jb[8]

set_property -dict { PACKAGE_PIN G13 IOSTANDARD LVCMOS33 } [get_ports { P[6] }]; #IO_0_15 Sch=jb[9]

set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports { P[7] }]; #IO_L13P_T2_MRCC_15 Sch=jb[10]


##Pmod Header JC

set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports { CE }]; #IO_L23N_T3_35 Sch=jc[1] #BF SW1

set_property -dict { PACKAGE_PIN F6 IOSTANDARD LVCMOS33 } [get_ports { RD}]; #IO_L19N_T3_VREF_35 Sch=jc[2] #BF SW2

set_property -dict { PACKAGE_PIN J2 IOSTANDARD LVCMOS33 } [get_ports { WR }]; #IO_L22N_T3_35 Sch=jc[3] #BF SW3

set_property -dict { PACKAGE_PIN G6 IOSTANDARD LVCMOS33 } [get_ports { STB }]; #IO_L19P_T3_35 Sch=jc[4] #BF SW4

set_property -dict { PACKAGE_PIN E7 IOSTANDARD LVCMOS33 } [get_ports { RESET }]; #IO_L6P_T0_35 Sch=jc[7]

set_property -dict { PACKAGE_PIN J3 IOSTANDARD LVCMOS33 } [get_ports { A0 }]; #IO_L22P_T3_35 Sch=jc[8]

set_property -dict { PACKAGE_PIN J4 IOSTANDARD LVCMOS33 } [get_ports { INTR }]; #IO_L21P_T3_DQS_35 Sch=jc[9]

set_property -dict { PACKAGE_PIN E6 IOSTANDARD LVCMOS33 } [get_ports { IBF }]; #IO_L5P_T0_AD13P_35 Sch=jc[10]


##Pmod Header JD

set_property -dict { PACKAGE_PIN H4 IOSTANDARD LVCMOS33 } [get_ports { Y1 }]; #IO_L21N_T3_DQS_35 Sch=jd[1]

set_property -dict { PACKAGE_PIN H1 IOSTANDARD LVCMOS33 } [get_ports { Y2 }]; #IO_L17P_T2_35 Sch=jd[2]

set_property -dict { PACKAGE_PIN G1 IOSTANDARD LVCMOS33 } [get_ports { Y3 }]; #IO_L17N_T2_35 Sch=jd[3]

