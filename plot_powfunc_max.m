clear all;
close all;
dir_pwr = './DataPwr/'; % Directory to save the data of the power functions

% keyword = 'Brown1D_'; x_max = 25;
% keyword = 'Gauss1D_'; x_max = 25;
% keyword = 'Gauss2D_sqr_'; x_max = 35;
% keyword = 'Gauss2D_tri_'; x_max = 35;
% keyword = 'Gauss2D_dsk_'; x_max = 35;
keyword = 'sphere_'; gamma = 0.1; x_max = 35;

basic_str = strcat(dir_pwr, keyword, 'powfunc_max'); 
if keyword(1) == 's'
    file_proposed = strcat(basic_str, '_gamma_', num2str(gamma) ,'.txt'); 
    file_proposed_seq = strcat(basic_str, '_gamma_', num2str(gamma) ,'_seq.txt');
    file_pgreedy = strcat(basic_str, '_pgreedy_gamma_', num2str(gamma) ,'.txt');
else
    file_proposed = strcat(basic_str, '.txt'); 
    file_proposed_seq = strcat(basic_str, '_seq.txt');
    file_pgreedy = strcat(basic_str, '_pgreedy.txt');
end

dat_proposed = dlmread(file_proposed);
dat_proposed_seq = dlmread(file_proposed_seq);
dat_pgreedy = dlmread(file_pgreedy);

plot(dat_proposed(:,1), dat_proposed(:,2), '--.', 'MarkerSize', 25, 'LineWidth', 2); 
hold on;
plot(dat_proposed_seq(:,1), dat_proposed_seq(:,2), '-->', 'MarkerSize', 5, 'LineWidth', 2); 
plot(dat_pgreedy(:,1), dat_pgreedy(:,2), '--<', 'MarkerSize', 5, 'LineWidth', 2); 
legend('Algorithm 1', 'Algorithm 2', 'P-greedy');
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('log_{10} (max |P(x)|)');
xlim([0,x_max]);
