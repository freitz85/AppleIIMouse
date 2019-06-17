library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity mouseCtrl is
	port(
			clk7m : in STD_LOGIC;
			clr : in STD_LOGIC;
			sel : in STD_LOGIC;
			PS2C : inout STD_LOGIC;
			PS2D : inout STD_LOGIC;
			byte3 : out STD_LOGIC_VECTOR(7 downto 0);
			xData : out STD_LOGIC_VECTOR(8 downto 0);
			yData : out STD_LOGIC_VECTOR(8 downto 0)
		);
end mouseCtrl;

architecture mouseCtrl of mouseCtrl is
	type STATE_T is (start, clklo, datlo, relclk, sndbyt, wtack,
		wtclklo, wtcdrel, wtclklo1, wtclkhi1, getack, wtclklo2,
		wtclkhi2, getmdata);

	signal state: STATE_T;
	signal PS2Cf, PS2Df, cen, den, sndflg, xs, ys: STD_LOGIC;
	signal ps2cin, ps2din ps2cio, ps2dio: STD_LOGIC;
	signal ps2c_filter, ps2d_filter: STD_LOGIC_VECTOR(7 downto 0);
	signal xMouseV, yMouseV: STD_LOGIC_VECTOR(8 downto 0);
	signal xMouseD, yMouseD: STD_LOGIC_VECTOR(8 downto 0);
	signal shift1, shift2, shift3: STD_LOGIC_VECTOR(10 downto 0);
	signal f4cmd: STD_LOGIC_VECTOR(9 downto 0);
	signal bitCount, bitCount1: STD_LOGIC_VECTOR(3 downto 0);
	signal bitCount3: STD_LOGIC_VECTOR(5 downto 0);
	signal count: STD_LOGIC_VECTOR(11 downto 0);

	constant COUNT_MAX : STD_LOGIC_VECTOR(11 downto 0) := X"2BC";	-- 700 100us
	constant BIT_COUNT_MAX: STD_LOGIC_VECTOR(3 downto 0) := "1010";	-- 10
	constant BIT_COUNT1_MAX: STD_LOGIC_VECTOR(3 downto 0) := "1100"; -- 12 ack
	constant BIT_COUNT3_MAX: STD_LOGIC_VECTOR(5 downto 0) := "100001"; -- 33

