# Maze_Game

Introduction 

  For the project we decided, with input from our professor, to make a basic maze game with a few additional features. We added a teleported to move between 'levels',   a reset, so you can start the game over, and a win screen once you reach the end. 



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
	  
	  
	   

  


		



 
 
