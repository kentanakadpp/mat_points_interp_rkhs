clear all;
close all;
% dir_smp = './DataSmp/'; seq = 0; % Directory to save the data of the sampling points
% dir_smp = './DataSmpSeq/'; seq = 1; % Directory to save the data of the sampling points
dir_smp = './DataSmpPG/'; seq = 2; % Directory to save the data of the sampling points

n = 35;

%% Kernels and regions
% [[Brownian kernel]]
% prefix = 'Brown';

% [[Gaussian kernel]]
% [Square]
prefix = 'sqr';
x = 0;
y = 0;
% [Triangle]
% prefix = 'tri';
% t = linspace(-1,1);
% x = t;
% y = -t;
% [Disk]
% prefix = 'dsk';
% t = linspace(0,2*pi);
% x = cos(t);
% y = sin(t);

%% Plotting sampling points
if seq == 0
    filename = strcat(dir_smp,'Gauss2D_', prefix ,'_smp','_n_', num2str(n), '.txt');
    a = dlmread(filename);
elseif seq == 1
    filename = strcat(dir_smp,'Gauss2D_', prefix ,'_smp_seq','_n_', num2str(n), '.txt');
    a = dlmread(filename);
else
    filename = strcat(dir_smp,'Gauss2D_', prefix ,'_smp_pgreedy.txt');
    na = dlmread(filename);
    na(:,1) = [];
    a = na;
end

scatter(a(:,1), a(:,2), 'filled');
hold on;
plot(x,y,'k');
daspect([1 1 1]);
xlim([-1,1]);
ylim([-1,1]);

set(gca,'FontSize',16);
grid on; 
xlabel('x_1');
ylabel('x_2');
% title(strcat('Generated points for n=',num2str(n)));
