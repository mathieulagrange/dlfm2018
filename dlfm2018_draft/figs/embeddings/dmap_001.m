% Generate diffusion maps colored by instrument family for the ordinario
% playing technique.

f = load('data/co1_feSc_me1_ne5_prLm_reMofa_sc1000_st1.mat');

file = cellfun(@(x)(fileparts(x)), f.d.file, 'uniformoutput', false);
file = cellfun(@(x)(strsplit(x, '/')), file, 'uniformoutput', false);

insts = cellfun(@(x)(x{1}), file, 'uniformoutput', false);
techs = cellfun(@(x)(x{2}), file, 'uniformoutput', false);

[insts, ~, inst_idx] = unique(insts);
inst_idx = inst_idx(:)';
[techs, ~, tech_idx] = unique(techs);
tech_idx = tech_idx(:)';

inst_families = cellfun(@(x)(feval(@(y)(y{1}), strsplit(x, '-'))), insts, 'uniformoutput', false);
[inst_families, ~, inst_family_map] = unique(inst_families);
inst_family_map = inst_family_map(:)';

tech_families = cellfun(@(x)(feval(@(y)(y{1}), strsplit(x, '-'))), techs, 'uniformoutput', false);
[tech_families, ~, tech_family_map] = unique(tech_families);
tech_family_map = tech_family_map(:)';

ordinario_id = find(strcmp('ordinario', techs), 1);

mask = find(tech_idx == ordinario_id);

features = f.d.features(mask,:);

n2 = sum(abs(features).^2, 2);

dists2 = bsxfun(@plus, n2, n2') - 2*features*features';

dists2 = max(dists2, 0);

epsilon = median(dists2(:));

W = exp(-dists2/epsilon);

d = sqrt(sum(W, 2));

S = bsxfun(@times, 1./d, bsxfun(@times, W, 1./d'));

S = (S+S')/2;

eigs_opt.tol = 1e-3;
eigs_opt.disp = 2;

[V, lambda] = eigs(S, 4, 'la', eigs_opt);

phi = bsxfun(@times, 1./d, V(:,2:4));

mask_inst_family_idx = inst_family_map(inst_idx(mask(good_idx)));
mask_inst_families = unique(inst_families(mask_inst_family_idx));

figure(1);
clf;
hold on;
for k = unique(mask_inst_family_idx)
    mask_k = find(mask_inst_family_idx==k);

    scatter3(phi(mask_k,1), phi(mask_k,2), phi(mask_k,3), ...
        100, k*ones(numel(mask_k), 1), 'filled');
end
hold off;
colormap('jet');
xticks([]); yticks([]); zticks([]);
box on;
view(-15, 15);

hleg = legend(mask_inst_families{:});
set(hleg, 'fontsize', 36);
