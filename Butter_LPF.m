function [ bw_filter ] = Butter_LPF(M,N,d0,n)
bw_filter=zeros(M,N);

%d0	 = Cutoff Frequency
%n 	 = Order of butterworth filter

for i=1:M
    for j=1:N
        dist=((i-M/2)^2 + (j-N/2)^2)^0.5; % distance taken from center not from origin 
        bw_filter(i,j)= ( 1 + (dist/d0)^(2*n))^(-1); %butterwort LPF formula
        
    end
end

end

