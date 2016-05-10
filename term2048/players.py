from board import Board
import random


class AI:
    
    def __init__(self,size):
        self.size           = size
        self.prev_state     = (size*size)*[0]
        self.prev_score     = 0  
        self.prev_move      = 0
        self.prev_qvalue    = 0
       # self.states         = {}
       # self.states[self.prev_state] = self.init_state(0,0.2)
    
    def init_state(self,a,b):
        return [random.uniform(a,b),random.uniform(a,b),random.uniform(a,b),random.uniform(a,b)]

    def get_state(self,board):
        """
        Append all rows to one array, starting from the uppermost one.
        """
        s = range(board.size())
        return [ board.getCell(x,y) for y in s for x in s]
    
    def largest_tile(self, board):
        """ Returns the value of the largest tile at board """
        return max(get_state(board))
    
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

    def q_learning_ai(self,board, score, nn = None):
#           Initialize the prev_values when the game restart
        if score==0 and self.prev_score!=0:
            self.prev_state = (self.size*self.size)*[0]
            self.prev_score = 0  
            self.prev_move = 0  
            self.prev_qvalue = 0          

        new_state = self.get_state(board)
        r = score - self.prev_score

        inputs = [float(i) for i in new_state]
#           Get the q-values from the network
        outputs = nn.feed_forward(inputs)        
        
        gamma = 1 #0.85 
        alpha = 0.005
        epsilon = 0.6

        moves = [Board.UP, Board.DOWN, Board.LEFT, Board.RIGHT]
        move = 0

        if random.uniform(0,1) < epsilon:
            move = moves[outputs.index(max(outputs))]
        else:
            move = moves[random.randint(0,3)]

#           This is the update rule. ( minus 1 from self.prev_move to correct indexing) 
        best_move = max(outputs) 
        training_inputs = [float(i) for i in self.prev_state]
        training_outputs = [0] * 4
        training_outputs[self.prev_move - 1] = self.prev_qvalue + alpha*(r + gamma*best_move - self.prev_qvalue)
        #self.states[self.prev_state][self.prev_move-1] += alpha*(r + gamma*best_move - self.states[self.prev_state][self.prev_move-1])        
        nn.train(training_inputs, training_outputs)    

        self.prev_state = new_state
        self.prev_move = move
        self.prev_score = score
        self.prev_qvalue = outputs[move-1]
        
        return move
    
    def print_states(self):
        for key in self.states:
            print(key, self.states[key])

