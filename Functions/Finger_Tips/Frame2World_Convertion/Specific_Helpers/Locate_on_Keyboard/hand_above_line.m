function [outputArg1,outputArg2] = hand_above_line(inputArg1,inputArg2)
%HAND_ABOVE_LINE returns a Boolean indicating if given selected hand is
%Above or Below a given line.
%
% IMPORTANT NOTE:
%    Since Image coordinate system origin is placed on Top-left corner of
%    image itself, Y grows going down.
%    This implies that 'above' and 'below'
%
%
% OUTPUTS:
%    * result - logical value
%
%
% INPUTS:
%    * point - 2d homogeneous vector represented as a row vector [x, y, 1]
%
%    * line - 2d homogeneous vector represented as a row vector [a, b, c]
%
%
% PROCEDURE:
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

