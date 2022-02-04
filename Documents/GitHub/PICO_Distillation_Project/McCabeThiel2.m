function McCabeThiel(Flowrate,Startconc,Reductionfactor,Percentloss,R,q,vol)
% This function models mccabe thiel diagram for radon and freon for a
% temperature 221.17 K and returns min reflux ratio, cooling and heating
% required and end concentration of distillate.

% Flowrate =  Flowrate through the column in kg/hr
% Startconc = Mass concentration of Radon/C3F8 of input feed
% Reduction Factor = Amount output feed of C3F8 is radon reduced by
% Percent Loss = Percent of radon enriched C3F8 mass output
% R = Enriching section reflux ratio of column
% q = gaseous vs liquid feed (q = 0 gas, q = 1 liquid)
% vol = Volatility of Radon/C3F8


% Defining variables
Fd=Flowrate;
xf=Startconc;
xb=Startconc/Reductionfactor; % Bottom concentration
Pl=Percentloss;
Bd=Fd/(1+Pl/100); % Bottom flow rate
Dd=Fd-Bd; % Top flow rate
xd=(Fd*xf-xb*Bd)/Dd; % Top Concentration



totemp=82.7092; % Power required to heat 12kg/hr from 15 -36 C
lhv=12.65*1000/.18802; % Latent heat per mol vaporization C3F8 

% Defining other flow rate specifications for internal column
Ld=R*Dd;
Vd=Dd+Ld;

Lp=Ld+q*Fd;
Vp=Lp-Bd;

Rp=Lp/Bd;


% Vector for liquid concentration values
xrn=1*10^-27:10^-29:5*10^-24;


% Equilibrium, collection adn condensation lines
equil=vol.*xrn./(1+(vol-1).*xrn);
collec=R/(R+1).*xrn+xd/(R+1);
conden=Rp/(Rp-1).*xrn-xb/(Rp-1);

% Cooling required
cool=Ld*lhv/3600+82.7092;

% Heating required
if q==0
    heat=Fd*lhv/3600+Vd*lhv/3600+82.7092;
elseif q==1
    heat=Vd*lhv/3600+82.7092;
end

% Minimum q value calculation
if q==1
    minR=(1/(vol-1)*(xd/xf+vol*(1-xd)/(1-xf)));
elseif q==0
    minR=(1/(vol-1)*(vol*xd/xf-(1-xd)/(1-xf)))-1;
else
end


    

if q<1
    inter=q/(q-1).*xrn-xf/(q-1);
    figure(1)
    loglog(xrn,equil,'r',xrn,collec,'b',xrn,conden,'g',xrn,inter,'k',[xb xb],[min(equil) max(equil)],'k',[xd xd],[min(equil) max(equil)],'k')
    xlim([1*10^-27 5*10^-24])
    ylim([min(conden) max(equil)])
    title('McCabe Thiele diagram C3F8 and Radon')
    ylabel('yRn (Conc vapor phase)')
    xlabel('xRn (Conc liquid phase)')
    legend('Equilibrium Line','Collection Line','Condensation line','Start/End Lines','Location','NorthWest')
   
    
else
    figure(1)
    loglog(xrn,equil,'r',xrn,collec,'b',xrn,conden,'g',[xf xf],[min(equil) max(equil)],'k',[xb xb],[min(equil) max(equil)],'k',[xd xd],[min(equil) max(equil)],'k')
    xlim([1*10^-27 5*10^-24])
    ylim([min(conden) max(equil)])
    title('McCabe Thiele diagram C3F8 and Radon')
    ylabel('yRn (Conc vapor phase)')
    xlabel('xRn (Conc liquid phase)')
    legend('Equilibrium Line','Collection Line','Condensation line','Start/End Lines','Location','NorthWest')
   
end
fprintf('\nMin reflux ratio is %6.2f\n',minR)
fprintf('Cooling required is %6.2f W\n',cool)
fprintf('Heating required is %6.2f W\n',heat)
fprintf('End concentration is %6.2e \n\n',xb)


