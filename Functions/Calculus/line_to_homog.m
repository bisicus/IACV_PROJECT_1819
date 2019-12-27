function [homogen_line_coord, p1, p2] = line_to_homog(line)
    p1 = [line.point1, 1];
    p2 = [line.point2, 1];

    l1 = cross(p1, p2);
    homogen_line_coord = l1 / l1(3);
end