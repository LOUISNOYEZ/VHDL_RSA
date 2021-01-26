----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 00:53:20
-- Design Name: 
-- Module Name: full_adder - full_adder_arch
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

entity full_adder is
    Port (a_i : in STD_LOGIC;
          b_i : in STD_LOGIC;
          c_i : in STD_LOGIC;
          c_o : out STD_LOGIC;
          s_o : out STD_LOGIC );
end full_adder;

architecture full_adder_arch of full_adder is

    component half_adder is
        port(a_i : in STD_LOGIC;
             b_i : in STD_LOGIC;
             c_o : out STD_LOGIC;
             s_o : out STD_LOGIC);
    end component;

    signal c_0_s : STD_LOGIC;
    signal c_1_s : STD_LOGIC;
    signal s_s : STD_LOGIC;

begin

    HALF_ADDER_0 : half_adder
    port map(a_i => a_i,
             b_i => b_i,
             c_o => c_0_s,
             s_o => s_s);
             
    HALF_ADDER_1 : half_adder
    port map(a_i => s_s,
             b_i => c_i,
             c_o => c_1_s,
             s_o => s_o);
             
    c_o <= c_0_s or c_1_s;

end full_adder_arch;
