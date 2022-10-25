load('1000.mat')
%plot_results(u_opt,x_opt, geo_Params)
mini = min(developed_opt/(10^4));
maxi = max(developed_opt/(10^4));
figure(1);
zoomplot(developed_opt,developing_opt);
f2 = figure(2);
set(f2,'Position',[583,536,515,265]);
scatter(c_range,T_AT_c,'LineWidth',2);
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',12,'FontWeight','bold');
xlabel('$p$','Interpreter','latex','fontsize',16,'FontWeight','bold');
ylabel('$\bf T^{\rm \bf AT}$','Interpreter','latex','fontsize',14,'FontWeight','bold');
