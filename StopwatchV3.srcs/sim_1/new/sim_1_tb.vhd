LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY sim_1_tb IS
END sim_1_tb;
 
ARCHITECTURE behavior OF sim_1_tb IS 
 
    COMPONENT top
    PORT(
         start_stop_button_i : IN  std_logic;
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         led7_an_o : OUT  std_logic_vector(3 downto 0);
         led7_seg_o : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   signal start_stop_button_i : std_logic := '0';
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';

   signal led7_an_o : std_logic_vector(3 downto 0);
   signal led7_seg_o : std_logic_vector(7 downto 0);

   constant clk_i_period : time := 10 ns;
 
BEGIN
 
   uut: top PORT MAP (
          start_stop_button_i => start_stop_button_i,
          clk_i => clk_i,
          rst_i => rst_i,
          led7_an_o => led7_an_o,
          led7_seg_o => led7_seg_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 10ns;
      	
		start_stop_button_i <='1';
      wait for 100ns;
        start_stop_button_i <='0';
        
        wait for 100ms;
      	
		start_stop_button_i <='1';
      wait for 100ns;	
		start_stop_button_i <='0';
		
		wait for 10ms;
		
 	
		rst_i <= '1';
        wait for 100ns;	
		rst_i <= '0';
		
		

      wait for 10ms;
      
      	start_stop_button_i <='1';
      wait for 100ns;
        start_stop_button_i <='0';
        
         wait for 1000ms;
         
         	start_stop_button_i <='1';
      wait for 100ns;
        start_stop_button_i <='0';	

      wait for clk_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
