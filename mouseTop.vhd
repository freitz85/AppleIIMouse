library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.ps2_components.all;

entity mouseTop is
	port(
		mclk : in STD_LOGIC;
		PS2C : inout STD_LOGIC;
		PS2D : inout STD_LOGIC;
		btn : in STD_LOGIC_VECTOR(3 downto 0);
		ld : out STD_LOGIC_VECTOR(3 downto 0);
		aToG : out STD_LOGIC_VECTOR(6 downto 0);
		dp : out STD_LOGIC;
		an : out STD_LOGIC_VECTOR(3 downto 0)
		);
end mouseTop;

architecture mouseTop of mouseTop is
	signal clk7m, clk190, clr: STD_LOGIC;
	signal byte3: STD_LOGIC_VECTOR(7 downto 0);
	signal xData, yData: STD_LOGIC_VECTOR(8 downto 0);
	signal xMouse: STD_LOGIC_VECTOR(15 downto 0);

begin
	clr <= btn(3);
	dp <= '1';				-- decimal points off
	xMouse <= xData(7 downto 0) & yData(7 downto 0);
	ld(0) <= yData(8);
	ld(1) <= xData(8);
	ld(2) <= byte3(1);		-- right button
	ld(3) <= byte3(0);		-- left button

U1 : clkdiv2
	port map(mclk => mclk, clr => clr, clk7m => clk7m, clk190 => clk190);

U2 : mouseCtrl
	port map(clk7m => clk7m, clr => clr, sel => btn(0),
			PS2C => PS2C, PS2D => PS2D, byte3 => byte3,
			xData => xData, yData => yData);

U3 : x7segb
	port map(x => xMouse, cclk => clk190, clr => clr,
			aToG => aToG, an => an);

end mouseTop;




