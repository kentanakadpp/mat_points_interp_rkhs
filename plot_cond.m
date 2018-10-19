clear all;
close all;
dir_cnd = './DataCnd/'; % Directory to save the data of the power functions

% keyword = 'Brown1D_'; x_max = 25;
% keyword = 'Gauss1D_'; x_max = 25;
% keyword = 'Gauss2D_sqr_'; x_max = 35;
% keyword = 'Gauss2D_tri_'; x_max = 35;
% keyword = 'Gauss2D_dsk_'; x_max = 35;
keyword = 'sphere_'; x_max = 35;

basic_str = strcat(dir_cnd, keyword); 
file_proposed = strcat(basic_str, 'cnd.txt'); 
file_proposed_seq = strcat(basic_str, 'cnd_seq.txt');
file_pgreedy = strcat(basic_str, 'cnd_pg.txt');

dat_proposed = dlmread(file_proposed);
dat_proposed_seq = dlmread(file_proposed_seq);
dat_pgreedy = dlmread(file_pgreedy);

plot(dat_proposed(:,1), dat_proposed(:,2), '--.', 'MarkerSize', 25, 'LineWidth', 2); 
hold on;
plot(dat_proposed_seq(:,1), dat_proposed_seq(:,2), '-->', 'MarkerSize', 5, 'LineWidth', 2); 
plot(dat_pgreedy(:,1), dat_pgreedy(:,2), '--<', 'MarkerSize', 5, 'LineWidth', 2); 
legend('Algorithm 1', 'Algorithm 2', 'P-greedy','Location','northwest');
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('log_{10}(Cond(K))');
xlim([0,x_max]);
