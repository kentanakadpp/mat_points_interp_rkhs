clear all;
close all;
% dir_smp = './DataSmp/'; seq = 0; % Directory to save the data of the sampling points
% dir_smp = './DataSmpSeq/'; seq = 1; % Directory to save the data of the sampling points
dir_smp = './DataSmpPG/'; seq = 2; % Directory to save the data of the sampling points

n = 35;

%% Plotting sampling points
if seq == 0
    filename = strcat(dir_smp,'sphere_smp','_n_', num2str(n), '.txt');
    a = dlmread(filename);
elseif seq == 1
    filename = strcat(dir_smp,'sphere_smp_seq','_n_', num2str(n), '.txt');
    a = dlmread(filename);
else
    filename = strcat(dir_smp,'sphere_smp_pgreedy_gamma_0.1.txt');
    na = dlmread(filename);
    na(:,1) = [];
    a = na;
end

scatter3(a(:,1), a(:,2), a(:,3), 'filled');
hold on;
[xx,yy,zz] = sphere;
surf(xx,yy,zz,'FaceAlpha',0.1);
daspect([1 1 1]);
xlim([-1,1]);
ylim([-1,1]);
view(-60, 15);

set(gca,'FontSize',16);
grid on; 
xlabel('x_1');
ylabel('x_2');
zlabel('x_3');
% title(strcat('Generated points for n=',num2str(n)));
