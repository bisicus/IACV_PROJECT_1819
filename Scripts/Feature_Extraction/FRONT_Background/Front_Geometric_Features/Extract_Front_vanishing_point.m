I = front_video.WhiteKeys_Mask;
BW = bwperim(I);

%% Vanishing Point
[H,T,R] = hough(BW,'Theta',-45:0.5:45, 'RhoResolution', 1);

P  = houghpeaks(H,80,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,T,R,P,'MinLength', 40);

% figure(1000)
% imshow(H,[],'XData',T,'YData',R,...
%             'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% x = T(P(:,2)); y = R(P(:,1));
% plot(x,y,'s','color','white');



%% Post Production

% Deletion of vertical lines
theta = [lines.theta]';
[theta, ind] = sortrows(theta, 'descend');
lines = lines(ind);

ind = (theta < -15) | (theta > 15);
lines = lines(ind);


%% Divide Theta array w.r.t vertical simmetry axis on image
thsh = 20; % hardocoded threshold delimiting image

[~, max_ind] = max( abs( theta(1:end-1) -  theta(2:end) ) );

lines_left = lines( 1:max_ind );

% Reordering w.r.t. keys from left to right
point1 = reshape([lines_left.point1]', 2, [])';
[point1, ind] = sortrows(point1, [1, 2], 'ascend');
lines_left = lines_left(ind);

% Rough deletion of lines near border of the screen:
%     since lines are sorted all vertical lines that have point1-x 
%     coordinate near image border need to be removed
del_idx = sum(point1(:,1) < thsh);
lines_left = lines_left(del_idx+1 : end);


% ------- %
lines_right = lines( max_ind+1:end );

% Reordering w.r.t. keys from left to right
point1 = reshape([lines_right.point1]', 2, [])';
[point1, ind] = sortrows(point1, [1, 2], 'ascend');
lines_right = lines_right(ind);

% Rough deletion of lines near border of the screen:
del_idx = sum(point1(:,1) > size(I, 2)-thsh);
lines_right = lines_right(1:end - del_idx);


%%
% figure(1001); imshow(BW); hold on
% 
% for k = 1:length(lines_left)
%    xy = [lines_left(k).point1; lines_left(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% end
% for k = 1:length(lines_right)
%    xy = [lines_right(k).point1; lines_right(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% end

%% Find Vanishing Point:
%{
    in order to mitigate distortion introduced by camera, beacuse of which
    "white keys" horizontal line appears 'curve' all left_lines are 
    intersect with all right lines in order to obtain candidates 'vanishing
    points'.
    All points will be averaged giving single vanishing point
%}

% pre-allocation for speed
vanish_points = zeros(...
length(lines_left) * length(lines_right),...
3 ...
);

for ii = 1:length(lines_left)

   l1 = HoughLine_to_homog(lines_left(ii));
   %     [l1, p1, p2] = HoughLine_to_homog(lines_left(ii));

   for jj = 1:length(lines_right)

      l2 = HoughLine_to_homog(lines_right(jj));
      %         [l2, t1, t2] = HoughLine_to_homog(lines_right(jj));

      vp = homog_cross(l1,l2);
      
      % Comping right index where to store
      k = (ii-1) * length(lines_right) + jj;
      vanish_points(k, :) = vp;

      %         plot(vp(1), vp(2), 'x')
      %         plot([p2(1), vp(1)], [p2(2), vp(2)], 'LineWidth',2,'Color','green');
      %         plot([t2(1), vp(1)], [t2(2), vp(2)], 'LineWidth',2,'Color','green');

   end
end

%% Center of Mass

front_geometric_features.vanish_point = mean(vanish_points, 1);
% plot(front_vanish_point(1), front_vanish_point(2), 'bo', 'LineWidth', 10)


%% Cleaning Workspace

clear H P R T x y
clear BW I thsh xy
clear ii jj k l1 l2 p1 p2 t1 t2
clear theta ind del_idx max_ind point1
clear lines lines_left lines_right
clear vp vanish_points