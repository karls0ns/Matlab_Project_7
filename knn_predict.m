function yHat = knn_predict(xq, x, y, k)
% funkcija prognozç yHat vçrtîbas no xq ieejas vçrtîbâm, izmantojot tuvâko kaimiòu metodi,
% ja dota apmâcîbas kopa x,y un tuvâko kaimiòu skaits k
    yHat = zeros(size(xq,1),1);
    for q = 1 : size(xq,1)
        distances = zeros(size(x,1),1);
        xquery = xq(q,:);
        for i = 1 : size(x,1)
            %{
            for j = 1 : size(x,2)
                distances(i) = distances(i) + (xquery(1,j) - x(i,j)) ^ 2;
            end
            distances(i) = sqrt(distances(i));
            %}
            distances(i) = norm(xquery - x(i,:));
        end
        [~, idx] = sort(distances); % sakârtojam attâlumus augoðâ secîbâ
        
        idx = idx(1:k); % òemam tikai k tuvâko kaimiòu indeksus
        yNeighbors = y(idx); % òemam y no tikai atlasîtajiem kaimiòiem
        yHat(q) = mean(yNeighbors); % vidçjais y no atlasîto k kaimiòu y vçrtîbâm
        
        %yHat(q) = mean(y(idx(1:k))); % viss vienâ rindiòâ
        
        %{
        % svçrtajai k-NN versijai:
        if (distances(idx(1)) == 0)
            yHat(q) = yNeighbors(1);
            %yHat(q) = y(idx(1)); % tas pats, neizmantojot yNeighbors
        else
            weights = 1 ./ distances(idx);
            yHat(q) = sum(yNeighbors .* weights) / sum(weights);
            %yHat(q) = sum(y(idx) .* weights) / sum(weights); % tas pats, neizmantojot yNeighbors
        end
        %}
    end
end
