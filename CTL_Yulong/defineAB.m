clear all

A = [2 4];
B = [1 2 3];
z = rand(5,1);
aa = [];
sumA=[];
%%
for i = 1:1:5
    for j=1:1:length(A)
        if i == A(j)
        aa = [aa z(i)];
        sumA = sum(aa);
        end
    end
end
