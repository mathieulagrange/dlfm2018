% Use locally varying epsilon determined by the average distance to the
% nearest neighbors. Also exclude certain instruments, optionally, that
% tend to distort the map.
% From dmap_001.

n_nbor = 300;
exclude_outliers = false;

%transf = 'sc';

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
inst_idx = inst_idx(:)';
[techs, ~, tech_idx] = unique(techs);
tech_idx = tech_idx(:)';

insts = cellfun(@(x)(strrep(x, 'Alto-Sax', 'Sax')), insts, ...
    'uniformoutput', false);
insts = cellfun(@(x)(strrep(x, 'Bass-Tuba', 'Tuba')), insts, ...
    'uniformoutput', false);
insts = cellfun(@(x)(strrep(x, 'Tenor-Trombone', 'Trombone')), insts, ...
    'uniformoutput', false);

accordions = {'Accordion'};
woodwinds = {'Bassoon', 'Clarinet', 'Flute', 'Oboe', 'Sax'};
brass = {'Horn', 'Trombone', 'Trumpet', 'Tuba'};
bowed = {'Contrabass', 'Viola', 'Violin', 'Violoncello'};
plucked = {'Guitar', 'Harp'};

types = {{'Accordion', accordions}, ...
    {'WindWood', woodwinds}, ...
    {'WindBrass', brass}, ...
    {'StringBowed', bowed}, ...
    {'StringPlucked', plucked}};

for k = 1:numel(insts)
    family = feval(@(y)(y{1}), strsplit(insts{k}, '-'));

    for ell = 1:numel(types)
        if any(strcmp(family, types{ell}{2}))
            insts{k} = [types{ell}{1} '.' insts{k}];
        end
    end
end

family_separator = '-';

inst_families = cellfun( ...
    @(x)(feval(@(y)(y{1}), strsplit(x, family_separator))), insts, ...
    'uniformoutput', false);
[inst_families, ~, inst_family_map] = unique(inst_families);
inst_family_map = inst_family_map(:)';

tech_families = cellfun(@(x)(feval(@(y)(y{1}), strsplit(x, '-'))), techs, 'uniformoutput', false);
[tech_families, ~, tech_family_map] = unique(tech_families);
tech_family_map = tech_family_map(:)';

ordinario_id = find(strcmp('ordinario', techs), 1);

harp_id = find(strcmp('Harp', insts), 1);
guitar_id = find(strcmp('Guitar', insts), 1);
tuba_id = find(strcmp('Bass-Tuba', insts), 1);

if exclude_outliers
    mask = find(tech_idx == ordinario_id & ...
        inst_idx ~= harp_id & inst_idx ~= guitar_id & inst_idx ~= tuba_id);
else
    mask = find(tech_idx == ordinario_id);
end

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

mask_inst_family_idx = inst_family_map(inst_idx(mask(good_idx)));
mask_inst_families = unique(inst_families(mask_inst_family_idx));

family_one = 'StringBowed.Violin';
family_two = 'WindBrass.Trumpet';

idx_one = find(strcmp(family_one, inst_families), 1);
idx_two = find(strcmp(family_two, inst_families), 1);
idx_others = find(~ismember(1:numel(inst_families), [idx_one idx_two]));

figure(1+strcmp(transf, 'mf'));
clf;
hold on;
for k = 1:3
    if k == 1
        mask_k = find(ismember(mask_inst_family_idx, idx_one));
        color = [230 158 0]/255;
        alpha = 1.0;
    elseif k == 2
        mask_k = find(ismember(mask_inst_family_idx, idx_two));
        color = [87 181 232]/255;
        alpha = 1.0;
    elseif k == 3
        mask_k = find(ismember(mask_inst_family_idx, idx_others));
        color = [64 64 64]/255;
        alpha = 0.25;
    end

    h = scatter3(phi(mask_k,1), phi(mask_k,2), phi(mask_k,3), ...
        100, ones(numel(mask_k), 1)*color, 'filled');

    if ~exist('OCTAVE_VERSION', 'builtin')
        set(h, 'MarkerFaceAlpha', alpha);
    end
end
hold off;
colormap('jet');
xticks([]); yticks([]); zticks([]);
box on;
view(-15, 15);

families_legend = {family_one, family_two};

families_legend = cellfun(@(x)(feval(@(y)(y{2}), strsplit(x, '.'))), ...
    families_legend, 'uniformoutput', false);

hleg = legend(families_legend{:}, 'Others');
set(hleg, 'fontsize', 36);
