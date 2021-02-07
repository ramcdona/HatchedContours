clear all
format compact
close all

pfiletype='-dpng';
pfileext='.png';

obj = @(x1,x2) x1^2+x2^2-2*x1-2*x2+2;
g3 = @(x1,x2) -.8-1/((x1)^3)+x2;

x1=linspace(0.01,8,91);
x2=linspace(0.01,8,95);

for i=1:length(x1)
  for j=1:length(x2)
    f(i,j)=obj(x1(i),x2(j));
    con3(i,j)=g3(x1(i),x2(j));
  end
end

x1 = exp(x1);
x2 = exp(x2);


c3=ocontourc(x1,x2',con3',[0 0]);

figure(1)
[c,h]=contour(x1,x2',f',[0.01 0.05 0.2 0.4, 0.8 1.6 3.2 6.4]);
hold on

tic

% This call is fast because the earlier call to contour established the
% axis limits as something reasonable for the data.
hatchedcontours(c3);
hold off

set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ax = axis;

toc

figure(2)

% This call is slow because without something to establish the axis limits,
% the default spc causes hatched line to create _way_ too many hatches.
% This causes slowdown or worse.
hatchedcontours(c3);
toc

hold on
[c,h]=contour(x1,x2',f',[0.01 0.05 0.2 0.4, 0.8 1.6 3.2 6.4]);
hold off

set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

axis(ax)
