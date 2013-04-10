function [Edges] = BuildEdges(Nodes,nNeighbours)
% make x edges per node with closest neighbors

Edges = sparse(length(Nodes.ID),length(Nodes.ID));
for i=1:length(Nodes.ID)
    Dists = zeros(length(Nodes.ID),1);
    for j=1:length(Nodes.ID)
        Dists(j) = norm([Nodes.X(i) Nodes.Y(i)] - [Nodes.X(j) Nodes.Y(j)]);
    end
    Dists(i) = Inf;
    [~,idx] = sort(Dists,'ascend');
    for j=1:nNeighbours,
        Edges(i,idx(j)) = Dists(idx(j));
        Edges(idx(j),i) = Dists(idx(j));
    end
end
