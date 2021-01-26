----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 01:17:33
-- Design Name: 
-- Module Name: bit_reg_comp - bit_reg_comp_arch
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

entity bit_reg_comp is
    Port (clock_i : in STD_LOGIC;
          reset_i : in STD_LOGIC;
          set_i : in STD_LOGIC;
          en_i : in STD_LOGIC;
          data_i : in STD_LOGIC;
          data_o : out STD_LOGIC );
end bit_reg_comp;

architecture bit_reg_comp_arch of bit_reg_comp is

    signal data_s : STD_LOGIC;

begin

    P0 : process(clock_i)
    begin
        if clock_i = '1' and clock_i'event then
            if reset_i = '0' then
                data_s <= '0';
            elsif set_i = '1' then
                data_s <= '1';
            elsif en_i = '1' then
                data_s <= data_i;
            else
                data_s <= data_s;
            end if;
        end if;
    end process;
    
    data_o <= data_s;

end bit_reg_comp_arch;
