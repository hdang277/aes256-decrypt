library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity shift_sub_add_mix is 
    port(
    tmp           : in std_logic_vector(127 downto 0) ;
    keyin     : in std_logic_vector(127 downto 0);
    mix_counter   : in std_logic_vector(3 downto 0)  ;
	output : out std_logic_vector(127 downto 0)

    );
    
    
end entity; 


architecture arch of shift_sub_add_mix is

signal tmp_1 : std_logic_vector(127 downto 0);
signal tmp_2 : std_logic_vector(127 downto 0);

 signal   A0xDI     :  std_logic_vector(7 downto 0);
 signal   A1xDI     :  std_logic_vector(7 downto 0);
 signal   A2xDI     :  std_logic_vector(7 downto 0);
 signal   A3xDI     :  std_logic_vector(7 downto 0);
 
 signal   Q0xDI     :  std_logic_vector(7 downto 0);
 signal   Q1xDI     :  std_logic_vector(7 downto 0);
 signal   Q2xDI     :  std_logic_vector(7 downto 0);
 signal   Q3xDI     :  std_logic_vector(7 downto 0);
 
 signal   W0xDI     :  std_logic_vector(7 downto 0);
 signal   W1xDI     :  std_logic_vector(7 downto 0);
 signal   W2xDI     :  std_logic_vector(7 downto 0);
 signal   W3xDI     :  std_logic_vector(7 downto 0);
 
 signal   E0xDI     :  std_logic_vector(7 downto 0);
 signal   E1xDI     :  std_logic_vector(7 downto 0);
 signal   E2xDI     :  std_logic_vector(7 downto 0);
 signal   E3xDI     :  std_logic_vector(7 downto 0);

 -----------------------------------------
 -----------------------------------------
 -----------------------------------------

 signal B0xDO     :  std_logic_vector(7 downto 0);  
 signal B1xDO     :  std_logic_vector(7 downto 0);  
 signal B2xDO     :  std_logic_vector(7 downto 0);  
 signal B3xDO     :  std_logic_vector(7 downto 0);  
 
 signal Q0xDO     :  std_logic_vector(7 downto 0);  
 signal Q1xDO     :  std_logic_vector(7 downto 0);  
 signal Q2xDO     :  std_logic_vector(7 downto 0);  
 signal Q3xDO     :  std_logic_vector(7 downto 0);  
 
 signal W0xDO     :  std_logic_vector(7 downto 0);  
 signal W1xDO     :  std_logic_vector(7 downto 0);  
 signal W2xDO     :  std_logic_vector(7 downto 0);  
 signal W3xDO     :  std_logic_vector(7 downto 0);  
 
 signal E0xDO     :  std_logic_vector(7 downto 0);  
 signal E1xDO     :  std_logic_vector(7 downto 0);  
 signal E2xDO     :  std_logic_vector(7 downto 0);  
 signal E3xDO     :  std_logic_vector(7 downto 0);  
 




TYPE sBoxArray IS ARRAY (NATURAL RANGE 0 TO 255) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT sBox : sBoxArray := (
        x"52", x"09", x"6a", x"d5", x"30", x"36", x"a5", x"38", x"bf", x"40", x"a3", x"9e", x"81", x"f3", x"d7", x"fb",
        x"7c", x"e3", x"39", x"82", x"9b", x"2f", x"ff", x"87", x"34", x"8e", x"43", x"44", x"c4", x"de", x"e9", x"cb",
        x"54", x"7b", x"94", x"32", x"a6", x"c2", x"23", x"3d", x"ee", x"4c", x"95", x"0b", x"42", x"fa", x"c3", x"4e",
        x"08", x"2e", x"a1", x"66", x"28", x"d9", x"24", x"b2", x"76", x"5b", x"a2", x"49", x"6d", x"8b", x"d1", x"25",
        x"72", x"f8", x"f6", x"64", x"86", x"68", x"98", x"16", x"d4", x"a4", x"5c", x"cc", x"5d", x"65", x"b6", x"92",
        x"6c", x"70", x"48", x"50", x"fd", x"ed", x"b9", x"da", x"5e", x"15", x"46", x"57", x"a7", x"8d", x"9d", x"84",
        x"90", x"d8", x"ab", x"00", x"8c", x"bc", x"d3", x"0a", x"f7", x"e4", x"58", x"05", x"b8", x"b3", x"45", x"06",
        x"d0", x"2c", x"1e", x"8f", x"ca", x"3f", x"0f", x"02", x"c1", x"af", x"bd", x"03", x"01", x"13", x"8a", x"6b",
        x"3a", x"91", x"11", x"41", x"4f", x"67", x"dc", x"ea", x"97", x"f2", x"cf", x"ce", x"f0", x"b4", x"e6", x"73",
        x"96", x"ac", x"74", x"22", x"e7", x"ad", x"35", x"85", x"e2", x"f9", x"37", x"e8", x"1c", x"75", x"df", x"6e",
        x"47", x"f1", x"1a", x"71", x"1d", x"29", x"c5", x"89", x"6f", x"b7", x"62", x"0e", x"aa", x"18", x"be", x"1b",
        x"fc", x"56", x"3e", x"4b", x"c6", x"d2", x"79", x"20", x"9a", x"db", x"c0", x"fe", x"78", x"cd", x"5a", x"f4",
        x"1f", x"dd", x"a8", x"33", x"88", x"07", x"c7", x"31", x"b1", x"12", x"10", x"59", x"27", x"80", x"ec", x"5f",
        x"60", x"51", x"7f", x"a9", x"19", x"b5", x"4a", x"0d", x"2d", x"e5", x"7a", x"9f", x"93", x"c9", x"9c", x"ef",
        x"a0", x"e0", x"3b", x"4d", x"ae", x"2a", x"f5", x"b0", x"c8", x"eb", x"bb", x"3c", x"83", x"53", x"99", x"61",
        x"17", x"2b", x"04", x"7e", x"ba", x"77", x"d6", x"26", x"e1", x"69", x"14", x"63", x"55", x"21", x"0c", x"7d"
    );
    

