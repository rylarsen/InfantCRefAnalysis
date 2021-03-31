function cga = remove_var(g,GA)%remove variability from GA

mu(1) = 338.3658;
mu(2) = 44.9490;

[ps] = polyfit((GA-mu(1))/mu(2),g,2);

pred_g = polyval(ps,GA,[],mu);

cga = g - pred_g;

end