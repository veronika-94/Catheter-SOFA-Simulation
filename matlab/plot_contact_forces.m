close all
clear all
clc
%% Read file excel
inputData = readmatrix('../contactForces/experiment2_f.xlsx');
EXPERIMENT = 2;
%%
T = 1000;
timeArray = inputData(1:T,1); % array of time at first 10 seconds
data = inputData(1:T,:); % data without time column
data(:,1) = [];


numPoints = length(data(1,:)) / 3; % 756 / 3 = 252
pointsPerDOF = 12;
dof = numPoints / pointsPerDOF; % 21

%%
contactForces = zeros(dof,T,3);
for t = 1:T
    for i = 1:dof   
        for j = 1:pointsPerDOF
            contactForces(i,t,1) = contactForces(i,t,1) + data(t, (pointsPerDOF*3)*(i-1) + (j-1)*3 + 1);
            contactForces(i,t,2) = contactForces(i,t,2) + data(t, (pointsPerDOF*3)*(i-1) + (j-1)*3 + 2);
            contactForces(i,t,3) = contactForces(i,t,3) + data(t, (pointsPerDOF*3)*(i-1) + (j-1)*3 + 3);
        end
    end
end

%% Raw plots
for i = 1:dof
    name = ['Experiment ' num2str(EXPERIMENT) ' - Contact force ' num2str(i)]
    fig = figure('name', name, 'position', [10 50 1000 600])
    subplot(3,1,1)
    plot(timeArray, contactForces(i,:,1))
    title('x')
    xlabel('time')
    ylabel('force')
    subplot(3,1,2)
    plot(timeArray, contactForces(i,:,2))
    title("y")
    xlabel('time')
    ylabel('force')
    subplot(3,1,3)
    plot(timeArray, contactForces(i,:,3))
    title("z")
    xlabel('time')
    ylabel('force')
    saveas(fig, [name '.png'])
end

%% Apply smoothing - Moving Median - Window size = 5
for i = 1:dof
    name = ['Experiment ' num2str(EXPERIMENT) ' - Contact force ' num2str(i) ' - Smoothed']
    fig = figure('name', name, 'position', [10 50 1000 600])
    subplot(3,1,1)
    plot(timeArray, smoothdata(contactForces(i,:,1),'movmedian',5))
    title('x')
    xlabel('time')
    ylabel('force')
    subplot(3,1,2)
    plot(timeArray, smoothdata(contactForces(i,:,2),'movmedian',5))
    title("y")
    xlabel('time')
    ylabel('force')
    subplot(3,1,3)
    plot(timeArray, smoothdata(contactForces(i,:,3),'movmedian',5))
    title("z")
    xlabel('time')
    ylabel('force')
    saveas(fig, [name '.png'])
end

%% Test filter / moving mean / moving median
% x = contactForces(21,:,3);
% y_filter = lowpass(x, 8, 100);
% y_mean = smoothdata(x,'movmean', 5);
% y_median = smoothdata(x,'movmedian',5);
% 
% fig = figure('name', 'Experiment 2 - Contact forces at the tip - z axis', 'position', [10 50 1000 600]);
% subplot(2,2,1);
% plot(timeArray, x);
% title("Contact forces");
% 
% subplot(2,2,2);
% plot(timeArray,y_filter);
% title("Low-pass filter (passband frequency = 8 Hz)");
% 
% subplot(2,2,3);
% plot(timeArray,y_mean);
% title("Moving mean (window size = 5)");
% 
% subplot(2,2,4);
% plot(timeArray,y_median);
% title("Moving median (window size = 5)");