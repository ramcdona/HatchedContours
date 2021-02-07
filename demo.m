clear all
format compact

x1=linspace(0,3,15);
x2=linspace(1,5,21);


for i=1:length(x1)
    for j=1:length(x2)
        
        z(i,j)=x1(i)*2*x2(j)*cos(x1(i)*x2(j));
        
    end
end

c=contour(x1,x2,z',[5 5],'k');

hatchedcontours(c)