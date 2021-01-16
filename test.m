clear
close all

range=[1 2 3 4];

%%%% data for amplitude per target
t_amplitude=[4.2466; 3.9711; 3.4301; 2.4364];
target=[1;2;3;4];
table_amplitude=table(t_amplitude,target);
%%% linear regression for target amplitude + predicted vals
model_target=fitlm(table_amplitude)
target_pred_vals = feval(model_target, range);
%%% plot data + predicted model vals
subplot(1,2,1)
set(gca, 'FontName', 'Times New Roman');
plot(range,t_amplitude,'.r','MarkerSize', 15)
hold on
plot(range,target_pred_vals,'-k','linewidth',.5) 
axis([0 5 0 7])
xticks([1 2 3 4])
xlabel('Target')
ylabel('Amplitude')
axis('square')
title('Amplitude per Target*')
set(gca, 'FontName', 'Times New Roman');


%%% data for item amplitudes
i_amplitude=[2.5786; 3.9963; 4.3177; 3.0291];
item=[1; 2; 3; 4];
table_item=table(i_amplitude,item);
%%% linear regression for item amplitudes + predicted vals
x0=[2 3]
model_item= fitlm(table_item)
item_pred_vals = feval(model_item, range);

%%% plot data + predicted vals
subplot(1,2,2)
plot(range,i_amplitude,'.r','MarkerSize', 15)
hold on
plot(range,item_pred_vals,'-k','linewidth',.5) 
axis([0 5 0 7])
xticks([1 2 3 4])
xlabel('Item')
ylabel('Amplitude')
title('Amplitude per Item')
axis('square')
set(gca, 'FontName', 'Times New Roman');

sgtitle('.')
b=gcf;
exportgraphics(b,'Linear_regression_amplitudes.png','Resolution',720);