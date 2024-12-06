library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity proj2 is
  Port ( CE,  WR, RD, STB : in std_logic; -- active low
         A0, RESET : in std_logic; -- active high
        P : in std_logic_vector(7 downto 0);
        D : inout std_logic_vector(7 downto 0);
        Y1, Y2 : inout std_logic; -- used for the asynchro section
        INTR, IBF : out std_logic;
        OE : out std_logic
        );
end proj2;

architecture Behavioral of proj2 is

signal WR_rising : std_logic;
signal data_in, D_value : std_logic_vector(7 downto 0);
signal CR : std_logic_vector(1 downto 0);
signal SR : std_logic_vector(2 downto 0);  -- 2 = INTR, 1 = INTE, 0 = IBF
signal X1, X2 : std_logic;
signal P_signal : std_logic_vector(7 downto 0);
signal IBF_sig, INTR_sig : std_logic;
signal check_value : std_logic;
signal Qualified_read : std_logic;
signal D_value_rep : std_logic_vector(7 downto 0);

begin

-- input to signal assignment
--P_signal <= P when RESET = '0' else (others => '0');
WR_rising <= WR;

-- Mode 0 output
output_op : process(P, CE, A0, CR, RD, STB, SR, data_in, RESET) begin
    -- Mode 1  
    if(falling_edge(STB)) then
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


data_in_op : process(P, CE, A0, STB, RESET) begin
    if(falling_edge(STB)) then
        if(CE = '0' and A0 = '0') then
            data_in <= P;
        end if;
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
X1 <= STB;

X2 <= RD;


Y1 <= ((Y1 and Y2) or (X1 and X2 and Y2) or (not(X1) and Y1) or (not(Y2) and Y1)) when CE = '0' and A0 = '0' and CR = "11" else '0' when RESET = '1';

Y2 <= ((not(Y1) and Y2) or (not(X1) and X2 and Y1) or (not(X1) and Y2) or (X2 and Y2)) when CE = '0' and A0 = '0' and CR = "11" else '0' when RESET = '1';

             
IBF_sig <= ((Y2) or (not(X1) and Y1) or (not(X1) and Y1) or (not(X1) and X2)) when CE = '0' and A0 = '0' and CR = "11" else '0'  when RESET = '1';

INTR_sig <= Y1 and Y2 when CE = '0' and A0 = '0' and CR = "11" else '0' when RESET = '1';


SR(2) <= INTR_sig when CE = '0' else '0';
SR(1) <= CR(1) when CE = '0' else '0';
SR(0) <= IBF_sig when CE = '0' else '0';

IBF <=  IBF_sig;
INTR <= INTR_sig;




end Behavioral;
