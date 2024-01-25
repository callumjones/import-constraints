
var 
    l c ch cf m mh mf y e  
    rw rmc rph rpf rpm i q pi pih pif f y_star piftilde
    thet rmc_star cs ;
varexo 
    eps_thet ;
parameters 
    BETA RHO PSI EPS ETA ALPHA SIGMA PHI OMEGA RHO_i  
    RHO_thet sig_thet 
    coefm coefc 
    CHoY MHoY EoY CFoY_STAR MFoY_STAR KAPPA RPF ;

BETA     = 0.995; 
RHO      = 2; 
PSI      = 2;
EPS      = 2;
ETA      = 0.5;
ALPHA    = 2/3;
SIGMA    = 0.5;
calvo    = 0.75 ; % Calibrate PHI to match calvo of .75
KAPPA    = 4 ;
PHI      = (calvo*(KAPPA-1))/((1-calvo)*(1-BETA*calvo)); 
i0       = 1/BETA-1;
OMEGA    = 1.5;
RHO_i    = 0.5;
GAMMA    = 0.75 ;
XI       = 0.75;
CHI      = 1 ;
CSS      = 1 ;
RHO_thet = 0.5 ;
sig_thet = 1 ;

p=zeros(14,1);
    
p(1)=RHO;
p(2)=CHI;
p(3)=PSI;
p(4)=BETA;
p(5)=ALPHA;
p(6)=ETA;
p(7)=XI;
p(8)=EPS;
p(9)=i0;
p(10)=CSS;
p(11)=(KAPPA-1)/KAPPA;
p(12)=GAMMA;
p(13)=KAPPA;
p(14)=SIGMA;

options = optimoptions('fsolve','Display','iter') ;
x0      = ones(14,1)+rand(14,1) ;
myss    = fsolve(@(x)solve_ss(x,p),x0,options) ;

coefm       = -(1-XI)/XI * myss(12)^(-ETA) ; 
coefc       = -(1-GAMMA)/GAMMA * myss(12)^(-EPS) ; 
CHoY        = myss(14)/myss(3) ;
MHoY        = myss(6)/myss(3) ;
EoY         = myss(11)/myss(3) ;
CFoY_STAR   = myss(13)/(myss(13) + myss(7)) ;
MFoY_STAR   = myss(7)/(myss(13) + myss(7)) ;
RPF         = myss(12) ;

model(linear);

% import pricing 1
[name='imp_pr',relax='con']
f=0 ; 
[name='imp_pr',bind='con']
CFoY_STAR * cf + MFoY_STAR * mf = log(1.02) ;

% euler 2
0 = thet(+1)-thet-RHO*(c(+1)-c)+i-pi(+1);

% labor supply 3
-RHO*c + rw = PSI*l;

% consumer allocation 4
ch = -EPS * rph + c ;

% consumer allocation 5
cf = -EPS * rpf + c ;

% demand for labor 6
rw + l = rmc + y;

% demand of intermediate good composite 7
rpm + m = rmc + y ;

% demand of domestic intermediates 8
mh = -ETA*(rph - rpm) + m ;

% demand of foreign intermediates 9
mf = -ETA*(rpf - rpm) + m ;

% marginal cost 10
rmc = ALPHA * rw + (1-ALPHA) * rpm ;

% domestic pricing 11
pih = (KAPPA-1)/PHI * (rmc - rph) + BETA*pih(+1); 

% import pricing 12
pif = (KAPPA-1)/PHI * (rmc_star + q - rpf) + KAPPA/PHI * (1/RPF) * f + BETA*pif(+1); 

% relative price of home intermediate 13
rph-rpm = coefm * (rpf-rpm) ;

% relative price of home consumption 14
rph = coefc * rpf ;

% resource constraint of y 15
y = CHoY * ch + MHoY * mh + EoY * e ;

% resource constraint of y_star 16
y_star = CFoY_STAR * cf + MFoY_STAR * mf ;

% exports 17
e = SIGMA*q - SIGMA*rph + cs ; 

% Risk sharing 18
c = cs + (q + thet)/RHO;

% Taylor rule 19
i = OMEGA*(1-RHO_i)*pi + RHO_i * i(-1) ;

% auxiliary pih 20
pih = (rph - rph(-1)) + pi ;

% auxiliary pif 21
pif = (rpf - rpf(-1)) + pi ;

% exogenous theta 22
thet = RHO_thet*thet(-1) + sig_thet/100 * eps_thet ;

% exogenous cs 23
cs = 0 ;

% exogenous rmc_star 24
rmc_star = 0 ;

% producer price inflation 25
piftilde = pif - (1/RPF)*(f-f(-1)) ;

end;

resid(1);

steady;
check;

occbin_constraints ; 
    name 'con'; 
        bind (CFoY_STAR * cf + MFoY_STAR * mf) >= log(1.02) + 1e-8 ; 
        relax (CFoY_STAR * cf + MFoY_STAR * mf) < log(1.02) - 1e-8 ; 
end ; 

shocks;
var eps_thet = 1^1 ;
end;

seq = [4.75,0] ;

shocks(surprise,overwrite);
    var eps_thet;
    periods 1:2 ;
    values (seq) ;
end;

stoch_simul(order=1,nocorr,nomoments,irf=20,nograph);

occbin_setup(simul_maxit=100, simul_debug, simul_periods=20, simul_check_ahead_periods=20) ;
occbin_solver ;
