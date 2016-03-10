-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                          
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul odogvaran za indikaciju o proteku sekunde
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY clk_counter IS GENERIC(
                              -- maksimalna vrednost broja do kojeg brojac broji
                              max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "10111110101111000010000000" -- 50 000 000
                             );
                      PORT   (
                               clk_i     : IN  STD_LOGIC; -- ulazni takt
                               rst_i     : IN  STD_LOGIC; -- reset signal
                               cnt_en_i  : IN  STD_LOGIC; -- signal dozvole brojanja
                               cnt_rst_i : IN  STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               one_sec_o : OUT STD_LOGIC  -- izlaz koji predstavlja proteklu jednu sekundu vremena
										 
                             );
END clk_counter;
ARCHITECTURE rtl OF clk_counter IS
SIGNAL   counter_r : STD_LOGIC_VECTOR(25 DOWNTO 0);
Signal counter_r_next  : std_logic_vector(25 downto 0);
signal sCmp: STD_LOGIC;
signal sigM1: STD_LOGIC_VECTOR(25 downto 0);
signal sigM2: STD_LOGIC_VECTOR(25 downto 0);
signal sigM3: STD_LOGIC_VECTOR(25 downto 0);
signal sone_sec_o : STD_LOGIC;
component reg is
	generic(
		WIDTH    : positive := 1;
		RST_INIT : integer := 0
	);
	port(
		i_clk  : in  std_logic;
		in_rst : in  std_logic;
		i_d    : in  std_logic_vector(WIDTH-1 downto 0);
		o_q    : out std_logic_vector(WIDTH-1 downto 0)
	);
end component reg;
BEGIN
	cnt_reg : reg
	generic map(	
		WIDTH => 8
	)
	port map(
		i_clk => clk_i,
		in_rst => not(rst_i),
		i_d => sigM3,
		o_q => counter_r
	);
	counter_r_next<=counter_r+1;
	
	--comparator
	sCmp<='1' when counter_r_next=max_cnt-1 else '0';
	
	--mux1
	sigM1<=counter_r_next when sCmp='0' else (others=>'0');	
	
	--mux2
	
	sigM2<=sigM1 when cnt_en_i='1' else counter_r;
	
	--mux3
	
	sigM3<= sigM2 when  cnt_rst_i='0' else (others=>'0');
	
	sone_sec_o<='1' when counter_r=max_cnt-1 else '0' ;
	
	one_sec_o<=sone_sec_o;
	
END rtl;