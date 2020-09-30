clear all
clc
%% Read file excel
inputData = readmatrix('../contactForces/contactForces_experiment3_f.xlsx');

%%
timeArray = inputData(1:1000,1); % array of time at first 10 seconds
data = inputData(1:1000,:); % data without time column
data(:,1) = [];


numPoints = length(data(1,:)) / 3 % 756 / 3 = 252
pointsPerDOF = 12
dof = numPoints / pointsPerDOF % 21
time = length(timeArray) % 100

%%
contactForces = zeros(dof,time,3);
for t = 1:time
    for i = 1:dof   
        for j = 1:pointsPerDOF
            contactForces(i,t,1) = contactForces(i,t,1) + data(t, (pointsPerDOF*3)*(i-1) + (j-1)*3 + 1);
            contactForces(i,t,2) = contactForces(i,t,2) + data(t, (pointsPerDOF*3)*(i-1) + (j-1)*3 + 2);
            contactForces(i,t,3) = contactForces(i,t,3) + data(t, (pointsPerDOF*3)*(i-1) + (j-1)*3 + 3);
        end
    end
end

%%
for i = 1:dof
    name = ['Experiment 3 - Contact force ' num2str(i)]
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