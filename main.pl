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
  searchPlayerOneID(PlayerList, PlayerOneID, MatchList),
  searchPlayerTwoID(PlayerList, PlayerTwoID, MatchList),
  defineTheWinner(Winner, WinnerValidity),
  WinnerValidity == true ->
      append(MatchList, [[PlayerOneID, PlayerTwoID, Winner]], NewList),
      write("Partida adicionada com sucesso!\n\n"),
      initialFlow(true, PlayerList, NewList)
    ;
      write("Cor da peça vencedora não reconhecida");
      initialFlow(true, PlayerList, MatchList).

defineTheWinner(Winner, WinnerValidity):-
  write("Informe a cor das peças do jogador vencedor(B - Branca | P - Preta): \n"),
  read_string(user, ".", "\n", _, Winner),
  analyzeWinnerInput(Winner, WinnerValidity).

analyzeWinnerInput("B", WinnerValidity):- WinnerValidity = true.
analyzeWinnerInput("P", WinnerValidity):- WinnerValidity = true.
analyzeWinnerInput(_, WinnerValidity):- WinnerValidity = false.
  
searchPlayerTwoID(PlayerList, PlayerTwoID, MatchList):-
  write("Informe o nome do jogador com peças pretas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, Player, SearchStatus),
  SearchStatus == false ->
    initialFlow(true, PlayerList, MatchList) ;
    setPlayerTwoID(PlayerTwoID, Player).

searchPlayerOneID(PlayerList, PlayerOneID, MatchList):-
  write("Informe o nome do jogador com peças brancas: \n"),
  read_string(user, ".", "\n", _, Name),
  searchPlayer(Name, PlayerList, Player, SearchStatus),
  SearchStatus == false ->
    initialFlow(true, PlayerList, MatchList) ;
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
  SearchStatus == false ->
    initialFlow(true, PlayerList, MatchList) ;
    write("Jogador encontrado!").

searchSecondPlayer(PlayerList, PlayerTwo, SearchStatus, MatchList):-
  write("Informe o nome do segundo jogador:\n"),
  read_string(user_input, "\n", "\n", _, NameInput),
  remove_chars(NameInput, ., Name),
  searchPlayer(Name, PlayerList, PlayerTwo, SearchStatus),
  SearchStatus == false ->
    initialFlow(true, PlayerList, MatchList) ;
    write("Jogador encontrado!").

compareTwoPlayers([HOne|_], [HTwo|_]):-
  append(HOne, " ", FirstPlayerName),
  append(FirstPlayerName, HTwo, PlayersName),
  append("Comparando os jogadores ", PlayersName, OutputString),
  write(OutputString).

remove_chars(String, CharRemove, R ) :-
  atom_codes(X, String),
  atom_chars( X , Xs ),
  select(CharRemove, Xs , Ys ),
  atomic_list_concat(Ys, "", Atom),
  atom_string(Atom, R),
  write(R).