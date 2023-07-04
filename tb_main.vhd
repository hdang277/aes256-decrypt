
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_main is
--  Port ( );
end tb_main;

architecture Behavioral of tb_main is
component main is 
    port(
    ciphertext   : in std_logic_vector(127 downto 0) ;
    key           : in std_logic_vector(255 downto 0) ;
    clk           : in std_logic;

    plaintext       : out std_logic_vector(127 downto 0)

    
    
    
    );
    
    
end component; 
signal    ciphertext   : std_logic_vector(127 downto 0) ;
signal    key           : std_logic_vector(255 downto 0) ;
signal    clk           : std_logic;

signal    plaintext       :  std_logic_vector(127 downto 0);
constant clock_period   : time := 8ns;

begin

uut: main port map( 
                ciphertext => ciphertext,
                key => key,
                clk => clk,

                plaintext => plaintext );

clock_Process: process
    begin
        clk <= '0';
        wait for clock_period / 2;
        clk <= '1';
        wait for clock_period / 2;
     end process;
     
     
stim_proc: process
    begin              
        
        --unencrypted <= x"8ea2b7ca516745bfeafc49904b496089"; -- example 1
        ciphertext <= x"f66f84a7e68b339ae78d5e61c9495c8a"; -- example  2
        
                     
    
         key         <= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";  -- example 1 
        -- key         <= x"43a564b5634e55634f6534e32324f132" ; -- example  2
        
        
    wait for clock_period*30;
       wait;  

    end process;


end Behavioral;
