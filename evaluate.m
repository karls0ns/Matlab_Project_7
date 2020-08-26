function [SAE, MAE, SSE, MSE, RMSE, R2] = evaluate(y, yHat)
% funkcija aprçíina kïûdu kritçriju vçrtîbas
    n = size(y,1);
    SAE = sum(abs(y - yHat));
    MAE = SAE / n;
    SSE = sum((y - yHat) .^ 2);
    MSE = SSE / n;
    RMSE = sqrt(MSE);
    SSEtot = sum((y - mean(y)) .^ 2);
    R2 = 1 - SSE / SSEtot;
end
