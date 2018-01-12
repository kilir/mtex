function sF = quadrature(f, varargin)
%
% Syntax
%  sF = S2FunHarmonic.quadrature(nodes,values,'weights',w)
%  sF = S2FunHarmonic.quadrature(f)
%  sF = S2FunHarmonic.quadrature(f, 'bandwidth', bandwidth)
%
% Input
%  values - double (first dimension has to be the evaluations)
%  nodes - @vector3d
%  f - function handle in vector3d (first dimension has to be the evaluations)
%
% Output
%   sF - @S2FunHarmonic
%
% Options
%  bandwidth - minimal degree of the spherical harmonic (default: 128)
%

bw = get_option(varargin, 'bandwidth', 128);
if isa(f,'function_handle')
  if check_option(varargin, 'gauss')
    [nodes, W] = quadratureS2Grid(2*bw, 'gauss');
  else
    [nodes, W] = quadratureS2Grid(2*bw);
  end
  values = f(nodes(:));
else
  nodes = f(:);
  values = varargin{1};
  W = get_option(varargin,'weights',1);
end

% initialize nfsft
nfsftmex('precompute', bw, 1000, 1, 0);
plan = nfsftmex('init_advanced', bw, length(nodes), 1);
nfsftmex('set_x', plan, [nodes.rho'; nodes.theta']); % set vertices
nfsftmex('precompute_x', plan);

s = size(values);
values = reshape(values, length(nodes), []);
num = size(values, 2);

fhat = zeros((bw+1)^2, num);
for index = 1:num
  % adjoint nfsft
  nfsftmex('set_f', plan, W(:) .* values(:, index));
  nfsftmex('adjoint', plan);
  fhat(:, index) = nfsftmex('get_f_hat_linear', plan);
end

% finalize nfsft
nfsftmex('finalize', plan);

% maybe we have a multivariate function
try
  fhat = reshape(fhat, [(bw+1)^2 s(2:end)]);
end
sF = S2FunHarmonic(fhat);
sF.bandwidth = bw;

% if antipodal consider only even coefficients
if check_option(varargin,'antipodal') || nodes.antipodal 
  sF = sF.even;
end

end
