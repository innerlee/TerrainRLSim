import pyterrain as pt

env = pt.getEnv(env_name="PD_Biped2D_Slopes_Mixed_Terrain-v0", render=True)
env.reset()

for i in range(300):
    action = env.action_space.sample()
    observation, reward, done, info = env.step(action)
    env.render()
    print("Reward: ", reward, ", Done: ", done)
    if (done):
        env.reset()

env.close()
print('finished.')
