function [ freq_offset ] = avg_freq_offset( seq1, seq2)
% a = seq1.*conj(seq2);
% freq_offset = angle(mean(a(2:end).*conj(a(1:end-1))))/(2*pi)
freq_offset = angle(mean(seq1(2:end).*seq2(1:end-1).*conj(seq1(1:end-1).*seq2(2:end))))/(2*pi);
end