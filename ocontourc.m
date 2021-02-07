function oC = ocontourc(x, y, z, NV, cgt)
%OCONTOURC Calculates contours with consistent orientation
%   oC = ocontourc(x, y, z) calculates oriented contour curves
%   such that the field variable greater than the iso-level is on a
%   consistent side of the curve.
%
%   x, y, z, are the parameters passed to contourc used to calculate the
%   contour curve.  x and y are vectors, z is a matrix.
%
%   oC = ocontourc(x, y, z, NV ) NV is passed on to contourc.  NV is used
%   to specify the number of levels or a vector of specific levels:
%
%   oC = ocontourc(x, y, z, N)  To specify N contour levels.
%   oC = ocontourc(x, y, z, V)  To specify contours at levels V.
%
%   oC = ocontourc(x, y, z, NV, cgt) cgt is a flag (true/false) to
%   identify which orientation is preferred.  The default value is true.
%   An empty vector [] can be passed to NV to allow contourc to use its
%   default behavior while specifying cgt.
%
%   See also CONTOURC.

%   Rob McDonald 
%   ramcdona@calpoly.edu  
%   19 February 2013 v. 1.0

if( nargin < 4 )
  C = contourc( x, y, z );
else
  if( isempty(NV) )
    C = contourc( x, y, z );
  else
    C = contourc( x, y, z, NV );
  end
end

if( nargin < 5 )
  cgt = true;
end 

oC = C;  % Initialize to same size.

nx = length(x);
ny = length(y);

nlimit=size(C,2);
icont=1;
while( icont < nlimit )
  zc = C( 1, icont );
  n = C( 2, icont );
  
  % Pick off contour points
  xc = C( 1, icont+1:icont+n );
  yc = C( 2, icont+1:icont+n );
  
  % Use histogram calculator to place contour points in bins.
  % x(k) <= xc < x(k+1)
  [~,kx] = histc(xc,x);
  kx(xc < x(1) | ~isfinite(xc)) = 1;
  kx(xc >= x(nx)) = nx-1;

  [~,ky] = histc(yc,y);
  ky(yc < y(1) | ~isfinite(yc)) = 1;
  ky(yc >= y(ny)) = ny-1;
  
  % Given point on contour is bounded by
  % z(kx,ky) z(kx+1,ky) z(kx,ky+1) z(kx+1,ky+1)
  
  % Find the longest segment of the chain.  This protects against
  % zero-length segments.
  ilong = longseg( xc, yc );
  
  % Form long line segment.
  p0(1) = xc(ilong);
  p0(2) = yc(ilong);
  
  p1(1) = xc(ilong+1);
  p1(2) = yc(ilong+1);
  
  % Find the furthest point in the grid from the line segment.
  [ifar, jfar] = furthestpt( p0, p1, kx(ilong), ky(ilong), x, y );
  
  pf(1) = x(ifar);
  pf(2) = y(jfar);
  
  % Find which side of the line segment the furthest point is on.
  s = orient( p0, p1, pf );
  
  % Test line orientation and constraint magnitude -- flip the chain
  % orientation if required.
  if(cgt)
    if( z(jfar, ifar) > zc )
      if( s < 0 )
        xc = fliplr(xc);
        yc = fliplr(yc);
      end
    else
      if( s > 0 )
        xc = fliplr(xc);
        yc = fliplr(yc);
      end
    end
  else
    if( z(jfar, ifar) < zc )
      if( s < 0 )
        xc = fliplr(xc);
        yc = fliplr(yc);
      end
    else
      if( s > 0 )
        xc = fliplr(xc);
        yc = fliplr(yc);
      end
    end
  end
  
  % Re-assemble the oriented contour.
  oC(1,icont+1:icont+n) = xc;
  oC(2,icont+1:icont+n) = yc;
  
  icont = icont + n + 1;
end


end

% Check which side of a line segment a point is on.
function s = orient( p0, p1, p )
u = p1 - p0;
v(1) = -u(2);
v(2) = u(1);
s = dot( p - p0, v );
end

% Find the longest segment of a curve.
function ilong = longseg( x, y )

n = length(x);

lmx = -1;
ilong = 0;

for i=1:n-1
  p0(1) = x(i);
  p0(2) = y(i);
  
  p1(1) = x(i+1);
  p1(2) = y(i+1);
  
  l = norm( p1 - p0, 2 );
  
  if( l > lmx )
    lmx = l;
    ilong = i;
  end  
end
end

% Find the furthest surrounding point in a mesh to a line segment.
function [ifar, jfar] = furthestpt( p0, p1, ibin, jbin, x, y )

ix = [ 0, 1, 1, 0 ];
jy = [ 0, 0, 1, 1 ];

rmx = -1;
imx = 0;

for i = 1:4

  p(1) = x( ibin + ix(i) );
  p(2) = y( jbin + jy(i) );
  
  r = distPointToLineSegment( p0, p1, p );
  
  if( r > rmx )
    rmx = r;
    imx = i;
  end  
end

ifar = ibin + ix(imx);
jfar = jbin + jy(imx);
end

% Calculate the distance from a line segment to a point.
function r = distPointToLineSegment( xy0, xy1, xyP )

vx = xy0(1)-xyP(1);
vy = xy0(2)-xyP(2);
ux = xy1(1)-xy0(1);
uy = xy1(2)-xy0(2);

lenSqr= (ux*ux+uy*uy);
detP= -vx*ux + -vy*uy;

if( detP < 0 )
  r = norm(xy0-xyP,2);
elseif( detP > lenSqr )
  r = norm(xy1-xyP,2);
else
  r = abs(ux*vy-uy*vx)/sqrt(lenSqr);
end
end

