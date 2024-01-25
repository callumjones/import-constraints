function y = solve_ss(x,p)

rho=p(1);
chi=p(2);
psi=p(3);
beta=p(4);
alpha=p(5);
eta=p(6);
xi=p(7); 
eps=p(8);
i0=p(9);
Cstar=p(10);
rmc_star=p(11);
gamma=p(12);
kappa=p(13);
sigma=p(14);

RW=x(1);
RMC=x(2);
Y=x(3);
C=x(4);
X=x(5);
XD=x(6);
XF=x(7);
Q=x(8);
L=x(9);
RPX=x(10);
E=x(11);
RPF=x(12);
CF=x(13);
CH=x(14);

%Consumption
y(1)=RW*C^(-rho)-chi*L^(psi);

%Production
y(2)=RMC-RW^alpha*RPX^(1-alpha);
y(3)=RW*L-alpha*RMC*Y;
y(4)=RPX*X-(1-alpha)*RMC*Y;
y(5)=RPX^(1-eta)-xi*1^(1-eta)-(1-xi)*(RPF)^(1-eta);
y(6)=XD-xi*(RPX)^(eta)*X;
y(7)=XF-(1-xi)*RPF^(-eta)*RPX^(eta)*X;
y(8)=E-Q^sigma*Cstar;
y(9)=1-kappa*(1-RMC);
y(10)=Y-CH-XD-E;
y(11)=(C/Cstar)^(-rho)*Q-1;
y(12)=1-kappa*(1-Q*rmc_star/RPF);
y(13)=CH-gamma*C;
y(14)=CF-(1-gamma)*C*RPF^(-eps);

end