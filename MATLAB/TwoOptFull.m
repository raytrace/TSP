function [Path NewDist] = TwoOptFull(Nodes,Path)
% optimize the path using 2-opt.

NNodes = length(Path);

Edges = zeros(NNodes,NNodes);
for i=1:NNodes
    Edges(i,i) = Inf;
    for j=i+1:NNodes
        Edges(i,j) = norm([Nodes.X(j) Nodes.Y(j)] - [Nodes.X(i) Nodes.Y(i)]);
        Edges(j,i) = Edges(i,j);
    end
end

zmin = -1;

% optimize path
while zmin < -0.001
    zmin = -0.001;
    i = 0;
    b = Path(NNodes);

    % Loop over all edge pairs (ab,cd)
    while i < NNodes-2
        a = b;
        i = i+1;
        b = Path(i);
        Dab = Edges(a,b);
        j = i+1;
        d = Path(j);
        while j < NNodes
            c = d;
            j = j+1;
            d = Path(j);
            % Tour length diff z
            % Note: a == d will occur and give z = 0
            z = (Edges(a,c) - Edges(c,d)) + Edges(b,d) - Dab;
            % Keep best exchange
            if z < zmin
                zmin = z;
                imin = i;
                jmin = j;
            end
        end
    end

    % Apply exchange
    if zmin < -0.001
        Path(imin:jmin-1) = Path(jmin-1:-1:imin);
        ind = sub2ind([NNodes,NNodes],Path,[Path(2:NNodes);Path(1)]);
        PDist = Edges(ind);
        fprintf('z = %1.4f, dist = %1.4f\n', zmin, sum(PDist));
    end
end

% Tour length
ind = sub2ind([NNodes,NNodes],Path,[Path(2:NNodes);Path(1)]);
PDist = Edges(ind);
NewDist = sum(PDist);
