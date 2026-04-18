clc;
clear;
close all;

%% Training Data
% Columns:
% [Attendance  AssignmentMarks  TestMarks  PerformanceScore]

data = [
    30 35 25 0;
    40 45 40 20;
    55 50 60 50;
    65 70 68 70;
    75 80 78 85;
    85 88 90 100;
    50 40 45 40;
    90 92 95 100;
    20 25 30 0;
    60 65 58 60;
    70 75 72 80;
    35 50 38 25;
    45 55 50 45;
    80 78 85 90;
    68 60 70 75
];

%% Generate Initial FIS using Grid Partitioning
numMFs = 3;              % Low, Medium, High
mfType = 'gbellmf';      % Good for ANFIS

initFis = genfis1(data, numMFs, mfType);

%% Train ANFIS
numEpochs = 50;
[trnFis, trainError] = anfis(data, initFis, numEpochs);

%% Plot Training Error
figure('Color','w','Position',[100 100 800 500]);
plot(trainError, 'LineWidth', 2);
grid on;
title('ANFIS Training Error','FontSize',14,'FontWeight','bold');
xlabel('Epoch','FontSize',12,'FontWeight','bold');
ylabel('Error','FontSize',12,'FontWeight','bold');

%% Plot Membership Functions Before Training
figure('Color','w','Position',[100 100 900 600]);
subplot(3,1,1);
plotmf(initFis,'input',1);
title('Initial Membership Functions - Attendance');

subplot(3,1,2);
plotmf(initFis,'input',2);
title('Initial Membership Functions - Assignment Marks');

subplot(3,1,3);
plotmf(initFis,'input',3);
title('Initial Membership Functions - Test Marks');

%% Plot Membership Functions After Training
figure('Color','w','Position',[120 120 900 600]);
subplot(3,1,1);
plotmf(trnFis,'input',1);
title('Trained Membership Functions - Attendance');

subplot(3,1,2);
plotmf(trnFis,'input',2);
title('Trained Membership Functions - Assignment Marks');

subplot(3,1,3);
plotmf(trnFis,'input',3);
title('Trained Membership Functions - Test Marks');

%% Test Example
testInput = [78 82 80];   % [Attendance Assignment Test]
predictedScore = evalfis(testInput, trnFis);

fprintf('Predicted Performance Score: %.2f\n', predictedScore);

if predictedScore <= 35
    performanceLabel = 'Poor';
elseif predictedScore <= 70
    performanceLabel = 'Average';
else
    performanceLabel = 'Good';
end

fprintf('Predicted Performance Level: %s\n', performanceLabel);

%% More Test Cases
testData = [
    25 30 28;
    55 60 58;
    88 90 92;
    70 68 72
];

disp(' ');
disp('Sample Predictions:');
for i = 1:size(testData,1)
    score = evalfis(testData(i,:), trnFis);

    if score <= 35
        label = 'Poor';
    elseif score <= 70
        label = 'Average';
    else
        label = 'Good';
    end

    fprintf('Attendance = %.1f, Assignment = %.1f, Test = %.1f --> Score = %.2f --> %s\n', ...
        testData(i,1), testData(i,2), testData(i,3), score, label);
end

%% Rule Viewer
ruleview(trnFis);

%% Surface Viewer
figure('Color','w','Position',[150 150 900 600]);
gensurf(trnFis);
title('Surface View of Student Performance Prediction');
xlabel('Attendance');
ylabel('Assignment Marks');
zlabel('Performance Score');

%% Save trained FIS
writeFIS(trnFis, 'student_performance_anfis');
disp('Trained FIS saved as student_performance_anfis.fis');
