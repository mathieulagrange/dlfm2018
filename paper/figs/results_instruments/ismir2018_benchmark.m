f = open('Fig149.fig');

%%
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


%%
mfcc_color = 'b';
scat_color = 'r';

clf();
figure(2);
subplot(121);
hold on;
plot(log10(time_scales), mfcc_none_inst, '--', ...
    'LineWidth', 2.0, 'Color', mfcc_color);
plot(log10(time_scales), mfcc_lmnn_inst, '-', ...
    'LineWidth', 2.0, 'Color', mfcc_color);
plot(log10(time_scales), scat_none_inst, '--o', ...
    'LineWidth', 2.0, 'Color', scat_color, 'MarkerSize', 6);
plot(log10(time_scales), scat_lmnn_inst, '-o', ...
    'LineWidth', 2.0, 'Color', scat_color);
ylim([75 100]);
hold off;

subplot(122);
hold on;
plot(log10(time_scales), mfcc_none_mode, '--', ...
    'LineWidth', 2.0, 'Color', mfcc_color);
plot(log10(time_scales), mfcc_lmnn_mode, '-', ...
    'LineWidth', 2.0, 'Color', mfcc_color);
plot(log10(time_scales), scat_none_mode, '--o', ...
    'LineWidth', 2.0, 'Color', scat_color, 'MarkerSize', 6);
plot(log10(time_scales), scat_lmnn_mode, '-o', ...
    'LineWidth', 2.0, 'Color', scat_color);
hold off;
ylim([40 65]);
set(gcf(), 'WindowStyle', 'docked');