function [Time, MAC, SS] = readcsv(file,len)
fid = fopen(file);   
Data = textscan(fid, '%s %s %s %d %s', 'delimiter', ','); % Get data of raspi1
fclose(fid);
S = regexp(Data{1,2}, ' ', 'split');
S1 = cell(len, 1);
for i = 1:len
    S1(i,1) = regexp(S{i,1}(2), ':', 'split');
end
Time = zeros(len,2);
for i = 2:1:len
    Time(i,1) = str2double(cell2mat(S1{i,1}(2)));
    Time(i,2) = str2double(cell2mat(S1{i,1}(3)));
end
MAC = Data{1,3};
SS = Data{1,4};
end