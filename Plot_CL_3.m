% Run through positions - use linspecer(35) for colours
h = plot(E_field.p5.field_vector_all_amps(:,2:end),'-*','LineWidth',2.5,'DisplayName','E_field.p1.field_vector_all_amps(:,2:end)')
set(h(1), 'Color', '[0.9389    0.3810    0.2693]');
set(h(2), 'Color', '[ 0.9048    0.3296    0.2883]');
set(h(3), 'Color', '[0.8625    0.2778    0.3059]');
set(h(4), 'Color', '[0.8160    0.2182    0.3091]');
set(h(5), 'Color', '[0.7598    0.1518    0.3010]');
set(h(6), 'Color', '[0.6936    0.0802    0.2841]');
set(h(7), 'Color', '[0.6196    0.0039    0.2588]');
legend('10Hz','50Hz','100Hz','500Hz','1000Hz','2500Hz','5000Hz');
legend('Location','northwest')
ylabel('|E(x,y,z)| (V/m)')
set(gca,'FontSize', 14);
set(gca,'TickDir', 'out');
xlabel('Current Amplitude (mA)')
xticks([0 5 10 15 20])
xticklabels({'0','2.5','5','7.5','10'})
set(gca,'FontSize', 14);
set(gca,'TickDir', 'out');
box off

b = {hz10(:,[5,10,15,20]);hz50(:,[5,10,15,20]);hz100(:,[5,10,15,20]);hz500(:,[5,10,15,20]);hz1000(:,[5,10,15,20]);hz2500(:,[5,10,15,20]);hz5000(:,[5,10,15,20])};
aboxplot(b,'labels',[],'colorgrad','green_down');
legend('10Hz','50Hz','100Hz','500Hz','1000Hz','2500Hz','5000Hz');
legend('Location','northwest')
ylabel('Normalised |E(x,y,z)| (V/m)')
set(gca,'FontSize', 14);
set(gca,'TickDir', 'out');
xlabel('Current Amplitude (mA)')
xticklabels({'2.5','5','7.5','10'})
set(gca,'FontSize', 14);
set(gca,'TickDir', 'out');
box off

mA25 = [b{1, 1}(:,1),b{2, 1}(:,1),b{3, 1}(:,1),b{4, 1}(:,1),b{5, 1}(:,1),b{6, 1}(:,1),b{7, 1}(:,1)];
mA5 = [b{1, 1}(:,2),b{2, 1}(:,2),b{3, 1}(:,2),b{4, 1}(:,2),b{5, 1}(:,2),b{6, 1}(:,2),b{7, 1}(:,2)];
mA75 = [b{1, 1}(:,3),b{2, 1}(:,3),b{3, 1}(:,3),b{4, 1}(:,3),b{5, 1}(:,3),b{6, 1}(:,3),b{7, 1}(:,3)];
mA10 = [b{1, 1}(:,4),b{2, 1}(:,4),b{3, 1}(:,4),b{4, 1}(:,4),b{5, 1}(:,4),b{6, 1}(:,4),b{7, 1}(:,4)];

[p,tbl,stats] = anova1(mA25);
[p,tbl,stats] = anova1(mA5);
[p,tbl,stats] = anova1(mA75);
[p,tbl,stats] = anova1(mA10);

bc = bar(not_normalised_hz1000,'DisplayName','not_normalised_hz1000')
set(bc(1), 'FaceColor', '[0.3686    0.3098    0.6353]');
set(bc(2), 'FaceColor', '[0.4140    0.7690    0.6467]');
set(bc(3), 'FaceColor', '[0.9105    0.9606    0.6005]');
set(bc(4), 'FaceColor', '[0.9959    0.8554    0.5152]');
set(bc(5), 'FaceColor', '[0.9389    0.3810    0.2693]');
legend('p1','p2','p3','p4','p5');
legend('Location','northwest')
ylabel('|E(x,y,z)| (V/m)')
set(gca,'FontSize', 14);
set(gca,'TickDir', 'out');
xlabel('Current Amplitude (mA)')
xticks([0 5 10 15 20])
xticklabels({'0','2.5','5','7.5','10'})
set(gca,'FontSize', 24);
set(gca,'TickDir', 'out');
box off