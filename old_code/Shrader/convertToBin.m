function output=convertToBin(input)
    output=zeros(1,4*length(input));

    for k=1:length(input)
        temp=[0 0 0 0];
        val=input(k);
        if val/8 >= 1
            temp(1)=1;
            val=mod(val,8);
        end
        if val/4 >= 1
            temp(2)=1;
            val=mod(val,4);
        end
        if val/2 >= 1
            temp(3)=1;
            val=mod(val,2);
        end
        if val >= 1
            temp(4)=1;
        end
        output(1+4*(k-1):4*k)=temp;
    end
end