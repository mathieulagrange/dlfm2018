

mfamily_values = countcats(categorical(modeFamily));
mfamily_keys = unique(modeFamily);
n_modefamilies = length(mfamily_keys);

[x, sorting_indices] = sort(mfamily_values, 'descend');


n_families = 143;
mfamily_ys = 1:n_families;
sorting_indices = sorting_indices(mfamily_ys);

mfamily_values = mfamily_values(sorting_indices);
mfamily_keys = mfamily_keys(sorting_indices);

%%
for n = 101:143
    fprintf([mfamily_keys{n}, '\n']);
end