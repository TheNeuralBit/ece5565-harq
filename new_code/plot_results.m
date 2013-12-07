function plot_results(glob)
    close all;
    
    colors = ['-ks'; '-b*'; '-ro'; '-gx'; '-m+'; '-cv'];

    results_dir = [pwd '/../results/'];
    files = dir([results_dir glob '.mat']);
    legend_data = cell(1,length(files));

    for idx = 1:length(files)
        filename = files(idx).name;
        legend_data(idx) = {filename};
        load([results_dir, filename])

        figure(1);
        if idx > 1
            hold on;
        end
        semilogy(EBNO, ber, colors(mod(idx - 1, length(colors)) + 1,:));
        if idx > 1
            hold off;
        end
        
        figure(2);
        if idx > 1
            hold on;
        end
        plot(EBNO, throughput, colors(mod(idx - 1, length(colors)) + 1,:));
        if idx > 1
            hold off;
        end
    end

    figure(1);
    hold on;
    legend(legend_data);
    title('BER')
    xlabel('E_b/N_0 (dB)')
    ylabel('BER')
    hold off;

    figure(2);
    hold on;
    legend(legend_data);
    title('Throughput')
    xlabel('E_b/N_0 (dB)')
    ylabel('Throughput')
    hold off;
