use_module(library(clpfd)).

ntower(N, T, counts(Top, Bottom, Left, Right)) :-
    % ensure dimensions check out
    length(T,N),
    maplist(same_length(T),T),
    maplist(same_length(T),[Top, Bottom, Left, Right]),

    % ensure values are in the range 1 to N
    length(T,Length),
    flatten(T, FlatT),
    maplist(between(1, Length), FlatT),

    % all rows have distinct values
    maplist(fd_all_different, T),

    % all columns have distinct values
    transpose(T, TransposedT),
    maplist(fd_all_different, TransposedT),

    % Calculate the counts
    tower_counts_valid(T, counts(Top, Bottom, Left, Right)).







plain_ntower(N, T, counts(Top, Bottom, Left, Right)) :-
    % ensure dimensions check out
    length(T,N),
    maplist(same_length(T),T),
    maplist(same_length(T),[Top, Bottom, Left, Right]),

    % ensure all values are in the range 1 to N and distinct
    all_towers_diff(T),

    % Calculate the counts
    tower_counts_valid(T, counts(Top, Bottom, Left, Right)).

all_towers_diff(T) :-
    % all values are in the range 1 to N
    length(T,Length),
    flatten(T, FlatT),
    maplist(between(1, Length), FlatT),

    % all rows have distinct values
    maplist(all_distinct, T),

    % all columns have distinct values
    transpose(T, TransposedT),
    maplist(all_distinct, TransposedT).

tower_counts_valid(T, counts(Top, Bottom, Left, Right)) :-
    % verify the counts
    maplist(verify_row, T, Left),
    maplist(reverse, T, ReversedT),
    maplist(verify_row, ReversedT, Right),

    transpose(T, TransposedT),
    maplist(verify_row, TransposedT, Top),
    maplist(reverse, TransposedT, ReversedTransposedT),
    maplist(verify_row, ReversedTransposedT, Bottom).

% This is the "step into" verifying a row
verify_row(Row, Count) :-
    verify_row(0, 0, Row, Count).

% If there is a new tallest tower, increment the count
verify_row(OldMax, OldCount, [Hd | Tl], Count) :-
    % write(Hd),
    OldMax < Hd,
    NewCount is OldCount + 1,
    verify_row(Hd, NewCount, Tl, Count).

% If the tower is smaller, keep the count the same
verify_row(OldMax, OldCount, [Hd | Tl], Count) :-
    OldMax >= Hd,
    verify_row(OldMax, OldCount, Tl, Count).

% If we've reached the end of the row, return the count
verify_row(_, Count, [], Count).



ambiguous(N, C, T1, T2) :- % takes 122721ms to run on seasnet
    ntower(N, T1, C),
    ntower(N, T2, C),
    T1 \= T2.

speedup_ntower(NormalTime) :-
    statistics(cpu_time, [Start1|_]),
    ntower(4,
          [[1,2,3,4],T2,T3,T4],
          counts([4,2,2,1],[1,2,2,4],[4,2,2,1],[1,2,2,4])),
    statistics(cpu_time, [End1|_]),
    NormalTime is End1 - Start1.

speedup_plain_ntower(PlainTime) :-
    statistics(cpu_time, [Start2|_]),
    plain_ntower(4,
          [[1,2,3,4],T2,T3,T4],
          counts([4,2,2,1],[1,2,2,4],[4,2,2,1],[1,2,2,4])),
    statistics(cpu_time, [End2|_]),
    PlainTime is End2 - Start2,
    write(PlainTime).

speedup(Speedup) :-
    % Time ntower
    speedup_ntower(NormalTime),

    % Time plain_ntower
    speedup_plain_ntower(PlainTime),

    Speedup is PlainTime/NormalTime.


% speedup(Speedup) :-
%     statistics(real_time, [T0|_]),
%     ntower(8,
%           [[2,1,5,3,4,7,8,6],
%           [8,5,3,4,6,1,2,7],
%           [6,7,8,2,3,5,1,4],
%           [5,3,6,1,8,4,7,2],
%           [3,8,1,6,7,2,4,5],
%           [1,4,7,8,2,6,5,3],
%           [4,6,2,7,5,8,3,1],
%           [7,2,4,5,1,3,6,8]],
%           C),
%     statistics(real_time, [T1|_]),
%     NormalTime is T1 - T0,

%     statistics(real_time, [T3|_]),
%     plain_ntower(8,
%           [[2,1,5,3,4,7,8,6],
%           [8,5,3,4,6,1,2,7],
%           [6,7,8,2,3,5,1,4],
%           [5,3,6,1,8,4,7,2],
%           [3,8,1,6,7,2,4,5],
%           [1,4,7,8,2,6,5,3],
%           [4,6,2,7,5,8,3,1],
%           [7,2,4,5,1,3,6,8]],
%           C),
%     statistics(real_time, [T4|_]),
%     PlainTime is T4 - T3,

%     Speedup is PlainTime/NormalTime.






same_length(FirstList, SecondList) :-
    length(FirstList, Length),
    length(SecondList, Length).

all_distinct([]).
all_distinct(T) :-
    sort(T, SortedT),
    length(T, Length),
    length(SortedT, Length).

% From clpfd.pl
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).


% ntower(2, T,
%           counts([1,2],
%                  [2,1],
%                  [1,2],
%                  [2,1])).
% ntower(2,
%           [[2,1],
%            [1,2]],
%           C).


% ntower(3,
%           [[2,1,3],
%            [1,3,2],
%            [1,2,3]],
%           C).

% ntower(3, T,
%           counts([1,2,1],
%                  [2,2,1],
%                  [2,2,3],
%                  [1,2,1])).