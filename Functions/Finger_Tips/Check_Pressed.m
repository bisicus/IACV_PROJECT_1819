function [WHT_pressed_idxs, BLK_pressed_idxs] = ...
                  Check_Pressed( Z_Front, Z_Up, ...
                                 angle, BLK_height, ...
                                 Up_Tips, ...
                                 up_video_struct)
%CHECK_PRESSED Summary of this function goes here
%   Detailed explanation goes here

   % ===== Check White Pressed ===== %
   WHT_pressed_idxs = find( Z_Up > Z_Front);
   
   % Remove 'Pressed White Keys' from input Coordinates, if any
   Z_Front(WHT_pressed_idxs) = [];
   Z_Up(WHT_pressed_idxs) = [];
   
   
   % ===== Check Balck Pressed ===== %
   base = abs( Z_Front - Z_Up );
   height = base / tan(angle);
   
   BLK_pressed_idxs = find( height < BLK_height);
   
   [nearest_key, dists] = find_nearest_idxs( up_video_struct.BLACK_Keys_centerCoord, ...
                                             Up_Tips, ...
                                             1, ...
                                             'method', 'only_x' );
   
   
   
   % ----- Black Pressed Sanitation ----- % TODO: Aggiungi documentazione
   % Devo controllare se i tasti identificati sono realmente sopra un tasto
   % nero. Per farlo il tip deve essere distante dal centroide meno di 2/3
   % della lunghezza del tasto.
   
   
   pressed_idxs = sort(pressed_idxs, 'ascend');
   if ~isempty(pressed_idxs)
      disp(['The result is: [' num2str(pressed_idxs(:).') '], at frame: ' num2str(frame_counter)]) ;
   end

end

