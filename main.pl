:- use_module(library(readutil)).

main:- initialFlow(true, [], []).

save(Players,Matches):-
  write(Players, Matches).

repeatFlow(Repeat,_,_):- Repeat == false, halt.
repeatFlow(Repeat,Players,Matches):- Repeat == true, write("\n\n"), initialFlow(Repeat,Players,Matches).

initialFlow(Repeat,PlayerList,MatchList):-
  showMainMenu,
  read_string(user, ".", "\n", _, Option),
  controlFlow(Option,Repeat,PlayerList,MatchList),
  repeatFlow(Repeat,PlayerList,MatchList).

showMainMenu:- write("Bem vindo ao Nimzo \n"),
                 write("Escolha uma das opções abaixo: \n"),
                 write("1 - Cadastrar um novo jogador \n"),
                 write("2 - Adicionar uma partida \n"),
                 write("3 - Pesquisar por um jogador \n"),
                 write("4 - Comparar dois jogadores \n"),
                 write("5 - Sair do programa \n").

controlFlow(Option,Repeat,PlayerList,MatchList):-
  Repeat = true,
  ( Option =:= "1" -> addPlayer(PlayerList, MatchList) ;
    Option =:= "2" -> addMatch(PlayerList, MatchList) ;
    Option =:= "3" -> searchForPlayer(PlayerList, MatchList) ;
    Option =:= "4" -> comparePlayers(PlayerList, MatchList) ;
    Option =:= "5" -> repeatFlow(false,_,_)
  ).

addPlayer(PlayerList, MatchList):- 
  write("Adicionando um novo jogador!\n"),
  showAddPlayerMenu(Name),
  length(PlayerList, Length),
  append(PlayerList, [[Name, Length, 1200]], NewList),
  write("Jogador adicionado com sucesso!\n\n"),
  initialFlow(true, NewList, MatchList).

showAddPlayerMenu(Name):-
  write("Informe o nome do jogador que deseja adicionar: \n"),
  read_string(user, ".", "\n", _, Name).
  
addMatch(PlayerList, MatchList):- 
  write("Adicionando uma nova partida!\n"),
  showAddMatchMenu(PlayerList, MatchList).

showAddMatchMenu(PlayerList, MatchList):-
  searchPlayerOneID(PlayerList, PlayerOne, PlayerOneID, MatchList),
  searchPlayerTwoID(PlayerList, PlayerTwo, PlayerTwoID, MatchList),
  defineTheWinner(Winner, WinnerValidity),
  WinnerValidity == true ->
      append(MatchList, [[PlayerOneID, PlayerTwoID, Winner]], NewList),
      changePlayersELO(PlayerOne, PlayerTwo, Winner, PlayerList, NewPlayerList),
      write(NewPlayerList),
      write("Partida adicionada com sucesso!\n\n"),
      initialFlow(true, NewPlayerList, NewList)
    ;
      write("Cor da peça vencedora não reconhecida");
      initialFlow(true, PlayerList, MatchList).

changePlayersELO(PlayerOne, PlayerTwo, Winner, PlayerList, NewPlayerList):-
  select(PlayerOne, PlayerList, NewList),
  select(PlayerTwo, NewList, PlayerListWithoutPlayers),
  nth0(2, PlayerOne, ELOPOne),
  nth0(2, PlayerTwo, ELOPTwo),
  calculateNewELO(ELOPOne, ELOPTwo, Winner, NewELO1, NewELO2),
  setPlayerELO(PlayerOne, NewELO1, NewPlayerOne),
  setPlayerELO(PlayerTwo, NewELO2, NewPlayerTwo),
  append(PlayerListWithoutPlayers, [NewPlayerOne], NewListWithPOne),
  append(NewListWithPOne, [NewPlayerTwo], NewPlayerList).
  
setPlayerELO(Player, NewELO, NewPlayer):-
  nth0(0, Player, PlayerName),
  nth0(1, Player, PlayerID),
  NewPlayer = [PlayerName, PlayerID, NewELO].

calculateNewELO(ELOPOne, ELOPTwo, Winner, NewELO1, NewELO2):-
  analyzeResult(Winner, R),
  getNewELO(R, ELOPOne, ELOPTwo, NewELO1, NewELO2).

getNewELO(R, ELOPOne, ELOPTwo, NewELO1, NewELO2):-
  winChance(ELOPOne, ELOPTwo, WinChance),
  NewELO1 is (ELOPOne + 30 * (R - WinChance)),
  NewELO2 is (ELOPTwo - 30 * (R - WinChance)).

analyzeResult("B",R):- R is 1.
analyzeResult("P",R):- R is 0.
analyzeResult("E",R):- R is 0.5.


