function h=hatchedcontours(C,varargin)
%HATCHEDCONTOURS Plot contours with hatched style
%   H=hatchedcontours(C,VARARGIN) plots the 
%   contours specified in C with a hatched line style appropriate for 
%   constriant diagrams.  The remaining parmeters describe the hatch 
%   style as described in HATCHEDCONTOURS.
%
%   The graphics handles for all of the curves are returned in H.
%
%   See also HATCHEDLINE, CONTOURC.

%   Rob McDonald 
%   ramcdona@calpoly.edu  
%   12 December 2006 v. 1.0
%   11 March 2007 v. 1.5 -- Rearranged inputs, added defaults for variable
%                           argument list.  Incompatible calling
%                           convention.

% Break contour array C into curves for individual plotting and plot them.

% Store axis setting in case figure is cleared.
ax=axis;

holdsetting=ishold;
if(~holdsetting) 
  clf
  axis(ax);
end
hold on;

nlimit=size(C,2);
h=[];
icont=1;
while(icont<nlimit)
  n=C(2,icont);
  
  % Pick off contour points
  xc=C(1,icont+1:icont+n);
  yc=C(2,icont+1:icont+n);
  
  % Plot hatched curves
  h=[h; hatchedline(xc,yc,varargin{:})];
  icont=icont+n+1;
end

if(~holdsetting)
  hold off;
end