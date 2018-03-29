family_values = countcats(categorical(family));
family_keys = unique(family);

[~, sorting_indices] = sort(family_values, 'descend');
family_values = family_values(sorting_indices);
family_keys = family_keys(sorting_indices);

family_categories = reordercats(categorical(family_keys), family_keys);
bar(family_categories, family_values);

n_xticks = 5;
ax = gca();
%xticks_linspace = linspace(0, 3500, n_xticks);
ax.YAxis.MinorTickValues = 0:200:3500;
ax.YAxis.TickValues = 0:1000:3000;
% xtick_linspace_strs = cell(1, n_xticks);
% for xtick_id = 1:n_xticks
%     if mod(xtick_id, 4) == 1
%         xtick_linspace_strs{xtick_id} = string(xticks_linspace(xtick_id));
%     else
%         xtick_linspace_strs{xtick_id} = '';
%     end
% end
% xticklabels(xtick_linspace_strs);

xticks(1:length(family_keys));
xticklabels(family_keys);
xlim([0, length(family_keys)+1]);
ylim([0, 3700]);
ax.Box = 'off';

ax.YGrid = 'on';
ax.MinorGridLineStyle = '--';
ax.GridLineStyle = '-';
xtickangle(45);
set(ax,'yminorgrid', 'on');

text(0.4, 3650, 'Quantity of data');

fig = gcf();
set(fig, 'Position', [1 1 353 369]);
addpath(genpath('~/export_fig'));
export_fig -transparent -m8 histogram_instruments.png 

%%
