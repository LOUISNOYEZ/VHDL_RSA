----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 01:07:53
-- Design Name: 
-- Module Name: reg_bank - reg_bank_arch
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

entity reg_bank is
    generic(data_width : natural := 64;
            addr_width : natural := 7;
            register_amount : natural := 8);
    Port (clock_i : in STD_LOGIC;
          reset_i : in STD_LOGIC;
          en_i : in STD_LOGIC;
          write_address_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
          read_address_0_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
          read_address_1_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
          data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
          data_0_o : out STD_LOGIC_VECTOR(data_width-1 downto 0);
          data_1_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
end reg_bank;

architecture reg_bank_arch of reg_bank is

    component reg_comp is
        generic(data_width : natural := 64);
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             en_i : in STD_LOGIC;
             data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
    end component;
    
    type type_t is array(0 to register_amount-1) of STD_LOGIC_VECTOR(data_width-1 downto 0);
    
    signal data_output_s : type_t;
    signal en_s : STD_LOGIC_VECTOR(register_amount-1 downto 0);

begin

    G0 : for I in 0 to register_amount-1 generate
    
        REG_INST : reg_comp
        generic map(data_width => data_width)
        port map(clock_i => clock_i,
                 reset_i => reset_i,
                 en_i => en_s(I),
                 data_i => data_i,
                 data_o => data_output_s(I));
                 
    end generate;
    
    P0 : process(en_i, write_address_i)
    begin
        en_s <= (others => '0');
        en_s(To_Integer(Unsigned(write_address_i))) <= en_i;
    end process;
    
    data_0_o <= data_output_s(To_Integer(Unsigned(read_address_0_i)));
    data_1_o <= data_output_s(To_Integer(Unsigned(read_address_1_i)));
    
end reg_bank_arch;
