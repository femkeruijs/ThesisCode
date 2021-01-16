clear
close all

rng(123); %set random number generator

%NOTE: !!!!!!!!!! RUN THIS SCRIPT BEFORE RUNNING 'H1_SD_COMBINED'
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

error1=response(target==1)-x1(target==1);
error2=response(target==2)-x2(target==2);
error3=response(target==3)-x3(target==3);
error4=response(target==4)-x4(target==4);

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%      COMBINE TO GET ALL RELDIF AND ALL ERRORS

%%% COMBINE ALL SUCCEEDING & PRECEDING EFFECTS IN ONE DATASET
preceding=[prec12;prec23;prec34;prec13;prec24;prec14];
preceding=preceding(:);
succeeding=[succ21;succ32;succ43;succ31;succ42;succ41];
succeeding=succeeding(:);
%%% COMBINE AND SCALE TO -90 TO 90 RANGE
reldif=[preceding;succeeding];
reldif(reldif>90)=reldif(reldif>90)-180;
reldif(reldif<-90)=reldif(reldif<-90)+180;


%%% COMBINE ALL ERRORS
errorprec=[error2;error3;error4;error3;error4;error4];
errorprec=errorprec(:);
errorsucc=[error1;error2;error3;error1;error2;error1];
errorsucc=errorsucc(:);
%%% COMBINE AND SCALE TO -90 TO 90 RANGE
err=[errorprec;errorsucc];
err(err>90)=err(err>90)-180;
err(err<-90)=err(err<-90)+180;

%%% CONVERT INTO SINGLE DATASET
dataset=([reldif err]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%     PERMUTATION TEST FOR AMPLITUDE DIFFERENCE      %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
recompute = 0;

if recompute==0;

    permutations = 10000;
    amp_diffs = nan(1,permutations);
    tic
    
    for i=1:permutations

        i

        % make random logical vector
        swap_index = round(rand(1,length(dataset)));

        % save values
        shuffled_preceding  =   dataset(swap_index==1,1);
        shuffled_succeeding =   dataset(swap_index==0,1);
        preceding_error     =   dataset(swap_index==1,2);
        succeeding_error    =   dataset(swap_index==0,2);



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%% NONLINEAR REGRESSION UNCONSTRAINED MODEL
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        x0=[5 0.01 1];
        model_prec_influencer = fitnlm(shuffled_preceding,preceding_error,@onedogc,x0);
        model_succ_influencer = fitnlm(shuffled_succeeding,succeeding_error,@onedogc,x0);


        ampP = model_prec_influencer.Coefficients.Estimate(1); 
        ampS = model_succ_influencer.Coefficients.Estimate(1);

        amp_diff = ampP-ampS;

        amp_diffs(i) = amp_diff;
    end
    toc

    save('amp_diffs','amp_diffs')
else
    load('amp_diffs')
end


