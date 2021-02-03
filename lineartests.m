clear
close all
load('Amp')
range=[1 2 3 4];

%%%% data for amplitude per target
t_amplitude=[4.2466; 3.9711; 3.4301; 2.4364];
target=[1;2;3;4];
table_amplitude=table(target,t_amplitude);
%%% linear regression for target amplitude + predicted vals
model_target=fitlm(table_amplitude)
target_pred_vals = feval(model_target, range);
%%% plot data + predicted model vals
subplot(1,3,1)
set(gca, 'FontName', 'Times New Roman');
plot(range,t_amplitude,'.', 'Color',[.15, .55, .90, .6], 'MarkerSize', 15)
hold on
plot(range,target_pred_vals,'-k','linewidth',.5) 
axis([0 5 0 7])
xticks([1 2 3 4])
xlabel('Target')
ylabel('Amplitude (°)')
axis('square')
title('Amplitudes per Target*')
set(gca, 'FontName', 'Times New Roman');


%%% data for item amplitudes
i_amplitude=[2.5786; 3.9963; 4.3177; 3.0291];
item=[1;2;3;4];
table_item=table(item,i_amplitude);
%%% linear regression for item amplitudes + predicted vals
x0=[2 3]
model_item= fitlm(table_item)
item_pred_vals = feval(model_item, range);

%%% plot data + predicted vals
subplot(1, 3, 2)
plot(range,i_amplitude,'.','Color', [.15, .90, .55, .6], 'MarkerSize', 15)
hold on
plot(range,item_pred_vals,'-k','linewidth',.5) 
axis([0 5 0 7])
xticks([1 2 3 4])
xlabel('Item')
ylabel('Amplitude (°)')
title('Amplitudes per Item')
axis('square')
set(gca, 'FontName', 'Times New Roman');

range_distance=[1 2 3];
%%%% data for amplitude per distance
d_amplitude=[4.255310366601133; 2.093265642916319; 4.113956913925683];
distance=[1;2;3];
table_distance=table(distance,d_amplitude);
%%% linear regression for target amplitude + predicted vals
model_distance=fitlm(table_distance)
distance_pred_vals = feval(model_distance, range_distance);
%%% plot data + predicted model vals
subplot(1,3,3)
set(gca, 'FontName', 'Times New Roman');
plot(range_distance,d_amplitude,'.', 'Color',[1, .65, .0, .6], 'MarkerSize', 15)
hold on
plot(range_distance,distance_pred_vals,'-k','linewidth',.5) 
axis([0 4 0 7])
axis('square')
xticks([1 2 3])
xlabel('Distance')
ylabel('Amplitude (°)')
title('Amplitudes per Distance')
set(gca, 'FontName', 'Times New Roman');

sgtitle('.')
b=gcf;
exportgraphics(b,'Linear_regression_amplitudes.png','Resolution',720);