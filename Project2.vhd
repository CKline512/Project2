----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2024 01:54:21 PM
-- Design Name: 
-- Module Name: project_o - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_o is
Port ( CE,  WR, RD, STB : in std_logic; -- active low
         A0, RESET : in std_logic; -- active high
        P : in std_logic_vector(7 downto 0);
        D : inout std_logic_vector(7 downto 0);
        Y1, Y2 : inout std_logic; -- used for the asynchro section
        INTR, IBF : out std_logic;
        data_in_check : out std_logic_vector(7 downto 0);
        CR_check : out std_logic_vector(1 downto 0);
        SR_check : out std_logic_vector(2 downto 0);
        OE : out std_logic
        );
end project_o;

architecture Behavioral of project_o is


signal WR_rising : std_logic;
signal data_in, D_value : std_logic_vector(7 downto 0);
signal CR : std_logic_vector(1 downto 0);
signal SR : std_logic_vector(2 downto 0);  -- 2 = INTR, 1 = INTE, 0 = IBF
signal X1, X2 : std_logic;
signal P_signal : std_logic_vector(7 downto 0);
signal IBF_signal, INTR_signal : std_logic;
signal check_value : std_logic;
signal Qualified_read : std_logic;
signal D_value_rep : std_logic_vector(7 downto 0);
signal stb_signal : std_logic;
signal check : std_logic := '0';

begin

-- input to signal assignment
P_signal <= P;
WR_rising <= WR;
stb_signal <= STB;

-- Mode 0 output
output_op : process(P, CE, A0, CR, RD, STB, SR, data_in, RESET) begin
    -- Mode 1  
    if(falling_edge(stb_signal)) then
        if(CE = '0' and A0 = '0' and RD = '0' and CR(0) = '1')then
            D_value <= data_in;
        end if;
    end if;

    -- mode 0
    if (RESET = '0') then
        if(CE = '0' and A0 = '0' and RD = '0' and CR(0) = '0') then
            D_value <= P;
        elsif(CE = '0' and A0 = '1' and RD = '0') then  -- status reg bit
            D_value(2 downto 0) <= SR;
        end if;
    else
        D_value <= (others => '0');
    end if;
   
     
end process output_op;

OE_Enable : process(CR, RD, WR, CE) begin
    if(WR = '1' and CR(0) = '0' and CE = '0' and A0 = '0') then
        OE <= '0';
    elsif(RD = '1' and CR(0) = '1' and CE = '0' and A0 = '0') then
        OE <= '1';
    elsif (A0 = '1') then
        OE <= '0';
    else
        OE <= '1';
    end if;
end process OE_Enable;


CR_op : process(D, WR_rising, RESET, CE, A0) begin
   
    if(rising_edge(WR_rising)) then
        if(CE = '0' and A0 = '1') then
            CR(1) <= D(7);
            CR(0) <= D(6);

        end if;
    end if;
    if(RESET = '1') then
        CR <= "00";
    end if;

end process CR_op;


data_in_op : process(P, CE, A0, stb_signal, RESET) begin
    if(falling_edge(stb_signal) and CE = '0' and A0 ='0') then
            data_in <= P;
    end if;
       
        if(RESET = '0') then
            data_in <= (others => '0');
        end if;
       
    if(CE = '0' and A0 = '0') then
            Qualified_read <= RD;
     end if;

end process data_in_op;

-- output signals to outputs. (D, INTR, IBF)
D <= D_value when CE = '0' else (others => 'Z');


-- asynchronous components


Y1 <= ((Y1 and Y2) or (STB and RD and Y2) or (not(STB) and Y1) or (not(RD) and Y1)) when CE = '0' and A0 = '0' and CR = "11" else '0' when RESET = '1';

Y2 <= ((not(Y1) and Y2) or (not(STB) and RD and not(Y2)) or (not(STB) and Y2) or (RD and Y2)) when CE = '0' and A0 = '0' and CR = "11" else '0' when RESET = '1';

             
IBF_signal <= ((Y2) or (not(STB) and Y1 and not(Y2)) or (not(RD) and Y1) or (not(STB) and RD)) when CE = '0' and A0 = '0' and CR = "11" else '0'  when RESET = '1';

INTR_signal <= ((not(STB) and not(RD) and Y2) or (RD and Y1 and Y2) or (not(STB) and Y1 and Y2)) when CE = '0' and A0 = '0' and CR = "11" else '0' when RESET = '1';


SR(2) <= INTR_signal;
SR(1) <= CR(1);
SR(0) <= IBF_signal;


CR_check <= CR; -- debug signal
SR_check <= SR; -- debug signal

IBF <=  IBF_signal;
INTR <= INTR_signal;

end Behavioral;

