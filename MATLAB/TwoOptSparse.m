function [Path NewDist] = TwoOptSparse(Nodes,Edges,Path,NIter)
% optimize the path using 2-opt. 

NNodes = length(Path);

ind = sub2ind([NNodes,NNodes],Path,[Path(2:NNodes);Path(1)]);
PDist = Edges(ind);
ind = find(PDist==0);
for i=1:length(ind)
    j = mod(ind(i),NNodes)+1;
    PDist(ind(i)) = norm([Nodes.X(Path(j)) Nodes.Y(Path(j))] - [Nodes.X(Path(ind(i))) Nodes.Y(Path(ind(i)))]);
end

% optimize path, starting from longest edge pair
[~,LongEdges] = sort(PDist,'descend');
j = 1;
for iter=1:NIter
    a = Path(LongEdges(j)); 
    b = Path(mod(LongEdges(j),NNodes)+1);
    Dab = PDist(LongEdges(j));
    
    zmin = -0.001;

    for i=1:NNodes-1
        c = Path(i);
        if a == c, continue; end
        d = Path(i+1);
    
        Dac = Edges(a,c);
        if Dac == 0,
            Dac = norm([Nodes.X(a) Nodes.Y(a)] - [Nodes.X(c) Nodes.Y(c)]);
        end
        Dbd = Edges(b,d);
        if Dbd == 0,
            Dbd = norm([Nodes.X(b) Nodes.Y(b)] - [Nodes.X(d) Nodes.Y(d)]);
        end
        Dcd = Edges(c,d);
        if Dcd == 0,
            Dcd = norm([Nodes.X(c) Nodes.Y(c)] - [Nodes.X(d) Nodes.Y(d)]);
        end
            
        z = (Dac - Dcd) + Dbd - Dab;
        % Keep best exchange
        if z < zmin
            zmin = z;
            dmin = d;
        end
    end

    % Apply exchange
    if zmin < -0.001
        Path = Path([LongEdges(j):NNodes 1:LongEdges(j)-1]);
        imin = find(dmin == Path);
        Path(2:imin-1) = Path(imin-1:-1:2);
        ind = sub2ind([NNodes,NNodes],Path,[Path(2:NNodes);Path(1)]);
        PDist = Edges(ind);
        ind = find(PDist==0);
        for i=1:length(ind)
            ii = mod(ind(i),NNodes)+1;
            PDist(ind(i)) = norm([Nodes.X(Path(ii)) Nodes.Y(Path(ii))] - [Nodes.X(Path(ind(i))) Nodes.Y(Path(ind(i)))]);
        end
        [~,LongEdges] = sort(PDist,'descend');
        fprintf('Iter %d: z = %1.4f, dist = %f\n', iter, full(zmin), full(sum(PDist)));
    else
        fprintf('Iter %d: no improvement\n', iter);
        j = j + 1;
        if j==NNodes, j = 1; end % reset it back to beginning
    end
end

% Tour length
NewDist = full(sum(PDist));
