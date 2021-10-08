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
    Option =:= "3" -> searchPlayer ;
    Option =:= "4" -> comparePlayers ;
    Option =:= "5" -> repeatFlow(false,_,_)
  ).

addPlayer(PlayerList, MatchList):- 
  write("Adicionando um novo jogador!\n"),
  showAddPlayerMenu(Name),
  length(PlayerList, Length),
  append(PlayerList, [[Name, Length, 1200]], NewList),
  initialFlow(true, NewList, MatchList).

showAddPlayerMenu(Name):-
  write("Informe o nome do jogador que deseja adicionar: \n"),
  read_string(user, ".", "\n", _, Name).
  
addMatch(PlayerList, MatchList):- 
  write("Adicionando uma nova partida!\n"),
  showAddMatchMenu(PlayerOneID, PlayerTwoID, PlayerList, MatchList).

showAddMatchMenu(PlayerOneID, PlayerTwoID, PlayerList, MatchList):-
  searchPlayerOneID(PlayerList, PlayerOneID),
  searchPlayerTwoID(PlayerList, PlayerTwoID),
  defineTheWinner(Winner),
  append(MatchList, [[PlayerOneID, PlayerTwoID, Winner]], NewList),
  write(NewList),
  initialFlow(true, PlayerList, NewList).

defineTheWinner(Winner):-
  write("Informe a cor das peças do jogador vencedor(b - Branca | p - Preta): \n"),
  read_string(user, ".", "\n", _, Winner).
  
searchPlayerTwoID(PlayerList, PlayerTwoID):-
  write("Informe o nome do jogador com peças pretas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, PlayerTwo),
  setPlayerTwoID(PlayerTwoID, PlayerTwo).

searchPlayerOneID(PlayerList, PlayerOneID):-
  write("Informe o nome do jogador com peças brancas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, Player),
  setPlayerOneID(PlayerOneID, Player).

setPlayerOneID(PlayerOneID, [H|[ID|Rest]]):-
  PlayerOneID = ID.

setPlayerTwoID(PlayerTwoID, [H|[ID|Rest]]):-
  PlayerTwoID = ID.

searchPlayer(Name,[],Player,_):- write("Jogador com esse nome não foi encontrado!").
searchPlayer(Name,[[PName|Rest]|T],Player):-
  Name == PName -> Player = [PName|Rest] ; searchPlayer(Name, T, Player).

searchPlayer:- write("Search player").
comparePlayers:- write("Compare players").
