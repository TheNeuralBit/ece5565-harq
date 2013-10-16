function [output,pad_length]=interleaver(input)
    block_length=13;
    block_depth=12;
    matrix=zeros(block_depth,block_length);
    pad_length=0;

    if rem(length(input),block_length*block_depth)~=0
        pad=zeros(1,block_length*block_depth-rem(length(input),block_length*block_depth)); %pad to length divisible by symbol size
        pad_length=length(pad);
        input = [input pad];
    end

    a=1;
    output=zeros(1,length(input));
    while a<=length(input)
        for k=1:block_length
           matrix(1:block_depth,k)=input(a+(k-1)*block_depth:(a-1)+k*block_depth);
        end

        for k=1:block_depth
           output(a+(k-1)*block_length:(a-1)+k*block_length)=matrix(k,1:block_length);
        end

        a=a + block_length*block_depth;
    end

end



