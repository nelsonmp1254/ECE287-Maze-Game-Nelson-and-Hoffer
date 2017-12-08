library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Maze_Game is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  InputLeft : in STD_LOGIC;
			  InputRight : in STD_LOGIC;
			  InputUp : in STD_LOGIC;
			  InputDown : in STD_LOGIC;
			  VGA_clk : out STD_LOGIC; 
           HSYNC : out  STD_LOGIC;
           VSYNC : out  STD_LOGIC;
           RGB : out  STD_LOGIC_VECTOR (2 downto 0));
end Maze_Game;

architecture Behavioral of Maze_Game is

	signal clk25 : std_logic := '0';
	signal counter : std_logic_vector(21 downto 0);
	
	constant HD : integer := 639;  --  639   Horizontal Display (640)
	constant HFP : integer := 16;         --   16   Right border (front porch)
	constant HSP : integer := 96;       --   96   Sync pulse (Retrace)
	constant HBP : integer := 48;        --   48   Left boarder (back porch)
	constant VD : integer := 479;   --  479   Vertical Display (480)
	constant VFP : integer := 10;       	 --   10   Right border (front porch)
	constant VSP : integer := 2;				 --    2   Sync pulse (Retrace)
	constant VBP : integer := 33;       --   33   Left boarder (back porch)
	signal hPos : integer := 0;			-- horizontal position of pixels
	signal vPos : integer := 0;			-- vertical position of pixels
	signal charCenterV : integer := 10;  -- center of character. Used to determine the vertical pixels to be colored by drawChar process, allows for easier movement
	signal charCenterH : integer := 10;  -- *** same as above, but horizontal 
	signal videoOn : std_logic := '0';
	
begin


