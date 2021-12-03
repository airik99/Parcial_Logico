% ------------------ PUNTO 1 ------------------

atleta(camila, 22, argentina).
atleta(fede, 35, brasil).
atleta(juan, 25, chile).
atleta(juli, 27, chile).
atleta(dalilahMuhammad, 30, brasil).
atleta(nicolas, 22, argentina).
atleta(sofia, 40, argentina).

enEquipo(voleyMasculino).
enEquipo(hockeyFemenino).

individual(natacion400MetrosFemenino).
individual(carrera100MetrosLlanosFemenino).
individual(carrera400MetrosConVallasFemenino).
individual(natacion100MetrosEspaldaMasculino).

compite(camila, natacion400MetrosFemenino).
compite(fede, natacion100MetrosEspaldaMasculino).
compite(juan, voleyMasculino).
compite(juli, voleyMasculino).
compite(dalilahMuhammad, carrera400MetrosConVallasFemenino).
compite(dalilahMuhammad, carrera100MetrosLlanosFemenino).
compite(nicolas, voleyMasculino).
compite(camila, carrera100MetrosLlanosFemenino).

medalla(bronce, argentina, voleyMasculino).
medalla(plata, dalilahMuhammad, carrera400MetrosConVallasFemenino).
medalla(oro, camila, natacion400MetrosFemenino).
medalla(oro, camila, carrera100MetrosLlanosFemenino).
medalla(bronce, dalilahMuhammad, natacion400MetrosFemenino).
medalla(plata, dalilahMuhammad, natacion600MetrosFemenino).

evento(hockeyFemenino, final, [argentina, paisesBajos]).
evento(voleyMasculino, octavosDeFinal, [argentina, chile]).
evento(natacion100MetrosEspaldaMasculino, 2, [fede, juan, juli, fernando, edgardo, facundo, martin, messi]).
evento(carrera100MetrosLlanosFemenino, 2, [camila, dalilahMuhammad]).
evento(carrera400MetrosConVallasFemenino, 3, [laura, dalilahMuhammad]).
evento(carrera400MetrosConVallasFemenino, 4, [laura, dalilahMuhammad]).
evento(hockeyFemenino, faseDeGrupos, [argentina, paisesBajos]).

pais(Pais) :-
    atleta(_, _, Pais).

% ------------------ PUNTO 2 ------------------

vinoAPasear(Atleta) :-
    atleta(Atleta, _, _),
    not(compite(Atleta, _)).

% ------------------ PUNTO 3 ------------------

medallasDelPais(Medalla, Pais, Disciplina) :-
    medalla(Medalla, Atleta, Disciplina),
    atleta(Atleta, _, Pais).

medallasDelPais(Medalla, Pais, Disciplina) :-
    medalla(Medalla, Pais, Disciplina),
    enEquipo(Disciplina).

% ------------------ PUNTO 4 ------------------

participoEn(Ronda, Disciplina, Atleta) :-
    evento(Disciplina, Ronda, Participantes),
    compite(Atleta, Disciplina),
    estuvoEnEvento(Participantes, Atleta).

estuvoEnEvento(Participantes, Atleta) :-
    member(Atleta, Participantes).

estuvoEnEvento(Participantes, Atleta) :-
    atleta(Atleta, _, Pais),
    member(Pais, Participantes).

% ------------------ PUNTO 5 ------------------

dominio(Pais, Disciplina) :-
    medallasDelPais(_, Pais, Disciplina),
    individual(Disciplina),
    forall(medalla(Medalla, _, Disciplina), medallasDelPais(Medalla, Pais, Disciplina)).

% ------------------ PUNTO 6 ------------------

medallaRapida(Disciplina) :-
    medalla(_, _, Disciplina),
    fueRondaUnica(Disciplina).

fueRondaUnica(Disciplina) :-
    evento(Disciplina, UnaRonda, _),
    not((evento(Disciplina, OtraRonda, _), UnaRonda \= OtraRonda)).

% ------------------ PUNTO 7 ------------------

noEsElFuerte(Pais, Disciplina) :-
    evento(Disciplina, _, _),
    pais(Pais),
    not(participo(Disciplina, Pais, _)).

noEsElFuerte(Pais, Disciplina) :-
    participo(Disciplina, Pais, _),
    not(pasoRondaInicial(Disciplina, Pais)).

participo(Disciplina, Pais, Ronda) :-
    participoEn(Ronda, Disciplina, Atleta),
    atleta(Atleta, _, Pais).

participo(Disciplina, Pais, Ronda) :-
    evento(Disciplina, Ronda, Paises),
    pais(Pais),
    member(Pais, Paises).

pasoRondaInicial(Disciplina, Pais) :-
    participo(Disciplina, Pais, Ronda),
    huboOtraRonda(Disciplina, Ronda).

huboOtraRonda(Disciplina, Ronda):-
    individual(Disciplina), 
    Ronda \= 1.

huboOtraRonda(Disciplina, Ronda) :-
    enEquipo(Disciplina),
    Ronda \= faseDeGrupos.

% ------------------ PUNTO 8 ------------------

medallasEfectivas(Pais, CuentaFinal) :-
    pais(Pais),
    findall(ValorMedalla, valorDeMedallaPorPais(Pais, ValorMedalla), Medallas),
    sum_list(Medallas, CuentaFinal).

valorDeMedallaPorPais(Pais, ValorMedalla) :-
    medallasDelPais(Medalla, Pais, _),
    valorMedalla(Medalla, ValorMedalla).

valorMedalla(oro, 3).
valorMedalla(plata, 2).
valorMedalla(bronce, 1).

% ------------------ PUNTO 9 ------------------

laEspecialidad(Atleta) :-
    atleta(Atleta, _, _),
    not(vinoAPasear(Atleta)),
    forall(compite(Atleta, Disciplina), obtuvoOroOPlata(Atleta, Disciplina)).

obtuvoOroOPlata(Atleta, Disciplina) :-
    medalla(oro, Atleta, Disciplina).

obtuvoOroOPlata(Atleta, Disciplina) :-
    medalla(plata, Atleta, Disciplina).

