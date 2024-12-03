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

--signal Data_In : std_logic_vector (7 downto 0);
signal Control_Reg0 : std_logic; -- MODE bit
signal Control_Reg1 : std_logic; -- INTE (Interrupt Enable) Bit
signal Status_Reg0 : std_logic; -- IBF (Input Buffer Full) Bit
signal Status_Reg1 : std_logic; -- INTE (Interrupt Enable) Bit
signal Status_Reg2 : std_logic; -- INTR (Interrupt Request) Bit
signal X1, X2, Y1, Y2, Y3, Z1, Z2 : std_logic; 
signal mode1_data : std_logic_vector (7 downto 0);
signal data_reg : std_logic_vector (7 downto 0);
signal IBF_signal, INTR_signal : std_logic;


begin


control_reg: process(WR, CE, A0, RESET) 
    begin 
    if (RESET = '1') then 
        Control_Reg0 <= '0';
        Control_Reg1 <= '0';
    end if;
    if rising_edge(WR) then 
        if(CE = '0' and A0 = '1')then 
            Control_Reg0 <= D(0);
            Control_Reg1 <= D(1);
        end if;
    end if; 
end process control_reg;


data : process(CE, WR, A0, RD, Control_Reg0, P, Status_Reg2, Status_Reg1, Status_Reg0, mode1_data) begin 
    if(CE = '0' and RD = '0' and WR = '1') then 
        if(A0 = '1') then 
            if(Control_Reg0 = '1') then 
                data_reg <= P;
            else
                data_reg <= mode1_data;
            end if;
        else 
            data_reg(2) <= Status_Reg2;
            data_reg(1) <= Status_Reg1;
            data_reg(0) <= Status_Reg0;
        end if;
    end if;
    

end process data;

mode1_register_control: process(CE, STB, A0, P)begin
    if(CE = '0' and falling_edge(STB) and A0 = '1') then 
        mode1_data <= P;
    end if; 

end process mode1_register_control;

X1 <= STB;
-- RD has to be a qualified read
X2 <= RD;

Y1 <= ((not(Y2) and Y3 and X2) or (Y2 and not(Y3) and X1)) and not(RESET);

Y2 <= ((Y3 and X1 and X2) or (Y2 and X1 and not(X2)) or (Y2 and Y3 and X1)) and not(RESET);

Y3 <= ((Y3 and X1 and X2) or (not(Y2) and Y3 and X2) or
             (not(Y1) and not(Y2) and not(X1) and X2)) and not(RESET);
             
Z1 <= ((Y3 and X1 and X2) or (not(Y1) and not(Y2) and not(X1) and X2) or (not(Y2) and Y3 and X2)
                or (Y2 and Y3 and X1) or (Y2 and X1 and not(X2)));

Z2 <= (Y3 and X1 and X2);



INTR_signal <= Z2 when Control_Reg0 = '1' and Control_Reg1 = '1' else '0';

IBF_signal <= Z1 when Control_Reg0 = '1' else '0';

Status_Reg0 <= IBF_signal when CE = '0' else '0' ;     -- IBF status
Status_Reg1 <= Control_Reg1 when CE = '0' else '0';  -- INTE status
Status_Reg2 <= INTR_signal when CE = '0' else '0';   -- INTR status 

IBF <= IBF_signal;
INTR <= INTR_signal;
D <= data_reg when CE = '0' else (others => 'Z');

end Behavioral;
