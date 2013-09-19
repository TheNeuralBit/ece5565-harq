function [ phase_offset ] = avg_phase_offset( seq1, seq2)
% AVG_PHASE_OFFSET  Measures the average phase offset between two sequences
%                   of complex symbols
%
%   Author: Brian Hulette

phase_offset = angle(mean(seq1.*conj(seq2)));
end