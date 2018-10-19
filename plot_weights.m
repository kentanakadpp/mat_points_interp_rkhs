clear all;
close all;
dir_weight = './DataWeight/'; 

% keyword = 'Brown1D'; d = 1; n=15;
% keyword = 'Gauss1D'; d = 1; n=10;
% keyword = 'Gauss2D_sqr'; d = 2; n=15;
keyword = 'Gauss2D_tri'; d = 2; n=15;

if d == 1
    filename = strcat(dir_weight, 'weight_', keyword ,'_n', num2str(n), '.txt');
    xw = dlmread(filename);
    plot(xw(:,1), xw(:,2), 'o--', 'LineWidth', 1 ,'MarkerSize', 5, 'MarkerEdgeColor', 'b' , 'MarkerFaceColor', 'b');
    set(gca,'FontSize',16);
    grid on; 
    xlabel('y_{j}');
    ylabel('w_{j}');
    title(strcat('Weights for n=',num2str(n)));    
else
    filename = strcat(dir_weight, 'weight_', keyword ,'_n', num2str(n), '.txt');
    xw = dlmread(filename);
    stem3(xw(:,1), xw(:,2), xw(:,3), 'o--', 'LineWidth', 1 ,'MarkerSize', 5, 'MarkerEdgeColor', 'b' , 'MarkerFaceColor', 'b');
    view(-52, 17);
    set(gca,'FontSize',16);
    grid on; 
    xlabel('y_{j1}');
    ylabel('y_{j2}');
    zlabel('w_{j}');
    title(strcat('Weights for n=',num2str(n)));    
end
