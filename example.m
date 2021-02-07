clear all
format compact

pfiletype='-dpng';
pfileext='.png';

% pfiletype='-dpdf';
% pfileext='.pdf';

obj = @(x1,x2) x1^2+x2^2-2*x1-2*x2+2;
g1 = @(x1,x2) 3*x1+x2-5.5;
g2 = @(x1,x2) x1+2*x2-4;
g3 = @(x1,x2) -.8-1/((x1)^3)+x2;

x1=linspace(0.01,4,91);
x2=linspace(0.01,4,95);

for i=1:length(x1)
  for j=1:length(x2)
    f(i,j)=obj(x1(i),x2(j));
    con1(i,j)=g1(x1(i),x2(j));
    con2(i,j)=g2(x1(i),x2(j));
    con3(i,j)=g3(x1(i),x2(j));
  end
end

[c,h]=contour(x1,x2',f',[0.01 0.05 0.2 0.4, 0.8 1.6 3.2 6.4]);
xlabel('x_1')
ylabel('x_2')
% clabel(c,h)
axis equal
axis([0 4 0 4])

c1=ocontourc(x1,x2',con1',[0 1e6]);
c2=ocontourc(x1,x2',con2',[0 1e6]);
c3=ocontourc(x1,x2',con3',[0 -1e6]);

hold on
hatchedcontours(c1,'k');
hatchedcontours(c2,'r');
hatchedcontours(c3);
hold off

print(pfiletype,'-r600',strcat('HatchedExample', pfileext));

