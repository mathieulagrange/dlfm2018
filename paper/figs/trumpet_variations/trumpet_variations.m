%%
clear opts;
opts{1}.time.size = 65536;
opts{1}.time.T = 2^10;
opts{1}.time.max_scale = 8*opts{1}.time.T;
opts{1}.time.nFilters_per_octave = 24;
opts{1}.time.gamma_bounds = ...
    [1+opts{1}.time.nFilters_per_octave*1 ...
    opts{1}.time.nFilters_per_octave*7];
opts{1}.time.max_Q = 12;
opts{1}.time.is_chunked = false;

archs = sc_setup(opts);

%%

addpath(genpath('~/MATLAB/scattering.m'));
samples = { ...
    'TpC-ord-G4-mf.wav', ...
    'TpC-ord-E4-mf.wav', ...
    'TpC-ord-G3-mf.wav', ...
    'TpC-ord-G4-pp.wav', ...
    'TpC-sfz-G4-fp.wav', ...
    'TpC-brassy-G4-ff.wav', ...
    'TpC-flatt-G4-mf.wav', ...
    'TpC+H-ord-G4-mf.wav', ...
    'TpC-trill-maj2-G4-mf.wav', ...
    'TpC-voc-harms-C4-mf.wav'};

nSamples = length(samples);
shifts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];


for sample_index = 1:nSamples
    sample_str = samples{sample_index};
    [sample_x, sr] = audioread(sample_str);
    sample_x = sample_x(1:65536) .* tukeywin(65536, 0.2);
    sample_x = circshift(sample_x, shifts(sample_index));
    [S, U] = sc_propagate(sample_x, archs);
    scalogram = display_scalogram(U{1+1});
    figure(sample_index);
    image(200 * log1p(1e-3*scalogram(:,:)));
    colormap rev_magma;
    axis off;
    savefig(gcf, [sample_str(1:(end-4)), '.fig'], 'compact');
end