----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2021 02:29:37
-- Design Name: 
-- Module Name: top - top_arch
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

entity top is
    Port (clock_i : in STD_LOGIC;
          reset_i : in STD_LOGIC;
          start_i : in STD_LOGIC;
          data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
          done_o : out STD_LOGIC );
end top;

architecture top_arch of top is

    component reg_comp is
        generic(data_width : natural := 64);
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             en_i : in STD_LOGIC;
             data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
    end component;
    
    component bit_reg_comp is
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             set_i : in STD_LOGIC;
             en_i : in STD_LOGIC;
             data_i : in STD_LOGIC;
             data_o : out STD_LOGIC);
    end component;
    
    component reg_bank is
        generic(data_width : natural := 64;
                addr_width : natural := 7;
                register_amount : natural := 8);
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             en_i : in STD_LOGIC;
             write_address_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
             read_address_0_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
             read_address_1_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
             data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_0_o : out STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_1_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
    end component;
    
    component reg_bank_3_out is
        generic(data_width : natural := 64;
                addr_width : natural := 7;
                register_amount : natural := 8);
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             en_i : in STD_LOGIC;
             write_address_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
             read_address_0_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
             read_address_1_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
             read_address_2_i : in STD_LOGIC_VECTOR(addr_width-1 downto 0);
             data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_0_o : out STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_1_o : out STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_2_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
    end component;

    component counter is
        generic(counter_data_width : natural := 7);
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             set_i : in STD_LOGIC;
             en_i : in STD_LOGIC;
             data_i : in STD_LOGIC_VECTOR(counter_data_width-1 downto 0);
             data_o : out STD_LOGIC_VECTOR(counter_data_width-1 downto 0));
    end component;
    
    component adder is
        generic(data_width : natural := 64);
        port(a_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             b_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             c_i : in STD_LOGIC;
             c_o : out STD_LOGIC;
             s_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
    end component;
    
    component shiftleft is
        generic(data_width : natural := 64;
                shift_amount_width : natural := 7);
        port(data_i : in STD_LOGIC_VECTOR(data_width-1 downto 0);
             shift_amount_i : in STD_LOGIC_VECTOR(shift_amount_width-1 downto 0);
             data_low_o : out STD_LOGIC_VECTOR(data_width-1 downto 0);
             data_high_o : out STD_LOGIC_VECTOR(data_width-1 downto 0));
    end component;
    
    component FSM is
        port(clock_i : in STD_LOGIC;
             reset_i : in STD_LOGIC;
             start_i : in STD_LOGIC;
             count_i : in STD_LOGIC_VECTOR(counter_data_width-1 downto 0);
             carry_i : in STD_LOGIC;
             carry_instant_i : in STD_LOGIC;
             order_reg_data_output_i : in STD_LOGIC_VECTOR(2 downto 0);
             op_a_cursor_i : in STD_LOGIC;
             data_mem_reset_o : out STD_LOGIC;
             data_mem_en_o : out STD_LOGIC;
             counter_mem_reset_o : out STD_LOGIC;
             counter_mem_en_o : out STD_LOGIC;
             counter_mem_write_address_o : out STD_LOGIC_VECTOR(counter_addr_width-1 downto 0);
             counter_mem_read_address_0_o : out STD_LOGIC_VECTOR(counter_addr_width-1 downto 0);
             counter_mem_read_address_1_o : out STD_LOGIC_VECTOR(counter_addr_width-1 downto 0);
             address_mem_reset_o : out STD_LOGIC;
             address_mem_en_o : out STD_LOGIC;
             address_mem_write_address_o : out STD_LOGIC_VECTOR(address_addr_width-1 downto 0);
             address_mem_read_address_0_o : out STD_LOGIC_VECTOR(address_addr_width-1 downto 0);
             address_mem_read_address_1_o : out STD_LOGIC_VECTOR(address_addr_width-1 downto 0);
             address_mem_read_address_2_o : out STD_LOGIC_VECTOR(address_addr_width-1 downto 0); 
             address_mem_data_input_o : out STD_LOGIC_VECTOR(addr_width-1 downto 0); 
             accu_0_reset_o : out STD_LOGIC;
             accu_0_en_o : out STD_LOGIC;
             accu_1_reset_o : out STD_LOGIC;
             accu_1_en_o : out STD_LOGIC;
             order_reg_reset_o : out STD_LOGIC;
             order_reg_en_o : out STD_LOGIC;
             order_reg_data_input_o : out STD_LOGIC_VECTOR(2 downto 0);
             carry_reg_reset_o : out STD_LOGIC;
             carry_reg_set_o : out STD_LOGIC;
             carry_reg_en_o : out STD_LOGIC;
             counter_inst_reset_o : out STD_LOGIC;
             counter_inst_set_o : out STD_LOGIC;
             counter_inst_en_o : out STD_LOGIC;
             control_o : out STD_LOGIC_VECTOR(2 downto 0);
             sel_accu_o : out STD_LOGIC;
             done_o : out STD_LOGIC);
    end component; 

    -- DATA_MEM signals
    signal data_mem_reset_s : STD_LOGIC;
    signal data_mem_en_s : STD_LOGIC;
    signal data_mem_write_address_s : STD_LOGIC_VECTOR(addr_width-1 downto 0);
    signal data_mem_read_address_0_s : STD_LOGIC_VECTOR(addr_width-1 downto 0);
    signal data_mem_read_address_1_s : STD_LOGIC_VECTOR(addr_width-1 downto 0);
    signal data_mem_data_input_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    signal data_mem_data_output_0_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    signal data_mem_data_output_1_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    
    -- COUNTER_MEM signals
    signal counter_mem_reset_s : STD_LOGIC;
    signal counter_mem_en_s : STD_LOGIC;
    signal counter_mem_write_address_s : STD_LOGIC_VECTOR(counter_addr_width-1 downto 0);
    signal counter_mem_read_address_0_s : STD_LOGIC_VECTOR(counter_addr_width-1 downto 0);
    signal counter_mem_read_address_1_s : STD_LOGIC_VECTOR(counter_addr_width-1 downto 0);
    signal counter_mem_data_output_0_s : STD_LOGIC_VECTOR(counter_data_width-1 downto 0);
    signal counter_mem_data_output_1_s : STD_LOGIC_VECTOR(counter_data_width-1 downto 0);
    
    -- ADDRESS_MEM signals
    signal address_mem_reset_s : STD_LOGIC;
    signal address_mem_en_s : STD_LOGIC;
    signal address_mem_write_address_s : STD_LOGIC_VECTOR(address_addr_width-1 downto 0);
    signal address_mem_read_address_0_s : STD_LOGIC_VECTOR(address_addr_width-1 downto 0);
    signal address_mem_read_address_1_s : STD_LOGIC_VECTOR(address_addr_width-1 downto 0);
    signal address_mem_read_address_2_s : STD_LOGIC_VECTOR(address_addr_width-1 downto 0);
    signal address_mem_data_input_s : STD_LOGIC_VECTOR(address_data_width-1 downto 0);
    signal address_mem_data_output_0_s : STD_LOGIC_VECTOR(address_data_width-1 downto 0);
    signal address_mem_data_output_1_s : STD_LOGIC_VECTOR(address_data_width-1 downto 0);
    signal address_mem_data_output_2_s : STD_LOGIC_VECTOR(address_data_width-1 downto 0);
    
    -- ACCU_0 signals
    signal accu_0_reset_s : STD_LOGIC;
    signal accu_0_en_s : STD_LOGIC;
    signal accu_0_data_output_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    
    -- ACCU_1 signals
    signal accu_1_reset_s : STD_LOGIC;
    signal accu_1_en_s : STD_LOGIC;
    signal accu_1_data_output_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    
    -- CARRY_REG signals
    signal carry_reg_reset_s : STD_LOGIC;
    signal carry_reg_set_s : STD_LOGIC;
    signal carry_reg_en_s : STD_LOGIC;
    signal carry_reg_data_input_s : STD_LOGIC;
    signal carry_reg_data_output_s : STD_LOGIC;
    
    -- ORDER_REG signals
    signal order_reg_reset_s : STD_LOGIC;
    signal order_reg_en_s : STD_LOGIC;
    signal order_reg_data_input_s : STD_LOGIC_VECTOR(2 downto 0);
    signal order_reg_data_output_s : STD_LOGIC_VECTOR(2 downto 0);
    
    -- ADDER_INST signals
    signal adder_inst_data_input_0_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    signal adder_inst_data_input_1_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    signal adder_inst_data_output_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    
    -- SIFTLEFT_INST signals
    signal shiftleft_inst_data_input_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    signal shiftleft_inst_shift_amount_s : STD_LOGIC_VECTOR(shift_amount_width-1 downto 0);
    signal shiftleft_inst_data_low_output_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    signal shiftleft_inst_data_high_output_s : STD_LOGIC_VECTOR(data_width-1 downto 0);
    
    -- COUNTER_INST signals
    signal counter_inst_reset_s : STD_LOGIC;
    signal counter_inst_set_s : STD_LOGIC;
    signal counter_inst_en_s : STD_LOGIC;
    signal counter_inst_data_input_s : STD_LOGIC_VECTOR(counter_data_width-1 downto 0);
    signal counter_inst_data_output_s : STD_LOGIC_VECTOR(counter_data_width-1 downto 0);

    -- FSM_INST signals
    signal FSM_accu_0_en_s : STD_LOGIC;
    signal FSM_accu_1_en_s : STD_LOGIC;
    
    -- DATA FLOW CONTROL signals
    signal control_s : STD_LOGIC_VECTOR(2 downto 0);
    signal sel_accu_s : STD_LOGIC;
    signal op_a_cursor_s : STD_LOGIC;
    signal carry_instant_s : STD_LOGIC;

begin

    DATA_MEM : reg_bank
    generic map(data_width => data_width,
                addr_width => addr_width,
                register_amount => register_amount)
    port map(clock_i => clock_i,
             reset_i => data_mem_reset_s,
             en_i => data_mem_en_s,
             write_address_i => data_mem_write_address_s,
             read_address_0_i => data_mem_read_address_0_s,
             read_address_1_i => data_mem_read_address_1_s,
             data_i => data_mem_data_input_s,
             data_0_o => data_mem_data_output_0_s,
             data_1_o => data_mem_data_output_1_s);
             
    COUNTER_MEM : reg_bank
    generic map(data_width => counter_data_width,
                addr_width => counter_addr_width,
                register_amount => counter_register_amount)
    port map(clock_i => clock_i,
             reset_i => counter_mem_reset_s,
             en_i => counter_mem_en_s,
             write_address_i => counter_mem_write_address_s,
             read_address_0_i => counter_mem_read_address_0_s,
             read_address_1_i => counter_mem_read_address_1_s,
             data_i => counter_inst_data_output_s,
             data_0_o => counter_mem_data_output_0_s,
             data_1_o => counter_mem_data_output_1_s);
             
    ADDRESS_MEM : reg_bank_3_out
    generic map(data_width => address_data_width,
                addr_width => address_addr_width,
                register_amount => address_register_amount)
    port map(clock_i => clock_i,
             reset_i => address_mem_reset_s,
             en_i => address_mem_en_s,
             write_address_i => address_mem_write_address_s,
             read_address_0_i => address_mem_read_address_0_s,
             read_address_1_i => address_mem_read_address_1_s,
             read_address_2_i => address_mem_read_address_2_s,
             data_i => address_mem_data_input_s,
             data_0_o => address_mem_data_output_0_s,
             data_1_o => address_mem_data_output_1_s,
             data_2_o => address_mem_data_output_2_s);
             

    accu_0 : reg_comp
    generic map(data_width => data_width)
    port map(clock_i => clock_i,
             reset_i => accu_0_reset_s,
             en_i => accu_0_en_s,
             data_i => adder_inst_data_output_s,
             data_o => accu_0_data_output_s);
             
    accu_1 : reg_comp
    generic map(data_width => data_width)
    port map(clock_i => clock_i,
             reset_i => accu_1_reset_s,
             en_i => accu_1_en_s,
             data_i => adder_inst_data_output_s,
             data_o => accu_1_data_output_s);
             
    ORDER_REG : reg_comp
    generic map(data_width => 3)
    port map(clock_i => clock_i,
             reset_i => order_reg_reset_s,
             en_i => order_reg_en_s,
             data_i => order_reg_data_input_s,
             data_o => order_reg_data_output_s);
                          
    CARRY_REG : bit_reg_comp
    port map(clock_i => clock_i,
             reset_i => carry_reg_reset_s,
             set_i => carry_reg_set_s,
             en_i => carry_reg_en_s,
             data_i => carry_reg_data_input_s,
             data_o => carry_reg_data_output_s);
             

             
    COUNTER_INST : counter
    generic map(counter_data_width => counter_data_width)
    port map(clock_i => clock_i,
             reset_i => counter_inst_reset_s,
             set_i => counter_inst_set_s,
             en_i => counter_inst_en_s,
             data_i => counter_mem_data_output_0_s,
             data_o => counter_inst_data_output_s);

    ADDER_INST : adder
    generic map(data_width => data_width)
    port map(a_i => adder_inst_data_input_0_s,
             b_i => adder_inst_data_input_1_s,
             c_i => carry_reg_data_output_s,
             c_o => carry_reg_data_input_s,
             s_o => adder_inst_data_output_s);

    SHIFTLEFT_INST : shiftleft
    generic map(data_width => data_width,
                shift_amount_width => shift_amount_width)
    port map(data_i => shiftleft_inst_data_input_s,
             shift_amount_i => shiftleft_inst_shift_amount_s,
             data_low_o => shiftleft_inst_data_low_output_s,
             data_high_o => shiftleft_inst_data_high_output_s);
                

    FSM_INST : FSM
    port map(clock_i => clock_i,
             reset_i => reset_i,
             start_i => start_i,
             count_i => counter_inst_data_output_s,
             carry_i => carry_reg_data_output_s,
             carry_instant_i => carry_instant_s,
             order_reg_data_output_i => order_reg_data_output_s,
             op_a_cursor_i => op_a_cursor_s,
             data_mem_reset_o => data_mem_reset_s,
             data_mem_en_o => data_mem_en_s,
             counter_mem_reset_o => counter_mem_reset_s,
             counter_mem_en_o => counter_mem_en_s,
             counter_mem_write_address_o => counter_mem_write_address_s,
             counter_mem_read_address_0_o => counter_mem_read_address_0_s,
             counter_mem_read_address_1_o => counter_mem_read_address_1_s,
             address_mem_reset_o => address_mem_reset_s,
             address_mem_en_o => address_mem_en_s,
             address_mem_write_address_o => address_mem_write_address_s,
             address_mem_read_address_0_o => address_mem_read_address_0_s,
             address_mem_read_address_1_o => address_mem_read_address_1_s,
             address_mem_read_address_2_o => address_mem_read_address_2_s,
             address_mem_data_input_o => address_mem_data_input_s,
             accu_0_reset_o => accu_0_reset_s,
             accu_0_en_o => FSM_accu_0_en_s,
             accu_1_reset_o => accu_1_reset_s,
             accu_1_en_o => FSM_accu_1_en_s,
             order_reg_reset_o => order_reg_reset_s,
             order_reg_en_o => order_reg_en_s,
             order_reg_data_input_o => order_reg_data_input_s,
             carry_reg_reset_o => carry_reg_reset_s,
             carry_reg_set_o => carry_reg_set_s,
             carry_reg_en_o => carry_reg_en_s,
             counter_inst_reset_o => counter_inst_reset_s,
             counter_inst_set_o => counter_inst_set_s,
             counter_inst_en_o => counter_inst_en_s,
             control_o => control_s,
             sel_accu_o => sel_accu_s,
             done_o => done_o);
             
    -- DATA FLOW CONTROL
    
    -- DATA_MEM inputs
    
    with control_s select data_mem_data_input_s <= 
        data_i when LOAD_MODE,
        adder_inst_data_output_s when MUL_STORE_MODE,
        adder_inst_data_output_s when ADD_MODE,
        adder_inst_data_output_s when SUB_MODE,
        adder_inst_data_output_s when COPY_MODE,
        (others => '0') when others;
        
    with control_s select data_mem_write_address_s <=
        address_mem_data_output_2_s xor counter_inst_data_output_s(addr_width-1 downto 0) when LOAD_MODE,
        address_mem_data_output_2_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when MUL_STORE_MODE,
        address_mem_data_output_2_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when COPY_MODE,
        address_mem_data_output_2_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when ADD_MODE,
        address_mem_data_output_2_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when SUB_MODE,
        (others => '0') when others;
        
    with control_s select data_mem_read_address_0_s <=
        address_mem_data_output_0_s xor counter_mem_data_output_0_s(addr_width-1 downto 0) when MUL_ACCU_MODE,
        address_mem_data_output_2_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when MUL_STORE_MODE,
        address_mem_data_output_0_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when COPY_MODE,
        address_mem_data_output_0_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0)when ADD_MODE,
        address_mem_data_output_0_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0)when SUB_MODE,
        address_mem_data_output_0_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-(message_width_size-data_width_size))) & counter_inst_data_output_s(message_width_size-1 downto data_width_size) when CHECK_MODE,
        (others => '0') when others;
        
    with control_s select data_mem_read_address_1_s <=
        address_mem_data_output_1_s xor counter_mem_data_output_1_s(addr_width-1 downto 0) when MUL_ACCU_MODE,
        address_mem_data_output_1_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when ADD_MODE,
        address_mem_data_output_1_s xor STD_LOGIC_VECTOR(To_Unsigned(0,addr_width-data_offset_size-1)) & counter_inst_data_output_s(data_offset_size downto 0) when SUB_MODE,
        (others => '0') when others;
    
            
    -- ADDER_INST inputs
    
    adder_inst_data_input_0_s <= shiftleft_inst_data_low_output_s when control_s = MUL_ACCU_MODE and sel_accu_s = '0' else
                                 shiftleft_inst_data_high_output_s when control_s = MUL_ACCU_MODE and sel_accu_s = '1' else
                                 data_mem_data_output_0_s;
                            
    adder_inst_data_input_1_s <= accu_0_data_output_s when (((control_s = MUL_ACCU_MODE) or (control_s = MUL_STORE_MODE)) and sel_accu_s = '0') else
                                 accu_1_data_output_s when (((control_s = MUL_ACCU_MODE) or (control_s = MUL_STORE_MODE)) and sel_accu_s = '1') else
                                 (others => '0') when control_s = COPY_MODE else
                                 not(data_mem_data_output_1_s) when control_s = SUB_MODE else
                                 data_mem_data_output_1_s;
    
    -- SHIFTLEFT_INST inputs
    
    shiftleft_inst_data_input_s <= data_mem_data_output_1_s when control_s = MUL_ACCU_MODE else
                                   (others => '0');
                                   
    shiftleft_inst_shift_amount_s <= counter_inst_data_output_s(shift_amount_width-1 downto 0) when control_s = MUL_ACCU_MODE else
                                     (others => '0');
                                     
    -- ACCU_0 inputs
    
    accu_0_en_s <= data_mem_data_output_0_s(To_Integer(Unsigned(counter_inst_data_output_s(data_width_size-1 downto 0)))) when control_s = MUL_ACCU_MODE and sel_accu_s = '0' else
                  '0' when control_s = MUL_ACCU_MODE and sel_accu_s = '1' else
                  FSM_accu_0_en_s;
                  
    -- ACCU_1 inputs
                  
    accu_1_en_s <= data_mem_data_output_0_s(To_Integer(Unsigned(counter_inst_data_output_s(data_width_size-1 downto 0)))) when control_s = MUL_ACCU_MODE and sel_accu_s = '1' else
                   '0' when control_s = MUL_ACCU_MODE and sel_accu_s = '0' else
                   FSM_accu_1_en_s;
                   
    -- OTHER
    
    op_a_cursor_s <= data_mem_data_output_0_s(To_Integer(Unsigned(counter_inst_data_output_s(data_width_size-1 downto 0)))) when control_s = CHECK_MODE else
                     '0';
    
    carry_instant_s <= carry_reg_data_input_s;
    
end top_arch;
