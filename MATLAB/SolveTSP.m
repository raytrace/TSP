function [Path] = SolveTSP(Nodes,Edges)
% solve the Travelling Salesman Problem

if isempty(Edges)
    Edges = BuildEdges(Nodes,2);
end

Graphs = {};
G.Nodes = Nodes;
G.Edges = Edges;
Graphs{1} = G;
i = 1;

while length(Graphs{i}.Nodes.ID) > 8,
    G = [];
    [G.Nodes G.Edges G.ClusterMap] = StrictBifurcateGraph(Graphs{i}.Nodes, Graphs{i}.Edges);
    i = i+1;
    Graphs{i} = G;
end

NGraphs = i;
Graphs{i}.Path = FindShortestPathTSP(Graphs{i}.Nodes);

% paste the solutions together
for g=NGraphs:-1:2
    Graphs{g-1}.OrigPath = SolveSubPathTSP(Graphs{g}.Path,Graphs{g}.ClusterMap,Graphs{g-1}.Nodes);
    if length(Graphs{g-1}.OrigPath) < 5000,
        Graphs{g-1}.Path = TwoOptFull(Graphs{g-1}.Nodes,Graphs{g-1}.OrigPath);
    else
        Edges = BuildEdges(Graphs{g-1}.Nodes,2);
        NIter = round(log(length(Graphs{g-1}.OrigPath)).*1000); % changing this changes speed and quality of solution
        Graphs{g-1}.Path = TwoOptSparse(Graphs{g-1}.Nodes,Edges,Graphs{g-1}.OrigPath,NIter);
    end
end

Path = Graphs{1}.Path;

return