begin
	-- tri-state buffers
	ps2cio <= ps2cin when cen = '1' else 'Z';
	ps2dio <= ps2din when den = '1' else 'Z';
	PS2C <= ps2cio;
	PS2D <= ps2dio;

	-- filter for PS2 clock
	filter: process(clk7m, clr)
	begin
		if clr = '1' then
			ps2c_filter <= (others => '0');
			ps2d_filter <= (others => '0');
			PS2Cf <= '1';
			PS2Df <= '1';
		elsif rising_edge(clk7m) then
			ps2c_filter(7) <= ps2cio;
			ps2c_filter(6 downto 0) <= ps2c_filter(7 downto 1);
			ps2d_filter(7) <= ps2dio;
			ps2d_filter(6 downto 0) <= ps2d_filter(7 downto 1);

			if ps2c_filter = X"FF" then
				PS2Cf <= '1';
			elsif ps2c_filter = X"00" then
				PS2Cf <= '0';
			end if;

			if ps2d_filter = X"FF" then
				PS2Df <= '1';
			elsif ps2d_filter = X"00" then
				PS2Df <= '0';
			end if;
		end if;
	end process filter;

	-- state machine for reading mouse
	smouse: process(clk7m, clr)
	begin
		if clr = '1' then
			state <= start;
			cen <= '0';
			den <= '0';
			ps2din <= '0';
			count <= (others => '0');
			bitCount1 <= (others => '0');
			bitCount3 <= (others => '0');
			shift1 <= (others => '0');
			shift2 <= (others => '0');
			shift3 <= (others => '0');
			xMouseV <= (others => '0');
			yMouseV <= (others => '0');
			xMouseD <= (others => '0');
			yMouseD <= (others => '0');
			sndflg <= '0';
		elsif falling_edge(clk7m) then
		  case state is
		  	when start =>
		  		cen <= '1';			-- enable clock output
		  		ps2cin <= '0';		-- start bit
		  		count <= (others => '0'); -- reset count
		  		state <= clklo;
		  	when clklo =>
		  		if count < COUNT_MAX then
		  			count <= count + 1;
		  			state <= clklo;
		  		else
		  			state <= datlo;
		  			den <= '1';		-- enable data output
		  		end if;
		  	when datlo =>
		  		state <= relclk
	  			cen <= '0';			-- release clock
	  		when relclk =>
	  			sndflg <= '1';
	  			state <= sndbyt;
	  		when sndbyt =>
	  			if bitCount < BIT_COUNT_MAX then
	  				state <= sndbyt;
  				else
  					state <= wtack;
  					sndflg <= '0';
  					den <= '0';		-- release data
  				end if;
  			when wtack =>			-- wait for data low
  				if PS2Df = '1' then
  					state <= wtack;
  				else
  					state <= wtclklo;
  				end if;
  			when wtclklo =>			-- wait for clock low
  				if PS2Cf = '1' then
  					state <= wtclklo;
  				else
  					state <= wtcdrel;
  				end if;
  			when wtcdrel =>			-- wait to release clock and data
  				if PS2Cf = '1' and PS2Df = '1' then
  					state <= wtclklo1;
  					bitCount1 <= (others => '0');
  				else
  					state <= wtcdrel;
  				end if;
  			when wtclklo1 =>		-- wait for clock low
  				if bitCount1 < BIT_COUNT1_MAX then
  					if PS2Cf = '1' then
  						state <= wtclklo1;
  					else
  						state wtclkhi1;	-- get ack byte FA
  						shift1 <= PS2Df & shift1(10 downto 1);
  					end if;
  				else
  					state <= getack;
  				end if;
  			when wtclkhi1 =>		-- wait for clock high
  				if PS2Cf = '0' then
  					state <= wtclkhi1;
  				else
  					state <= wtclklo1;
  					bitCount1 <= bitCount1 + 1;
  				end if;
  			when getack =>			-- get ack FA
  				yMouseV <= shift1(9 downto 1);
  				xMouseV <= shift2(8 downto 0);
  				byte3 <= shift1(10 downto 5) & shift1(1 downto 0);
  				state <= wtclklo2;
  				bitCount3 <= (others => '0');
  			when wtclklo2 =>		-- wait for clock low
  				if bitCount3 < BIT_COUNT3_MAX then
  					if PS2Cf = '1' then
  						state <= wtclklo2;
  					else
  						state <= wtclkhi2;
  						shift1 <= PS2Df & shift1(10 downto 1);
  						shift2 <= shift1(0) & shift2(10 downto 1);
  						shift3 <= shift2(0) & shift3(10 downto 1);
  					end if;
  				else
  					xMouseV <= shift3(5) & shift2(8 downto 1);	-- x velocity
  					yMouseV <= shift3(6) & shift1(8 downto 1);  -- y velocity
  					byte3 <= shift3(8 downto 1);
  					state <= getmdata;
  				end if;
  			when wtclkhi2 =>		-- wait for clock high
  				if PS2Cf = '0' then
  					state <= wtclkhi2;
  				else
  					state <= wtclklo2;
  					bitCount3 <= bitCount3 + 1;
  				end if;
  			when getmdata =>		-- read mouse data and keep going
  				xMouseD <= xMouseD + xMouseV;					-- x distance
  				yMouseD <= yMouseD + yMouseV;					-- y distance
  				bitCount3 <= (others => '0');
  				state <= wtclklo2;
  		  end case;
  		end if;
  	end process smouse;

  	-- send F4 command to mouse
  	sndf4: process(PS2Cf, clr, sndflg)
  	begin
  		if clr = '1' then
  			f4cmd <= "1011110100";	-- stop-parity-F4
  			ps2din <= '0';
  			bitCount <= (others => '0');
  		elsif falling_edge(PS2Cf) and sndflg = '1' then
  			ps2din <= f4cmd(0);
  			f4cmd(8 downto 0) <= f4cmd(9 downto 1);
  			f4cmd(9) <= '0';
  			bitCount <= bitCount + 1;
  		end if;
  	end process sndf4;

  	-- output select
  	outsel: process(xMouseV, yMouseV, xMouseD, yMouseD, sel)
  	begin
  		if sel = '0' then
  			xData <= xMouseV;
  			yData <= yMouseV;
  		else
  			xData <= xMouseD;
  			yData <= yMouseD;
  		end if;
  	end process outsel;
end architecture mouseCtrl;
