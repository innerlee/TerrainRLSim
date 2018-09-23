import sys
import numpy as np
import pyterrain as pt

env = pt.getEnv(env_name="PD_Biped2D_Slopes_Mixed_Terrain-v0", render=True)

env.reset()
actionSpace = env.getActionSpace()

for i in range(1000):
    action = ((actionSpace.getMaximum() - actionSpace.getMinimum()) *
              np.random.uniform(size=actionSpace.getMinimum().shape[0])) + actionSpace.getMinimum()
    observation, reward, done, info = env.step(action)
    env.render()
    print("Reward: ", reward, ", Done: ", done)
    if (done):
        env.reset()

env.finish()
print('finished.')
