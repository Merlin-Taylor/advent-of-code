:- use_module(library(clpfd)).
:- use_module(library(pio)).

:- set_prolog_flag(back_quotes, codes).

% Grammar for extracting the digits from the text %

parse_lines(Parser, [T|Trees]) --> parse_line(Parser, T), `\n`, parse_lines(Parser, Trees).
parse_lines(Parser, [Tree]) --> parse_line(Parser, Tree).
parse_line(Parser, Tree) --> ...(not_nl, Text), { call(Parser, Text, Tree) }.

digits_in(Cs, Ds) :-
    dif(Ds, []),
    findall(D, phrase(digit_in(D), Cs), Ds).
digit_in(D) --> ..., digit(D), ... .

digit(C) --> [C], { code_type(C, digit) }.
digit(48) --> `zero`.
digit(49) --> `one`.
digit(50) --> `two`.
digit(51) --> `three`.
digit(52) --> `four`.
digit(53) --> `five`.
digit(54) --> `six`.
digit(55) --> `seven`.
digit(56) --> `eight`.
digit(57) --> `nine`.

not_nl(C) --> [C], { code_type(C, alnum) }.

... --> [].
... --> [_], ... .

...(_, []) --> [].
...(G, [P|Ps]) --> call(G, P), ...(G, Ps).

% Predicate relating the list of digits found on each line to its calibration value %

calibration_numbers(Ns, Cal) :-
    phrase(calibration_numbers_(Cal), Ns).

calibration_numbers_(Cal) --> [N], { number_codes(Cal, [N,N]) }.
calibration_numbers_(Cal) --> [N0], ..., [N], { number_codes(Cal, [N0,N]) }.

% Putting it all together %

solution(File, Dss, S) :-
    phrase_from_file(lines(digits_in, Dss), File),
    maplist(calibration_numbers, Dss, Cals),
    sum(Cals, #=, S).
