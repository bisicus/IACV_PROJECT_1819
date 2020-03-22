function ratio = cross_ratio(A,B,C,D)
%CROSS_RATIO Given four points in 2D homogenous coordinates returns their
% crossratio value
% OUTPUTS:
%    * ratio - double value:
%
% INPUTS:
%    * Xi - 2d homogeneous points represented in a row vector
%        Xi = [x, y, 1]
%
% PROCEDURE:
%    * ratio = (|A,C|*|B,D|) / (|B,C|*|A,D|)
%
%                      |xi , xj| 
%    * |Xi, Xj| = det( |yi , yj| )

% Transformingn from homogeneous coordinates to Euclidean.
% NOTE: Assuming that last homogeneous coordinate 'w' is 1 
% There's also need to transpose all vectors since inputs are Rows
A = A(1:2)';
B = B(1:2)';
C = C(1:2)';
D = D(1:2)';

M1 = [A, C];
M2 = [B, D];
M3 = [B, C];
M4 = [A, D];

ratio = ( det(M1) * det(M2) ) / ( det(M3) * det(M4) );

end

