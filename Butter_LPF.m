function [ bw_filter ] = Butter_LPF(M,N,d0,n)
bw_filter=zeros(M,N);

% d0=10;				%Cutoff Frequency
% n=1; 				%Order of butterworth filter

for i=1:M
    for j=1:N
        dist=((i-M/2)^2 + (j-N/2)^2)^0.5;
        %dist=((i)^2 + (j)^2)^0.5;
        bw_filter(i,j)= ( 1 + (dist/d0)^(2*n))^(-1);
        
    end
end

end

