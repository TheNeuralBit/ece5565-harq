function plot_spectrum( samples, fs )

f = fftshift(fft(samples));
plot(linspace(-fs/2, fs/2, length(f)), 10*log(abs(f)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')

end
