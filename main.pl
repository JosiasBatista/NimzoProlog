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
    Option =:= "3" -> searchForPlayer ;
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
  showAddMatchMenu(PlayerList, MatchList).

showAddMatchMenu(PlayerList, MatchList):-
  searchPlayerOneID(PlayerList, PlayerOneID, MatchList),
  searchPlayerTwoID(PlayerList, PlayerTwoID, MatchList),
  defineTheWinner(Winner),
  append(MatchList, [[PlayerOneID, PlayerTwoID, Winner]], NewList),
  write("Partida adicionada com sucesso!\n\n"),
  initialFlow(true, PlayerList, NewList).

defineTheWinner(Winner):-
  write("Informe a cor das peças do jogador vencedor(B - Branca | P - Preta): \n"),
  read_string(user, ".", "\n", _, Winner).
  
searchPlayerTwoID(PlayerList, PlayerTwoID, MatchList):-
  write("Informe o nome do jogador com peças pretas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayerTwo(Name, PlayerList, PlayerTwo, SearchStatus),
  SearchStatus == false ->
    initialFlow(true, PlayerList, MatchList) ;
    setPlayerTwoID(PlayerTwoID, PlayerTwo).

searchPlayerOneID(PlayerList, PlayerOneID, MatchList):-
  write("Informe o nome do jogador com peças brancas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayerOne(Name, PlayerList, PlayerOne, SearchStatus),
  SearchStatus == false ->
    initialFlow(true, PlayerList, MatchList) ;
    setPlayerOneID(PlayerOneID, PlayerOne).

setPlayerOneID(PlayerOneID, [_|[ID|_]]):-
  PlayerOneID = ID.

setPlayerTwoID(PlayerTwoID, [_|[ID|_]]):-
  PlayerTwoID = ID.

searchPlayerOne(_, [], _, SearchStatus):- 
  write("Jogador com esse nome não foi encontrado!\n\n"),
  SearchStatus = false.
searchPlayerOne(Name, [[PName|Rest]|T], PlayerOne, SearchStatus):-
  Name == PName -> PlayerOne = [PName|Rest] ; searchPlayerOne(Name, T, PlayerOne, SearchStatus).

searchPlayerTwo(_, [], _, SearchStatus):- 
  write("Jogador com esse nome não foi encontrado!\n\n"),
  SearchStatus = false.
searchPlayerTwo(Name,[[PName|Rest]|T],PlayerTwo,SearchStatus):-
  Name == PName -> PlayerTwo = [PName|Rest] ; searchPlayerTwo(Name, T, PlayerTwo, SearchStatus).


searchForPlayer:- write("Search player").
comparePlayers:- write("Compare players").
