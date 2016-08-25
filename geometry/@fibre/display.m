function display(f,varargin)
% standard output

if ~check_option(varargin,'skipHeader')
  disp(' ');
  disp([inputname(1) ' = ' doclink('fibre_index','fibre') ...
    ' ' docmethods(inputname(1))]);
end

disp([' size: ' size2str(f)]);

% display symmetry
dispSym(f.CS);
dispSym(f.SS);

if f.antipodal, disp(' antipodal: true'); end

if length(f)>1, return; end

% display starting and end orientation
disp([' o1: ' char(f.o1)]);
if isa(f.o2,'rotation'), disp([' o2: ' char(f.o2)]); end

return



f = 1;

% display coordinates
if isa(f.CS,'crystalSymmetry')
  if any(strcmp(f.b.CS.lattice,{'hexagonal','trogonal'}))
    d = [f.b.UVTW f.n.hkl];
    d(abs(d) < 1e-10) = 0;
    cprintf(d,'-L','  ','-Lc',{'U' 'V' 'T' 'W' '| H' 'K' 'I' 'L'});
  else
    d = [f.b.uvw f.n.hkl];
    d(abs(d) < 1e-10) = 0;
    cprintf(d,'-L','  ','-Lc',{'u' 'v' 'w' '| h' 'k' 'l'});
  end
else
  d = round(100*[f.b.xyz f.n.xyz])./100;
  d(abs(d) < 1e-10) = 0;
  cprintf(d,'-L','  ','-Lc',{'x' 'y' 'z' ' |   x' 'y' 'z' });
end

return


% display coordinates
if ~check_option(varargin,'skipCoordinates') && ...
    (check_option(varargin,'all') || (length(f) < 20 && ~isempty(f)))
  
  d = [f.x(:),f.y(:),f.z(:)];
  d(abs(d) < 1e-10) = 0;
  
  cprintf(d,'-L','  ','-Lc',{'x' 'y' 'z'});
end

end

function dispSym(s)

if isa(s,'crystalSymmetry')
  if ~isempty(s.mineral)
    disp([' mineral: ',char(s,'verbose')]);
  else
    disp([' crystal symmetry:  ',char(s,'verbose')]);
  end
elseif s.id > 2
  disp([' specimen symmetry: ',char(s,'verbose')]);
end

end