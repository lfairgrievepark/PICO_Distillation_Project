function Totalreduction
% This model determines the fractional steady state radon concentration in
% the target volume as a result of a distillation procedure. Aspects of the
% distillation column that effect the reduction in radon concentration is
% the flow rate of the column and reduction ability of the column as well
% as the radon introduction (ementation rate) which can be calculated by
% taking a steady state radon level and assuming all radon that decays will
% be replaced to keep value constant (basically radon emanation rate will
% be function of inital radon presence, assuming presence is const. w/o
% some external effect.)

%Given some radon background we can find the emenation rate assuming a
%steady state ie. emR=N*lam where emR=emanation rate, N=radon number at steady
%state, lam=decay const.

lam=2.098*10^-6;
N=350;
emR=N*lam;

%Flow rate in kg per hour
FRkg=transpose([6 12 20 40 60 80 120 200])
%Distillation reduction rate
Red=[1.5 3 5 10 25 50 100 100000]
%Flowrate in ratio per sec
FRr=FRkg./3600./800;

Redfac=1+FRr./lam*(1-1./Red)

%surf(FRkg,Red,Nnew)
%colormap hsv
%colorbar
%xlabel('Flowrate')
%ylabel('Reduction value')
%zlabel('Radon # steady state')

csvwrite('Total reduction values',Redfac)



