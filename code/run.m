%
% Comin, Johnson, Jones (2024) "Import Constraints"
%

%% Preliminaries

warning('Off','all') ;

path(pathdef)

% Figure defaults
set(groot, 'DefaultAxesLineWidth', 1);
set(groot, 'DefaultLineLineWidth', 1.5);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultTextInterpreter','latex');
set(groot, 'DefaultAxesFontSize',14);
set(groot, 'defaultAxesXGrid','on')
set(groot, 'defaultAxesYGrid','on')
set(groot, 'DefaultAxesBox', 'on');

list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end

darkblue    = [0.02  0.28, 0.46];     % dark blue
maroon      = [0.64, 0.08, 0.18];     % maroon

%% Run Models

dynare model.mod

oo_priced = oo_ ;

n_ = M_.endo_nbr ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables
n_ = n_+1 ;        % Constant

setup_priced.variable.n_ = n_ ; 
setup_priced.variable.l_ = l_ ; 
setup_priced.nparam      = M_.param_nbr ;

var_names   = cellstr(M_.endo_names) ;
param_names = cellstr(M_.param_names) ;
exo_var_names = cellstr(M_.exo_names) ;

for ii=1:n_-1
    eval(['setup_priced.variable.',var_names{ii},'=',int2str(ii),';']) ;
end

save results oo_priced setup_priced

dynare model_unpriced.mod

oo_unpriced = oo_ ;

n_ = M_.endo_nbr ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables
n_ = n_+1 ;        % Constant

setup_unpriced.variable.n_ = n_ ; 
setup_unpriced.variable.l_ = l_ ; 
setup_unpriced.nparam      = M_.param_nbr ;

var_names   = cellstr(M_.endo_names) ;
param_names = cellstr(M_.param_names) ;
exo_var_names = cellstr(M_.exo_names) ;

for ii=1:n_-1
    eval(['setup_unpriced.variable.',var_names{ii},'=',int2str(ii),';']) ;
end

%% Draw Figures

figure ;

subplot(2,2,1);  hold on ;
plot(400*oo_priced.occbin.simul.piecewise(:,setup_priced.variable.pi),'Color',darkblue)
plot(400*oo_unpriced.occbin.simul.piecewise(:,setup_unpriced.variable.pi),'-.','Color',maroon)
xlim([0 8]) ;
line([0 8],[0 0],'Color','k','LineWidth',1) ;
legend('Trade Cost Adjusts','Trade Cost Fixed','','location','northeast') ;
exportgraphics(gcf, '../results/figure1a.pdf');
close

figure ;
subplot(2,2,1);  hold on ;
plot(400*oo_priced.occbin.simul.piecewise(:,setup_priced.variable.pih),'Color',darkblue)
plot(400*oo_unpriced.occbin.simul.piecewise(:,setup_unpriced.variable.pih),'-.','Color',maroon)
xlim([0 8]) ;
line([0 8],[0 0],'Color','k','LineWidth',1) ;
%legend('Priced','Unpriced','','location','northeast') ;
exportgraphics(gcf, '../results/figure1b.pdf');
close

figure ;
subplot(2,2,1);  hold on ;
plot(400*oo_priced.occbin.simul.piecewise(:,setup_priced.variable.pif),'Color',darkblue)
plot(400*oo_unpriced.occbin.simul.piecewise(:,setup_unpriced.variable.pif),'-.','Color',maroon)
xlim([0 8]) ;
line([0 8],[0 0],'Color','k','LineWidth',1) ;
exportgraphics(gcf, '../results/figure1c.pdf');
close

figure;
subplot(2,2,1); 
yyaxis left
plot(400*oo_priced.occbin.simul.piecewise(:,setup_priced.variable.piftilde),'Color',darkblue)
line([0 8],[0 0],'Color','k','LineWidth',1,'LineStyle','-') ;
set(gca,'ycolor','k') 
ylim([-40 40]) ;
yyaxis right
plot(400*oo_unpriced.occbin.simul.piecewise(:,setup_unpriced.variable.piftilde),'-.','Color',maroon)
set(gca,'ycolor','k') 
line([0 8],[0 0],'Color','k','LineWidth',1) ;
xlim([0 8]) ;
ylim([-.4 .4]) ;
h=legend('Trade Cost Adjusts (LHS)','','Trade Cost Fixed (RHS)','','location','southeast') ;
set(h,'FontSize',8)
exportgraphics(gcf, '../results/figure2a.pdf');
close

figure ;
subplot(2,2,1) ; hold on ;
plot(100*oo_priced.occbin.simul.piecewise(:,setup_priced.variable.cf),'Color',darkblue)
plot(100*oo_priced.occbin.simul.piecewise(:,setup_priced.variable.mf),'-o','Color',darkblue)
plot(100*oo_unpriced.occbin.simul.piecewise(:,setup_unpriced.variable.cf),'-.','Color',maroon)
plot(100*oo_unpriced.occbin.simul.piecewise(:,setup_unpriced.variable.mf),'-.o','Color',maroon)
h=legend('Cons., Trade Cost Adjusts','Inputs, Trade Cost Adjusts','Cons., Trade Cost Fixed','Inputs, Trade Cost Fixed','location','northeast') ;
set(h,'FontSize',8) ;
xlim([0 8]) ;
exportgraphics(gcf, '../results/figure2b.pdf');
close

% EOF