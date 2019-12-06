x = [0:1:255];
a = size(x,2);
for i = 1:a
    w(i) = gauss_weight(x(i));
end
w = 129*(w/max(w));