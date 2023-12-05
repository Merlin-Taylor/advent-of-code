:- use_module(library(clpfd)).
:- use_module(library(pio)).

:- set_prolog_flag(back_quotes, codes).

% Grammar for extracting the digits from the text %

calibration_lines([L]) --> calibration_line(L).
calibration_lines([L|Ls]) --> calibration_line(L), `\n`, calibration_lines(Ls).

calibration_line(Ds) --> calibration_line_(Ds), non_digits.
calibration_line_([]) --> [].
calibration_line_([D|Ds]) --> non_digits, digit(D), calibration_line_(Ds).

digit(C) --> [C], { code_type(C, digit) }.

non_digits --> [].
non_digits --> non_digit, non_digits.

non_digit --> [C], { code_type(C, alpha) }.

non_nl --> [].
non_nl --> [C], { dif(C, 10) }, non_nl .

% Predicate relating the list of digits found on each line to its calibration value %

... --> [].
... --> [_], ... .

calibration(N) --> [C], { number_codes(N, [C,C]) }.
calibration(N) --> [C1], ..., [C2], { number_codes(N, [C1,C2]) }.
calibration_numbers(Cal, Ns) :-
    phrase(calibration(Cal), Ns).

% Putting it all together %

solution(File, S) :-
    phrase_from_file(calibration_lines(Ls), File),
    maplist(calibration_numbers, Cals, Ls),
    sum(Cals, #=, S).
