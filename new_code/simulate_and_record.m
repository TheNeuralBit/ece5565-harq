function simulate_and_record()
    configuration;
    %NUM_PACKETS = 100;
    %DATA_BITS_PER_PACKET = 1752;
    NUM_PACKETS = 1000;
    DATA_BITS_PER_PACKET = 980;
    EBNO = -3:12;
    HARQ_TYPE = 0:2;
    %HARQ_TYPE = [0];
    for harq=HARQ_TYPE
        [throughput, ber] = harq_toplevel( NUM_PACKETS, DATA_BITS_PER_PACKET, EBNO, harq );
        if harq == 0
            harq_str='ARQ';
        elseif harq == 1
            harq_str='HARQI';
        elseif harq == 2
            harq_str='HARQII';
        else
            harq_str='UNK';
        end
        result_file = [pwd, '/../results/', harq_str, '-', MODULATION, '-', CODING, CODE_RATE_STR '-', num2str(MAX_DOPPLER)];
        disp 'Saving results to ', result_file
        save(result_file);
    end
end
