function h=hatchedcontours(C,linespec,ar,spc,len,theta)
%HATCHEDCONTOURS Plot contours with hatched style
%   H=hatchedcontours(C,LINESPEC,AR,SPC,LEN,THETA) plots the contours
%   specified in C with a hatched line style appropriate for constriant
%   diagrams.  The remaining parmeters describe the hatch style as
%   described in HATCHEDCONTOURS.
%
%   The graphics handles for all of the curves are returned in H.
%
%   See also HATCHEDLINE, CONTOURC.

%   Rob McDonald 
%   ramcdona@calpoly.edu  
%   12 December 2006 v. 1.0

% Break contour array C into curves for individual plotting and plot them.

holdsetting=ishold;
if(~holdsetting) 
  clf
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
  h=[h; hatchedline(xc,yc,linespec,ar,spc,len,theta)];
  icont=icont+n+1;
end

if(~holdsetting)
  hold off;
end