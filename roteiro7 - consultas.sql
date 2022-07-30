--Quantidade de Gols e Assitencias feitos pelo Jogador mais velho
SELECT SUM(Gols) AS Total_de_gols, SUM(Assistencias) AS Total_de_Assistencias FROM participacao WHERE Jogador_id = (SELECT id FROM Jogador WHERE data_de_nascimento = (SELECT min(data_de_nascimento) FROM jogador));

-- Nome do jogador, sua quantidade de gols e sua quantidade de jogos ordenados pela quantidade de jogos 
SELECT Nome, COUNT(p.Partida_ID) AS qtd_Jogos FROM Jogador AS j LEFT OUTER JOIN Participacao AS p ON j.id = p.Jogador_ID GROUP BY(j.id) ORDER BY COUNT(p.Partida_ID) DESC;

-- Nome do time e quantidade total de gols
SELECT e.nome, SUM(p_j.Gols) FROM Equipe e JOIN (Jogador j JOIN Participacao p ON j.ID = p .Jogador_ID) AS p_j ON p_j.Equipe_ID = e .id GROUP BY e.nome;