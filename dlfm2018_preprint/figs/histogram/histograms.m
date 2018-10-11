bar_color = [0 0 178]/255;

clf;
family_values = countcats(categorical(family));
family_keys = unique(family);

[~, sorting_indices] = sort(family_values, 'descend');
family_values = family_values(sorting_indices);
family_keys = family_keys(sorting_indices);

% "Tenor" means tenor trombone
family_keys{strcmp(family_keys, 'Tenor')} = 'Tenor trombone';

% "Alto" means alto saxophone
family_keys{strcmp(family_keys, 'Alto')} = 'Alto saxophone';

% "Bass" means bass tuba
family_keys{strcmp(family_keys, 'Bass')} = 'Bass tuba';

% "Contrabass" means double bass
family_keys{strcmp(family_keys, 'Contrabass')} = 'Double bass';

% Horn means French horn
family_keys{strcmp(family_keys, 'Horn')} = 'French horn';

% Violoncello means Cello
family_keys{strcmp(family_keys, 'Violoncello')} = 'Cello';

family_categories = reordercats(categorical(family_keys), family_keys);
fig = bar(family_values);
set(fig, 'FaceColor', bar_color);

n_xticks = 5;
ax = gca();
ax.FontSize = 6;
%ax.YAxis.MinorTickValues = 0:500:3500;
%ax.YAxis.TickValues = 0:1000:3000;

xticks(1:length(family_keys));
xticklabels(family_keys);
xlim([0, length(family_keys)+1]);
ylim([0, 3700]);
ax.Box = 'off';

%ax.YGrid = 'on';
%ax.MinorGridLineStyle = '--';
%ax.GridLineStyle = '-';
xtickangle(45);
%set(ax,'yminorgrid', 'on');
%set(ax, 'FontSize', 6);

text(0.4, 3650, 'Quantity of data', 'FontSize', 6);

fig = gcf();
set(fig, 'Position', [1 1 265 150]);

scale = 0.05;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)

addpath(genpath('~/export_fig'));
export_fig -transparent histogram_instruments.pdf

%%


%%
clf;
x_offset = 1/15;
x_ticks = [100 300 1000 3000];

mfamily_values = countcats(categorical(modeFamily));
mfamily_keys = unique(modeFamily);
n_modefamilies = length(mfamily_keys);

[x, sorting_indices] = sort(mfamily_values, 'descend');


n_families = 50;
mfamily_ys = 1:n_families;
sorting_indices = sorting_indices(mfamily_ys);

mfamily_values = mfamily_values(sorting_indices);
mfamily_keys = mfamily_keys(sorting_indices);

family_categories = reordercats(categorical(mfamily_keys), mfamily_keys);
%fig = barh(mfamily_ys, log10(x_offset) + log10(mfamily_values));
fig = barh(mfamily_ys, mfamily_values);
set(fig, 'FaceColor', bar_color);

ax = gca();
ax.XScale = 'log';
%xticks(log10(x_ticks) + log10(x_offset));
xticks(x_ticks);
xticklabels(x_ticks);
xtickangle(45);
%xlim([0, log10(x_offset)+log10(5000)]);
xlim([50 5000]);
yticks(mfamily_ys);
ylim([0, n_families+2]);
%yticklabels(mfamily_keys);
yticklabels(repmat({''}, numel(mfamily_keys), 1));

xt = get(gca, 'YTick');
set(gca, 'FontSize', 12)

xlabel('Quantity of data');
ax.Box = 'off';
set(gca(), 'YDir', 'reverse');

fig = gcf();
fig.Position = [1 1 300 993];

drawnow();

%export_fig -transparent histogram_modes.pdf

mfamily_keys_str = cellfun(@(x)(['"' x '",']), mfamily_keys, ...
    'uniformoutput', false);
mfamily_keys_str = [mfamily_keys_str{:}];
mfamily_keys_str = ['\def\ipt_array{{' mfamily_keys_str(1:end-1) '}}%'];

fprintf('%s\n', mfamily_keys_str);
