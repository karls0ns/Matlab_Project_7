rng(1);

x = mpgX2;
y = mpgY;
names = mpgNames2;

% ja nepieciesams, varam samazinam datu kopas apjomu, demonstracijas paatrinasanai
%idx = randperm(size(x,1));
%x = x(idx(1:200),:);
%y = y(idx(1:200),:);

% normalizejam visus faktorus
for j = 1 : size(x,2)
    minX = min(x(:,j));
    range = max(x(:,j)) - minX;
    x(:,j) = (x(:,j) - minX) / range;
end

k = 3;

numGenes = size(x, 2);
popSize = 10; % para skaitlis, lai vienkarsaka realizacija
numGenerations = 50;
crossoverProbability = 0.9;
mutationProbability = 0.05; % medz iestatit vienadu ar 1 / numGenes

% Statistikas dati izvadei diagramma
stats = zeros(numGenerations, 2);

% sakotneja paaudze (boolean tipa matrica ar popSize rindam un numGenes kolonnam)
pop = boolean(randi(2, popSize, numGenes) - 1);

% Labakais atrastais indivîds un ta hromosoma
bestFFinal = Inf;
bestChromFinal = NaN;

generation = 1;
while true
    % Visas paaudzes individu piemerotibas novertesana
    fittness = evaluate_pop(pop, x, y, k);
    
    % Atrodam labako no visiem individiem saja paaudze
    % (lai beigas izvaditu labako atrasto rezultatu ka ari diagrammas paradisanai)
    [bestF, bestFIdx] = min(fittness);
    bestChrom = pop(bestFIdx,:);
    fprintf('Generation #%d:\t      bestF = %.2f\t     bestChrom = %s\n', generation, bestF, sprintf('%d ', bestChrom));
    
    % Ja sis labakais individs paaudze ir labaks par lidz sim kopuma labako atrasto,
    % tad piefiksejam to ka kopuma labako atrasto.
    if bestF < bestFFinal
        bestFFinal = bestF;
        bestChromFinal = bestChrom;
    end
    
    % Statistikas dati izvadei diagramma
    stats(generation,1) = mean(fittness);
    stats(generation,2) = bestF;
    stats(generation,3) = bestFFinal;
    
    % Ja sasniegts definçtais paaudþu skaits, apstâdinâm algoritmu
    generation = generation + 1;
    if generation > numGenerations
        break;
    end
    
    % Inicializejam nakamas paaudzes hromosomas
    popNext = false(popSize, numGenes);
    
    % Izlase (tournament selection) un krustosana (single-point crossover)
    % Izvelesimies priekstecu parus pop matrica un no tiem izveidosim
    % pectecu parus popNext matrica
    for i = 1 : 2 : popSize
        % Tournament selection, lai izveletos pirmo prieksteci (turnira izmers = 2)
        idx1 = randi(popSize);
        idx2 = randi(popSize);
        if fittness(idx1) < fittness(idx2)
            parentIdx1 = idx1;
        else
            parentIdx1 = idx2;
        end
        
        % Tournament selection, lai izveletos otro prieksteci (turnira izmers = 2)
        idx1 = randi(popSize);
        idx2 = randi(popSize);
        if fittness(idx1) < fittness(idx2)
            parentIdx2 = idx1;
        else
            parentIdx2 = idx2;
        end
        
        % Krustosana (single-point crossover)
        if rand < crossoverProbability
            % Nejausi izvelamies hromosomu griezuma poziciju
            crossOverPoint = randi(numGenes - 1);
            % Veicam hromosomu krustosanu
            popNext(i,:) = [pop(parentIdx1,1:crossOverPoint) pop(parentIdx2,(crossOverPoint+1):end)];
            popNext(i+1,:) = [pop(parentIdx2,1:crossOverPoint) pop(parentIdx1,(crossOverPoint+1):end)];
        else
            % Preteja gadijuma ievietojam priekstecu hromosomas nakamaja paaudze bez izmainam
            popNext(i,:) = pop(parentIdx1,:);
            popNext(i+1,:) = pop(parentIdx2,:);
        end
    end
    
    % Mutacija (lemjot par katra individa hromosomas katru genu atseviski)
    for i = 1 : popSize
        for j = 1 : numGenes
            if rand < mutationProbability % ar so varbutibu notiks j-tajam genam mutacija
                popNext(i,j) = ~popNext(i,j);
            end
        end
    end
    
    % Jauna paaudze ir izveidota
    pop = popNext;
end

fprintf('KOPUMA LABAKAIS: bestFFinal = %.2f\tbestChromFinal = %s\n', bestFFinal, sprintf('%d ', bestChromFinal));
fprintf('Izveletie datu kopas faktori: %s\n', sprintf('"%s", ', names{bestChromFinal}));

figure;
hold all;
plot(1:numGenerations, stats(:,1));
plot(1:numGenerations, stats(:,2));
plot(1:numGenerations, stats(:,3));
title('MSE vertibu izmainas pa GA paaudzem');
xlabel('Paaudze');
ylabel('MSE');
legend({'Videjais MSE paaudze', 'Mazakais MSE paaudze', 'Mazakais MSE kopuma'});
