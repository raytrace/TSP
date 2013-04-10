TSP
===

Solve the traveling salesman problem for extremely large graphs directly.

It does this via clustering nodes until the problem becomes trivial, then iteratively de-clustering to add the de-clustered nodes to the path:

1. Bifurcate the nodes: pair up nodes to nearest neighbors to form new nodes, until all nodes are paired or single.
2. Form new nodes from the clusters.
3. Repeat steps 1-2 until the TSP problem is trivial.
4. Solve the trivial TSP problem.
5. Find the shortest path through the each cluster, and paste together to form a new solution.
6. Optimize the solution using two-opt (this could be improved with three-opt or another method).
7. Repeat 5-6 until all clusters have been converted into the original nodes.

Input is a CSV of nodes with X/Y coordinates, with columns id,x,y.

To call, run:

Nodes = BuildGraph(CSVFile);
Path = SolveTSP(Nodes,Edges);

Edges can be empty, ie Path = SolveTSP(Nodes,[]);

Code was tested on a list of 150,000 nodes and took approximately 1 hour to achieve a fairly good solution.

To improve solution (at the cost of computation time), increase the number of two-opt iterations in SolveTSP().
