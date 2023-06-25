library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity main is 
    port(
    unencrypted   : in std_logic_vector(127 downto 0) ;--:= x"00112233445566778899aabbccddeeff";
    key           : in std_logic_vector(255 downto 0) ;--:= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
    clk           : in std_logic;
    crypted       : out std_logic_vector(127 downto 0) := x"00000000000000000000000000000000"                                      
    );
    
    
end entity; 

architecture arch of main is 


component sub_shift_mix is 
    port(
    tmp           : in std_logic_vector(127 downto 0);  -- := x"00102030405060708090a0b0c0d0e0f0";
    keyround      : in std_logic_vector(127 downto 0);
    after_add_rounds : out std_logic_vector(127 downto 0);

    mix_counter   : in std_logic_vector(3 downto 0)      
    );
    
    
end component; 

component key_schedule is 
    port(
    tmp_key_main   : in std_logic_vector(255 downto 0)  ;
    clk   : in  std_logic;

    tmp_1 : out std_logic_vector(127 downto 0);
   
    rcon_ct_key : in std_logic_vector(3 downto 0)          
    );
    
    
end component; 


signal tmp :  std_logic_vector(127 downto 0);
signal after_add_rounds :  std_logic_vector(127 downto 0);
signal tmp_key_main :  std_logic_vector(255 downto 0);
signal keyround : std_logic_vector(127 downto 0);

signal tmp_1 :  std_logic_vector(127 downto 0);
signal rcon_ct_key :  std_logic_vector(3 downto 0)  := "0001";
signal mix_counter :  std_logic_vector(3 downto 0)  := "0001";
signal not_mix_col :  std_logic_vector(127 downto 0) ;

signal i_key :  std_logic_vector(127 downto 0);


type state_type is (KEY_GEN,ROUND);
signal state,current_state : state_type := ROUND;


begin
SUB_SHIFT_MIX_MODULE: sub_shift_mix port map(
                                             tmp => tmp,
                                             keyround => keyround,
                                             after_add_rounds => after_add_rounds,
                                             mix_counter      => mix_counter                                        
                                             );

KEY_MODULE: key_schedule port map(
                                             tmp_key_main => tmp_key_main,
                                             tmp_1 => tmp_1,
                                             rcon_ct_key => rcon_ct_key,
                                             clk => clk
                                             );

    tmp_key_main <= key;    --nap vao key_schedule key va tmp_key_main deu la 256 bit
  
    process(clk)
    begin
      if(rising_edge(clk)) then
            case state is 
               when ROUND => 
               
                if (rcon_ct_key = "0001") then
                    tmp <= unencrypted xor tmp_1;     -- R1start tmp_1 =  key14
                    state <= KEY_GEN;
                elsif(rcon_ct_key < "1111") then  -- voi cac round < 15
                    tmp <= i_key;       -- R.start
                    state <= KEY_GEN;
                
                elsif(rcon_ct_key = "1111") then  -- het round 14 qua round 15 ikey la gia tri ma hoa
                        crypted <= i_key;
                
                end if;
                    
               when KEY_GEN =>  
                  if (rcon_ct_key = "0001") then
                    rcon_ct_key <= rcon_ct_key + "0001" ; -- ct = 2
                    keyround <= tmp_1;              -- key13
                    i_key <= after_add_rounds; -- End of round 1
                    state <= ROUND;                 
                                    
                  
                  elsif(rcon_ct_key = "1101" ) then     --13
                     
                     rcon_ct_key <= rcon_ct_key + "0001" ; 
                     keyround <= tmp_1;
                     i_key <= after_add_rounds;
                     mix_counter <= "1110" ;            -- ct= 14
                     state <= ROUND;
                 
                 elsif(rcon_ct_key < "1111") then           -- <15
                     rcon_ct_key <= rcon_ct_key + "0001" ;
                     keyround <= tmp_1;
                     i_key <= after_add_rounds ;
                     
                     state <= ROUND;
                 end if;
                when others => 
                
                
                end case;
              end if;
        end process;
end architecture;