signal tmp_sub_bytes : std_logic_vector(127 downto 0) := (others => 'Z') ;


		  
begin	 

         --ShiftRows
         tmp_1(39 downto 32)         <= tmp (7 downto 0);    -- SHIFT ROWS --
	     tmp_1(79 downto 72)          <= tmp (15 downto 8);
	     tmp_1(119 downto 112)          <= tmp (23 downto 16);
	     tmp_1(31 downto 24)          <= tmp (31 downto 24);
	     tmp_1(71 downto 64)            <= tmp (39 downto 32);
	     tmp_1(111 downto 104)        <= tmp (47 downto 40);
	     tmp_1(23 downto 16)          <= tmp (55 downto 48);
	     tmp_1(63 downto 56)          <= tmp (63 downto 56);
	     tmp_1(103 downto 96)          <= tmp (71 downto 64);
	     tmp_1(15 downto 8)           <= tmp (79 downto 72);
	     tmp_1(55 downto 48)        <= tmp (87 downto 80);
	     tmp_1(95 downto 88)          <= tmp (95 downto 88);
	     tmp_1(7 downto 0)          <= tmp (103 downto 96);
	     tmp_1(47 downto 40)          <= tmp (111 downto 104);
	     tmp_1(87 downto 80)          <= tmp (119 downto 112);
	     tmp_1(127 downto 120)        <= tmp (127 downto 120);
         
         --
         tmp_sub_bytes (7 downto 0)     <=      sBox(to_integer(unsigned(tmp_1(7 downto 0)    ))); -- SUB BYTES --
         tmp_sub_bytes (15 downto 8)    <=      sBox(to_integer(unsigned(tmp_1(15 downto 8)   )));
         tmp_sub_bytes (23 downto 16)   <=      sBox(to_integer(unsigned(tmp_1(23 downto 16)  )));
         tmp_sub_bytes (31 downto 24)   <=      sBox(to_integer(unsigned(tmp_1(31 downto 24)  )));
         tmp_sub_bytes (39 downto 32)   <=      sBox(to_integer(unsigned(tmp_1(39 downto 32)  )));
         tmp_sub_bytes (47 downto 40)   <=      sBox(to_integer(unsigned(tmp_1(47 downto 40)  )));
         tmp_sub_bytes (55 downto 48)   <=      sBox(to_integer(unsigned(tmp_1(55 downto 48)  )));
         tmp_sub_bytes (63 downto 56)   <=      sBox(to_integer(unsigned(tmp_1(63 downto 56)  )));
         tmp_sub_bytes (71 downto 64)   <=      sBox(to_integer(unsigned(tmp_1(71 downto 64)  )));
         tmp_sub_bytes (79 downto 72)   <=      sBox(to_integer(unsigned(tmp_1(79 downto 72)  )));
         tmp_sub_bytes (87 downto 80)   <=      sBox(to_integer(unsigned(tmp_1(87 downto 80)  )));
         tmp_sub_bytes (95 downto 88)   <=      sBox(to_integer(unsigned(tmp_1(95 downto 88)  )));
         tmp_sub_bytes (103 downto 96)  <=      sBox(to_integer(unsigned(tmp_1(103 downto 96) )));
         tmp_sub_bytes (111 downto 104) <=      sBox(to_integer(unsigned(tmp_1(111 downto 104))));
         tmp_sub_bytes (119 downto 112) <=      sBox(to_integer(unsigned(tmp_1(119 downto 112))));
         tmp_sub_bytes (127 downto 120) <=      sBox(to_integer(unsigned(tmp_1(127 downto 120))));
          
	     --tmp_2 <= tmp_sub_bytes;
	     
	    tmp_2 <= tmp_sub_bytes xor keyin; -- ADD RoundKEYs 
	    
	A0xDI <= tmp_2(127 downto 120);  -- MIX COLUMNS --
	Q0xDI <=  tmp_2(95 downto 88) ;
	W0xDI <=  tmp_2(63 downto 56) ;
	E0xDI <=  tmp_2(31 downto 24) ;
			  
	
	A1xDI <= tmp_2(119 downto 112);
	Q1xDI <= tmp_2(87 downto 80 ) ;
	W1xDI <= tmp_2(55 downto 48)  ;
	E1xDI <= tmp_2(23 downto 16)  ;
	
	
	A2xDI <= tmp_2(111 downto 104);
	Q2xDI <= tmp_2(79 downto 72)  ;
	W2xDI <= tmp_2(47 downto 40);  
	E2xDI <= tmp_2(15 downto 8)  ;
	
	
	A3xDI <= tmp_2(103 downto 96)  ;
	Q3xDI <= tmp_2(71 downto 64)   ;
	W3xDI <= tmp_2(39 downto 32)   ;
	E3xDI <= tmp_2(7 downto 0)     ;









  -- Calculate all bytes at once
  mix_columns_p : process (A0xDI, A1xDI, A2xDI, A3xDI,Q0xDI,Q1xDI,Q2xDI,Q3xDI,W0xDI,W1xDI,W2xDI,W3xDI,E0xDI,E1xDI,E2xDI,E3xDI) is
    variable a0_mul_2 : std_logic_vector(7 downto 0);
	variable a1_mul_2 : std_logic_vector(7 downto 0);
	variable a2_mul_2 : std_logic_vector(7 downto 0);
	variable a3_mul_2 : std_logic_vector(7 downto 0);
	variable a0_mul_4 : std_logic_vector(7 downto 0);
	variable a1_mul_4 : std_logic_vector(7 downto 0);
	variable a2_mul_4 : std_logic_vector(7 downto 0);
	variable a3_mul_4 : std_logic_vector(7 downto 0);
	variable a0_mul_8 : std_logic_vector(7 downto 0);
	variable a1_mul_8 : std_logic_vector(7 downto 0);
	variable a2_mul_8 : std_logic_vector(7 downto 0);
	variable a3_mul_8 : std_logic_vector(7 downto 0);
	
	
	
	
	
	variable q0_mul_2 : std_logic_vector(7 downto 0);
	variable q1_mul_2 : std_logic_vector(7 downto 0);
	variable q2_mul_2 : std_logic_vector(7 downto 0);
	variable q3_mul_2 : std_logic_vector(7 downto 0);
	variable q0_mul_4 : std_logic_vector(7 downto 0);
	variable q1_mul_4 : std_logic_vector(7 downto 0);
	variable q2_mul_4 : std_logic_vector(7 downto 0);
	variable q3_mul_4 : std_logic_vector(7 downto 0);
	variable q0_mul_8 : std_logic_vector(7 downto 0);
	variable q1_mul_8 : std_logic_vector(7 downto 0);
	variable q2_mul_8 : std_logic_vector(7 downto 0);
	variable q3_mul_8 : std_logic_vector(7 downto 0);	
	
	
	variable w0_mul_2 : std_logic_vector(7 downto 0);
	variable w1_mul_2 : std_logic_vector(7 downto 0);
	variable w2_mul_2 : std_logic_vector(7 downto 0);
	variable w3_mul_2 : std_logic_vector(7 downto 0);
	variable w0_mul_4 : std_logic_vector(7 downto 0);
	variable w1_mul_4 : std_logic_vector(7 downto 0);
	variable w2_mul_4 : std_logic_vector(7 downto 0);
	variable w3_mul_4 : std_logic_vector(7 downto 0);
	variable w0_mul_8 : std_logic_vector(7 downto 0);
	variable w1_mul_8 : std_logic_vector(7 downto 0);
	variable w2_mul_8 : std_logic_vector(7 downto 0);
	variable w3_mul_8 : std_logic_vector(7 downto 0);	
	
	variable e0_mul_2 : std_logic_vector(7 downto 0);
	variable e1_mul_2 : std_logic_vector(7 downto 0);
	variable e2_mul_2 : std_logic_vector(7 downto 0);
	variable e3_mul_2 : std_logic_vector(7 downto 0);
	variable e0_mul_4 : std_logic_vector(7 downto 0);
	variable e1_mul_4 : std_logic_vector(7 downto 0);
	variable e2_mul_4 : std_logic_vector(7 downto 0);
	variable e3_mul_4 : std_logic_vector(7 downto 0);
	variable e0_mul_8 : std_logic_vector(7 downto 0);
	variable e1_mul_8 : std_logic_vector(7 downto 0);
	variable e2_mul_8 : std_logic_vector(7 downto 0);
	variable e3_mul_8 : std_logic_vector(7 downto 0);


  begin  -- process mix_columns_p
    -- 2*a0
    a0_mul_2(0) := A0xDI(7);
    a0_mul_2(1) := A0xDI(0) xor A0xDI(7);
    a0_mul_2(2) := A0xDI(1);
    a0_mul_2(3) := A0xDI(2) xor A0xDI(7);
    a0_mul_2(4) := A0xDI(3) xor A0xDI(7);
    a0_mul_2(5) := A0xDI(4);
    a0_mul_2(6) := A0xDI(5);
    a0_mul_2(7) := A0xDI(6);
	
	q0_mul_2(0) := Q0xDI(7);
    q0_mul_2(1) := Q0xDI(0) xor Q0xDI(7);
    q0_mul_2(2) := Q0xDI(1);
    q0_mul_2(3) := Q0xDI(2) xor Q0xDI(7);
    q0_mul_2(4) := Q0xDI(3) xor Q0xDI(7);
    q0_mul_2(5) := Q0xDI(4);
    q0_mul_2(6) := Q0xDI(5);
    q0_mul_2(7) := Q0xDI(6);
	
	w0_mul_2(0) := W0xDI(7);
    w0_mul_2(1) := W0xDI(0) xor W0xDI(7);
    w0_mul_2(2) := W0xDI(1);
    w0_mul_2(3) := W0xDI(2) xor W0xDI(7);
    w0_mul_2(4) := W0xDI(3) xor W0xDI(7);
    w0_mul_2(5) := W0xDI(4);
    w0_mul_2(6) := W0xDI(5);
    w0_mul_2(7) := W0xDI(6);
	
	e0_mul_2(0) := E0xDI(7);
    e0_mul_2(1) := E0xDI(0) xor E0xDI(7);
    e0_mul_2(2) := E0xDI(1);
    e0_mul_2(3) := E0xDI(2) xor E0xDI(7);
    e0_mul_2(4) := E0xDI(3) xor E0xDI(7);
    e0_mul_2(5) := E0xDI(4);
    e0_mul_2(6) := E0xDI(5);
    e0_mul_2(7) := E0xDI(6);

    -- 2*a1
    
	a1_mul_2(0) := A1xDI(7);
    a1_mul_2(1) := A1xDI(0) xor A1xDI(7);
    a1_mul_2(2) := A1xDI(1);
    a1_mul_2(3) := A1xDI(2) xor A1xDI(7);
    a1_mul_2(4) := A1xDI(3) xor A1xDI(7);
    a1_mul_2(5) := A1xDI(4);
    a1_mul_2(6) := A1xDI(5);
    a1_mul_2(7) := A1xDI(6);
	
	q1_mul_2(0) := Q1xDI(7);
    q1_mul_2(1) := Q1xDI(0) xor Q1xDI(7);
    q1_mul_2(2) := Q1xDI(1);
    q1_mul_2(3) := Q1xDI(2) xor Q1xDI(7);
    q1_mul_2(4) := Q1xDI(3) xor Q1xDI(7);
    q1_mul_2(5) := Q1xDI(4);
    q1_mul_2(6) := Q1xDI(5);
    q1_mul_2(7) := Q1xDI(6);
	
	w1_mul_2(0) := W1xDI(7);
    w1_mul_2(1) := W1xDI(0) xor W1xDI(7);
    w1_mul_2(2) := W1xDI(1);
    w1_mul_2(3) := W1xDI(2) xor W1xDI(7);
    w1_mul_2(4) := W1xDI(3) xor W1xDI(7);
    w1_mul_2(5) := W1xDI(4);
    w1_mul_2(6) := W1xDI(5);
    w1_mul_2(7) := W1xDI(6);
	
	e1_mul_2(0) := E1xDI(7);
    e1_mul_2(1) := E1xDI(0) xor E1xDI(7);
    e1_mul_2(2) := E1xDI(1);
    e1_mul_2(3) := E1xDI(2) xor E1xDI(7);
    e1_mul_2(4) := E1xDI(3) xor E1xDI(7);
    e1_mul_2(5) := E1xDI(4);
    e1_mul_2(6) := E1xDI(5);
    e1_mul_2(7) := E1xDI(6);

    -- 2*a2
    a2_mul_2(0) := A2xDI(7);
    a2_mul_2(1) := A2xDI(0) xor A2xDI(7);
    a2_mul_2(2) := A2xDI(1);
    a2_mul_2(3) := A2xDI(2) xor A2xDI(7);
    a2_mul_2(4) := A2xDI(3) xor A2xDI(7);
    a2_mul_2(5) := A2xDI(4);
    a2_mul_2(6) := A2xDI(5);
    a2_mul_2(7) := A2xDI(6);
	
	q2_mul_2(0) := Q2xDI(7);
    q2_mul_2(1) := Q2xDI(0) xor Q2xDI(7);
    q2_mul_2(2) := Q2xDI(1);
    q2_mul_2(3) := Q2xDI(2) xor Q2xDI(7);
    q2_mul_2(4) := Q2xDI(3) xor Q2xDI(7);
    q2_mul_2(5) := Q2xDI(4);
    q2_mul_2(6) := Q2xDI(5);
    q2_mul_2(7) := Q2xDI(6);
	
	w2_mul_2(0) := W2xDI(7);
    w2_mul_2(1) := W2xDI(0) xor W2xDI(7);
    w2_mul_2(2) := W2xDI(1);
    w2_mul_2(3) := W2xDI(2) xor W2xDI(7);
    w2_mul_2(4) := W2xDI(3) xor W2xDI(7);
    w2_mul_2(5) := W2xDI(4);
    w2_mul_2(6) := W2xDI(5);
    w2_mul_2(7) := W2xDI(6);
	
	e2_mul_2(0) := E2xDI(7);
    e2_mul_2(1) := E2xDI(0) xor E2xDI(7);
    e2_mul_2(2) := E2xDI(1);
    e2_mul_2(3) := E2xDI(2) xor E2xDI(7);
    e2_mul_2(4) := E2xDI(3) xor E2xDI(7);
    e2_mul_2(5) := E2xDI(4);
    e2_mul_2(6) := E2xDI(5);
    e2_mul_2(7) := E2xDI(6);

    -- 2*a3
    a3_mul_2(0) := A3xDI(7);
    a3_mul_2(1) := A3xDI(0) xor A3xDI(7);
    a3_mul_2(2) := A3xDI(1);
    a3_mul_2(3) := A3xDI(2) xor A3xDI(7);
    a3_mul_2(4) := A3xDI(3) xor A3xDI(7);
    a3_mul_2(5) := A3xDI(4);
    a3_mul_2(6) := A3xDI(5);
    a3_mul_2(7) := A3xDI(6);
	
	q3_mul_2(0) := Q3xDI(7);
    q3_mul_2(1) := Q3xDI(0) xor Q3xDI(7);
    q3_mul_2(2) := Q3xDI(1);
    q3_mul_2(3) := Q3xDI(2) xor Q3xDI(7);
    q3_mul_2(4) := Q3xDI(3) xor Q3xDI(7);
    q3_mul_2(5) := Q3xDI(4);
    q3_mul_2(6) := Q3xDI(5);
    q3_mul_2(7) := Q3xDI(6);
	
	w3_mul_2(0) := W3xDI(7);
    w3_mul_2(1) := W3xDI(0) xor W3xDI(7);
    w3_mul_2(2) := W3xDI(1);
    w3_mul_2(3) := W3xDI(2) xor W3xDI(7);
    w3_mul_2(4) := W3xDI(3) xor W3xDI(7);
    w3_mul_2(5) := W3xDI(4);
    w3_mul_2(6) := W3xDI(5);
    w3_mul_2(7) := W3xDI(6);
	
	e3_mul_2(0) := E3xDI(7);
    e3_mul_2(1) := E3xDI(0) xor E3xDI(7);
    e3_mul_2(2) := E3xDI(1);
    e3_mul_2(3) := E3xDI(2) xor E3xDI(7);
    e3_mul_2(4) := E3xDI(3) xor E3xDI(7);
    e3_mul_2(5) := E3xDI(4);
    e3_mul_2(6) := E3xDI(5);
    e3_mul_2(7) := E3xDI(6);
    
    --4*a0
    a0_mul_4(0) := a0_mul_2(7);
    a0_mul_4(1) := a0_mul_2(0) xor a0_mul_2(7);
    a0_mul_4(2) := a0_mul_2(1);
    a0_mul_4(3) := a0_mul_2(2) xor a0_mul_2(7);
    a0_mul_4(4) := a0_mul_2(3) xor a0_mul_2(7);
    a0_mul_4(5) := a0_mul_2(4);
    a0_mul_4(6) := a0_mul_2(5);
    a0_mul_4(7) := a0_mul_2(6);
	
	q0_mul_4(0) := q0_mul_2(7);
    q0_mul_4(1) := q0_mul_2(0) xor q0_mul_2(7);
    q0_mul_4(2) := q0_mul_2(1);
    q0_mul_4(3) := q0_mul_2(2) xor q0_mul_2(7);
    q0_mul_4(4) := q0_mul_2(3) xor q0_mul_2(7);
    q0_mul_4(5) := q0_mul_2(4);
    q0_mul_4(6) := q0_mul_2(5);
    q0_mul_4(7) := q0_mul_2(6);
	
	w0_mul_4(0) := w0_mul_2(7);
    w0_mul_4(1) := w0_mul_2(0) xor w0_mul_2(7);
    w0_mul_4(2) := w0_mul_2(1);
    w0_mul_4(3) := w0_mul_2(2) xor w0_mul_2(7);
    w0_mul_4(4) := w0_mul_2(3) xor w0_mul_2(7);
    w0_mul_4(5) := w0_mul_2(4);
    w0_mul_4(6) := w0_mul_2(5);
    w0_mul_4(7) := w0_mul_2(6);
	
	e0_mul_4(0) := e0_mul_2(7);
    e0_mul_4(1) := e0_mul_2(0) xor e0_mul_2(7);
    e0_mul_4(2) := e0_mul_2(1);
    e0_mul_4(3) := e0_mul_2(2) xor e0_mul_2(7);
    e0_mul_4(4) := e0_mul_2(3) xor e0_mul_2(7);
    e0_mul_4(5) := e0_mul_2(4);
    e0_mul_4(6) := e0_mul_2(5);
    e0_mul_4(7) := e0_mul_2(6);

    -- 4*a1
    
	a1_mul_4(0) := a1_mul_2(7);
    a1_mul_4(1) := a1_mul_2(0) xor a1_mul_2(7);
    a1_mul_4(2) := a1_mul_2(1);
    a1_mul_4(3) := a1_mul_2(2) xor a1_mul_2(7);
    a1_mul_4(4) := a1_mul_2(3) xor a1_mul_2(7);
    a1_mul_4(5) := a1_mul_2(4);
    a1_mul_4(6) := a1_mul_2(5);
    a1_mul_4(7) := a1_mul_2(6);
	
	q1_mul_4(0) := q1_mul_2(7);
    q1_mul_4(1) := q1_mul_2(0) xor q1_mul_2(7);
    q1_mul_4(2) := q1_mul_2(1);
    q1_mul_4(3) := q1_mul_2(2) xor q1_mul_2(7);
    q1_mul_4(4) := q1_mul_2(3) xor q1_mul_2(7);
    q1_mul_4(5) := q1_mul_2(4);
    q1_mul_4(6) := q1_mul_2(5);
    q1_mul_4(7) := q1_mul_2(6);
	
	w1_mul_4(0) := w1_mul_2(7);
    w1_mul_4(1) := w1_mul_2(0) xor w1_mul_2(7);
    w1_mul_4(2) := w1_mul_2(1);
    w1_mul_4(3) := w1_mul_2(2) xor w1_mul_2(7);
    w1_mul_4(4) := w1_mul_2(3) xor w1_mul_2(7);
    w1_mul_4(5) := w1_mul_2(4);
    w1_mul_4(6) := w1_mul_2(5);
    w1_mul_4(7) := w1_mul_2(6);
	
	e1_mul_4(0) := e1_mul_2(7);
    e1_mul_4(1) := e1_mul_2(0) xor e1_mul_2(7);
    e1_mul_4(2) := e1_mul_2(1);
    e1_mul_4(3) := e1_mul_2(2) xor e1_mul_2(7);
    e1_mul_4(4) := e1_mul_2(3) xor e1_mul_2(7);
    e1_mul_4(5) := e1_mul_2(4);
    e1_mul_4(6) := e1_mul_2(5);
    e1_mul_4(7) := e1_mul_2(6);

    -- 4*a2
    a2_mul_4(0) := a2_mul_2(7);
    a2_mul_4(1) := a2_mul_2(0) xor a2_mul_2(7);
    a2_mul_4(2) := a2_mul_2(1);
    a2_mul_4(3) := a2_mul_2(2) xor a2_mul_2(7);
    a2_mul_4(4) := a2_mul_2(3) xor a2_mul_2(7);
    a2_mul_4(5) := a2_mul_2(4);
    a2_mul_4(6) := a2_mul_2(5);
    a2_mul_4(7) := a2_mul_2(6);
	
	q2_mul_4(0) := q2_mul_2(7);
    q2_mul_4(1) := q2_mul_2(0) xor q2_mul_2(7);
    q2_mul_4(2) := q2_mul_2(1);
    q2_mul_4(3) := q2_mul_2(2) xor q2_mul_2(7);
    q2_mul_4(4) := q2_mul_2(3) xor q2_mul_2(7);
    q2_mul_4(5) := q2_mul_2(4);
    q2_mul_4(6) := q2_mul_2(5);
    q2_mul_4(7) := q2_mul_2(6);
	
	w2_mul_4(0) := w2_mul_2(7);
    w2_mul_4(1) := w2_mul_2(0) xor w2_mul_2(7);
    w2_mul_4(2) := w2_mul_2(1);
    w2_mul_4(3) := w2_mul_2(2) xor w2_mul_2(7);
    w2_mul_4(4) := w2_mul_2(3) xor w2_mul_2(7);
    w2_mul_4(5) := w2_mul_2(4);
    w2_mul_4(6) := w2_mul_2(5);
    w2_mul_4(7) := w2_mul_2(6);
	
	e2_mul_4(0) := e2_mul_2(7);
    e2_mul_4(1) := e2_mul_2(0) xor e2_mul_2(7);
    e2_mul_4(2) := e2_mul_2(1);
    e2_mul_4(3) := e2_mul_2(2) xor e2_mul_2(7);
    e2_mul_4(4) := e2_mul_2(3) xor e2_mul_2(7);
    e2_mul_4(5) := e2_mul_2(4);
    e2_mul_4(6) := e2_mul_2(5);
    e2_mul_4(7) := e2_mul_2(6);

    -- 4*a3
    a3_mul_4(0) := a3_mul_2(7);
    a3_mul_4(1) := a3_mul_2(0) xor a3_mul_2(7);
    a3_mul_4(2) := a3_mul_2(1);
    a3_mul_4(3) := a3_mul_2(2) xor a3_mul_2(7);
    a3_mul_4(4) := a3_mul_2(3) xor a3_mul_2(7);
    a3_mul_4(5) := a3_mul_2(4);
    a3_mul_4(6) := a3_mul_2(5);
    a3_mul_4(7) := a3_mul_2(6);
	
	q3_mul_4(0) := q3_mul_2(7);
    q3_mul_4(1) := q3_mul_2(0) xor q3_mul_2(7);
    q3_mul_4(2) := q3_mul_2(1);
    q3_mul_4(3) := q3_mul_2(2) xor q3_mul_2(7);
    q3_mul_4(4) := q3_mul_2(3) xor q3_mul_2(7);
    q3_mul_4(5) := q3_mul_2(4);
    q3_mul_4(6) := q3_mul_2(5);
    q3_mul_4(7) := q3_mul_2(6);
	
	w3_mul_4(0) := w3_mul_2(7);
    w3_mul_4(1) := w3_mul_2(0) xor w3_mul_2(7);
    w3_mul_4(2) := w3_mul_2(1);
    w3_mul_4(3) := w3_mul_2(2) xor w3_mul_2(7);
    w3_mul_4(4) := w3_mul_2(3) xor w3_mul_2(7);
    w3_mul_4(5) := w3_mul_2(4);
    w3_mul_4(6) := w3_mul_2(5);
    w3_mul_4(7) := w3_mul_2(6);
	
	e3_mul_4(0) := e3_mul_2(7);
    e3_mul_4(1) := e3_mul_2(0) xor e3_mul_2(7);
    e3_mul_4(2) := e3_mul_2(1);
    e3_mul_4(3) := e3_mul_2(2) xor e3_mul_2(7);
    e3_mul_4(4) := e3_mul_2(3) xor e3_mul_2(7);
    e3_mul_4(5) := e3_mul_2(4);
    e3_mul_4(6) := e3_mul_2(5);
    e3_mul_4(7) := e3_mul_2(6);
    
    --8*a0
    a0_mul_8(0) := a0_mul_4(7);
    a0_mul_8(1) := a0_mul_4(0) xor a0_mul_4(7);
    a0_mul_8(2) := a0_mul_4(1);
    a0_mul_8(3) := a0_mul_4(2) xor a0_mul_4(7);
    a0_mul_8(4) := a0_mul_4(3) xor a0_mul_4(7);
    a0_mul_8(5) := a0_mul_4(4);
    a0_mul_8(6) := a0_mul_4(5);
    a0_mul_8(7) := a0_mul_4(6);
	
	q0_mul_8(0) := q0_mul_4(7);
    q0_mul_8(1) := q0_mul_4(0) xor q0_mul_4(7);
    q0_mul_8(2) := q0_mul_4(1);
    q0_mul_8(3) := q0_mul_4(2) xor q0_mul_4(7);
    q0_mul_8(4) := q0_mul_4(3) xor q0_mul_4(7);
    q0_mul_8(5) := q0_mul_4(4);
    q0_mul_8(6) := q0_mul_4(5);
    q0_mul_8(7) := q0_mul_4(6);
	
	w0_mul_8(0) := w0_mul_4(7);
    w0_mul_8(1) := w0_mul_4(0) xor w0_mul_4(7);
    w0_mul_8(2) := w0_mul_4(1);
    w0_mul_8(3) := w0_mul_4(2) xor w0_mul_4(7);
    w0_mul_8(4) := w0_mul_4(3) xor w0_mul_4(7);
    w0_mul_8(5) := w0_mul_4(4);
    w0_mul_8(6) := w0_mul_4(5);
    w0_mul_8(7) := w0_mul_4(6);
	
	e0_mul_8(0) := e0_mul_4(7);
    e0_mul_8(1) := e0_mul_4(0) xor e0_mul_4(7);
    e0_mul_8(2) := e0_mul_4(1);
    e0_mul_8(3) := e0_mul_4(2) xor e0_mul_4(7);
    e0_mul_8(4) := e0_mul_4(3) xor e0_mul_4(7);
    e0_mul_8(5) := e0_mul_4(4);
    e0_mul_8(6) := e0_mul_4(5);
    e0_mul_8(7) := e0_mul_4(6);

    -- 8*a1
    
	a1_mul_8(0) := a1_mul_4(7);
    a1_mul_8(1) := a1_mul_4(0) xor a1_mul_4(7);
    a1_mul_8(2) := a1_mul_4(1);
    a1_mul_8(3) := a1_mul_4(2) xor a1_mul_4(7);
    a1_mul_8(4) := a1_mul_4(3) xor a1_mul_4(7);
    a1_mul_8(5) := a1_mul_4(4);
    a1_mul_8(6) := a1_mul_4(5);
    a1_mul_8(7) := a1_mul_4(6);
	
	q1_mul_8(0) := q1_mul_4(7);
    q1_mul_8(1) := q1_mul_4(0) xor q1_mul_4(7);
    q1_mul_8(2) := q1_mul_4(1);
    q1_mul_8(3) := q1_mul_4(2) xor q1_mul_4(7);
    q1_mul_8(4) := q1_mul_4(3) xor q1_mul_4(7);
    q1_mul_8(5) := q1_mul_4(4);
    q1_mul_8(6) := q1_mul_4(5);
    q1_mul_8(7) := q1_mul_4(6);
	
	w1_mul_8(0) := w1_mul_4(7);
    w1_mul_8(1) := w1_mul_4(0) xor w1_mul_4(7);
    w1_mul_8(2) := w1_mul_4(1);
    w1_mul_8(3) := w1_mul_4(2) xor w1_mul_4(7);
    w1_mul_8(4) := w1_mul_4(3) xor w1_mul_4(7);
    w1_mul_8(5) := w1_mul_4(4);
    w1_mul_8(6) := w1_mul_4(5);
    w1_mul_8(7) := w1_mul_4(6);
	
	e1_mul_8(0) := e1_mul_4(7);
    e1_mul_8(1) := e1_mul_4(0) xor e1_mul_4(7);
    e1_mul_8(2) := e1_mul_4(1);
    e1_mul_8(3) := e1_mul_4(2) xor e1_mul_4(7);
    e1_mul_8(4) := e1_mul_4(3) xor e1_mul_4(7);
    e1_mul_8(5) := e1_mul_4(4);
    e1_mul_8(6) := e1_mul_4(5);
    e1_mul_8(7) := e1_mul_4(6);

    -- 8*a2
    a2_mul_8(0) := a2_mul_4(7);
    a2_mul_8(1) := a2_mul_4(0) xor a2_mul_4(7);
    a2_mul_8(2) := a2_mul_4(1);
    a2_mul_8(3) := a2_mul_4(2) xor a2_mul_4(7);
    a2_mul_8(4) := a2_mul_4(3) xor a2_mul_4(7);
    a2_mul_8(5) := a2_mul_4(4);
    a2_mul_8(6) := a2_mul_4(5);
    a2_mul_8(7) := a2_mul_4(6);
	
	q2_mul_8(0) := q2_mul_4(7);
    q2_mul_8(1) := q2_mul_4(0) xor q2_mul_4(7);
    q2_mul_8(2) := q2_mul_4(1);
    q2_mul_8(3) := q2_mul_4(2) xor q2_mul_4(7);
    q2_mul_8(4) := q2_mul_4(3) xor q2_mul_4(7);
    q2_mul_8(5) := q2_mul_4(4);
    q2_mul_8(6) := q2_mul_4(5);
    q2_mul_8(7) := q2_mul_4(6);
	
	w2_mul_8(0) := w2_mul_4(7);
    w2_mul_8(1) := w2_mul_4(0) xor w2_mul_4(7);
    w2_mul_8(2) := w2_mul_4(1);
    w2_mul_8(3) := w2_mul_4(2) xor w2_mul_4(7);
    w2_mul_8(4) := w2_mul_4(3) xor w2_mul_4(7);
    w2_mul_8(5) := w2_mul_4(4);
    w2_mul_8(6) := w2_mul_4(5);
    w2_mul_8(7) := w2_mul_4(6);
	
	e2_mul_8(0) := e2_mul_4(7);
    e2_mul_8(1) := e2_mul_4(0) xor e2_mul_4(7);
    e2_mul_8(2) := e2_mul_4(1);
    e2_mul_8(3) := e2_mul_4(2) xor e2_mul_4(7);
    e2_mul_8(4) := e2_mul_4(3) xor e2_mul_4(7);
    e2_mul_8(5) := e2_mul_4(4);
    e2_mul_8(6) := e2_mul_4(5);
    e2_mul_8(7) := e2_mul_4(6);

    --8*a3
    a3_mul_8(0) := a3_mul_4(7);
    a3_mul_8(1) := a3_mul_4(0) xor a3_mul_4(7);
    a3_mul_8(2) := a3_mul_4(1);
    a3_mul_8(3) := a3_mul_4(2) xor a3_mul_4(7);
    a3_mul_8(4) := a3_mul_4(3) xor a3_mul_4(7);
    a3_mul_8(5) := a3_mul_4(4);
    a3_mul_8(6) := a3_mul_4(5);
    a3_mul_8(7) := a3_mul_4(6);
	
	q3_mul_8(0) := q3_mul_4(7);
    q3_mul_8(1) := q3_mul_4(0) xor q3_mul_4(7);
    q3_mul_8(2) := q3_mul_4(1);
    q3_mul_8(3) := q3_mul_4(2) xor q3_mul_4(7);
    q3_mul_8(4) := q3_mul_4(3) xor q3_mul_4(7);
    q3_mul_8(5) := q3_mul_4(4);
    q3_mul_8(6) := q3_mul_4(5);
    q3_mul_8(7) := q3_mul_4(6);
	
	w3_mul_8(0) := w3_mul_4(7);
    w3_mul_8(1) := w3_mul_4(0) xor w3_mul_4(7);
    w3_mul_8(2) := w3_mul_4(1);
    w3_mul_8(3) := w3_mul_4(2) xor w3_mul_4(7);
    w3_mul_8(4) := w3_mul_4(3) xor w3_mul_4(7);
    w3_mul_8(5) := w3_mul_4(4);
    w3_mul_8(6) := w3_mul_4(5);
    w3_mul_8(7) := w3_mul_4(6);
	
	e3_mul_8(0) := e3_mul_4(7);
    e3_mul_8(1) := e3_mul_4(0) xor e3_mul_4(7);
    e3_mul_8(2) := e3_mul_4(1);
    e3_mul_8(3) := e3_mul_4(2) xor e3_mul_4(7);
    e3_mul_8(4) := e3_mul_4(3) xor e3_mul_4(7);
    e3_mul_8(5) := e3_mul_4(4);
    e3_mul_8(6) := e3_mul_4(5);
    e3_mul_8(7) := e3_mul_4(6);
    
    -- b0 = 14*a0 + 11*a1 + 13*a2 + 9*a3
    B0xDO <= a0_mul_8 xor a0_mul_4 xor a0_mul_2 xor a1_mul_8 xor a1_mul_2 xor A1xDI xor a2_mul_8 xor a2_mul_4 xor A2xDI xor a3_mul_8 xor A3xDI;
	Q0xDO <= q0_mul_8 xor q0_mul_4 xor q0_mul_2 xor q1_mul_8 xor q1_mul_2 xor Q1xDI xor q2_mul_8 xor q2_mul_4 xor Q2xDI xor q3_mul_8 xor Q3xDI;
	W0xDO <= w0_mul_8 xor w0_mul_4 xor w0_mul_2 xor w1_mul_8 xor w1_mul_2 xor W1xDI xor w2_mul_8 xor w2_mul_4 xor W2xDI xor w3_mul_8 xor W3xDI;
	E0xDO <= e0_mul_8 xor e0_mul_4 xor e0_mul_2 xor e1_mul_8 xor e1_mul_2 xor E1xDI xor e2_mul_8 xor e2_mul_4 xor E2xDI xor e3_mul_8 xor E3xDI;

    -- b1 = 9*a0 + 14*a1 + 11*a2 + 13*a3
    B1xDO <= a0_mul_8 xor A0xDI xor a1_mul_8 xor a1_mul_4 xor a1_mul_2 xor a2_mul_8 xor a2_mul_2 xor A2xDI xor a3_mul_8 xor a3_mul_4 xor A3xDI;
	Q1xDO <= q0_mul_8 xor Q0xDI xor q1_mul_8 xor q1_mul_4 xor q1_mul_2 xor q2_mul_8 xor q2_mul_2 xor Q2xDI xor q3_mul_8 xor q3_mul_4 xor Q3xDI;
	W1xDO <= w0_mul_8 xor W0xDI xor w1_mul_8 xor w1_mul_4 xor w1_mul_2 xor w2_mul_8 xor w2_mul_2 xor W2xDI xor w3_mul_8 xor w3_mul_4 xor W3xDI;
	E1xDO <= e0_mul_8 xor E0xDI xor e1_mul_8 xor e1_mul_4 xor e1_mul_2 xor e2_mul_8 xor e2_mul_2 xor E2xDI xor e3_mul_8 xor e3_mul_4 xor E3xDI;
	   

    -- b2 = 13*a0 + 9*a1 + 14*a2 + 11*a3
    B2xDO <= a0_mul_8 xor a0_mul_4 xor A0xDI xor a1_mul_8 xor A1xDI xor a2_mul_8 xor a2_mul_4 xor a2_mul_2 xor a3_mul_8 xor a3_mul_2 xor A3xDI;
	Q2xDO <= q0_mul_8 xor q0_mul_4 xor Q0xDI xor q1_mul_8 xor Q1xDI xor q2_mul_8 xor q2_mul_4 xor q2_mul_2 xor q3_mul_8 xor q3_mul_2 xor Q3xDI;
	W2xDO <= w0_mul_8 xor w0_mul_4 xor W0xDI xor w1_mul_8 xor W1xDI xor w2_mul_8 xor w2_mul_4 xor w2_mul_2 xor w3_mul_8 xor w3_mul_2 xor W3xDI;
	E2xDO <= e0_mul_8 xor e0_mul_4 xor E0xDI xor e1_mul_8 xor E1xDI xor e2_mul_8 xor e2_mul_4 xor e2_mul_2 xor e3_mul_8 xor e3_mul_2 xor E3xDI;

    -- b3 = 11*a0 + 13*a1 + 9*a2 + 14*a3
    B3xDO <= a0_mul_8 xor a0_mul_2 xor A0xDI xor a1_mul_8 xor a1_mul_4 xor A1xDI xor a2_mul_8 xor A2xDI xor a3_mul_8 xor a3_mul_4 xor a3_mul_2;
	Q3xDO <= q0_mul_8 xor q0_mul_2 xor Q0xDI xor q1_mul_8 xor q1_mul_4 xor Q1xDI xor q2_mul_8 xor Q2xDI xor q3_mul_8 xor q3_mul_4 xor q3_mul_2;
	W3xDO <= w0_mul_8 xor w0_mul_2 xor W0xDI xor w1_mul_8 xor w1_mul_4 xor w1xDI xor w2_mul_8 xor W2xDI xor w3_mul_8 xor w3_mul_4 xor w3_mul_2;
	E3xDO <= e0_mul_8 xor e0_mul_2 xor e0xDI xor e1_mul_8 xor e1_mul_4 xor E1xDI xor e2_mul_8 xor E2xDI xor e3_mul_8 xor e3_mul_4 xor e3_mul_2;
      
    
     
    
    
    
    end process mix_columns_p;
    output <= tmp_2 when mix_counter = "1110"  else
                        B0xDO & B1xDO & B2xDO & B3xDO & Q0xDO & Q1xDO & Q2xDO & Q3xDO & W0xDO & W1xDO & W2xDO & W3xDO & E0xDO & E1xDO & E2xDO & E3xDO;
	
	     
	     
	     
end architecture; 