defineTheWinner(Winner, WinnerValidity):-
  write("Informe a cor das peças do jogador vencedor(B - Branca | P - Preta | E - Empate): \n"),
  read_string(user, ".", "\n", _, Winner),
  analyzeWinnerInput(Winner, WinnerValidity).

analyzeWinnerInput("B", WinnerValidity):- WinnerValidity = true.
analyzeWinnerInput("P", WinnerValidity):- WinnerValidity = true.
analyzeWinnerInput("E", WinnerValidity):- WinnerValidity = true.
analyzeWinnerInput(_, WinnerValidity):- WinnerValidity = false.
  
searchPlayerTwoID(PlayerList, Player, PlayerTwoID, MatchList):-
  write("Informe o nome do jogador com peças pretas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, Player, SearchStatus),
  showSearchStatus(SearchStatus, Player, PlayerList, MatchList),
  setPlayerTwoID(PlayerTwoID, Player).

searchPlayerOneID(PlayerList, Player, PlayerOneID, MatchList):-
  write("Informe o nome do jogador com peças brancas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, Player, SearchStatus),
  showSearchStatus(SearchStatus, Player, PlayerList, MatchList),
  setPlayerOneID(PlayerOneID, Player).

setPlayerOneID(PlayerOneID, [_|[ID|_]]):-
  PlayerOneID = ID.

setPlayerTwoID(PlayerTwoID, [_|[ID|_]]):-
  PlayerTwoID = ID.

searchPlayer(_, [], Player, SearchStatus):- 
  write("Jogador com esse nome não foi encontrado!\n\n"),
  Player = [],
  SearchStatus = false.
searchPlayer(Name,[[PName|Rest]|T],Player,SearchStatus):-
  Name == PName -> Player = [PName|Rest] ; searchPlayer(Name, T, Player, SearchStatus).

searchPlayerTwo(_, [], Player, SearchStatus):- 
  write("Jogador com esse nome não foi encontrado!\n\n"),
  Player = [],
  SearchStatus = false.
searchPlayerTwo(Name,[[PName|Rest]|T],Player,SearchStatus):-
  Name =:= PName -> Player = [PName|Rest] ; searchPlayer(Name, T, Player, SearchStatus).

searchForPlayer(PlayerList, MatchList):- 
  write("Buscando por um jogador!\n"),
  showSearchPlayerMenu(PlayerList, MatchList).

showSearchPlayerMenu(PlayerList, MatchList):-
  write("Informe o nome do jogador que você deseja buscar: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, Player, SearchStatus),
  showPlayer(Player,SearchStatus),
  initialFlow(true, PlayerList, MatchList).


showPlayer(Player,SearchStatus):-
  SearchStatus == false ->
      write("Tente uma nova pesquisa!\n") 
    ;
      write("O seguinte jogador foi encontrado:\n"),
      write(Player),
      write("\n\n").

comparePlayers(PlayerList, MatchList):- 
  write("Comparando dois jogadores de acordo com seu ELO!\n"),
  showComparePlayersMenu(PlayerList, MatchList).

showComparePlayersMenu(PlayerList, MatchList):-
  searchFirstPlayer(PlayerList, PlayerOne, SearchStatus, MatchList),
  searchSecondPlayer(PlayerList, PlayerTwo, SearchStatus, MatchList),
  compareTwoPlayers(PlayerOne, PlayerTwo).

searchFirstPlayer(PlayerList, PlayerOne, SearchStatus, MatchList):-
  write("Informe o nome do primeiro jogador:\n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, PlayerOne, SearchStatus),
  showSearchStatus(SearchStatus, PlayerOne, PlayerList, MatchList).

showSearchStatus(SearchStatus, Player, PlayerList, MatchList):-
  SearchStatus == false ->
      Player = [],
      initialFlow(true, PlayerList, MatchList)
    ;
      write("O seguinte jogador foi encontrado:\n"),
      write(Player),
      write("\n\n").

searchSecondPlayer(PlayerList, PlayerTwo, SearchStatus, MatchList):-
  write("Informe o nome do segundo jogador:\n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, PlayerTwo, SearchStatus),
  showSearchStatus(SearchStatus, PlayerTwo, PlayerList, MatchList).

compareTwoPlayers(PlayerOne, PlayerTwo):-
  write("Comparação dos jogadores:\n"),
  nth0(2, PlayerOne, ELOPOne),
  nth0(2, PlayerTwo, ELOPTwo),
  winChance(ELOPOne, ELOPTwo, Result),
  format("Chances do Jogador 1 vencer: ~f \n", (1 - Result)),
  format("Chances do Jogador 2 vencer: ~f \n", Result).

winChance(ELOPOne, ELOPTwo, Result):-
  Exponent is (1 * (ELOPOne - ELOPTwo) / 400),
  P is 10 ** Exponent,
  Result is (1 / (1 + 1 * (P))).
