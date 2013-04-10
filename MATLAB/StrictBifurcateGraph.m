function [CNodes CEdges ClusterMap] = StrictBifurcateGraph(Nodes, Edges)
% pair up each node with nearest neighbor... return a graph with new nodes

CNodes = [];

EdgeMap = zeros(length(Nodes.ID),2);
for i=1:length(Nodes.ID)
    Dists = Edges(i,:);
    jdx = find(Dists > 0);
    [mindist,j] = min(Dists(Dists ~= 0));
    EdgeMap(i,1) = mindist;
    EdgeMap(i,2) = jdx(j);
end
%save EdgeMap.mat EdgeMap

ClusterMap = zeros(size(Nodes.ID));
CEdgeMap = EdgeMap;
nclust = 0; CEdges = Edges;
while 1,
    [mindist,x] = min(CEdgeMap(:,1)); % minimum edge remaining
    
    if isinf(mindist), break; end % no more nodes to process
    
    y = CEdgeMap(x,2);
    nclust = nclust + 1;
    ClusterMap(x) = nclust;
    ClusterMap(y) = nclust;
    
    % remove these nodes
    CEdgeMap(x,1) = Inf; CEdgeMap(y,1) = Inf;
    CEdgeMap(x,2) = 0; CEdgeMap(y,2) = 0;
    CEdges(:,x) = 0; CEdges(x,:) = 0;
    CEdges(:,y) = 0; CEdges(y,:) = 0;
    
    idx = find(CEdgeMap(:,2) == x | CEdgeMap(:,2) == y); % recalc min dist
    for i=1:length(idx)
        Dists = CEdges(idx(i),:);
        jdx = find(Dists > 0);
        if isempty(jdx), % no more neighbors... make it its own cluster
            nclust = nclust + 1;
            ClusterMap(idx(i)) = nclust;
            CEdgeMap(idx(i),1) = Inf; CEdgeMap(idx(i),2) = 0;
        else
            [mindist,j] = min(Dists(Dists~=0));
            CEdgeMap(idx(i),1) = mindist;
            CEdgeMap(idx(i),2) = jdx(j);
        end
    end
end

% create nodes and edges with the clustered mapping
CNodes.ID = [0:nclust-1]';
CNodes.X = zeros(nclust,1);
CNodes.Y = zeros(nclust,1);
CNodes.Map = ClusterMap;

for i=1:nclust
    idx = find(ClusterMap==i);
    CNodes.X(i) = mean(Nodes.X(idx));
    CNodes.Y(i) = mean(Nodes.Y(idx));
end

CEdges = BuildEdges(CNodes,4);
