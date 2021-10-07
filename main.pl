main:- initialFlow(Repeat, Players, Matches),
       save(Players,Matches),
       repeatFlow(Repeat,Players,Matches).

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

controlFlow(Option,Repeat,PlayerList,_):-
  Repeat = true,
  ( Option =:= "1" -> addPlayer(PlayerList) ;
    Option =:= "2" -> addMatch ;
    Option =:= "3" -> searchPlayer ;
    Option =:= "4" -> comparePlayers ;
    Option =:= "5" -> Repeat = false
  ).

addPlayer(PlayerList):- 
  write("Adicionando um novo jogador!\n"),
  showAddPlayerMenu(Name),
  addPlayer(PlayerList,Name),
  write(PlayerList).

showAddPlayerMenu(Name):-
  write("Informe o nome do jogador que deseja adicionar: \n"),
  read_string(user, ".", "\n", _, Name).

addPlayer([H|T],Name):-
  length([H|T],Lenght),
  append(T, [[Name]], NewList),
  [H|T] = NewList.
  
addMatch:- write("Adding match").
searchPlayer:- write("Search player").
comparePlayers:- write("Compare players").
