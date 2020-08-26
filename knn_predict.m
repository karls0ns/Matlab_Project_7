function yHat = knn_predict(xq, x, y, k)
% funkcija prognoz� yHat v�rt�bas no xq ieejas v�rt�b�m, izmantojot tuv�ko kaimi�u metodi,
% ja dota apm�c�bas kopa x,y un tuv�ko kaimi�u skaits k
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
        [~, idx] = sort(distances); % sak�rtojam att�lumus augo�� sec�b�
        
        idx = idx(1:k); % �emam tikai k tuv�ko kaimi�u indeksus
        yNeighbors = y(idx); % �emam y no tikai atlas�tajiem kaimi�iem
        yHat(q) = mean(yNeighbors); % vid�jais y no atlas�to k kaimi�u y v�rt�b�m
        
        %yHat(q) = mean(y(idx(1:k))); % viss vien� rindi��
        
        %{
        % sv�rtajai k-NN versijai:
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
