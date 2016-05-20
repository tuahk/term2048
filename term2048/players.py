from board import Board
import random

class AI:

    def __init__(self,size, train = 1, alpha = 0.005, gamma = 1, epsilon = 0.6 ,goal = 2048):
        self.size = size
        self.prev_state = str((size*size)*[0])
        self.prev_score = 0
        self.prev_move = 0
        self.states = {}
        self.states[self.prev_state] = self.init_state(0,0)

        self.train = train
        self.gamma = gamma
        self.alpha = alpha
        self.epsilon = epsilon
        self.goal = goal

    def init_state(self,a,b):
        return [0.0,0.0,0.0,0.0]
        #return [random.uniform(a,b),random.uniform(a,b),random.uniform(a,b),random.uniform(a,b)]

    def get_state(self,board):
        """
        Append all rows to one array, starting from the uppermost one.
        """
        s = range(board.size())
        return [ board.getCell(x,y) for y in s for x in s]

    def largest_tile(self, board):
        """ Returns the value of the largest tile at board """
        return max(self.get_state(board))

    def random_ai(self,board, score):
        moves = [Board.UP, Board.DOWN, Board.LEFT, Board.RIGHT]
        r = random.randint(0,3)
        #time.sleep(0.2)
        return moves[r]

    def biasRandom_ai(self,board, score):
        r = random.random()
        if r < 0.6:
            return Board.UP
        elif r < 0.61:
            return Board.DOWN
        elif r < 0.90:
            return Board.LEFT
        else:
            return Board.RIGHT

    def q_learning_ai(self,board, score):
        if score==0 and self.prev_score!=0:
            self.prev_state = str((self.size*self.size)*[0])
            self.prev_score = 0
            self.prev_move = 0

        new_state = str(self.get_state(board))
#        r = score - self.prev_score
        if self.largest_tile(board) == self.goal:
           r = self.largest_tile(board)
        else:
           r = 0

        moves = [Board.UP, Board.DOWN, Board.LEFT, Board.RIGHT]
        move = 0
        if new_state in self.states:
            if random.uniform(0,1) < self.epsilon:
                move = moves[self.states[new_state].index(max(self.states[new_state]))]
            else:
                move = moves[random.randint(0,3)]
        else:
            move = moves[random.randint(0,3)]
            self.states[new_state] = self.init_state(0,0.2)

        if self.train != 0:
        # This is the update rule. ( minus 1 from self.prev_move to correct indexing)
            best_move = max(self.states[new_state])
            self.states[self.prev_state][self.prev_move-1] += self.alpha*(r + self.gamma*best_move - self.states[self.prev_state][self.prev_move-1])

        self.prev_state = new_state
        self.prev_move = move
        self.prev_score = score
        return move

    def print_states(self):
        for key in self.states:
            print(key, self.states[key])
