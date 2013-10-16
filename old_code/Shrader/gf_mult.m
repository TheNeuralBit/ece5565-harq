function result = gf_mult(x, y, gf_exp, gf_log)
if x == 0 || y == 0
    result = 0;
else
    result = gf_exp(gf_log(x)+gf_log(y)+1);
end
    