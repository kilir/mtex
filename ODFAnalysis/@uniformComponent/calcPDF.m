function pdf = calcPDF(~,h,r,varargin)
% calculate pdf 

if isempty(h) || nargin==2 || isempty(r)
  
  pdf = S2FunHarmonic(1);
  
else
  
  pdf = ones(size(h) .* size(r));
  
end
