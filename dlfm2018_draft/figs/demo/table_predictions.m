system_strs = { ...
    'cu1_feMf_ne5_prLm_reMofa_sc25_st1', ...
    'co1_feSc_me1_ne5_prLm_reMofa_sc1000_st1'
};

queries = { ...
    'Violin/ordinario/Vn-ord-G4-mf-4c', ...
    'Trumpet-C/flatterzunge/TpC-flatt-G4-mf'};
n_queries = length(queries);

data_dir = '~/Downloads/SOL_0.9_HQ';

addpath(genpath('~/scattering.m'));
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


n_systems = length(system_strs);
systems = cell(1, n_systems);
clc();

for query_id = 1:n_queries
    query_str = queries{query_id};
    
    for system_id = 1:n_systems
        system_str = system_strs{system_id};
        disp(system_str)
        disp([' Q: ', query_str]);
        disp(' ');

        systems{system_id} = load(system_str);
        system = systems{system_id};

        query_id = find(cellfun(@(x) strcmp(x, query_str), system.d.file));
        neighbor_ids = system.d.nn(query_id,:);
        for i = 1:length(neighbor_ids)
            neighbor_id = neighbor_ids(i);
            neighbor_str = system.d.file{neighbor_id};
            disp([' ', num2str(i),': ', neighbor_str]);
            neighbor_split = strsplit(neighbor_str, '/');
            instrument_str = neighbor_split{1};
            switch instrument_str
                case 'Trumpet-C'
                    family_str = 'Trumpets';
                case 'Trumpet-C-straight'
                    family_str = 'Trumpets';
                case 'Violin'
                    family_str = 'Strings';
                case 'Violin-sordina'
                    family_str = 'Strings';
                otherwise
                    error(['Unknown instrument: ', instrument_str]);
            end
            wav_path = [data_dir, '/', family_str, '/', ...
                system.d.file{neighbor_id}, '.wav'];
            [waveform, sample_rate] = audioread(wav_path);
            disp([length(waveform)/sample_rate, sample_rate/1000]);
            
            waveform = cat(1, zeros(sample_rate/4, 1), waveform);
            sample_x = waveform(1:65536) .* tukeywin(65536, 0.2);
            [S, U] = sc_propagate(sample_x, archs);
            
            scalogram = display_scalogram(U{1+1});
            image(200 * log1p(1e-3*scalogram(:,:)));
            colormap rev_magma;
            axis off;
            drawnow();
            export_fig([neighbor_split{3}, '.png'], '-transparent');
            
            
        end
        disp(' ');
        disp(' ');
    end
end

%%
