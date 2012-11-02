function plotipdf(odf,r,varargin)
% plot inverse pole figures
%
%% Input
%  odf - @ODF
%  r   - @vector3d specimen directions
%
%% Options
%  RESOLUTION - resolution of the plots
%
%% Flags
%  antipodal    - include [[AxialDirectional.html,antipodal symmetry]]
%  COMPLETE - plot entire (hemi)--sphere
%
%% See also
% S2Grid/plot savefigure Plotting Annotations_demo ColorCoding_demo PlotTypes_demo
% SphericalProjection_demo


%% make new plot
[ax,odf,r,varargin] = getAxHandle(odf,r,varargin{:});
if isempty(ax), newMTEXplot;end

argin_check(r,{'vector3d'});

%% plotting grid
[maxtheta,maxrho,minrho] = getFundamentalRegionPF(odf(1).CS,varargin{:});
if isnumeric(maxtheta), maxtheta = min(maxtheta,pi/2);end
h = S2Grid('PLOT','MAXTHETA',maxtheta,'MAXRHO',maxrho,'MINRHO',minrho,'RESTRICT2MINMAX',varargin{:});

%% plot
disp(' ');
disp('Plotting inverse pole density function:')

multiplot(ax{:},numel(r), h,...
  @(i) ensureNonNeg(pdf(odf,h,r(i)./norm(r(i)),varargin{:})),...
  'smooth','TR',@(i) r(i),varargin{:});

%% finalize plot
if isempty(ax)
  setappdata(gcf,'r',r);
  setappdata(gcf,'CS',odf(1).CS);
  setappdata(gcf,'SS',odf(1).SS);
  set(gcf,'tag','ipdf');
  setappdata(gcf,'options',extract_option(varargin,'antipodal'));
  name = inputname(1);
  if isempty(name), name = odf(1).comment;end
  set(gcf,'Name',['Inverse Pole Figures of ',name]);
end
