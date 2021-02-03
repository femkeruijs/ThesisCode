clear
close all

%%%% data for amplitude per target
t_amplitude=load('AmpTarget');
t_amplitude=t_amplitude.Amp(:);
target=[1;2;3;4];

%%% data for item amplitudes
i_amplitude=load('AmpItem');
i_amplitude=i_amplitude.Amp(:);
item=[1;2;3;4];

%%% data for distance amplitudes
d_amplitude=load('AmpDistance');
d_amplitude=d_amplitude.Amp(:);
distance=[1;2;3];

%%% sort data, labels, and colors for analysis/plotting
amplitudes={t_amplitude, i_amplitude, d_amplitude};
ranges={target, item, distance};
label=["Target" "Item" "Distance"];
colors={.15, .55, .90, .6; .15, .90, .55, .6; 1, .65, .0, .6};

for i = 1:3
    %%%obtain amplitude and range
    amplitude=cell2mat(amplitudes(1,i));
    range=cell2mat(ranges(1,i));
    %%%linear regression + predicted values
    linear_model=fitlm(range,amplitude)
    predicted_vals=feval(linear_model,range);
    
    %%% PLOT DATA
    subplot(1,length(ranges),i)
    plot(range,predicted_vals,'-k','linewidth',.5) %%%PLOT REGRESSION LINE
    hold on
    plot(range,amplitude,'.', 'Color',[cell2mat(colors(i,:))], 'MarkerSize', 15) %%% PLOT AMPLITUDES
    
    %%set title and axis labels
    if linear_model.Coefficients.pValue(1)<.05                  %%% ADD SIGNIFICANCE INDICATOR TO TITLE
        caption = sprintf('Amplitudes per %s*',label(i));
    else
        caption = sprintf('Amplitudes per %s',label(i));
    end
    title(caption, 'FontSize', 9);
    ylabel('Amplitude (°)')
    xlabel(label(i))
    
    %%set axis properties
    xticks([range])
    axis([0 length(range)+1 0 7])
    axis('square')
    set(gca, 'FontName', 'Times New Roman');
    hold off
end

%%save image
b=gcf;
exportgraphics(b,'Linear_regression_amplitudes.png','Resolution',720);
