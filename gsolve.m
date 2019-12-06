%
% gsolve.m ? Solve for imaging system response function
%
% Given a set of pixel values observed for several pixels in several
% images with different exposure times, this function returns the
% imaging system’s response function g as well as the log film irradiance
% values for the observed pixels.
%
% Assumes:
%
% Zmin = 0
% Zmax = 255
%
% Arguments:
%
% Z(i,j) is the pixel values of pixel location number i in image j
% B(j) is the log delta t, or log shutter speed, for image j (!!!!! they are inverse?!?!?)
% lambda is lamdba, the constant that determines the amount of smoothness
% w(z) is the weighting function value for pixel value z
%
% Returns:
%
% g(z) is the log exposure corresponding to pixel value z
% lE(i) is the log film irradiance at pixel location i
%
function [g,lE]=gsolve(Z,B,lambda)
n = 256;
A = zeros(size(Z,1)*size(Z,2)+n+1,n+size(Z,1));
b = zeros(size(A,1),1);

%Zmin=0; Zmax=255;

%% Include the data?fitting equations
k = 1;
for i=1:size(Z,1) % N pixels
    for j=1:size(Z,2) % P images
        wij = weighting_func(Z(i,j)); % jms20190312 - remove +1 ... Z are pixels values, they are in the range 0..255
        %wij = double(wij);
        A(k,Z(i,j)+1) = wij; % jms20190312 - +1 stays as it is for indexing 0..255 into 1..256
        A(k,n+i) = -wij; 
        b(k,1) = wij * B(j);
        k=k+1;
    end
end
%% Fix the curve by setting its middle value to 0
zmid=128;  % in the paper code 129, but ... in the paper it is written g(Zmid)=0 ... Zmid=(Zmax+Zmin)/2 ... if 255+1 => 128, ... they asume max is 256, but ... in any case it is  minor bias ... or not if Zmin/max are image actual valures, not range ...
%zmid=round((min(min(Z))+max(max(Z)))/2) % jms 20190312
A(k,zmid) = 1;
k=k+1;
%% Include the smoothness equations
for i=1:n-2
    A(k,i)=lambda*weighting_func(i); A(k,i+1)=-2*lambda*weighting_func(i); A(k,i+2)=lambda*weighting_func(i); % jms20190312 - remove +1 in weignthingfunc ... Z are pixels values, they are in the range 0..255
    k=k+1;
end
%% Solve the system using SVD
x = A\b;
g = x(1:n);
lE = x(n+1:size(x,1));
end