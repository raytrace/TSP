function PlotGraph(Nodes,Path)

figure,set(gcf,'Color','white','Position',[150 400 1200 900]),hold on

cmap = colormap('jet');

for i=1:length(Nodes.ID)
    plot(Nodes.X(i),Nodes.Y(i),'*','MarkerEdgeColor',cmap(1,:),'MarkerFaceColor',cmap(1,:))
end

if ~isempty(Path)
    for i=1:length(Path)-1
        x = [Nodes.X(Path(i)) Nodes.X(Path(i+1))];
        y = [Nodes.Y(Path(i)) Nodes.Y(Path(i+1))];
        plot(x,y,'k')
    end
    x = [Nodes.X(Path(end)) Nodes.X(Path(1))];
    y = [Nodes.Y(Path(end)) Nodes.Y(Path(1))];
    plot(x,y,'k')
end

hold off
