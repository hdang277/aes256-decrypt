library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity main is 
    port(
    ciphertext   : in std_logic_vector(127 downto 0) ;--:= x"8ea2b7ca516745bfeafc49904b496089";
    key           : in std_logic_vector(255 downto 0) ;--:= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
    clk           : in std_logic;
    plaintext       : out std_logic_vector(127 downto 0) := x"00000000000000000000000000000000"                                      
    );
    
    
end entity; 

architecture arch of main is 


component shift_sub_add_mix is 
    port(
    tmp           : in std_logic_vector(127 downto 0);  -- := x"00102030405060708090a0b0c0d0e0f0";
    keyin      : in std_logic_vector(127 downto 0);
    output : out std_logic_vector(127 downto 0);

    mix_counter   : in std_logic_vector(3 downto 0)      
    );
    
    
end component; 

component key_schedule is 
    port(
    tmp_key_main   : in std_logic_vector(255 downto 0)  ;
    clk   : in  std_logic;

    keyround : out std_logic_vector(127 downto 0);
   
    rcon_ct_key : in std_logic_vector(4 downto 0)          
    );
    
    
end component; 


signal tmp :  std_logic_vector(127 downto 0);
signal output :  std_logic_vector(127 downto 0);
signal tmp_key_main :  std_logic_vector(255 downto 0);

signal keyround : std_logic_vector(127 downto 0);
signal keyin :  std_logic_vector(127 downto 0);
signal rcon_ct_key :  std_logic_vector(4 downto 0)  := "00001";
signal mix_counter :  std_logic_vector(3 downto 0)  := "0000";
signal not_mix_col :  std_logic_vector(127 downto 0) ;

signal tmpin :  std_logic_vector(127 downto 0);


type state_type is (KEY_GEN,ROUND);
signal state,current_state : state_type := ROUND;


begin
SHIFT_SUB_ADD_MIX_MODULE: shift_sub_add_mix port map(
                                             tmp => tmp,
                                             keyin => keyin,
                                             output => output,
                                             mix_counter      => mix_counter                                        
                                             );

KEY_MODULE: key_schedule port map(
                                             tmp_key_main => tmp_key_main,
                                             keyround => keyround,
                                             rcon_ct_key => rcon_ct_key,
                                             clk => clk
                                             );

    tmp_key_main <= key;    -- tmp_key_main and key are 256 bits
  
    process(clk)
    begin
      if(rising_edge(clk)) then
            case state is 
               when ROUND => 
               
                if rcon_ct_key <"00111" then
                    state <= KEY_GEN;                               
                elsif (rcon_ct_key = "00111") then
                    tmp <= ciphertext xor keyround;     -- keyround =  key14
                    keyin <= keyround;
                    state <= KEY_GEN;
                elsif(rcon_ct_key < "10110") then  -- when round < 22 // sua 09 = 01001
                    keyin <= keyround;       -- R.start
                    tmp <= tmpin;
                    state <= KEY_GEN;
                
                elsif(rcon_ct_key = "10110") then  -- round= 22 
                        plaintext <= output;
                
                end if;
                    
               when KEY_GEN =>  
                 if rcon_ct_key < "00111" then
                    rcon_ct_key <= rcon_ct_key + "0001";
                    state <= ROUND;
                 elsif (rcon_ct_key = "00111") then
                    tmpin <= tmp; -- End of round 1
                    rcon_ct_key <= rcon_ct_key + "0001";
                    state <= ROUND;   
                 elsif rcon_ct_key < "10101" then  -- stop at 01001 for test
                    tmpin <= output; -- End of round 
                    rcon_ct_key <= rcon_ct_key + "0001";
                    state <= ROUND;            
                 elsif(rcon_ct_key = "10101" ) then     --round = 21, lastround only inv.shiftrow, inv.subbyte, addroundkey => mix_counter=1110 stop at 01001 for test
                     tmpin <= output;
                     rcon_ct_key <= rcon_ct_key + "0001" ;
                     mix_counter <= "1110" ;            
                     state <= ROUND;
                 end if;
                when others =>                
                end case; 
        end if;
      end process;
end architecture;  
            
                
                




--            if (rcon_ct_key < "00111") then
--                tmp <= unencrypted;
--                keyin <= tmp_key_main(255 downto 128);
--                rcon_ct_key <= rcon_ct_key +"00001";
--            elsif rcon_ct_key = "00111" then  --7 R0 K14
--                keyin <= keyround;
--                tmp <= tmp xor keyin;
--                rcon_ct_key <= rcon_ct_key +"00001";
--            elsif rcon_ct_key = "01000" then --8 R1 K13
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "01001" then --9 R2 K12
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "01010" then --10 R3 K11
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";             
--            elsif rcon_ct_key = "01011" then --11 R4 K10
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "01100" then --12 R5 K9
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "01101" then --13 R6 K8
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "01110" then --14 R7 K7
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "01111" then --15 R8 K6
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "10000" then --16 R9 K5
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001"; 
--            elsif rcon_ct_key = "10001" then --17 R10 K4
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001"; 
--             elsif rcon_ct_key = "10010" then --18 R11 K3
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--             elsif rcon_ct_key = "10011" then --19 R12 K2
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "10100" then --20 R13 K1
--                keyin <= keyround;
--                tmp <=tmpin;
--                tmpin <= output;
--                rcon_ct_key <= rcon_ct_key + "00001";
--            elsif rcon_ct_key = "10101" then --21 R14 K0
--                mix_counter <= "1111";
--                keyin <= keyround;
--                tmp <= tmpin;
--                rcon_ct_key <= rcon_ct_key + "00001";  
--            elsif rcon_ct_key = "10110" then 
--                crypted <= output;
--             end if;
