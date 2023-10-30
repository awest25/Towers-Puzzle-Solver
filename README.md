# Towers Puzzle Solver

**Language**: Prolog <br/>
**Date**: Feb 2023 <br/>
**Repository**: [github.com/awest25/TowersPuzzleSolver](https://github.com/awest25/TowersPuzzleSolver)

## Overview

The Towers Puzzle Solver is designed to solve the Towers arithmetical-logical puzzle, where the objective is to fill an N×N grid with integers. Each row and column should contain all the integers from 1 through N while satisfying additional constraints. The puzzle provides counts of towers visible from each edge, which the solver uses to determine the solution.

## Key Features

- **GNU Prolog Integration**: Uses the finite domain solver of GNU Prolog for efficient puzzle-solving.
- **Alternative Solver**: Offers `plain_ntower/3`, an alternative method without the finite domain solver.
- **Ambiguous Puzzle Identification**: Can identify puzzles with multiple solutions.
- **Performance Comparison**: The `speedup/1` predicate showcases the performance difference between the two solving methods.

## Technical Stack

- **Environment**: Prolog (GNU Prolog recommended for finite domain solver).
- **Integers Limitation**: The GNU Prolog finite domain solver has a limitation on integer values, which should not exceed `vector_max`.

## Getting Started

1. Clone the repo: `git clone https://github.com/awest25/TowersPuzzleSolver.git`
2. Load the Prolog program.
3. Query the desired predicate (e.g., `ntower/3`, `plain_ntower/3`, `ambiguous/4`).

## Predicates Usage

1. **ntower/3**: Uses the finite domain solver for efficient puzzle solving.

    ```prolog
    ?- ntower(5, T, counts([2,3,2,1,4],[3,1,3,3,2],[4,1,2,5,2],[2,4,2,1,2])).
    ```

2. **plain_ntower/3**: An alternative method without the finite domain solver.

    ```prolog
    ?- plain_ntower(5, T, counts([2,3,2,1,4],[3,1,3,3,2],[4,1,2,5,2],[2,4,2,1,2])).
    ```

3. **speedup/1**: Showcases the performance difference between `ntower/3` and `plain_ntower/3`.

    ```prolog
    ?- speedup(Ratio).
    ```

4. **ambiguous/4**: Identifies puzzles with multiple solutions.

    ```prolog
    ?- ambiguous(5, C, T1, T2).
    ```

## Further Notes

For more detailed explanations and insights into the puzzle-solving logic, refer to the detailed comments and documentation within the source code. In-depth technical breakdowns, including the reasoning behind each strategy, are provided, assisting in understanding the logic behind each predicate.
