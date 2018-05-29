system_strs = { ...
    'cu1_feMf_ne5_prLm_reMofa_sc25_st1', ...
    'co1_feSc_me1_ne5_prLm_reMofa_sc1000_st1'
};

queries = { ...
    'Violin/ordinario/Vn-ord-G4-mf-4c', ...
    'Trumpet-C/flatterzunge/TpC-flatt-G4-mf'};
n_queries = length(queries);

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
            disp([' ', num2str(i),': ', system.d.file{neighbor_id}]);
        end
        disp(' ');
        disp(' ');
    end
end