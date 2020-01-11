function Z_Coordinate = tip_2_world_depth(WORLD_Measures,cross_ratio)
%TIP_WORLD_DEPTH computes depth of Finger-Tip in 'World Coordinates
%  System' by mean of relation between Image Cross-Ratio and real world
%  known measurements.
%
% OUTPUTS:
%    * Z_Coordinate - float number defining depth of Finger-Tip w.r.t.
%    World origin system (See PROCEDURE for further details)
%
% INPUT:
%    * WORLD_Measures - struct of hardcoded measuments of world distances:
%
%    * cross_ratio - float number defining cross ratio between 4 points:
%
% 
% PROCEDURE:
% 0) NOTES: Since Cross-Ratio (Cr) is an invariant in in projective
%    transformations, frame's computed value can be used a fixed parameter
%    for real world coordinate system.
%       * input Cr is computed from, in strict order: 
%          - Finger-Tip (T),
%          - Black-Keys finishing border (B),
%          - White-Keys finishing border (W),
%          - Vanishing point (Vp).
% 
%       * WORLD Coordinate System Origin (O) is fixed where keyboard's keys
%       are connected to the plastic command board. Z-axis grows through 
%       keys lenght.
%
%       * OB and OW measumentens are know in WORLD Coordinates and resuts 
%       in Known Distance BW.
%       Distances involving Vanishing Point can be ignored in real world
%       since they result in infinite values.
%
% 1) Cross_ratios are matched together:
%       
%                          TW      BVp
%       Cr_img = Cr_Wld = ----- * -----
%                          TVp     BW
%     
%    Since Infinite Distances can be ignored relation is simplied in:
%       
%       Cr_img = TW / BW   -->   TW = Cr * BW = K
% 
%     
% 2) Since all four points are colinear in both Systems distances are
%    computed using 1D formulas, resulting in depth (Z) of point
% 
%       TW = | Z_t - Z_w | = K
%
% 3) In this framework distances can be translated in coordinates values
%    w.l.o.g., so Z_w is known and will be always bigger than Z_t.
%    Z_t can be computed as 
%       
%       Z_t = Z_w - K


K = WORLD_Measures.Only_White_Portion_lenght * cross_ratio;
Z_Coordinate = WORLD_Measures.White_Keys_End - abs(K);

end

