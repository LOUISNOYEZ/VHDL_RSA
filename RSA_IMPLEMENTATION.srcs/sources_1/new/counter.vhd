----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 01:48:05
-- Design Name: 
-- Module Name: counter - counter_arch
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    generic(counter_data_width : natural := 7);
    Port (clock_i : in STD_LOGIC;
          reset_i : in STD_LOGIC;
          set_i : in STD_LOGIC;
          en_i : in STD_LOGIC;
          data_i : in STD_LOGIC_VECTOR(counter_data_width-1 downto 0);
          data_o : out STD_LOGIC_VECTOR(counter_data_width-1 downto 0));
end counter;

architecture counter_arch of counter is

    signal count_s : STD_LOGIC_VECTOR(counter_data_width-1 downto 0);

begin

    P0 : process(clock_i)
        variable count : natural := 0;
    begin
        if clock_i = '1' and clock_i'event then
            if reset_i = '0' then
                count := 0;
            elsif set_i = '1' then
                count := To_Integer(Unsigned(data_i));
            elsif en_i = '1' then
                count := count+1;
            else
                count := count;
            end if;
            count_s <= STD_LOGIC_VECTOR(To_Unsigned(count,counter_data_width));
        end if;
    end process;
    
    data_o <= count_s;
    
end counter_arch;
