----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.01.2021 23:27:03
-- Design Name: 
-- Module Name: RSA_package - Behavioral
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
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package RSA_package is

    -- user defined parameters

    constant message_width : natural := 1024; -- taille d'une unité de donnée (multiple de deux)
    constant data_width : natural := 64; -- taille des blocs (multiple de deux)
    constant data_width_size : natural := natural(ceil(log2(real(data_width))));
    constant message_width_size : natural := natural(ceil(log2(real(message_width))));
    ------------------------ DO NOT MODIFY AFTER THIS POINT ------------------------
    
    -- data_memory parameters
    
    constant data_offset : natural := message_width/data_width; -- nombre de registres occuppé par chaque unité de donnée
    constant data_offset_size : natural := natural(ceil(log2(real(data_offset))));
    constant data_amount : natural := 12; -- nombre d'unités de donnée à stocker en mémoire
    constant register_amount : natural := data_amount*data_offset; -- nombre de registes requis au stockage de la donnée
    constant addr_width : natural := natural(ceil(log2(real(register_amount)))); -- nombre de bits nécessaire à l'addressage mémoire de la donnée
    
    -- counter memory parameters
    
    constant counter_data_width : natural := message_width_size; -- taille du compteur
    constant counter_register_amount : natural := 4;
    constant counter_addr_width : natural := natural(ceil(log2(real(counter_register_amount)))); -- nombre de bits nécessaire à l'addressage mémoire du contexte d'éxecution (compteur)
    
    -- operand memory parameters
    
    constant address_data_width : natural := addr_width;
    constant address_register_amount : natural := 7;
    constant address_addr_width : natural := natural(ceil(log2(real(address_register_amount))));
    
    -- shiftleft parameters
    
    constant shift_amount_width : natural := natural(ceil(log2(real(data_width)))); -- taille du signal shift_amount (directement lié au compteur, il indique la quantité de shift à fournir)
    
    -- DATA FLOW CONTROL MODES
    
    constant LOAD_MODE : STD_LOGIC_VECTOR(2 downto 0) := "000";
    constant STORE_MODE : STD_LOGIC_VECTOR(2 downto 0) := "001";
    constant MUL_ACCU_MODE : STD_LOGIC_VECTOR(2 downto 0) := "010";
    constant MUL_STORE_MODE : STD_LOGIC_VECTOR(2 downto 0) := "011";
    constant ADD_MODE : STD_LOGIC_VECTOR(2 downto 0) := "100";
    constant SUB_MODE : STD_LOGIC_VECTOR(2 downto 0) := "101";
    constant COPY_MODE : STD_LOGIC_VECTOR(2 downto 0) := "110";
    constant CHECK_MODE : STD_LOGIC_VECTOR(2 downto 0) := "111";
    
    -- data memory address table
    
    constant MESSAGE_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(0*data_offset,addr_width)); -- registres du message à chiffrer
    constant N_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(1*data_offset,addr_width)); -- registres de la donnée publique N (RSA)
    constant V_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(2*data_offset,addr_width)); -- registres de constante utilisée dans l'algorithme de Montgomery (NV=-1[R])
    constant R_2_MOD_N_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(3*data_offset,addr_width)); -- registres de constante utilisé pour obtenir la forme de Montgomery des opérandes
    constant A_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(4*data_offset,addr_width)); -- registres contenant la forme de Montgomery du message
    constant X_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(5*data_offset,addr_width)); -- registres contenant les résultats successifs des multiplication de Montgomery
    constant S_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(6*data_offset,addr_width)); -- registres contenant le produit classiques des opérandes
    constant T_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(8*data_offset,addr_width)); -- registres contenant le produit S*V
    constant E_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(9*data_offset,addr_width)); -- registres de la clé publique e (RSA)
    constant M_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(10*data_offset,addr_width)); -- registre utilisé pour accumuler la donnée des opérations arithmétiques grands nombres
    constant U_ADDRESS : STD_LOGIC_VECTOR(addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(11*data_offset,addr_width)); -- registre contentant U=(S+TN)/R (l'opération /R est opérée directement par le positionnement du registre dans la seconde moitié du registre de travail
    
    
    --  counter memory address table
    
    constant MUL_OP_A_COUNTER_ADDRESS : STD_LOGIC_VECTOR(counter_addr_width-1 downto 0) := (others => '0'); -- registre compteur stockant l'indice du registre courant de l'opérande A (multiplication classique)
    constant MUL_OP_B_COUNTER_ADDRESS : STD_LOGIC_VECTOR(counter_addr_width-1 downto 0) := (0 => '1', others => '0'); -- registre compteur stockant l'indice du registre courant de l'opérande B (multiplication classique)
    constant MUL_RESULT_COUNTER_ADDRESS : STD_LOGIC_VECTOR(counter_addr_width-1 downto 0) := (1 => '1', others => '0');-- registre compteur stockant l'indice du registre courant d'enrigstrement des résultats (multiplication classique)
    constant EXP_COUNTER_ADDRESS : STD_LOGIC_VECTOR(counter_addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(3, counter_addr_width));
    -- address_mem address table
    
    constant MGT_OP_A_ADDRESS_ADDR : STD_LOGIC_VECTOR(address_addr_width-1 downto 0) := (others => '0');
    constant MGT_OP_B_ADDRESS_ADDR : STD_LOGIC_VECTOR(address_addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(1, address_addr_width));
    constant MGT_RESULT_ADDRESS_ADDR : STD_LOGIC_VECTOR(address_addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(2, address_addr_width));
    constant TEMP_OP_A_ADDRESS_ADDR : STD_LOGIC_VECTOR(address_addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(3, address_addr_width));
    constant TEMP_OP_B_ADDRESS_ADDR : STD_LOGIC_VECTOR(address_addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(4, address_addr_width));
    constant TEMP_RESULT_ADDRESS_ADDR : STD_LOGIC_VECTOR(address_addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(5, address_addr_width));
    constant DIRECT_ADDRESS_ADDR : STD_LOGIC_VECTOR(address_addr_width-1 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(6, address_addr_width));
    
    -- ORDER CONSTANTS - Sequencing of operations -
    constant FIRST : STD_LOGIC_VECTOR(2 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(0,3));
    constant ANY_0 : STD_LOGIC_VECTOR(2 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(1,3));
    constant ANY_1 : STD_LOGIC_VECTOR(2 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(2,3));
    constant FINAL_0 : STD_LOGIC_VECTOR(2 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(3,3));
    constant FINAL_1 : STD_LOGIC_VECTOR(2 downto 0) := STD_LOGIC_VECTOR(To_Unsigned(4,3));
        
end RSA_package;