clk_div:process(CLK)
begin
	if(CLK'event and CLK = '1')then
		clk25 <= not clk25;
	end if;
end process;
VGA_CLK <= clk25;

Horizontal_position_counter:process(clk25, RST)
begin
	if(RST = '1')then
		hpos <= 0;
	elsif(clk25'event and clk25 = '1')then
		if (hPos = (HD + HFP + HSP + HBP)) then
			hPos <= 0;
		else
			hPos <= hPos + 1;
		end if;
	end if;
end process;

Vertical_position_counter:process(clk25, RST, hPos)
begin
	if(RST = '1')then
		vPos <= 0;
	elsif(clk25'event and clk25 = '1')then
		if(hPos = (HD + HFP + HSP + HBP))then
			if (vPos = (VD + VFP + VSP + VBP)) then
				vPos <= 0;
			else
				vPos <= vPos + 1;
			end if;
		end if;
	end if;
end process;

Horizontal_Synchronisation:process(clk25, RST, hPos)
begin
	if(RST = '1')then
		HSYNC <= '0';
	elsif(clk25'event and clk25 = '1')then
		if((hPos <= (HD + HFP)) OR (hPos > HD + HFP + HSP))then
			HSYNC <= '1';
		else
			HSYNC <= '0';
		end if;
	end if;
end process;


Vertical_Synchronisation:process(clk25, RST, vPos)
begin
	if(RST = '1')then
		VSYNC <= '0';
	elsif(clk25'event and clk25 = '1')then
		if((vPos <= (VD + VFP)) OR (vPos > VD + VFP + VSP))then
			VSYNC <= '1';
		else
			VSYNC <= '0';
		end if;
	end if;
end process;

video_on:process(clk25, RST, hPos, vPos)
begin
	if(RST = '1')then
		videoOn <= '0';
	elsif(clk25'event and clk25 = '1')then
		if(hPos <= HD and vPos <= VD)then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
end process;


drawChar:process(clk25, RST, hPos, vPos, videoOn, charCenterH, charCenterV)
begin
	if(RST = '1')then
		RGB <= "000";
	elsif(clk25'event and clk25 = '1')then
		if(videoOn = '1')then
			if not(charCenterV >=236  and charCenterV <= 266  and CharCenterH >= 6 and CharCenterH <= 46) then
			
			if((hPos >= charCenterH -5 and hPos <= charCenterH + 5) AND (vPos >= charCenterV - 5 and vPos <= charCenterV + 5))then
				RGB <= "101";
			
			elsif (vPos >= 470 and vPos <= 480) then --right border
				RGB <= "000";
			elsif (vPos >= 0 and vPos<= 4) then -- top border
				RGB <= "000";
			elsif (hPos >= 0 and hPos<= 4) then -- left border
				RGB <= "000";
			elsif (hPos >= 635 and hPos <= 645) then -- bottom border
				RGB <= "000";
			
			elsif (vPos >= 235 and vPos <= 239 and hPos >= 0 and hPos <=700) then -- middle
				RGB <= "000";
			elsif (vPos >= 240 and vPos <=270 and hPos >= 5 and hPos <= 39) then -- end
				RGB <= "010";
			elsif (vPos >= 200 and vPos <=234 and hPos >= 601 and hPos <= 634) then -- Teleport
				RGB <= "100";
			elsif (vPos >= 239 and vPos <= 330 and hPos >= 40 and hPos <=60) then -- bottom 1
				RGB <= "000";
			elsif (vPos >= 369 and vPos <= 399 and hPos >= 40 and hPos <=360) then -- bottom 2
				RGB <= "000";
			elsif (vPos >= 279 and vPos <= 370 and hPos >= 150 and hPos <= 180) then -- bottom 3
				RGB <= "000";
			elsif (vPos >= 239 and vPos <= 399 and hPos >= 330 and hPos <=360) then -- bottom 4
				RGB <= "000";	
			elsif (vPos >= 239 and vPos <= 399  and hPos >= 400 and hPos <=480) then -- bottom 5
				RGB <= "000";
			elsif (vPos >= 290 and vPos <= 475 and hPos >= 520 and hPos <=600) then -- bottom 6
				RGB <= "000";		
			
			elsif (vPos >= 0 and vPos <= 200 and hPos >= 50 and hPos <=100) then -- top 1
				RGB <= "000";
			elsif (vPos >= 50 and vPos <= 235 and hPos >= 150 and hPos <=200) then -- top 2
				RGB <= "000";
			elsif (vPos >= 50 and vPos <= 180 and hPos >= 150 and hPos <= 450) then -- top 3
				RGB <= "000";
			elsif (vPos >= 50 and vPos <= 235 and hPos >= 500 and hPos <= 600) then -- top 4
				RGB <= "000";
			
			else
					RGB <= "111";
		end if;
		
		else 
			if (vPos >= 100 and vPos <=275 and hPos >= 200 and hPos <= 225) then -- F1
					RGB <= "111";
				elsif (vPos >= 100 and vPos <=125 and hPos >= 200 and hPos <= 250) then -- F2
					RGB <= "111";
				elsif (vPos >= 150 and vPos <=175 and hPos >= 200 and hPos <= 250) then -- F3
					RGB <= "111";
				elsif (vPos >= 100 and vPos <=275 and hPos >= 300 and hPos <= 325) then --I
					RGB <= "111";
				elsif (vPos >= 100 and vPos <=275 and hPos >= 375 and hPos <= 400) then --N1
					RGB <= "111";
				elsif (vPos >= 100 and vPos <=125 and hPos >= 375 and hPos <= 425) then --N1
					RGB <= "111";
				elsif (vPos >= 100 and vPos <=275 and hPos >= 425 and hPos <= 450) then --N1
					RGB <= "111";
				else 
				RGB <= "000";
			end if;
			end if;
		
		
		else
			RGB <= "000";
		end if;
		end if;
end process;


move:process(RST, clk25, videoOn, InputLeft, InputRight, InputUp, InputDown, charCenterH, charCenterV)
begin 
	if RST = '0' then
	if(clk25'event and clk25 = '1')then
	  if counter < "1111010111100001000000" then
	  counter <= counter + 20;
	  else
		if (charCenterV >= 200 and charCenterV <=225 and charCenterH >= 600 and charCenterH <= 630) then
		
			charCenterV <= 429;
			
		
		end if;
		
		
		if (charCenterV <= 10)then -- bottom barriers
			
		elsif (charCenterV = 245) then -- middle from bottom
			--
		elsif (charCenterH >= 35 and charCenterH <= 65 and charCenterV = 336) then  -- bottom 1 bottom
			--
		elsif (charCenterH >= 35 and charCenterH <= 365 and charCenterV = 405 ) then -- bottom 2 bottom barrier
			--
		elsif (charCenterH >= 325 and charCenterH <= 365 and charCenterV = 405 ) then -- bottom 4 bottom barrier
			--
		elsif (charCenterH >= 395 and charCenterH <= 485 and charCenterV = 405) then -- bottom 5 bottom barrier
			--
		elsif (charCenterH >= 515 and charCenterH <= 605 and charCenterV = 481) then -- bottom 6 bottom barrier
			--
		elsif (charCenterH >= 50 and charCenterH <= 100 and charCenterV = 206) then -- top 1 bottom barrier
			--
		elsif (charCenterH >= 150 and charCenterH <= 450 and charCenterV = 186) then -- top 3 bottom barrier
			--
		elsif (videoOn = '1' and InputUp = '0')  then
			charcenterV <= charCenterV - 1;
		end if;
		 	
			
			
		if (charCenterV >= 464)then    -- top barriers
		--
		elsif (charCenterV = 363 and charCenterH >= 45 and charCenterH <= 365)then -- bottom 2 top barrier
		--
		elsif (charCenterV = 273 and charCenterH >= 155 and charCenterH <= 185)then -- bottom 3 top barrier
		--
		elsif (charCenterV = 233 and charCenterH >= 335 and charCenterH <= 365)then -- bottom 4 top barrier
		--	
		elsif (charCenterV = 233 and charCenterH >= 405 and charCenterH <= 485)then -- bottom 5 top barrier
		--
		elsif (charCenterV = 284 and charCenterH >= 525 and charCenterH <= 605)then -- bottom 6 top barrier
		elsif (charCenterV = 229) then -- middle from top
			--
		elsif (charCenterV = 44 and charCenterH >= 150 and charCenterH <= 450)then -- top 3 top barrier
		--	
		elsif (charCenterV = 44 and charCenterH >= 500 and charCenterH <= 600)then -- top 4 top barrier
		--	
		
		elsif (videoOn = '1' and InputDown = '0') then
			charcenterV <= charCenterV + 1;
		end if;
		
		
		-- (vPos >= 239 and vPos <= 330 and hPos >= 40 and hPos <=60) -- bottom 1
		-- vPos >= 369 and vPos <= 399 and hPos >= 40 and hPos <=360 -- bottom 2
		-- vPos >= 279 and vPos <= 370 and hPos >= 150 and hPos <= 180) -- bottom 3
		-- (vPos >= 239 and vPos <= 399 and hPos >= 330 and hPos <=360) then -- bottom 4
		-- (vPos >= 239 and vPos <= 399  and hPos >= 400 and hPos <=480) then -- bottom 5
		-- (vPos >= 290 and vPos <= 475 and hPos >= 520 and hPos <=600) then -- bottom 6
		
		if (charCenterH <= 10)then     -- right barriers
		
		elsif (charCenterV >= 234 and charCenterV <= 335 and  charCenterH = 66) then -- bottom 1 right
		--
		elsif(charCenterV >= 364 and charCenterV <= 404 and charCenterH = 366) then -- bottom 2 right
		--
		elsif (charCenterV >= 274 and charCenterV <= 376 and charCenterH = 186)then -- bottom 3 right
		--
		elsif (charCenterV >= 234 and charCenterV <= 405 and charCenterH = 366) then -- bottom 4 right
		--
		elsif (charCenterV >= 234 and charCenterV <= 405 and charCenterH = 486) then -- bottom 5 right
		--
		elsif (charCenterV >= 283 and charCenterV <= 498 and charCenterH = 606) then -- bottom 6 right
		--
		elsif (charCenterV >= 0 and charCenterV <= 200 and  charCenterH = 106) then -- top 1 right
		--
		elsif(charCenterV >= 50 and charCenterV <= 235 and charCenterH = 206) then -- top 2 right
		--
		elsif (charCenterV >= 50 and charCenterV <= 180 and charCenterH = 456)then -- top 3 right
		--
		elsif (charCenterV >= 50 and charCenterV <= 235 and charCenterH = 606) then -- top 4 right
		--
		
	
		elsif (videoOn = '1' and InputLeft = '0') then
			charcenterH <= charCenterH - 1;
			

		end if;
		
		if (charCenterH >= 629)then   -- left barriers
		
		elsif (charCenterV >= 236 and charCenterV <= 336 and charCenterH = 34)then  -- bottom 1 left
		--
		elsif (charCenterV >= 366 and charCenterV <= 405 and charCenterH = 34)then -- bottom 2 left
		--
		elsif (charCenterV >= 274 and charCenterV <= 376 and charCenterH = 144)then -- bottom 3 left
		--
		elsif (charCenterV >= 234 and charCenterV <= 405 and charCenterH = 324)then -- bottom 4 left
		--
		elsif (charCenterV >= 234 and charCenterV <= 405 and charCenterH = 394)then -- bottom 5 left
		-- 
		elsif (charCenterV >= 285   and charCenterV <= 481   and charCenterH = 514)then  -- bottom 6 left
		--
		elsif (charCenterV >= 0 and charCenterV <= 200 and charCenterH = 44)then  -- top 1 left
		--
		elsif (charCenterV >= 50 and charCenterV <= 180 and charCenterH = 144)then -- top 2 left
		--
		elsif (charCenterV >= 50 and charCenterV <= 235 and charCenterH = 144)then -- top 3 left
		--
		elsif (charCenterV >= 50 and charCenterV <= 235 and charCenterH = 494)then -- top 4 left
		--
		elsif (videoOn = '1' and InputRight = '0') then 
			charcenterH <= charCenterH + 1;
		end if;
		counter <= (others => '0');
		end if;
		end if;
		else 
			CharcenterH <= 11;
			CharcenterV <= 11;
		end if;
		
	
end process;


end Behavioral;