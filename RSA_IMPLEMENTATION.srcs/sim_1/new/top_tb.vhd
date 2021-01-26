----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 02:59:59
-- Design Name: 
-- Module Name: top_tb - top_tb_arch
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
use work.RSA_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
end top_tb;

architecture top_tb_arch of top_tb is


    component top is
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             start_i : in STD_LOGIC;
             data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             done_o : out STD_LOGIC);
    end component;

    type data_mem_t is array(0 to register_amount-1) of STD_LOGIC_VECTOR(message_width-1 downto 0);

    constant data_mem_c : data_mem_t := (0 => x"436563692065737420756e206d65737361676520646520746573742e20496c2065737420e9637269742064616e73206c276573706f697220646520737566666973656d656e74206c652072656d706c6972206166696e20646520706f75766f69722074657374657220636f6e76656e61626c656d656e74206d6f6e20696d706c",
                                         1 => x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005760D",
                                         2 => x"A65429827D9C32E07562E409CEE7FD800BFF56F6AC408A52B69B1B8D71057047E890DF7208850102994F63F3FAC09CFFDE2D9E0FAE6DDBBBC951A4265EAE2AE83F0C99273A6A94CCCED9D1A8E670DB0F2D16D6383D5F046D47DD746B23FE622AAB5E5C547989AC7FDC627B9ADE25DAA873436A219F5DEC43EFFC7C8DACA5373B",
                                         3 => x"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000335EB08BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA63A5DF335",
                                         9 => x"970451EF0732A35E028E4382BC4EC8294D7681505735A727208CA74E97ECBB969B13997BC7F04BB2D5CBE0E1114DDFBFA5E2A05A3970451EF0732A35E028E1744783FB8BDCB699A6C1644B06EFFBE390A88DD50148E2CB53AD6F99392075D9CD201E25DB2BEFE5F6942B82450822F1B2674A6D7514783FB8BDCB699A6C19802D",
                                         others => (others => '0'));
                                         
    signal clock_s : STD_LOGIC:='1';
    signal reset_s : STD_LOGIC:='1';
    signal start_s : STD_LOGIC:='0';
    signal data_input_s : STD_LOGIC_VECTOR(data_width-1 downto 0) := (others => '0');
    signal done_s : STD_LOGIC;

begin

    DUT : top
    port map(clock_i => clock_s,
             reset_i => reset_s,
             start_i => start_s,
             data_i => data_input_s,
             done_o => done_s);
             
    P0 : process
    begin
        wait for 5 ns;
        reset_s <= '0';
        wait for 10 ns;
        reset_s <= '1';
        wait for 10 ns;
        start_s <= '1';
        wait for 10 ns;
        for I in 0 to data_amount-1 loop
            if I = 9 then
                for J in 0 to data_offset-1 loop
                    for K in 0 to data_width-1 loop
                        data_input_s(K) <= data_mem_c(I)((data_offset-J)*data_width-1 downto (data_offset-(J+1))*data_width)(data_width-1-K+(data_offset-(J+1))*data_width);
                    end loop;
                    wait for 10 ns;
                end loop;
            else
                for J in 0 to data_offset-1 loop
                    data_input_s <= data_mem_c(I)((J+1)*data_width-1 downto J*data_width);
                    wait for 10 ns;
                end loop;
            end if;
        end loop;
        data_input_s <= (others => '0');
        wait for 1000000000 ns;
        wait for 1000000000 ns;
        wait for 1000000000 ns;
        wait for 1000000000 ns;
    end process;
    
    clock_s <= not(clock_s) after 5 ns;

end top_tb_arch;
