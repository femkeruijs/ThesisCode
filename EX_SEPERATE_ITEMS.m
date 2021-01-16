clear
close all

rng(123); %set random number generator

%NOTE: !!!!!!!!!! RUN THIS SCRIPT BEFORE RUNNING 'H1_COMBINED_EFFECTS'
%NOTE: !!!!!!!!!! FILE/FUNCTION 'onedogc.m' NEEDS TO BE IN FOLDER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%   LOAD DATA & DEFINE   VARIABLES      %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('raw_sd_data')
data=load('raw_sd_data');
% res = [target response err m' swaptrials' orientation{4} orientation{3} orientation{2} orientation{1} target_orient' color{1} color{2} color{3} color{4} target_color' d{1}' d{2}' d{3}' d{4}' ppt trialnum ];

x1             = res(:,9); % ORIENTATION  ITEM 1
x2             = res(:,8); % ORIENTATION  ITEM 2
x3             = res(:,7); % ORIENTATION  ITEM 3
x4             = res(:,6); % ORIENTATION  ITEM 4

target         = res(:,1); % CUED TARGET (1-4)
response       = res(:,2); % TARGET RESPONSE
response_error = res(:,3);  % RESPONSE ERROR


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% CALCULATE ERRORS FOR EACH TARGET SEPERATELY

err1=response(target==1)-x1(target==1);
err2=response(target==2)-x2(target==2);
err3=response(target==3)-x3(target==3);
err4=response(target==4)-x4(target==4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% ISOLATE RELATIVE DIFFERENCE (RELDIF) BETWEEN EACH
%%%%%%%%%%%%%%%%%%%%%%%% TARGET-ITEM COMBINATION

%%%%% ALL BACKWARD EFFECTS (SUCCEEDING INFLUENCER) 
succ21=x2(target==1)-x1(target==1);   %item 2 on target 1
succ32=x3(target==2)-x2(target==2);   %item 3 on target 2
succ43=x4(target==3)-x3(target==3);   %item 4 on target 3
succ31=x3(target==1)-x1(target==1);   %item 3 on target 1 
succ42=x4(target==2)-x2(target==2);   %item 4 on target 2 
succ41=x4(target==1)-x1(target==1);   %item 4 on target 1 

%%%% ALL FORWARD EFFECTS (PRECEDING INFLUENCER)
prec12= x1(target==2)-x2(target==2);   %item 1 on target 2
prec23= x2(target==3)-x3(target==3);   %item 2 on target 3
prec34= x3(target==4)-x4(target==4);   %item 3 on target 4
prec13= x1(target==3)-x3(target==3);   %item 1 on target 3   
prec24= x2(target==4)-x4(target==4);   %item 2 on target 4 
prec14= x1(target==4)-x4(target==4);   %item 1 on target 4


Item1=[prec12;prec13;prec14];
Item2=[succ21;prec23;prec24];
Item3=[succ31;succ32;prec34];
Item4=[succ41;succ42;succ43];

Err1=[err2;err3;err4];
Err2=[err1;err3;err4];
Err3=[err1;err2;err4];
Err4=[err1;err2;err3];


reldif= { Item1, Item2, Item3, Item4 };
errseperate =   { Err1,    Err2,    Err3,    Err4    };


%%% MODEL + FITTED VALS SET VALUES
x = linspace(-90,90,length(x4));
x0=[5 0.01 1];

for j=1:4

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%    NONLINEAR REGRESSION FOR AMPLITUDE  %%%%%%%%%%%%%%%%%
    
    relative=cell2mat(reldif(1,j));                     % SELECT RELATIVE DIFFERENCE
    err=cell2mat(errseperate(1,j));                     % SELECT ERROR
    
    relative(relative>90)=relative(relative>90)-180;      %% scale to range -90/90
    relative(relative<-90)=relative(relative<-90)+180;
    err(err>90)=err(err>90)-180;      %% scale to range -90/90
    err(err<-90)=err(err<-90)+180;
    
    
    %%% MODEL + FITTED VALS
    model_sep_influencer = fitnlm(relative,err,@onedogc,x0);
    model_weighed_vals = feval(model_sep_influencer, [x' x']);
    
    %%% MODEL ESTIMATES
    Amp(j) =    model_sep_influencer.Coefficients.Estimate(1)
    pVal(j)=    model_sep_influencer.Coefficients.pValue(1);
    BIC(j) =    model_sep_influencer.ModelCriterion.BIC;
    
    %%%% SORT DATA & SMOOTH ERROR
    sorted_influencer=sortrows([relative err]);   %%% sort data

    stacked_influencer=[sorted_influencer; sorted_influencer; sorted_influencer]; %% stack datasets to get correct movmean
    smooth_error=movmean(stacked_influencer(:,2),2100);                   %% movmean
    smooth_error=smooth_error(length(sorted_influencer)+1:length(sorted_influencer)*2);                          %% select only middle dataset for plotting
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%           PLOT DATA             %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%  DETERMINE POSITION
    figure(1)
    subplot(1,4,j); 
    hold on
    
    
    stem(sorted_influencer(:,1),smooth_error,'Markersize', 0.0000000001, 'Color',[.15, .90, .55, .6]) %%% SMOOTHED DATA
    
    %%%% SHOW AMPLITUDE + SIGNIFICANCE INDICATOR IN PLOT
    if pVal(j)<.05 & pVal(j)>=.001
        str=sprintf("amp=%.1f*",Amp(j));
        text(-90,5,str+ "\downarrow", "FontName", "Times New Roman", "FontSize", 7);
    elseif pVal(j)<.001
        str=sprintf("amp=%.1f**",Amp(j));
        text(-90,5,str+ "\downarrow", "FontName", "Times New Roman", "FontSize", 7);
    else
        str=sprintf("amp=%.1f",Amp(j));
        text(-90,5,str+ "\downarrow", "FontName", "Times New Roman", "FontSize", 7);
    end
        
    %%%% PLOT FITTED MODEL LINE
    plot(x,model_weighed_vals,'-k','linewidth',1)                              
    
   %%%% PLOT SUBPLOT DESCRIPTIVES + AXIS

    %caption = sprintf('Item%d %s Item%d',direction(j,1),'\rightarrow',direction(j,2));  %%CAPTION FOR
    %SEPERATE PLOT TITLES
    ylabel("Response error (°)", 'FontSize', 6)
    xlabel("Relative distance(°)", 'FontSize', 6)
    axis("square")
    axis([-100 100 -10 10])
    set(gca, 'FontName', 'Times New Roman');
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',6)
    if j<5
        caption = sprintf('Item %d',j);
        title(caption, 'FontSize', 9);
    end
    
    
    %%%%% OVERALL PLOT TITLE + annotation for significance
    annotation('textbox',[0.07 0.05 0.9 0],'String','Note: *p<.05  **p<.001','EdgeColor','none', "FontName", "Times New Roman", "FontSize", 8)
    sgtitle('SD Effects per Item', 'FontName', 'Times New Roman')
end
    

%%%%% SAVE PLOT AS PNG IMAGE
b=gcf;
exportgraphics(b,'Seperate_Items.png','Resolution',720);
