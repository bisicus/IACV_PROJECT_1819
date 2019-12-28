function ratio = cross_ratio(X1,X2,X3,X4)
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
%    * ratio = (|X1, X2|*|X3, X4|) / (|X1, X3|*|X2, X4|)
%
%                     (xi | xj)
%    * |Xi, Xj| = det( ------- )
%                     (yi | yj)

% Transformingn from homogeneous coordinates to Euclidean.
% NOTE: Assuming that last homogeneous coordinate 'w' is 1 
% There's also need to transpose all vectors since inputs are Rows
X1 = X1(1:2)';
X2 = X2(1:2)';
X3 = X3(1:2)';
X4 = X4(1:2)';

M1 = [X1, X2];
M2 = [X3, X4];
M3 = [X1, X3];
M4 = [X2, X4];

ratio = ( det(M1) * det(M2) ) / ( det(M3) * det(M4) );

end

