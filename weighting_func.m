function w = weighting_func(x)
mean = 129;
sigma = 50;
base = 1/(sigma*sqrt(2*3.141592));
exponent = -((x-mean)*(x-mean))/(2*sigma*sigma);
w = base*2.718182^(exponent);
end