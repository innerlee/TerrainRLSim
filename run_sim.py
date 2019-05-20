import pyterrain as pt

env = pt.getEnv(env_name="PD_Biped2D_Flat_Terrain-v0", render=True)
env.reset()

j = 0
r = 0
for i in range(3000):
    j += 1
    action = env.action_space.sample()
    observation, reward, done, info = env.step(action)
    r += reward
    env.render()
    if done:
        print(j, "Reward: ", r, ", Done: ", done)
        j = 0
        r = 0
    if (done):
        env.reset()

env.close()
print('finished.')
