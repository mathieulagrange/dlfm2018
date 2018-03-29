
f = open('Fig149.fig');

%
f_children = get(f, 'Children');
f_grandchildren = get(f_children, 'Children');
f_lines = f_grandchildren{2};
time_scales = [25, 128, 250, 500, 1000] / 1000;


mfcc_none_inst = f_lines(12).YData;
mfcc_none_mode = f_lines(11).YData;
mfcc_lmnn_inst = f_lines(10).YData;
mfcc_lmnn_mode = f_lines(9).YData;

scat_none_inst = f_lines(6).YData;
scat_none_mode = f_lines(5).YData;
scat_lmnn_inst = f_lines(4).YData;
scat_lmnn_mode = f_lines(3).YData;


%
mfcc_color = hex2rgb('0000B2');
scat_color = 0.95 * hex2rgb('E67300');
legends = {'MFCC', 'MFCC + LMNN', 'scattering', 'scattering + LMNN'};

%figure(2);
subplot(121);
hold on;
plot(log10(time_scales), mfcc_none_inst, '-.', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerSize', 6);
plot(log10(time_scales), mfcc_lmnn_inst, '-', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerSize', 6);
h1 = plot(log10(time_scales(1)), mfcc_none_inst(1), '-.o', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerFaceColor', mfcc_color, 'MarkerSize', 6);
h2 = plot(log10(time_scales(1)), mfcc_lmnn_inst(1), '-o', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerFaceColor', mfcc_color, 'MarkerSize', 6);
h3 = plot(log10(time_scales), scat_none_inst, '-.d', ...
    'LineWidth', 1.5, 'Color', scat_color, ...
    'MarkerFaceColor', scat_color, 'MarkerSize', 6);
h4 = plot(log10(time_scales), scat_lmnn_inst, '-d', ...
    'LineWidth', 1.5, 'Color', scat_color, ...
    'MarkerFaceColor', scat_color, 'MarkerSize', 6);
xlim([log10(0.015), log10(1.5)]);
ylim([75 100]);
xticks(log10(time_scales));
xticklabels(time_scales*1000);
legend([h1,h2,h3,h4], legends, 'Location', 'southwest');
xlabel('Time scale (ms)');
ylabel('Precision @ 5 (%)');
title('Instrument retrieval');
hold off;

subplot(122);
hold on;
plot(log10(time_scales), mfcc_none_mode, '-.', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerFaceColor', mfcc_color, 'MarkerSize', 6);
plot(log10(time_scales), mfcc_lmnn_mode, '-', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerFaceColor', mfcc_color, 'MarkerSize', 6);
plot(log10(time_scales(1)), mfcc_none_mode(1), '-.o', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerFaceColor', mfcc_color, 'MarkerSize', 6);
plot(log10(time_scales(1)), mfcc_lmnn_mode(1), '-o', ...
    'LineWidth', 1.5, 'Color', mfcc_color, ...
    'MarkerFaceColor', mfcc_color, 'MarkerSize', 6);
plot(log10(time_scales), scat_none_mode, '-.d', ...
    'LineWidth', 1.5, 'Color', scat_color, ...
    'MarkerFaceColor', scat_color, 'MarkerSize', 6);
plot(log10(time_scales), scat_lmnn_mode, '-d', ...
    'LineWidth', 1.5, 'Color', scat_color, ...
    'MarkerFaceColor', scat_color, 'MarkerSize', 6);
hold off;
xticks(log10(time_scales));
xticklabels(time_scales*1000);
xlim([log10(0.015), log10(1.5)]);
ylim([40 65]);
xlabel('Time scale (ms)');
ylabel('Precision @ 5 (%)');
title('Playing technique retrieval');
%set(gcf(), 'WindowStyle', 'docked');


set(gcf(), 'Position', [1, 1, 445, 351]);
export_fig results.png -m4 -transparent