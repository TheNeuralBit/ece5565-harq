function r = gf_poly_add(p, q)
    r = zeros(1, max(length(p), length(q)));
    for i = 1:length(p)
        r(i+length(r)-length(p)) = p(i);
    end
    for i = 1:length(q)
        r(i+length(r)-length(q)) = bitxor(r(i+length(r)-length(q)), q(i));
    end