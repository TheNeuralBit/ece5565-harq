function [output]=deinterleaver(input,pad_length)
    block_length=13;
    block_depth=12;
    matrix=zeros(block_depth,block_length);

    a=1;
    output=zeros(1,length(input));
    while a<=length(input)
        for k=1:block_depth
           matrix(k,1:block_length)=input(a+(k-1)*block_length:(a-1)+k*block_length);
        end

        for k=1:block_length
           output(a+(k-1)*block_depth:(a-1)+k*block_depth)=matrix(1:block_depth,k);
        end

        a=a + block_length*block_depth;
    end

    output = output(1:length(input)-pad_length);
    
    
end



