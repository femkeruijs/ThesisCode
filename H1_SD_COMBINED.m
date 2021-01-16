clear
close all

rng(123); %set random number generator

%NOTE: !!!!!!!!!!  RUN SCRIPT 'PERMUTATION_TEST.m' FIRST
%NOTE: !!!!!!!!!! FILE/FUNCTION 'onedogc.m' NEEDS TO BE IN FOLDER


load('raw_sd_data')
data=load('raw_sd_data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% VARIABLES ETC ARE RANDOM FILLER & DONT MAKE SENSE, THEY'RE JUST THERE
%%%%%%%% TO SEE IF THE CODE IS WORKING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1             = res(:,9); % ORIENTATION  ITEM 1
x2             = res(:,8); % ORIENTATION  ITEM 2
x3             = res(:,7); % ORIENTATION  ITEM 3
x4             = res(:,6); % ORIENTATION  ITEM 4

target         = res(:,1); % CUED ITEM (TARGET)
response       = res(:,2); % TARGET RESPONSE
response_error = res(:,3); % RESPONSE ERROR


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% CALCULATE ERRORS FOR EACH TARGET SEPERATELY

err1=response(target==1)-x1(target==1);   %% error target=1
err2=response(target==2)-x2(target==2);   %% error target=2
err3=response(target==3)-x3(target==3);   %% error target=3
err4=response(target==4)-x4(target==4);   %% error target=4


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% ISOLATE RELATIVE DIFFERENCE (RELDIF) BETWEEN EACH
%%%%%%%%%%%%%%%%%%%%%%%% TARGET-ITEM COMBINATION        %%%%%%%%%%%%%%%%%%


%%%%  FORWARD  SD (PRECEDING INFLUENCER)
prec12= x1(target==2)-x2(target==2);   %item 1 on target 2
prec23= x2(target==3)-x3(target==3);   %item 2 on target 3
prec34= x3(target==4)-x4(target==4);   %item 3 on target 4
prec13= x1(target==3)-x3(target==3);   %item 1 on target 3   
prec24= x2(target==4)-x4(target==4);   %item 2 on target 4 
prec14= x1(target==4)-x4(target==4);   %item 1 on target 4 


%%%%%  BACKWARD SD (SUCCEEDING INFLUENCER) 
succ21=x2(target==1)-x1(target==1);   %item 2 on target 1
succ32=x3(target==2)-x2(target==2);   %item 3 on target 2
succ43=x4(target==3)-x3(target==3);   %item 4 on target 3
succ31=x3(target==1)-x1(target==1);   %item 3 on target 1 
succ42=x4(target==2)-x2(target==2);   %item 4 on target 2 
succ41=x4(target==1)-x1(target==1);   %item 4 on target 1 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%       COMBINE AND SCALE DATASETS FOR ANALYSIS       %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%    FORWARD SD (PRECEDING INFLUENCERS)    %%%%%%%%%%%%%%%%
%%%relative differences 
preceding=[prec12;prec23;prec34;prec13;prec24;prec14];
preceding=preceding(:);
preceding(preceding>90)=preceding(preceding>90)-180;       %% scale to range -90/90
preceding(preceding<-90)=preceding(preceding<-90)+180;

%%% response errors
errorprec=[err2;err3;err4;err3;err4;err4];
errorprec=errorprec(:);
errorprec(errorprec>90)=errorprec(errorprec>90)-180;       %% scale to range -90/90
errorprec(errorprec<-90)=errorprec(errorprec<-90)+180;


%%%%%%%%%    BACKWARD SD (SUCCEEDING INFLUENCERS)    %%%%%%%%%%%%%%%%
%%%relative differences
succeeding=[succ21;succ32;succ43;succ31;succ42;succ41];
succeeding=succeeding(:);
succeeding(succeeding>90)=succeeding(succeeding>90)-180;  %% scale to range -90/90
succeeding(succeeding<-90)=succeeding(succeeding<-90)+180;

%%% response errors
errorsucc=[err1;err2;err3;err1;err2;err1];
errorsucc=errorsucc(:);
errorsucc(errorsucc>90)=errorsucc(errorsucc>90)-180;      %% scale to range -90/90
errorsucc(errorsucc<-90)=errorsucc(errorsucc<-90)+180;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%      NONLINEAR REGRESSION FOR PARAMETER ESTIMATION     %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% starting values
x0=[5 0.01 1];
%%% range for plotting predicted values
x = linspace(-90,90,length(x1));


%%% NONLINEAR REGRESSION PRECEDING
model_prec_influencer = fitnlm(preceding,errorprec,@onedogc,x0);  %% model
model_prec_vals = feval(model_prec_influencer, [x' x']);         %% create predicted values based on model
%%% NONLINEAR REGRESSION SUCCEEDING
model_succ_influencer = fitnlm(succeeding,errorsucc,@onedogc,x0); %% model
model_succ_vals = feval(model_succ_influencer, [x' x']);         %% create predicted values based on model


%%% ISOLATE AMPLITUDES AND THEIR P-VALLUES
AmpP = model_prec_influencer.Coefficients.Estimate(1)
AmpS = model_succ_influencer.Coefficients.Estimate(1)
pValP= model_prec_influencer.Coefficients.pValue(1);
pValS= model_succ_influencer.Coefficients.pValue(1);
WidP=1/model_prec_influencer.Coefficients.Estimate(2)
WidS=1/model_succ_influencer.Coefficients.Estimate(2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%   TEST SIGNIFICANCE OF AMPLITUDE DIFFERENCE --- PERMUTATION TEST %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%NOTE: FILE 'PERMUTATION_TEST' MUST BE RUN FOR CODE TO WORK

% load amplitude differences from PERMUTATION_TEST
load('amp_diffs')
% calculate observed amplitude difference
real_amp_diff = AmpP-AmpS;

%%% CALCULATE P-VALUE (TWO-SIDED) BY TAKING PROPORTION ABSOLUTE AMPLITUDE
%%% DIFFERENCES HIGHER THAN OBSERVED
p_value = sum(amp_diffs<real_amp_diff) / length(amp_diffs) + sum(amp_diffs>-real_amp_diff) / length(amp_diffs);

%%% PRINT RESULT
if p_value<.05
    result=sprintf('There is a SIGNIFICANT amplitude difference between forward and backward SD, with p= %.3f and ampdif= %.3f',p_value,real_amp_diff')
else
    result=sprintf('There is NO SIGNIFICANT amplitude difference between forward and backward SD')
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PLOT AMPLITUDE DIFFERENCE DISTRIBUTION FROM PERMUTATION TEST
figure(1)
hold on
set(gcf,'color','white')

histogram(amp_diffs,'normalization','pdf','facecolor',[.7 .7 .7],'edgecolor','none')
f1 = fitdist(amp_diffs','kernel');
xhs = -5:.01:5;
pdf1 = pdf(f1,xhs);
l1 = line(xhs,pdf1,'LineStyle','-','Color',[0 .7 .7],'linewidth',2);

%%%% PLOT OBSERVED AMPLITUDE DIFFERENCE
plot([real_amp_diff real_amp_diff],[0 max(pdf1)],'k','linewidth',2)
annotation('textbox',[0.32 0.72 0.9 0.1],'String','Actual Amp Difference','EdgeColor','none', "FontName", "Times New Roman", "FontSize", 6)

%%%% LABEL AND SAVE PLOT AS PNG
title("Distribution of Amplitude differences between forward/backward SD")
ylabel("Frequency")
xlabel("Amplitude difference")
set(gca, 'FontName', 'Times New Roman');
hold off
a=gcf;
exportgraphics(a,'Permutation_Result.png','Resolution',720);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%      PLOT OBSERVED AND PREDICTED SD VALUES     %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% SORT DATA & SMOOTH ERROR
sorted_succeeding=sortrows([succeeding errorsucc]);   %%% sort data
sorted_preceding=sortrows([preceding errorprec]); %%% sort data

stacked_succeeding=[sorted_succeeding; sorted_succeeding; sorted_succeeding]; %% stack datasets to get correct movmean
smooth_succ_error=movmean(stacked_succeeding(:,2),2000);                   %% movmean
smooth_succ_error=smooth_succ_error(length(sorted_succeeding)+1:length(sorted_succeeding)*2);                          %% select only middle dataset for plotting

stacked_preceding=[sorted_preceding; sorted_preceding; sorted_preceding];  %% stack datasets for movmean
smooth_prec_error=movmean(stacked_preceding(:,2),2000);                  %% movmean
smooth_prec_error=smooth_prec_error((length(sorted_preceding)+1):(length(sorted_preceding)*2));                          %% select only middle dataset for plotting



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%          PLOT FORWARD SD       %%%%%%%%%%%%%%%%%%%%%%

subplot(1,2,1);    
hold on
stem(sorted_preceding(:,1),smooth_prec_error,'Markersize', 0.0000000001, 'Color',[.50, .83, .50, 1])                             %%% SMOOTHED DATA
plot(x,model_prec_vals,'-k','linewidth',2)                                %%% FITTED DATA



    %%%% SHOW AMPLITUDE + SIGNIFICANCE INDICATOR IN PLOT
    if pValP<.05 && pValP>=.001
        str=sprintf("amp=%.1f*",AmpP);
        text(-35,3,str+ "\rightarrow", "FontName", "Times New Roman", "FontSize", 7);
    elseif pValP<.001
        str=sprintf("amp=%.1f**",AmpP);
        text(-35,3,str+ "\rightarrow", "FontName", "Times New Roman", "FontSize", 7);
    else
        str=sprintf("amp=%.1f",AmpP);
        text(-35,3,str+ "\rightarrow", "FontName", "Times New Roman", "FontSize", 7);
    end
    
%%% plot labels
title("Forward SD")
ylabel("Response error (°)", 'FontSize', 8)
xlabel("Relative distance influencer-target (°)", 'FontSize', 8)
axis("square")
axis([-100 100 -10 10])
set(gca, 'FontName', 'Times New Roman');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%          PLOT BACKWARD SD       %%%%%%%%%%%%%%%%%%%%%%

subplot(1,2,2); 
hold on
stem(sorted_succeeding(:,1),smooth_succ_error,'Markersize', 0.0000000001,'Color',[.90, .35, .50, 1])                            %%% SMOOTHED DATA
plot(x,model_succ_vals,'-k','linewidth',2)     %%% FITTED DATA



    %%%% SHOW AMPLITUDE + SIGNIFICANCE INDICATOR IN PLOT
    if pValS<.05 && pValS>=.001
        str=sprintf("amp=%.1f*",AmpS);
        text(-30,3,str+ "\rightarrow", "FontName", "Times New Roman", "FontSize", 7);
    elseif pValS<.001
        str=sprintf("amp=%.1f**",AmpS);
        text(-30,3,str+ "\rightarrow", "FontName", "Times New Roman", "FontSize", 7);
    else
        str=sprintf("amp=%.1f",AmpS);
        text(-30,3,str+ "\rightarrow", "FontName", "Times New Roman", "FontSize", 7);
    end

%%% plot labels
title("Backward SD")
ylabel("Response error (°)", 'FontSize', 8)
xlabel("Relative distance influencer-target (°)", 'FontSize', 8)
axis("square")
axis([-100 100 -10 10])


%%% add significance note and title to plot
annotation('textbox',[0.07 0.1 0.9 0.1],'String','Note: *p<.05  **p<.001','EdgeColor','none', "FontName", "Times New Roman", "FontSize", 8)
sgtitle('Overall Serial Dependence Strength', 'FontName', 'Times New Roman')
set(gca, 'FontName', 'Times New Roman');

%%% save plot as png
b=gcf;
exportgraphics(b,'Forward_Backward_SD.png','Resolution',720);






