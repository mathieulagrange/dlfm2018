family_values = countcats(categorical(family));
family_keys = unique(family);

[~, sorting_indices] = sort(family_values, 'descend');
family_values = family_values(sorting_indices);
family_keys = family_keys(sorting_indices);

family_categories = reordercats(categorical(family_keys), family_keys);
bar(family_categories, family_values);

n_xticks = 5;
ax = gca();
ax.YAxis.MinorTickValues = 0:200:3500;
ax.YAxis.TickValues = 0:1000:3000;

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
x_offset = 0.15; 
x_ticks = [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000];

mfamily_values = countcats(categorical(modeFamily));
mfamily_keys = unique(modeFamily);
n_modefamilies = length(mfamily_keys);

[x, sorting_indices] = sort(mfamily_values, 'descend');


n_families = 75;
mfamily_ys = 1:n_families;
sorting_indices = sorting_indices(mfamily_ys);

mfamily_values = mfamily_values(sorting_indices);
mfamily_keys = mfamily_keys(sorting_indices);

family_categories = reordercats(categorical(mfamily_keys), mfamily_keys);
fig = barh(mfamily_ys, log10(x_offset) + log10(mfamily_values));

ax = gca();
xticks(log10(x_ticks) + log10(x_offset));
xticklabels(x_ticks);
xtickangle(45);
xlim([0, log10(x_offset)+log10(5000)]);
yticks(mfamily_ys);
ylim([0, n_families+2]);
yticklabels(mfamily_keys);

ylabel('Y Axis', 'FontSize',12)
xt = get(gca, 'YTick');
set(gca, 'FontSize', 16)

%xlabel('Quantity of data');
ax.Box = 'off';
set(gca(), 'YDir', 'reverse');

fig = gcf();
fig.Position = [1 1 500 1650];

export_fig  -transparent histogram_modes.png 

%%
x_offset = 0.15; 
x_ticks = [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000];
%x_tick_labels = 

mfamily_values = countcats(categorical(modeFamily));
mfamily_keys = unique(modeFamily);
n_modefamilies = length(mfamily_keys);

[x, sorting_indices] = sort(mfamily_values, 'descend');

mfamily_ys = [1:20, 51:70, 101:120];
sorting_indices = sorting_indices(mfamily_ys);

mfamily_values = mfamily_values(sorting_indices);
mfamily_keys = mfamily_keys(sorting_indices);

family_categories = reordercats(categorical(mfamily_keys), mfamily_keys);
y_offset = 1.5;
mfamily_ys = [ ...
    1:20, ...
    (y_offset+20) * 1 + (1:20), ...
    (y_offset+20) * 2 + (1:20)];
fig = barh(mfamily_ys, log10(x_offset) + log10(mfamily_values));

ax = gca();
xticks(log10(x_ticks) + log10(x_offset));
xticklabels(x_ticks);
xtickangle(45);
xlim([0, log10(x_offset)+log10(5000)]);
yticks(mfamily_ys);
yticklabels(mfamily_keys);
xlabel('Quantity of data');
ax.Box = 'off';
set(gca(), 'YDir', 'reverse');

fig = gcf();
fig.Position = [1 1 554 1500];

export_fig  -transparent histogram_modes.png 