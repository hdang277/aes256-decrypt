
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_main is
--  Port ( );
end tb_main;

architecture Behavioral of tb_main is
component main is 
    port(
    unencrypted   : in std_logic_vector(127 downto 0) ;
    key           : in std_logic_vector(255 downto 0) ;
    clk           : in std_logic;

    crypted       : out std_logic_vector(127 downto 0)

    
    
    
    );
    
    
end component; 
signal    unencrypted   : std_logic_vector(127 downto 0) ;
signal    key           : std_logic_vector(255 downto 0) ;
signal    clk           : std_logic;

signal    crypted       :  std_logic_vector(127 downto 0);
constant clock_period   : time := 8ns;

begin

uut: main port map( 
                unencrypted => unencrypted,
                key => key,
                clk => clk,

                crypted => crypted );

clock_Process: process
    begin
        clk <= '0';
        wait for clock_period / 2;
        clk <= '1';
        wait for clock_period / 2;
     end process;
     
     
stim_proc: process
    begin              
        
        unencrypted <= x"8ea2b7ca516745bfeafc49904b496089"; -- example 1
        --unencrypted <= x"1546467a7687b768d97979c6687f987a"; -- example  2
        --unencrypted <= x"e787897f989789c879879b78787897f2";  -- example  3
                     
    
         key         <= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";  -- example 1 
        -- key         <= x"43a564b5634e55634f6534e32324f132" ; -- example  2
        -- key         <= x"ad2387b5e4f678435813798132aed6c5" ; -- example  3
        
    wait for clock_period*30;
       wait;  

    end process;


end Behavioral;