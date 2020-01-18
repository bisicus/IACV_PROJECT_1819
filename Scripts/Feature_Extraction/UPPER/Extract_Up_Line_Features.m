I = up_video.WhiteKeys_Mask;
BW = bwperim(I);
% figure(1); imshow(BW)

%% Horizontal Lines
% Note: theta is the angle between houghline and horizontal axis, so in
% order to catch bins belonging to horizontal lines there's need to set
% theta value near 90°
% 
[H,theta,rho] = hough(BW,'Theta',80:0.5:89, 'RhoResolution', 1);

P  = houghpeaks(H,5, ...
               'threshold',ceil(0.3*max(H(:))) ...
   );

%{
figure(2)
imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(theta(P(:,2)),rho(P(:,1)),'s','color','white');
%}

lines = houghlines(BW,theta,rho,P, ...
                  'FillGap', 103);


%% Lines Ordering
% Lines are Sorted by distance w.r.t. Coordinate System Origin that is on
% Top-Left Corner

rho = [lines.rho]';
[~, ind] = sortrows(rho, 'ascend');
lines = lines(ind);

%{
figure(3), imshow(BW), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end
%}


%% Saving for further computations

up_geometric_features.keys_start_line = ...
               HoughLine_to_homog(lines(1));
            
up_geometric_features.blackKey_end_line = ...
               HoughLine_to_homog(lines(2));
            
up_geometric_features.whiteKey_end_line = ...
               HoughLine_to_homog(lines(3));

%% Clear Workspace

clear BW I
clear H P rho theta
clear lines ind
            

