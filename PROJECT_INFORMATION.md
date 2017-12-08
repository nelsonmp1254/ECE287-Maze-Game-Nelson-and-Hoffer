# Maze_Game

Introduction 

  For the project we decided, with input from our professor, to make a basic maze game with a few additional features. We added a         teleported to move between 'levels', a reset, so you can start the game over, and a win screen once you reach the end. 



Design 

   To begin the project, we first found a VGA core with the help of Ross. Ross sent us a link to a VGA core tutorial, found on              https://www.youtube.com/watch?v=eJMYVLPX0no. The tutorial contained the code to set up the VGA core processes.                          https://drive.google.com/file/d/0B9T_kQ0ObLf7THpQSWpsT0xEMFE/view Is the code. 

   Once we had the VGA core up and running, we experimented with creating a draw process. In order to draw, we used the 'vPos' and          'hPos' variables, along with the RGB variables, in order to draw between 4 lines. 

   For example,

		elsif (vPos >=  50 and vPos <= 54 and hPos >= 50 and hPos <= 250) then
					RGB <= "000";
        
   creates a black box between the vertical pixels between 50 and 54, and extendes it horizontally between 50 and 250, creating a 
   4 x 200 pixel box. 

   Once we had the draw process running, we created variables to hold the position of our 'character' in two variables. We tracked          vertical and horizontal movement, 'charCenterV' and 'charCenterH' respectively. Using this method we could draw a square 'centered'      at the location, going 5 pixels from the center in two directions, making a 10x10 pixel character. The code to do this was; 

		if((hPos >= charCenterH -5 and hPos <= charCenterH + 5) AND (vPos >= charCenterV - 5 and vPos <= charCenterV + 5))then
					RGB <= "101";
        
   With the chracter position being stored in two variables, we set up 4 inputs using the FPGA buttons. We made a move process that        moved the position by 1 per cycle. The code for that; 

		move:process(clk25, videoOn, InputLeft, InputRight, InputUp, InputDown, charCenterH, charCenterV)
		begin 
			if RST = '0' then
			if(clk25'event and clk25 = '1')then
			  if counter < "1111010111100001000000" then
			  counter <= counter + 20;
			  else
				if (charCenterV >= 210 and charCenterV <=225 and charCenterH >= 610 and charCenterH <= 625) then
					charCenterV <= 400;
					charCenterH <= 400;
		.
		.
		.
				elsif (videoOn = '1' and InputUp = '0')  then
					charcenterV <= charCenterV - 1;
				end if;


    We made sure that the character couldn't move if videoOn was off, as that would allow the character to move without displaying it. 

    With having a way to draw our character, move the character, and draw our boxes, we just had to set boundaries. In order to do so,       we decided to have the move process check to make sure that our 'char' wasn't up against where we drew out line. Before allowing any     movement, we put in an if statement that would check if it was within 6 pixels of a side of a wall. If it was, it didn't allow the       character ot move in that direction, having no commands. The code was; 

		elsif (charCenterV = 245) then -- middle from bottom
				--
      
      
   The videoOn variable was tied to our reset input, which was on a switch. We created a process for this. When reset = '1', we had it      reset our character position to the starting point and turned the videoOn to '0', or off. 
 
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
		
    Then, in the moveChar process, we added an else statement for if RST was not = '1'; 

		else 
					CharcenterH <= 11;
					CharcenterV <= 11;
				end if;
			
   which would reset the char position to the starting position. 

   After getting the reset to work, we added a way to 'teleport' between levels, using a similar statement; 

		if (charCenterV >= 210 and charCenterV <=225 and charCenterH >= 610 and charCenterH <= 625) then
					charCenterV <= 400;
				end if;
			
   We originally wanted to shift it horizontally and vertically, but for a currently unknow reason we encounted a bug if we didn't enter    the location with the right movement, causing the character to only move vertically OR horizontally and not both. Having the teleport    only be vertical worked fine, fixing the issue. 
   
   

Contributions 

   Except for the final screen, the whole project was worked on together. Johnny got the final screen working, along with the screen        that would open up when you finish. I got the barriers working with the right offset from the draw, and this Wiki. 


Known Issues 

   Currently we have no known issues with the program.


Intellectual Property 


   Ross Cortino sent us the original link to the youtube tutorial that contained the VGA Core code that was the basis for the project. 
   He also sent us an extra line of code that was missing; 
   
	   VGA_CLK <= clk25;
	   
  At the bottom of the readme is the full code that we had written. The full code is uploaded as Maze_Game.vhd
	   
	   
Conclusion 

   The largest difficulty with this project was getting the VGA core up and running. Once that was done, it just took a little work to      get each of the proccess to work with eachother. The biggest issue outside of the VGA core was the teleporter, as it would 
   work about 50% of the time when it had vertical and horizontal position changes. Changing it to vertical only fixed the issue.
   
   
   
References 

   As said under our design process, the tutorial for the VGA core we used was https://www.youtube.com/watch?v=eJMYVLPX0no.                https://drive.google.com/file/d/0B9T_kQ0ObLf7THpQSWpsT0xEMFE/view contains the code for the VGA core. 
   
   
   
   
Intellectual Property 
 
  Below is the code that was written between John Hoffer and I, Michael Nelson. The rest of the code came from the VGA Core tutorial or   Ross Cortino. 
  
		  drawChar:process(clk25, RST, hPos, vPos, videoOn, charCenterH, charCenterV)
		begin
			if(RST = '1')then
				RGB <= "000";
			elsif(clk25'event and clk25 = '1')then
				if(videoOn = '1')then
					if not(charCenterV >=455  and charCenterV <= 470  and CharCenterH >= 600 and CharCenterH <= 634) then

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
					elsif (vPos >= 436 and vPos <=470 and hPos >= 601 and hPos <= 634) then -- end
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
				if (charCenterV >= 200 and charCenterV <=225 and charCenterH >= 610 and charCenterH <= 630) then

					charCenterV <= 249;
					charCenterH <= 15;

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
				elsif (charCenterV >= 279 and charCenterV <= 500 and charCenterH = 606) then -- bottom 6 right
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
  
   
   
	  
	  
	   

  


		



 
 
