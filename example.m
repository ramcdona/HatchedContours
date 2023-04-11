clear all
format compact
close all

pfiletype='-dpng';
pfileext='.png';

% pfiletype='-dpdf';
% pfileext='.pdf';

obj = @(x1,x2) x1^2+x2^2-2*x1-2*x2+2;
g1 = @(x1,x2) 3*x1+x2-5.5;
g2 = @(x1,x2) x1+2*x2-4;
g3 = @(x1,x2) -.8-1/((x1)^3)+x2;

x1=linspace(0.01,8,91);
x2=linspace(0.01,8,95);

% Save original x1, x2.
x1o = x1;
x2o = x2;

for i=1:length(x1)
  for j=1:length(x2)
    f(i,j)=obj(x1(i),x2(j));
    con1(i,j)=g1(x1(i),x2(j));
    con2(i,j)=g2(x1(i),x2(j));
    con3(i,j)=g3(x1(i),x2(j));
  end
end

figure(1)
[c,h]=contour(x1,x2',f',[0.01 0.05 0.2 0.4, 0.8 1.6 3.2 6.4]);
xlabel('x_1')
ylabel('x_2')
% clabel(c,h)
axis equal
axis([0 4 0 4])

c1=ocontourc(x1,x2',con1',[0 0]);
c2=ocontourc(x1,x2',con2',[0 0]);
c3=ocontourc(x1,x2',con3',[0 0]);

hold on

plot([0 0],[0 0],'k');
plot([0 0],[0 0],'r');
plot([0 0],[0 0],'b');

legend( 'Objective', 'Black', 'Red', 'Blue', 'AutoUpdate','off' );

hatchedcontours(c1,'k');
hatchedcontours(c2,'r');
hatchedcontours(c3);
hold off

print(pfiletype,'-r600',strcat('HatchedExample', pfileext));


figure(2)

% Transform data for log-log test.
x1 = exp(x1o);
x2 = exp(x2o);

[c,h]=contour(x1,x2',f',[0.01 0.05 0.2 0.4, 0.8 1.6 3.2 6.4]);
xlabel('x_1')
ylabel('x_2')
% clabel(c,h)
axis equal
%axis([0 4 0 4])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

c1=ocontourc(x1,x2',con1',[0 0]);
c2=ocontourc(x1,x2',con2',[0 0]);
c3=ocontourc(x1,x2',con3',[0 0]);

hold on
hatchedcontours(c1,'k');
hatchedcontours(c2,'r');
hatchedcontours(c3);
hold off

print(pfiletype,'-r600',strcat('HatchedExampleLog', pfileext));


figure(3)

% Transform data for log-log test.
x1 = exp(x1o);
x2 = x2o;

[c,h]=contour(x1,x2',f',[0.01 0.05 0.2 0.4, 0.8 1.6 3.2 6.4]);
xlabel('x_1')
ylabel('x_2')
% clabel(c,h)
% axis equal
%axis([0 4 0 4])
set(gca, 'XScale', 'log')

c1=ocontourc(x1,x2',con1',[0 0]);
c2=ocontourc(x1,x2',con2',[0 0]);
c3=ocontourc(x1,x2',con3',[0 0]);

hold on
hatchedcontours(c1,'k');
hatchedcontours(c2,'r');
hatchedcontours(c3);
hold off

print(pfiletype,'-r600',strcat('HatchedExampleLogX', pfileext));


figure(4)

% Transform data for log-log test.
x1 = x1o;
x2 = exp(x2o);

[c,h]=contour(x1,x2',f',[0.01 0.05 0.2 0.4, 0.8 1.6 3.2 6.4]);
xlabel('x_1')
ylabel('x_2')
% clabel(c,h)
% axis equal
%axis([0 4 0 4])
set(gca, 'YScale', 'log')

c1=ocontourc(x1,x2',con1',[0 0]);
c2=ocontourc(x1,x2',con2',[0 0]);
c3=ocontourc(x1,x2',con3',[0 0]);

hold on
hatchedcontours(c1,'k');
hatchedcontours(c2,'r');
hatchedcontours(c3);
hold off

print(pfiletype,'-r600',strcat('HatchedExampleLogY', pfileext));
