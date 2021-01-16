clear
close all

rng(123); %set random number generator

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
response_error = res(:,3); % RESPONSE ERROR

%%%%%%%% CREATE ERRORS  & SCALE TO RANGE

err1=response(target==1)-x1(target==1);
err1(err1>90)=err1(err1>90)-180;                %%%SCALE ERRORS TO BE IN -90/90 RANGE
err1(err1<-90)=err1(err1<-90)+180; 

err2=response(target==2)-x2(target==2);
err2(err2>90)=err2(err2>90)-180;                %%%SCALE ERRORS TO BE IN -90/90 RANGE
err2(err2<-90)=err2(err2<-90)+180; 

err3=response(target==3)-x3(target==3);
err3(err3>90)=err3(err3>90)-180;                %%%SCALE ERRORS TO BE IN -90/90 RANGE
err3(err3<-90)=err3(err3<-90)+180; 

err4=response(target==4)-x4(target==4);
err4(err4>90)=err4(err4>90)-180;                %%%SCALE ERRORS TO BE IN -90/90 RANGE
err4(err4<-90)=err4(err4<-90)+180; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% ISOLATE RELATIVE DIFFERENCE (RELDIF) OF
%%%%%%%%%%%%%%%%%%%%%%%% PRECEDING/SUCCEEDING INFLUENCER & TARGET ERROR


%%%%%%%%%%%%%%%%%    BACKWARD SD (SUCCEEDING INFLUENCER)  %%%%%%%%%%%%%%

% item 2 on item 1
%SUCCEEDING INFLUENCER  + SCALE TO RANGE [-90 90]
succ21=x2(target==1)-x1(target==1);     
succ21(succ21>90)=succ21(succ21>90)-180;
succ21(succ21<-90)=succ21(succ21<-90)+180;

%item 3 on item 2
%SUCCEEDING INFLUENCER  + SCALE TO RANGE [-90 90]
succ32=x3(target==2)-x2(target==2);     
succ32(succ32>90)=succ32(succ32>90)-180;
succ32(succ32<-90)=succ32(succ32<-90)+180; 

% item 4 on item 3
%SUCCEEDING INFLUENCER  + SCALE TO RANGE [-90 90]
succ43=x4(target==3)-x3(target==3);     
succ43(succ43>90)=succ43(succ43>90)-180;
succ43(succ43<-90)=succ43(succ43<-90)+180;  

% item 3 on item 1
%SUCCEEDING INFLUENCER  + SCALE TO RANGE [-90 90]
succ31=x3(target==1)-x1(target==1);     
succ31(succ31>90)=succ31(succ31>90)-180;
succ31(succ31<-90)=succ31(succ31<-90)+180;
  
%item 4 on item 2
%SUCCEEDING INFLUENCER  + SCALE TO RANGE [-90 90]
succ42=x4(target==2)-x2(target==2);     
succ42(succ42>90)=succ42(succ42>90)-180;
succ42(succ42<-90)=succ42(succ42<-90)+180;  

% item 4 on item 1
%SUCCEEDING INFLUENCER  + SCALE TO RANGE [-90 90]
succ41=x4(target==1)-x1(target==1);     
succ41(succ41>90)=succ41(succ41>90)-180;
succ41(succ41<-90)=succ41(succ41<-90)+180;  




%%%% FORWARD SD (PRECEDING INFLUENCER)

% item 1 on item 2
%PRECEDING INFLUENCER  + SCALE TO RANGE [-90 90]  
prec12= x1(target==2)-x2(target==2);    
prec12(prec12>90)=prec12(prec12>90)-180;
prec12(prec12<-90)=prec12(prec12<-90)+180;

%item 2 on item 3
%PRECEDING INFLUENCER  + SCALE TO RANGE [-90 90]  
prec23= x2(target==3)-x3(target==3);   
prec23(prec23>90)=prec23(prec23>90)-180;
prec23(prec23<-90)=prec23(prec23<-90)+180;

%item 3 on item 4
%PRECEDING INFLUENCER  + SCALE TO RANGE [-90 90]  
prec34= x3(target==4)-x4(target==4);   
prec34(prec34>90)=prec34(prec34>90)-180;
prec34(prec34<-90)=prec34(prec34<-90)+180;

%item 1 on item 3
%PRECEDING INFLUENCER  + SCALE TO RANGE [-90 90]  
prec13= x1(target==3)-x3(target==3);    
prec13(prec13>90)=prec13(prec13>90)-180;
prec13(prec13<-90)=prec13(prec13<-90)+180;

%item 2 on item 4
%PRECEDING INFLUENCER  + SCALE TO RANGE [-90 90]  
prec24= x2(target==4)-x4(target==4);    
prec24(prec24>90)=prec24(prec24>90)-180;
prec24(prec24<-90)=prec24(prec24<-90)+180;

% item 1 on item 4
%PRECEDING INFLUENCER  + SCALE TO RANGE [-90 90]  
prec14= x1(target==4)-x4(target==4);    
prec14(prec14>90)=prec14(prec14>90)-180;
prec14(prec14<-90)=prec14(prec14<-90)+180;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% COMBINE TO GET RELATIVE DIFFERENCE OF PRECEDING, SUCCEEDING AND
%%%%%%%%%%%%%%% THE TARGET ERROR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% FORWARD SD

