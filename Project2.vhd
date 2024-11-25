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
signal X1, X2, Y1, Y2, Y3, Z1, Z2 : std_logic; 

begin

Assign_Registers : process(CE, A0) begin
    if(not(CE) = '1' and A0 = '0') then --Data in (Read Access)
        --allows P to enter D_Bus aswell as P_Reg
    
    
    elsif(not(CE) = '1' and A0 = '1') then  -- Control_Reg (for write access only)

    
    elsif(not(CE )= '0' and A0 = '1') then -- Status_Reg for read access only

    end if;
end process Assign_Registers;


Asynch_Process : process(RD, STB, RESET) begin
    X1 <= STB;
        -- RD has to be a qualified read 
    X2 <= RD;
    if(RESET = '0') then
        Y1 <= ((not(Y2) and Y3 and X2) or (Y2 and not(Y3) and X1)) and not(RESET);
        
        Y2 <= ((Y3 and X1 and X2) or (Y2 and X1 and not(X2)) or (Y2 and Y3 and X1)) and not(RESET);
        
        Y3 <= ((Y3 and X1 and X2) or (not(Y2) and Y3 and X2) or
             (not(Y1) and not(Y2) and not(X1) and X2)) and not(RESET);
        -- needs to be IBF
        Z1 <= ((Y3 and X1 and X2) or (not(Y1) and not(Y2) and not(X1) and X2) or (not(Y2) and Y3 and X2)
                or (Y2 and Y3 and X1) or (Y2 and X1 and not(X2)));

        -- needs to be INTR, but this is only enabled when CR = 11
        Z2 <= (Y3 and X1 and X2);

        IBF <= Z1;

        if(Control_Reg0 = '1' and Control_Reg1 = '1')then 
            INTR <= Z2;
        end if;
        
    end if;
end process Asynch_Process;

RESET_Process : process(RESET) begin
    if (RESET = '0') then
        Control_Reg0 <= '0';
        Control_Reg1 <= '0';
        Status_Reg0 <= '0';
        Status_Reg1 <= '0';
        Status_Reg2 <= '0';
    else
        Control_Reg0 <= Control_Reg0;
        Control_Reg1 <= Control_Reg1;
        Status_Reg0 <= Status_Reg0;
        Status_Reg1 <= Status_Reg1;
        Status_Reg2 <= Status_Reg2;
    end if;
end process RESET_Process; 
end Behavioral;

