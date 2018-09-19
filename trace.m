function [] = trace(Table,MAC_num)
mapx = 4.095;
mapy = 5.2325;
x1 = mapx;
y1 = 0;
x2 = 0;
y2 = 0;
x3 = mapx/2;
y3 = mapy;
plot(x1,y1,'k^');
hold on;
plot(x2,y2,'k^');
hold on;
plot(x3,y3,'k^');
hold on;

x = Table{MAC_num,3};
y = Table{MAC_num,4};
n = length(x);
for i = 1:n
    hold on;
    plot(x(i),y(i),'r*');
    if i > 1
        hold on;
        plot([x1,x(i)],[y1,y(i)],'r'); 
    end
    x1 = x(i);
    y1 = y(i);
end
legend('Reference points','Testing point','Localized point', 'Location','SouthEast');  
title('Point Trace');
