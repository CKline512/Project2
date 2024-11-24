
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Project2 is 
    Port(CE, A0, RD, WR, RESET, STB : in std_logic;
          P : in std_logic_vector (7 downto 0);
          INTR, IBF: out std_logic;
          D : inout std_logic_vector (7 downto 0));
end Project2;

architecture Behavioral of Project2 is

--Control_Reg.0: MODE Bit
--    if 0: Mode 0 input from peripheral
--    if 1: Mode 1 input from peripheral
--Control_Reg1: INTE (Interrupt Enable) Bit
--    if 1: signal INTR is enabled
--    if 0: INTR is disabled
--Status_Reg.0: IBF (Input Buffer Full) Bit
--Status_Reg.1: INTE (Interrupt Enable) Bit
--Status_Reg.2: INTR (Interrupt Request) Bit

signal P_Reg : std_logic_vector (7 downto 0);
signal Control_Reg0 : std_logic; -- MODE bit
signal Control_Reg1 : std_logic; -- INTE (Interrupt Enable) Bit
signal Status_Reg0 : std_logic; -- IBF (Input Buffer Full) Bit
signal Status_Reg1 : std_logic; -- INTE (Interrupt Enable) Bit
signal Status_Reg2 : std_logic; -- INTR (Interrupt Request) Bit

begin



Assign_Registers : process(CE, A0) begin
    if(not(CE) = '1' and A0 = '0') then --Data in (Read Access)
        --allows P to enter D_Bus aswell as P_Reg
    
    
    elsif(not(CE) = '1' and A0 = '1') then  -- Control_Reg (for write access only)

    
    elsif(not(CE )= '0' and A0 = '1') then -- Status_Reg for read access only

    end if;
end process Assign_Registers;


RESET_Process : process(RESET) begin
    if (RESET = '1') then
        Control_Reg0 <= '0';
        Control_Reg1 <= '0';
        Status_Reg0 <= '0';
        Status_Reg1 <= '0';
        Status_Reg2 <= '0';
    else
        Control_Reg0 <= Control_Reg0;
        Control_Reg1 <= Control_Reg1;
        Status_Reg0 <= Status_Reg0 ;
        Status_Reg1 <= Status_Reg1 ;
        Status_Reg2 <= Status_Reg2 ;
    end if;
end process RESET_Process; 
end Behavioral;
