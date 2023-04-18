# Peg-Solitaire-Solver

This code returns an optimal strategy for the single player game called peg solitaire (see https://en.wikipedia.org/wiki/Peg_solitaire)

The board is initialized as a 7x7 matrix, with a -1 indicating the slot does not belong to the board, a 1 indicating the slot is occupied by a peg and a 0 for an empty slot. 

To obtain the optimal strategy run the code in the file called peg_sol_solver.jl. The resulting list is a collection of moves given by coordinates: ((r1,c1),(r2,c2)) indicating that the peg in row r1 and column c1 is moved to row r2 and column c2. 
