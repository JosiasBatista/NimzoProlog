# Nimzo

Descrição do Projeto
```
Nimzo é um sistema desenvolvido em Prolog para a disciplina de PLP que usa o sistema ELO 
para gerenciar e ranquear os jogadores de xadrez cadastrados. O projeto visa implementar 
um método eficiente de ranquear os jogadores de acordo com uma pontuação chamada ELO que 
varia de acordo com as suas vitórias e derrotas.
```

# Como rodar o projeto
Para rodar o projeto basta rodar:
```
swipl -q -f main.pl
```
e ao entrar na interface:
```
main.
```
e com isso o menu inicial já será apresentado para que o usuário possa navegar no projeto

# Funcionaliades do projeto
O projeto possui as seguintes funcionalidades apresentadas no menu principal:
```
1 - Cadastrar um novo jogador 
2 - Adicionar uma partida 
3 - Pesquisar por um jogador 
4 - Comparar dois jogadores 
```

- O ELO de cada jogador é modificado ao inserir uma nova partida e selecionar qual jogador venceu.
- A comparação entre dois jogadores é feita com base no ELO de cada um deles.
- A variação da pontuação que cada jogador perde ou ganha depende do ELO do jogador e do ELO de seu oponente

