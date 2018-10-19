clear all;
close all;
dir_cnd = './DataTime/'; % Directory to save the data of the power functions

% keyword = 'Brown1D_'; x_max = 25;
% keyword = 'Gauss1D_'; x_max = 25;
% keyword = 'Gauss2D_sqr_'; x_max = 35;
% keyword = 'Gauss2D_tri_'; x_max = 35;
% keyword = 'Gauss2D_dsk_'; x_max = 35;
keyword = 'sphere_'; x_max = 35;

% mode = 'making';
mode = 'optimization';

basic_str = strcat(dir_cnd, keyword); 
file_proposed = strcat(basic_str, 'smp_times.txt'); 
file_pgreedy = strcat(basic_str, 'smp_times_pgreedy.txt');

dat_proposed = dlmread(file_proposed);
dat_pgreedy = dlmread(file_pgreedy);

if mode(1) == 'm'
    plot(dat_proposed(:,1), dat_proposed(:,3), '--.', 'MarkerSize', 25, 'LineWidth', 2); 
    legend('Algorithm 1 (making)','Location','northwest');
else
    plot(dat_proposed(:,1), dat_proposed(:,4), '--.', 'MarkerSize', 25, 'LineWidth', 2); 
    hold on;
    plot(dat_pgreedy(:,1), dat_pgreedy(:,2), '--<', 'MarkerSize', 5, 'LineWidth', 2); 
    legend('Algorithm 1 (optimization)', 'P-greedy','Location','northwest');
end
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('Time (sec)');
xlim([0,x_max]);
