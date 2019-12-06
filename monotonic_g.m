function val = monotonic_g(g)
%Basic function to test if g is monotonic
%If the function is monotonic (there is no sign chnge in the function), the
%function will return a 0. If it is not monotonic, it will return a 1
dg = diff(g);
val = any(diff(sign(dg(dg~=0))));
plot(dg);

end

