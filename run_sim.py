import pyterrain as pt

env = pt.getEnv(env_name="PD_Biped2D_Flat_Terrain-v0", render=True)
env.reset()

for i in range(3000):
    action = env.action_space.sample()
    observation, reward, done, info = env.step(action)
    env.render()
    print(len(observation))
    print("Reward: ", reward, ", Done: ", done)
    if (done):
        env.reset()

env.close()
print('finished.')