reldif      =  {1,   succ21,  succ31,  succ41, prec12, 6,  succ32, succ42, prec13, prec23, 11,  succ43, prec14, prec24, prec34, 16};
errseperate =  {1,   err1,    err1,    err1,   err2,   6,  err2,   err2,   err3,   err3,   11,  err3,   err4,   err4,   err4,   16};
direction=[ 1 1;
            2 1;
            3 1;     
            4 1; 
            1 2; 
            2 2;  
            3 2;
            4 2; 
            1 3; 
            2 3;  
            3 3;
            4 3;        
            1 4;         
            2 4;
            3 4;
            4 4; ];

%%% MODEL + FITTED VALS SET VALUES
x = linspace(-90,90,length(x4));
x0=[5 0.01 1];

for j=1:16
    %%% CREATE EMPTY PLOTS FOR ITEM==TARGET TRIALS
    if j==1| j==6|j==11|j==16
        subplot(4,4,j);
        xvel1=[-70 70];
        xvel2=[70 -70];
        yvel=[-70 70];
        plot(xvel1,yvel,'k');
        hold on
        plot(xvel2,yvel,'k');
            if j<5
                caption = sprintf('Item %d',j);
                title(caption, 'FontSize', 9)
            end
        %set(gca,'visible','off')
        set(gca,'xtick',[]);
        set(gca,'xticklabel',[]);
        set(gca,'ytick',[]);
        set(gca,'yticklabel',[]);
        set(gca, 'FontName', 'Times New Roman');
    else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%    NONLINEAR REGRESSION FOR AMPLITUDE  %%%%%%%%%%%%%%%%%
    
    relative=cell2mat(reldif(1,j));                     % SELECT RELATIVE DIFFERENCE
    err=cell2mat(errseperate(1,j));                     % SELECT ERROR
    
    %%% MODEL + FITTED VALS
    model_sep_influencer = fitnlm(relative,err,@onedogc,x0);
    model_weighed_vals = feval(model_sep_influencer, [x' x']);
    
    %%% MODEL ESTIMATES
    Amp(j) =    model_sep_influencer.Coefficients.Estimate(1);
    pVal(j)=    model_sep_influencer.Coefficients.pValue(1);
    BIC(j) =    model_sep_influencer.ModelCriterion.BIC;
    
    %%%% SORT DATA & SMOOTH ERROR
    sorted_influencer=sortrows([relative err]);   %%% sort data

    stacked_influencer=[sorted_influencer; sorted_influencer; sorted_influencer]; %% stack datasets to get correct movmean
    smooth_error=movmean(stacked_influencer(:,2),700);                   %% movmean
    smooth_error=smooth_error(length(sorted_influencer)+1:length(sorted_influencer)*2);                          %% select only middle dataset for plotting
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%           PLOT DATA             %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%  DETERMINE POSITION
    figure(1)
    subplot(4,4,j); 
    hold on
    
    %%%%% PLOT SMOOTHED DATA IN BACKWARD/FORWARD COLOR
    if direction(j,1)>direction(j,2)  
        stem(sorted_influencer(:,1),smooth_error,'Markersize', 0.0000000001, 'Color',[.90, .35, .50, 1]) %%% SMOOTHED DATA
    else
        stem(sorted_influencer(:,1),smooth_error,'Markersize', 0.0000000001, 'Color',[.50, .83, .50, 1]) %%% SMOOTHED DATA
    end
    
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
%     axis("square")
    axis([-100 100 -10 10])
    set(gca, 'FontName', 'Times New Roman');
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',6)
    if j<5
        caption = sprintf('Item %d',j);
        title(caption, 'FontSize', 9);
    end
    
%%% add column names to reflect target
annotation('textbox', [0,0,.5,.84], 'String','Target 1', 'EdgeColor','none', "FontName", "Times New Roman",'fontweight','bold', "FontSize", 9);
annotation('textbox', [0,0,.5,.63], 'String','Target 2', 'EdgeColor','none', "FontName", "Times New Roman",'fontweight','bold', "FontSize", 9);
annotation('textbox', [0,0,.5,.42], 'String','Target 3', 'EdgeColor','none', "FontName", "Times New Roman",'fontweight','bold', "FontSize", 9);
annotation('textbox', [0,0,.5,.21], 'String','Target 4', 'EdgeColor','none', "FontName", "Times New Roman",'fontweight','bold', "FontSize", 9);

    
    %%%%% OVERALL PLOT TITLE + annotation for significance
    annotation('textbox',[0.07 0.05 0.9 0],'String','Note: *p<.05  **p<.001','EdgeColor','none', "FontName", "Times New Roman", "FontSize", 8)
    sgtitle('Seperate Serial Dependence Effects', 'FontName', 'Times New Roman')
    end
    
end

%%%%% SAVE PLOT AS PNG IMAGE
b=gcf;
exportgraphics(b,'Seperate_SD.png','Resolution',720);