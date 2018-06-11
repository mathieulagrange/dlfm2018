% Do the same thing for techniques, restricted to string instruments.
% From dmap_002.

n_nbor = 50;
exclude_outliers = false;

transf = 'sc';

if strcmp(transf, 'sc')
    f = load('data/co1_feSc_me1_ne5_prLm_reMofa_sc1000_st1.mat');
elseif strcmp(transf, 'mf')
    f = load('data/cu1_feMf_ne5_prLm_reMofa_sc1000_st1.mat');
end

file = cellfun(@(x)(fileparts(x)), f.d.file, 'uniformoutput', false);
file = cellfun(@(x)(strsplit(x, '/')), file, 'uniformoutput', false);

insts = cellfun(@(x)(x{1}), file, 'uniformoutput', false);
techs = cellfun(@(x)(x{2}), file, 'uniformoutput', false);

[insts, ~, inst_idx] = unique(insts);
[techs, ~, tech_idx] = unique(techs);

inst_families = cellfun(@(x)(feval(@(y)(y{1}), strsplit(x, '-'))), insts, 'uniformoutput', false);
[inst_families, ~, inst_family_map] = unique(inst_families);

tech_families = cellfun(@(x)(feval(@(y)(y{1}), strsplit(x, '-'))), techs, 'uniformoutput', false);
[tech_families, ~, tech_family_map] = unique(tech_families);

string_family_idx = find(strcmp('Contrabass', inst_families) | ...
    strcmp('Viola', inst_families) | ...
    strcmp('Violin', inst_families) | ...
    strcmp('Violoncello', inst_families));

mask = find(ismember(inst_family_map(inst_idx), string_family_idx));

features = f.d.features(mask,:);

n2 = sum(abs(features).^2, 2);

dists2 = bsxfun(@plus, n2, n2') - 2*features*features';

dists2 = max(dists2, 0);

dists2_sorted = sort(dists2, 1);

% There are some bad clips which occur multiple times. Remove them.
good_idx = find(dists2_sorted(2,:) > 0);

dists2 = dists2(good_idx,good_idx);
dists2_sorted = dists2_sorted(:,good_idx);

epsilons = sqrt(mean(dists2_sorted([2:n_nbor+1],:), 1))';

W = exp(-bsxfun(@times, 1./epsilons, bsxfun(@times, dists2, 1./epsilons')));

d = sqrt(sum(W, 2));

S = bsxfun(@times, 1./d, bsxfun(@times, W, 1./d'));

S = (S+S')/2;

eigs_opt.tol = 1e-3;
eigs_opt.disp = 2;

[V, lambda] = eigs(S, 4, 'la', eigs_opt);

phi = bsxfun(@times, 1./d, V(:,2:4));

mask_tech_family_idx = tech_family_map(tech_idx(mask(good_idx)));
mask_tech_families = unique(tech_families(mask_tech_family_idx));

figure(1+strcmp(transf, 'mf'));
clf;
hold on;
for k = unique(mask_tech_family_idx)
    mask_k = find(mask_tech_family_idx==k);

    scatter3(phi(mask_k,1), phi(mask_k,2), phi(mask_k,3), ...
        100, k, 'filled');
end
hold off;
colormap('jet');
xticks([]); yticks([]); zticks([]);
box on;
view(-45, 45);

hleg = legend(mask_tech_families{:});
set(hleg, 'fontsize', 36);
