r = linspace(0,100);
bl_color = lines( length( numberOfRandomBodies_vector ) );
dtb_string = {'UE in Pocket', 'UE in Hand'};

for dtb=1:2;
figure(dtb);
clf(dtb);

for nb=1:length(numberOfRandomBodies_vector);
h(nb) = plot(r, ...
    sim.ProbApBlocked(r,sim.distanceToTopHead,...
                sim.apHeight,distanceToUserBody_vector(dtb),...
                sim.bodyWide,sim.areaSide/2,...
                numberOfRandomBodies_vector(nb) ), ...
    '-',  ...
    'Color', bl_color(nb,:),...
    'LineWidth', 1.5,...
        'DisplayName', ...
        num2str([numberOfRandomBodies_vector(nb),ppm2(nb)],...
        'N_b = %d, %.3f body/m^2'));
hold on;
end
for nb=1:length(numberOfRandomBodies_vector);
prob = blockageRelFreq{dtb,nb};
plot(prob(:,2),prob(:,1), ...
        'x',  ...
        'Color', bl_color(nb,:));

end


title(strcat(dtb_string(dtb),...
    num2str([sim.areaSide,sim.areaSide],', N_b bodies per %dx%d m^2')));
legend([h(1),h(2),h(3)],...
    'Location','Best');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
xlabel('Distance from UE to AP (m)');
ylabel('Probability of Blockage');
% set(gca,'XTick',[1;2;5;10;20;50;100]);
% set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
ylim([ 0 1 ]);
xlim( [ 1 100 ] );
%%
clear fig;
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];

figname = strcat('figures/fig',...
    num2str([20+dtb],'%d_probBlockage'));
print(fig,figname,'-dpdf','-r0');
end