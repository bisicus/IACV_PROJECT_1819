function [homogen_line, p1, p2] = line_to_homog(line)
    p1 = [line.point1, 1];
    p2 = [line.point2, 1];

    homogen_line = homog_cross(p1, p2);
    
end