library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity clkgen is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           clk_o : out  STD_LOGIC);
end  clkgen;

architecture Behavioral of clkgen is
constant N : Integer := 100000;
signal licznik:  Integer range 0 to N/2:=0;
signal zegar: std_logic:='0';
begin
process (clk_i,rst_i)
begin
	  if rst_i='1' then
		  licznik <= 0;
		  zegar <= '0'; 
	  elsif clk_i='1' and clk_i'event then
				if licznik = N/2 then
				zegar <= not zegar;
				licznik <= 0;
				else
				licznik <= licznik + 1;
				end if;
	  end if;
end process;
clk_o <= zegar;
end Behavioral;
