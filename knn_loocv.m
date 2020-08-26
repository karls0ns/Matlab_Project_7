function [SAE, MAE, SSE, MSE, RMSE, R2] = knn_loocv(x, y, k)
% funkcija aprçíina kïûdu kritçriju vçrtîbas ar LOOCV metodi
    if isempty(x)
        error('Matrica ir tukða.');
    end
    n = size(y,1);
    yHat = zeros(n,1);
    for i = 1 : n
        % apmâcîbas kopas izveidoðana
        xTrain = x;
        xTrain(i,:) = []; % ðeit notiek i-tâ piemçra dzçðana no apmâcîbas kopas
        yTrain = y;
        yTrain(i) = []; % ðeit notiek i-tâ piemçra dzçðana no apmâcîbas kopas
        
        % validçðanas kopas izveidoðana no viena paða i-tâ piemçra
        xValid = x(i,:);
        %yValid nevajag, jo izmantosim evaluate funkciju ar visâm prognozçm vienlaicîgi
        
        % prognozes veikðana i-tajâ piemçrâ, kas netika iekïauts apmâcîbas kopâ
        yHat(i) = knn_predict(xValid, xTrain, yTrain, k);
    end
    [SAE, MAE, SSE, MSE, RMSE, R2] = evaluate(y, yHat);
end
