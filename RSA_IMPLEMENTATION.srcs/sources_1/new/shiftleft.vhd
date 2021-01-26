----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 01:20:32
-- Design Name: 
-- Module Name: shiftleft - shiftleft_arch
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

entity shiftleft is
    generic(data_width : natural := 64;
            shift_amount_width : natural := 7);
    Port (data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
          shift_amount_i : in STD_LOGIC_VECTOR(shift_amount_width-1 downto 0);
          data_low_o : out STD_LOGIC_VECTOR(data_width-1 downto 0);
          data_high_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
end shiftleft;

architecture shiftleft_arch of shiftleft is

    signal data_s : STD_LOGIC_VECTOR(2*data_width-1 downto 0);

begin

    P0 : process(data_i, shift_amount_i)
    begin
        data_s <= (others => '0');
        data_s(data_width-1+To_Integer(Unsigned(shift_amount_i)) downto To_Integer(Unsigned(shift_amount_i))) <= data_i;
    end process; 

    data_low_o <= data_s(data_width-1 downto 0);
    data_high_o <= data_s(2*data_width-1 downto data_width);

end shiftleft_arch;
