function [ output_samps ] = pulse_shaping( input_samps, fs, T, rolloff)

filt = generate_pulse_shaping_filt(fs, T, rolloff);
output_samps = apply_filt(input_samps, filt);

end

