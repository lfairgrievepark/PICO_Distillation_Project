function radonreturntime(FlowRate,Reduction,background,runtime,detecttime,repeats)
% Flowrate: Flowrate of distillation system in kg/hr
% Reduction: Reduction factor that distillation system applies
% background: Radon presence in the system (uBq)
% runtime: How long each distillation cycle is run for
% detecttime: How long the column is no operational for
% repeats: Number of distillation/detection cycles

% This model assumes an 800kg detector and takes the radon background
% radiation to be equal to radon emenation of the system. It solves for the
% radon background while running a distillation column that applies a
% constant reduction factor.

bg=background; %background radiation
Fr=FlowRate./3600./800; % Flowrate in %/s
lam=2.098*10^-6; % Decay const. of radon



Ns=bg/lam; % Number of radon atoms present at start #/kg
Nmin=Ns/(1+Fr./lam*(1-1./Reduction)); % Min radon atoms capable of being
% achieved with parameters

del=(lam+Fr*(1-Reduction^-1)); % Factor for simplifying differential



if repeats==0
t1=0:1:3600*runtime; %Time period spent distilling
t2=3600*runtime+1:1:3600*(runtime+detecttime); % Time spent not distilling
ttot=0:1:(3600*(detecttime+runtime));


N1 = -(bg/del-Ns)*exp(-del.*t1)+bg/del; % # radon atoms while running
N2= -(bg/lam-N1(3600*runtime)).*exp(-lam.*(t2-3600*runtime))+bg/lam;
% # of radon atoms while not running

th=ttot./(3600*24); %Total time in days
tz=[0 (detecttime+runtime)/24]; % Vector to display baselines

N= [N1 N2];

rate = N.*lam*10^6; % Radon rate
bgmin = Nmin*lam*10^6; % Minimum background rate
rat=N./Ns; % Ratio in terms of original rate


% Does same thing as previous loop but for multiple cycles   
else
    N=[];
    N2=[Ns];
    for i=0:1:repeats
        t1=0:1:(3600*runtime);
        t2=(3600*runtime+1):1:3600*(runtime+detecttime);


        N1 = -(bg/del-N2(end))*exp(-del.*t1)+bg/del;
        N2 = -(bg/lam-N1(end)).*exp(-lam.*(t2-3600*runtime))+bg/lam;
        N= [N N1 N2];
    end
    N = N(1:end-repeats);
    ttot=0:1:(3600*(repeats+1)*(detecttime+runtime));
    rate = N.*lam*10^6;
    bgmin = Nmin*lam*10^6;
    rat=N./Ns;
    th=ttot./(3600*24);
    tz=[0 (1+repeats)*(detecttime+runtime)/24];
    
end

minval=min(N);
        
    


figure(1)
plot(th,rate,tz,[bgmin bgmin],'k--',tz,[bg*10^6 bg*10^6],'k--');
title('Radon background over time');
ylabel('Radon Background (uBq)');
xlabel('Time (days)');
legend('Radon level','Max/Min level');
ylim([0 bg*10^6+5]);



figure(2)
plot(th,rat,tz,[Nmin/Ns Nmin/Ns],'b--')
title('Radon level as fraction of maximum');
ylabel('Radon amount (N/Nmax)');
xlabel('Time (days)');
ylim([0 1]);
legend('Radon level','Min level');


fprintf('\nThe lowest background reached is %6.4f uBq \n',minval*lam*10^6)
fprintf('This is a reduction factor of %6.4f\n\n', bg/minval/lam)
fprintf('\nThe lowest achievable background is %6.4f uBq \n',bgmin)
fprintf('This is a reduction factor of %6.4f\n\n', bg*10^6/bgmin)

if repeats~=0
    fprintf('The average radon reduction during detection is %6.4f\n\n',Ns/mean(N2))
end
    






