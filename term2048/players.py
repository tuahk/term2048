from board import Board
import random
import numpy as np

from pybrain.structure import FeedForwardNetwork
from pybrain.structure import LinearLayer, SigmoidLayer
from pybrain.structure import FullConnection

from pybrain.datasets import SequentialDataSet

from pybrain.supervised.trainers import BackpropTrainer

class AI:
    
    def __init__(self,size, train = 1, alpha = 0.005, gamma = 1, epsilon = 0.6 ):
        self.size = size
        #self.prev_state = str((size*size)*[0]) 
        self.prev_state = np.array(size*size*[0])
        self.prev_score = 0  
        self.prev_move = 0
        #self.states = {}
        #self.states[self.prev_state] = self.init_state(0,0.2)
        
        self.train = train
        self.gamma = gamma
        self.alpha = alpha
        self.epsilon = epsilon
        
        self.prev_outputs = np.array(4*[0])
        
        #   Network configuration    
        self.n = self.init_network()

        
    def init_network(self):
        n = FeedForwardNetwork()
        inLayer = LinearLayer(4)
        hiddenLayer = SigmoidLayer(30)
        outLayer = LinearLayer(4)

        n.addInputModule(inLayer)
        n.addModule(hiddenLayer)
        n.addOutputModule(outLayer)

        in_to_hidden = FullConnection(inLayer, hiddenLayer)
        hidden_to_out = FullConnection(hiddenLayer, outLayer) 
        
        n.addConnection(in_to_hidden)
        n.addConnection(hidden_to_out) 
        
        n.sortModules()
        
        return n
    
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

    def q_learning_ai(self,board, score, n = None):
        if score==0 and self.prev_score!=0:
            self.prev_state = np.array((self.size*self.size)*[0])
            self.prev_score = 0  
            self.prev_move = 0            
        

        new_state = np.array(self.get_state(board))
        r = score - self.prev_score

        outputs = self.n.activate(self.get_state(board))
        #print 'outputs'
        #print outputs

        moves = [Board.UP, Board.DOWN, Board.LEFT, Board.RIGHT]
        move = 0
        #if new_state in self.states:
        if random.uniform(0,1) < self.epsilon:
            move = moves[np.argmax(outputs)]
        else:
            move = moves[random.randint(0,3)]
        #else:
            #move = moves[random.randint(0,3)]
            #self.states[new_state] = self.init_state(0,0.2)
        
        if self.train != 0:
        # This is the update rule. ( minus 1 from self.prev_move to correct indexing) 
            #training = outputs
            #best_move = max(self.states[new_state])
            best_move = np.max(outputs) 
            #self.states[self.prev_state][self.prev_move-1] += self.alpha*(r + self.gamma*best_move - self.states[self.prev_state][self.prev_move-1])
            self.prev_outputs[self.prev_move-1] = self.alpha*(r + self.gamma*best_move - self.prev_outputs[self.prev_move-1])
            ds = SequentialDataSet(self.size*self.size, 4)
            #self.ds.newSequence()
            ds.addSample(self.prev_state, outputs)
            #print 'database'
            #print self.ds.getSequence(self.ds.getCurrentSequence())
            
            
            #sq_index = self.ds.getCurrentSequence()
            #training_set = np.array(self.ds.getSequence(sq_index))
            trainer = BackpropTrainer(self.n, ds)
            trainer.train()

        self.prev_state = new_state
        self.prev_move = move
        self.prev_score = score
        self.prev_outputs = outputs
        return move
    
    def print_states(self):
        for key in self.states:
            print(key, self.states[key])

