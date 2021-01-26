----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 00:52:04
-- Design Name: 
-- Module Name: half_adder - half_adder_arch
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

entity half_adder is
    port (a_i : in STD_LOGIC;
          b_i : in STD_LOGIC;
          c_o : out STD_LOGIC;
          s_o : out STD_LOGIC );
end half_adder;

architecture half_adder_arch of half_adder is

begin

    c_o <= a_i and b_i;
    s_o <= a_i xor b_i;

end half_adder_arch;
