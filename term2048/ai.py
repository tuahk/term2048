# Idea here is that to make a new AI-impelmentation you should write a
# function that takes as input board-object and current score (number).
#
# Your function should return value form list [Board.UP, Board.LEFT, ..]
# according to which move your AI decies to make. As respond to that move
# it receives updated board and score.
#
# To play one game with your AI, use run()-function or run_gui().
# Both take your function as first input and additional parameters
# defined in Board and Game classes.
#
# For example run(your_function, size=8) would set board size to 8.

from __future__ import print_function   # import print() for printing to file

import random
import time
import sys

from game import Game
from board import Board
from players import AI
import pickle
import os.path

def get_state(board):
    """
    Append all rows to one array, starting from the uppermost one.
    """
    s = range(board.size())
    return [ board.getCell(x,y) for y in s for x in s]

def largest_tile(board):
    """ Returns the value of the largest tile at board """
    return max(get_state(board))


# Print results to file
def print_to_file(results):
    l = len(results)                                    # get number of results
    f = open('results.csv','w')                         # open file
    print("moves,largestTile,score", file=f)            # print title row
    for i in range(0, l):                               # loop over results
        print(str(results[i][0]) + \
        ',' + str(results[i][1]) + \
        ',' + str(results[i][2]), file=f)
    f.close()                                           # close file


# Use this to run your AI with GUI
def run_gui(ai_function, **kws):
    game = Game(**kws)
    game.ai_loop(ai_function)

def run(ai_function, times=1,  **kws):
    results = []
    states_encountered = {}
    prev_states = 0
    while(times > 0):
        score = 0
        moves = 0
        board = Board(**kws)
        while True:


            move = ai_function(board,score)
            score += board.move(move)
            moves += 1

            if board.won() or not board.canMove():
                move = ai_function(board,score)
                break

        results.append((moves, largest_tile(board), score))
        times -= 1
    return results

startTime = time.time() # start the timer
board_size = 3 # Define board size here
number_of_runs = 10
goal = 32
train = 1
alpha = 0.6
gamma = 1
epsilon = 0.85

args = sys.argv
print(len(args))
if len(args) > 1:
    board_size = int(args[1])
    number_of_runs = int(args[2])
    train = int(args[3]) # 0 for NO and 1 for YES
    alpha = float(args[4])
    gamma = float(args[5])
    epsilon = float(args[6])
    goal = int(args[7])
#    print(board_size,number_of_runs,train,alpha,gamma,epsilon)
    ai = AI(board_size, train, alpha, gamma ,epsilon,goal)
else:
     ai = AI(board_size, train, alpha, gamma ,epsilon,goal)

if train == 0 and os.stat('states').st_size!=0:
    pkl_file = open('states', 'r')
    ai.states = pickle.load(pkl_file)

results = run(ai.q_learning_ai,number_of_runs, goal=goal, size=board_size)
ai.print_states()

if train != 0:
    pkl_file = open('states', 'w+')
    pickle.dump(ai.states, pkl_file, pickle.HIGHEST_PROTOCOL)
pkl_file.close()

print('Highscore =    ' + str(max([res[1] for res in results] )))
print_to_file(results)  # print to file
endTime = time.time()   # end the timer
print('Elapsed time = ' + str(endTime - startTime))
