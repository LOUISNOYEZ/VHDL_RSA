----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 00:56:16
-- Design Name: 
-- Module Name: adder - adder_arch
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

entity adder is
    generic(data_width : natural := 64);
    Port (a_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
          b_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
          c_i : in STD_LOGIC;
          c_o : out STD_LOGIC;
          s_o : out STD_LOGIC_VECTOR(data_width-1 downto 0) );
end adder;

architecture adder_arch of adder is

    component full_adder is
        port(a_i : in STD_LOGIC;
             b_i : in STD_LOGIC;
             c_i : in STD_LOGIC;
             c_o : out STD_LOGIC;
             s_o : out STD_LOGIC);
    end component;
    
    signal c_s : STD_LOGIC_VECTOR(data_width downto 0);
    
begin

    G0 : for I in 0 to data_width-1 generate
    
        FULL_ADDER_INST : full_adder
        port map(a_i => a_i(I),
                 b_i => b_i(I),
                 c_i => c_s(I),
                 s_o => s_o(I),
                 c_o => c_s(I+1));

    end generate;
    
    c_s(0) <= c_i;
    c_o <= c_s(data_width);
    
end adder_arch;
