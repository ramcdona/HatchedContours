function h=hatchedline(xc,yc,linespec,theta,ar,spc,len,varargin)
%HATCHEDLINE Plot curve with hatched style
%   H=hatchedline(XC,YC,LINESPEC,THETA,AR,SPC,LEN,VARARGIN) plots the curve 
%   specified in the vectors (XC, YC) with a hatched line style appropriate
%   for constriant diagrams.  
%
%   The line style is specified by LINESPEC in the standard format used 
%   by the plot command.  If not specified, a solid blue line is drawn
%   LINESPEC='b-'.
%
%   The tick angle (in radians) is specified in THETA.  When plotting curves
%   generated by contourc, positive THETA will point the hatches in the
%   decreasing direction of the contour variable.  If not specified,
%   THETA=45*pi/180 is used.
%
%   The aspect ratio of the plot window (y range divided by x range) is 
%   specified in AR.  If not specified, the current axes aspect ratio is
%   used.
%
%   The tick spacing is specified in SPC.  If positive, SPC is taken in
%   units of the x coordinate.  If negative, SPC is taken as a fraction of
%   the x range.  If not specified, -0.02 for 2% of x range is used.
%
%   The tick length (relative to the tick spacing) is specified in LEN.  If
%   not specified, SPC=1.4.
%
%   Any remaining options are passed to the plot command.  These may be
%   used to change line weights etc.
%
%   The graphics handles for all of the curves are returned in H.
%
%   See also HATCHEDCONTOURS, CONTOURC.

%   Rob McDonald 
%   ramcdona@calpoly.edu  
%   12 December 2006 v. 1.0
%   11 March 2007 v. 1.5 -- Rearranged inputs, added defaults for variable
%                           argument list.  Incompatible calling
%                           convention.


% Default blue solid line
if(nargin < 3)
  linespec='b-';
end

% Default angle
if(nargin<4)
  theta=45*pi/180;
end

% As Default, read aspect ratio from chart.
if(nargin<5)
  ax=axis;
  ar=(ax(4)-ax(3))/(ax(2)-ax(1));
end

% Default tick spacing
if(nargin<6)
   spc=-0.02;
end

% Default length
if(nargin<7)
  len=1.4;
end

% Done handling input options.

% 'dimensionalize' spc if specified nondimensional
if(spc < 0)
  ax=axis;
  spc=-spc*(ax(2)-ax(1));
end

% 'dimenionalize' length
len=spc*len;

% Find distance between points on the line
ds=((xc(2:end)-xc(1:end-1)).^2+((yc(2:end)-yc(1:end-1))/ar).^2).^0.5;

% Mask for elements of zero length
imask=(ds~=0);

% Eliminate duplicate points for interp1
ds=ds(imask);
xc=xc([imask true]);
yc=yc([imask true]);

% Build parametric coordinate along curve 
s=[0 cumsum(ds)];
stot=s(end);

% Pick parameter values for ticks.
stick=linspace(0,stot,ceil(stot/spc));

% Find points along the parameterized curve
xtick=interp1(s,xc,stick);
ytick=interp1(s,yc,stick);

% Find vectors in local direction of curve
u=(interp1(s,xc,stick+spc/100)-xtick)/spc;
v=(interp1(s,yc,stick+spc/100)-ytick)/(spc*ar);

% Normalize slope into unit slope vector.
dr=(u.^2+v.^2).^0.5;
uv=[u./dr; v./dr];

ct=cos(theta);
st=sin(theta);
T=[ct -st;st ct];

% Rotate and scale unit vector into tick vector
dxy=(uv'*T)'*len;

% Plot the curve and the ticks.
h=plot(xc,yc,linespec,[xtick; xtick+dxy(1,:)],[ytick; ytick+dxy(2,:)*ar],linespec,varargin{:});

