function figResize(fig,evt,mtexFig) %#ok<INUSL,INUSL>
% resize figure and reorder subfigs

if isempty(mtexFig.children), return;end

% store old units and perform all calculations in pixel
old_units = get(fig,'Units');
set(fig,'Units','pixels');

figSize = get(mtexFig.parent,'Position');
figSize = figSize(3:4) - 2*mtexFig.outerPlotSpacing;

mtexFig.calcBestFit;

% align axes according to the partioning
for i = 1:length(mtexFig.children)
  
  % compute position in raster
  [col,row] = ind2sub([mtexFig.ncols mtexFig.nrows],i);
  
  aw = mtexFig.axisWidth + mtexFig.innerPlotSpacing + sum(mtexFig.tightInset([1,3]));
  ah = mtexFig.axisHeight + mtexFig.innerPlotSpacing + sum(mtexFig.tightInset([2,4]));
  
  axisPos = [1 + mtexFig.outerPlotSpacing + ...
    (col-1)*aw + mtexFig.tightInset(1),...
    figSize(2) + 1 + mtexFig.outerPlotSpacing ...
    - row * ah ...
    + mtexFig.innerPlotSpacing + mtexFig.tightInset(2),...
    mtexFig.axisWidth,mtexFig.axisHeight];
  set(mtexFig.children(i),'Units','pixels','Position',axisPos);
    
  % position the colorbars
  if numel(mtexFig.cBarAxis) == numel(mtexFig.children)
    
    resizeColorBar(mtexFig.cBarAxis(i))
  
  elseif ~isempty(mtexFig.cBarAxis) && i == numel(mtexFig.children) 
    
    resizeColorBar(mtexFig.cBarAxis)
    
  end
end

% revert figure units
set(fig,'Units',old_units);


  function resizeColorBar(cBar)
  
    if ~mtexFig.keepAspectRatio, return; end
    pos = get(cBar,'position');
    if pos(4) > pos(3) % vertical
      set(cBar,'position',...
        [axisPos(1)+mtexFig.axisWidth+10,...
        axisPos(2)+1,...
        pos(3),mtexFig.axisHeight-1]);
    else % horizonal
      set(cBar,'position',...
        [axisPos(1),...
        axisPos(2)-pos(4),...
        mtexFig.axisWidth-1,pos(4)]);
    end
  end
  
function testit

close all
mtexFig = mtexFigure;
mtexFig.gca
rectangle('position',[0,0,1,1])
axis equal  tight
title('asdsa')
xlabel('asd')
mtexFig.nextAxis;
rectangle('position',[0,0,1,1])
axis equal tight
xlabel('asd')

title('asdasd2')
axis(mtexFig.children(1),'off')
axis(mtexFig.children(2),'off')

mtexFig.drawNow

end


end

