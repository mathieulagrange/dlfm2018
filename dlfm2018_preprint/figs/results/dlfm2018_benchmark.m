system_strs = { ...
    'co1_feSc_me1_ne5_prLm_reMofa_sc1000_st1.mat', ...
    'co1_feSc_me1_ne5_prLm_reMofa_sc25_st1.mat', ...
    'co1_feSc_me1_ne5_reMofa_sc1000_st1.mat', ...
    'co1_feSc_me1_ne5_reMofa_sc25_st1.mat', ...
    'cu1_feMf_ne5_prLm_reMofa_sc1000_st1.mat', ...
    'cu1_feMf_ne5_prLm_reMofa_sc25_st1.mat', ...
    'cu1_feMf_ne5_reMofa_sc1000_st1.mat', ...
    'cu1_feMf_ne5_reMofa_sc25_st1.mat' ...
};

n_systems = 1;%length(system_strs);
systems = cell(1, n_systems);

ordinary_techniques = { ...
    'ordinario', ...
    'ordinario-1q', ...
    'note-lasting', ...
    'non-vibrato', ...
    'decrescendo', ...
    'crescendo', ...
    'crescendo-to-decrescendo'}; 

for system_id = 1:n_systems
    system_str = system_strs{system_id};
    disp(['System: ', system_str]);
    for restrict_ordinary = 0:1
        systems{system_id} = load(['../demo/', system_str]);
        system = systems{system_id};

        [n_queries, n_neighbors] = size(system.d.nn);
        instrument_precisions = nan(1, n_queries);
        sordina_precisions = nan(1, n_queries);
        technique_precisions = nan(1, n_queries);
        for query_id = 1:n_queries
            query_split = strsplit(system.d.file{query_id}, '/');
            query_sordina_str = query_split{1};
            query_sordina_split = strsplit(query_sordina_str, '-');
            query_instrument_str = query_sordina_split{1};
            query_technique_str = query_split{2};
            is_ordinary_query = ...
                any(strcmp(query_technique_str, ordinary_techniques));
            if (~restrict_ordinary) || is_ordinary_query
                neighbor_id_ids = system.d.nn(query_id, :);
                instrument_precision = 0.0;
                sordina_precision = 0.0;
                technique_precision = 0.0;
                for neighbor_id_id = 1:n_neighbors
                    neighbor_id = system.d.nn(query_id, neighbor_id_id);
                    neighbor_split = strsplit(system.d.file{neighbor_id}, '/');
                    neighbor_sordina_str = neighbor_split{1};
                    neighbor_sordina_split = ...
                        strsplit(query_sordina_str, '-');
                    neighbor_instrument_str = neighbor_sordina_split{1};
                    neighbor_technique_str = neighbor_split{2};

                    if strcmp(query_instrument_str, neighbor_instrument_str)
                        instrument_precision = ...
                            instrument_precision + 1/n_neighbors;
                    end
                    
                    if strcmp(query_sordina_str, neighbor_sordina_str)
                        sordina_precision = ...
                            sordina_precision + 1/n_neighbors;
                    end

                    if (is_ordinary_query && any(strcmp(neighbor_technique_str, ordinary_techniques))) || ...
                            strcmp(query_technique_str, neighbor_technique_str)
                        technique_precision = ...
                            technique_precision + 1/n_neighbors;
                    end
                end
                instrument_precisions(query_id) = instrument_precision;
                sordina_precisions(query_id) = sordina_precision;
                technique_precisions(query_id) = technique_precision;
            end
        end
        instrument_precision = nanmean(instrument_precisions);
        sordina_precision = nanmean(sordina_precisions);
        technique_precision = nanmean(technique_precisions);

        if restrict_ordinary
            disp('Ordinary techniques');
        else
            disp('All techniques');
        end
        fprintf('Instrument P@5: %5.6f\n', 100*instrument_precision);
        fprintf('Sordina P@5: %5.6f\n', 100*sordina_precision);
        fprintf('Technique P@5: %5.6f\n', 100*technique_precision);
        disp(' ');
    end
    disp(' ');
end