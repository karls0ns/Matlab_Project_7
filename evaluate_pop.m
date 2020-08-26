function fittness = evaluate_pop(pop, x, y, k)
% Funkcija noverte katra populacijas individa piemerotibu (fittness)
    popSize = size(pop,1); % noskaidrojam populacijas izmeru
    fittness = zeros(popSize,1); % rezervejam novertejumu vektoru
    for i = 1 : popSize
        chromosome = pop(i,:); % i-tâ indivîda hromosoma
        % Ja hromosoma nav nevienas true vertibas, tas nozime, ka
        % regresijas modelis nelietos nevienu faktoru. Tadam modelim
        % vienkarsi pienemsim novertejumu bezgaligi sliktu.
        if ~any(chromosome)
            fittness(i) = Inf;
            continue;
        end
        xUsed = x(:,chromosome); % lietotie faktori
        [~, ~, ~, MSE] = knn_loocv(xUsed, y, k); % novertejam k-NN modeli
        fittness(i) = MSE; % saglabajam novertejumu vektora i-taja pozîcija (tas ir i-ta indivîda novertejums)
    end
end
