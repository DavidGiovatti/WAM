function [Table] = loc(file1,file2,file3,leng,time_step)
% Input 1-3: locations of files generated at different Raspberry Pis;
% Input 4: Length of the files to read;
% Input 5: Time step between lines of data;
% Output: Locations of each MAC at specific times;
% Generates a csv file named "Localization.csv".

A = -50; % A
mapx = 4.095;
mapy = 5.2325;
x1 = mapx;
y1 = 0;
x2 = 0;
y2 = 0;
x3 = mapx/2;
y3 = mapy;
len = leng;

%% Read data
[Time1, MAC1, SS1] = readcsv(file1,len);
[Time2, MAC2, SS2] = readcsv(file2,len);
[Time3, MAC3, SS3] = readcsv(file3,len);

%% Sort by MAC and time
Table = unique([MAC1;MAC2;MAC3]);
Mlen = length(Table);
for i = 2:9
    Table{1,i} = [];
end

for j = 1:Mlen
    time_run1 = 0.0;
    time_run2 = 0.0;
    time_run3 = 0.0;
    
    min_start1 = Time1(2,1);
    sec_start1 = Time1(2,2); % Set start time

    min_start2 = Time2(2,1);
    sec_start2 = Time2(2,2); % Set start time

    min_start3 = Time3(2,1);
    sec_start3 = Time3(2,2); % Set start time

    for i = 1:len        
        time_passed1 = 60*(Time1(i,1) - min_start1) + Time1(i,2) - sec_start1;  % Time passed in this period
        if ismember(Table{j,1},MAC1(i,1)) && time_passed1 >= time_step
            Table{j,2} = [Table{j,2},time_run1];
            Table{j,3} = [Table{j,3},SS1(i)];
            time_run1 = time_run1 + time_step;
            min_start1 = Time1(i,1);
            sec_start1 = Time1(i,2);
        end
        time_passed2 = 60*(Time2(i,1) - min_start2) + Time2(i,2) - sec_start2;
        if ismember(Table{j,1},MAC2(i,1)) && time_passed2 >= time_step
            Table{j,4} = [Table{j,4},time_run2];
            Table{j,5} = [Table{j,5},SS2(i)];
            time_run2 = time_run2 + time_step;
            min_start2 = Time2(i,1);
            sec_start2 = Time2(i,2);
        end
        time_passed3 = 60*(Time3(i,1) - min_start3) + Time3(i,2) - sec_start3;
        if ismember(Table{j,1},MAC3(i,1)) && time_passed3 >= time_step
            Table{j,6} = [Table{j,6},time_run3];
            Table{j,7} = [Table{j,7},SS3(i)];
            time_run3 = time_run3 + time_step;
            min_start3 = Time3(i,1);
            sec_start3 = Time3(i,2);
        end
    end
end

%% Delete useless data
for i = Mlen:-1:1
    if isempty(Table{i,3}) || isempty(Table{i,5}) || isempty(Table{i,7}) 
        Table(i,:) = [];
    end
end
Table(1,:) = [];
Mlen = length(Table);

%% Calculation

for i = 1:Mlen
    min_len = min([length(Table{i,3}),length(Table{i,5}),length(Table{i,7})]);
%     t1 = Table{i,2}(1:min_len);
%     t2 = Table{i,4}(1:min_len);
%     t3 = Table{i,6}(1:min_len);
    s1 = Table{i,3}(1:min_len);
    s2 = Table{i,5}(1:min_len);
    s3 = Table{i,7}(1:min_len);
    for j = 1:min_len
        if s1(j)*s2(j)*s3(j) ~= 0
            Dist1 = 2.^((abs(A-double(s1(j))-1.552)/12.92-1));
            Dist2 = 2.^((abs(A-double(s2(j))-1.552)/12.92-1));
            Dist3 = 2.^((abs(A-double(s3(j))-1.552)/12.92-1));
            [Table{i,8}(j), Table{i,9}(j)] = triposition(x1,y1,Dist1,x2,y2,Dist2,x3,y3,Dist3);
        else
            Table{i,8}(j) = 0;
            Table{i,9}(j) = 0;
        end
    end
end

%% Delete Signal Strength
Table(:,3:7) = [];

%% Write data
Tab = cell2table(Table,'VariableNames',{'MAC', 'Time', 'x', 'y'});
delete('Localization.csv')
writetable(Tab, 'Localization.csv');
open('Localization.csv')

end