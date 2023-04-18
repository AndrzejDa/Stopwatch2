----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2023 18:12:21
-- Design Name: 
-- Module Name: top - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity top is
    Port ( start_stop_button_i : in  STD_LOGIC;
           clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           led7_an_o : out  STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out  STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is
constant zero     : STD_LOGIC_VECTOR(6 downto 0) := "0000001"; 
constant jeden    : STD_LOGIC_VECTOR(6 downto 0) := "1001111"; 
constant dwa      : STD_LOGIC_VECTOR(6 downto 0) := "0010010"; 
constant trzy     : STD_LOGIC_VECTOR(6 downto 0) := "0000110"; 
constant cztery   : STD_LOGIC_VECTOR(6 downto 0) := "1001100"; 
constant piec     : STD_LOGIC_VECTOR(6 downto 0) := "0100100"; 
constant szesc    : STD_LOGIC_VECTOR(6 downto 0) := "0100000"; 
constant siedem   : STD_LOGIC_VECTOR(6 downto 0) := "0001111"; 
constant osiem    : STD_LOGIC_VECTOR(6 downto 0) := "0000000"; 
constant dziewiec : STD_LOGIC_VECTOR(6 downto 0) := "0000100"; 


Type tablica is Array (0 to 9) of STD_LOGIC_VECTOR(6 downto 0);
Constant Table: tablica:=(zero,jeden,dwa,trzy,cztery,piec,szesc,siedem,osiem,dziewiec);
signal Digit:  STD_LOGIC_VECTOR(31 downto 0) := "00000001000000010000000100000001";
signal Clock:  STD_LOGIC := '0';
signal Button:  STD_LOGIC := '0';
signal Stan: Integer range 0 to 3 := 0;


Component Clkgen 
 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           clk_o : out  STD_LOGIC);
END Component;
Component Display
	 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           digit_i : in  STD_LOGIC_VECTOR (31 downto 0);
           led7_an_o : out  STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out  STD_LOGIC_VECTOR (7 downto 0));
END Component;
signal licznik :  Integer range 0 to 9:=0;
signal licznik0:  Integer range 0 to 9:=0;
signal licznik1:  Integer range 0 to 9:=0;
signal licznik2:  Integer range 0 to 9:=0;
signal licznik3:  Integer range 0 to 9:=0;

signal opoznienie1,opoznienie2,opoznienie3 : std_logic;
signal wyjscie : std_logic;


begin
uut0: Clkgen PORT MAP(
    clk_i => clk_i,
    rst_i => rst_i,
	clk_o => Clock
);
uut1: Display PORT MAP(
    clk_i => Clock,
    rst_i => rst_i,
	digit_i => Digit,
	led7_an_o => led7_an_o,
	led7_seg_o => led7_seg_o
);

----------debounce------------------------

process (Clock,rst_i)
begin
	if(rst_i = '1') then
	opoznienie1<='0';
	opoznienie2<='0';
	opoznienie3<='0';
	elsif rising_edge(Clock) then
	opoznienie1<=start_stop_button_i;
	opoznienie2<=opoznienie1;
	opoznienie3<=opoznienie2;
	end if;
end process;

wyjscie<=opoznienie1 and opoznienie2 and opoznienie3;

------------------przelaczanie----------------------------------------


----------------------------------------------------------------------

process (Clock,rst_i)
begin
  if rst_i='1' then
    Stan <= 0;		
	Button   <= '1';
	licznik  <= 0;
	licznik0 <= 0;
	licznik1 <= 0;
	licznik2 <= 0;
	licznik3 <= 0;
  elsif rising_edge(Clock) then
  if wyjscie='1' and Button='0' then
  case Stan is
  when 0 =>   Stan <= 1;
  when 1 =>   Stan <= 2;
  when others => Stan <= 0;
				licznik <= 0;
				licznik0 <= 0;
				licznik1 <= 0;
				licznik2 <= 0;
				licznik3 <= 0;
end case;

  end if;
  
  Button <= wyjscie;
          	if Stan =1  then
					if licznik<9 then
					licznik <= licznik + 1;
					else
						licznik <=0;
						if licznik0<9 then
						licznik0 <= licznik0 + 1;
						else
						licznik0 <=0;
							if licznik1<9 then
							licznik1 <= licznik1 + 1;
							else
							licznik1 <=0;
								if licznik2<9 then
								licznik2 <= licznik2 + 1;
								else
								licznik2 <=0;
									if licznik3<5 then
									licznik3 <= licznik3 + 1;
									else
									Stan <= 3;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
  end if;
end process;

Digit(7 downto 1)   <= Table(licznik0)  when Stan<3 else "1111110";	
Digit(15 downto 9)  <= Table(licznik1)  when Stan<3 else "1111110";	
Digit(23 downto 17) <= Table(licznik2)  when Stan<3 else "1111110";	
Digit(31 downto 25) <= Table(licznik3)  when Stan<3 else "1111110";	

Digit(0) <='1';
Digit(8) <='1';
Digit(16)<='0';
Digit(24)<='1';

end Behavioral;

