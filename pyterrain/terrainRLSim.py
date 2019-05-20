import os
import sys
import json
import numpy as np
from dill.source import indent
import gym
from gym.spaces import Box
from gym import Env


class TerrainRLSimWrapper(Env):  #pylint: disable=W0223
    """
        Wrapper for the TerrainRLSim env to make function calls more simple
    """

    def __init__(self, sim, render=False, config=None):

        self._sim = sim
        self._render = render
        self._done = None
        self._action_space = Box(-1.0, 1.0, (self._sim.getActionSpaceSize(), ))
        self._action_scale = Box(np.array([-2.57, -3.14, -1.57, -2.57, -3.14, -1.57, -1.2, 0.0, -1.2, 0.0, -0.57]),
                                 np.array([2.57, 0.5, 1.57, 2.57, 0.5, 1.57, 3.0, 2.8, 3.0, 2.8, 0.57]))
        self._obs_scale = Box(
            np.array([
                -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000,
                -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000,
                -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000,
                -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000,
                -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000,
                -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000, -1.00000000,
                -1.00000000, -1.00000000, 0.06586086, -0.33134258, -0.22473772, -0.08842427, -0.24940665, -0.15451589,
                -0.49955064, -0.44008026, -0.59096092, -0.27878672, -0.14038287, -0.28852576, -0.20101279, -0.22234532,
                -0.22769515, -0.54376805, -0.35379013, -0.3725186, -0.33276483, -0.67418987, -0.35524186, -0.45274141,
                -0.25600547, -0.86293733, -0.60379982, -1.3963486, -1.35225046, -1.56099963, -1.59434652, -2.93630743,
                -3.02572751, -4.52309895, -5.14550066, -1.79466832, -1.95292163, -2.29718137, -2.53373265, -2.79888201,
                -3.67393041, -1.96048367, -2.22237873, -4.52637959, -5.36702728, -1.79870808, -1.6695528, -2.83235455,
                -2.84780359, -1.73784041, -2.26103067, -0.062334, -0.5, -0.5, -0.5, -0.5
            ]),
            np.array([
                1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000,
                1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000,
                1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000,
                1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000,
                1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000,
                1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000, 1.00000000,
                1.00000000, 1.00000000, 0.61076754, 0.30874607, 0.16389988, 0.278528, 0.10735691, 0.55370122,
                0.28979328, 0.88343042, 0.46615249, 0.24841864, 0.25305298, 0.20827545, 0.35527417, 0.10670558,
                0.34333566, 0.46612564, 0.34286582, 0.24609406, 0.55321878, 0.50907576, 0.41017145, 0.19810088,
                0.49811089, 0.83155686, 0.40484139, 1.4751488, 1.06637669, 1.60812414, 1.50176299, 3.01205444,
                3.09199214, 4.45173025, 5.29966736, 1.6375221, 1.83521891, 2.14798474, 2.5548656, 2.72522235, 3.7703712,
                2.17525077, 1.90829098, 4.67793322, 5.20727777, 1.98003554, 1.36583793, 2.76746488, 2.68556261,
                2.02427745, 1.82794178, 1.07712889, 0.5, 0.5, 0.5, 0.5
            ]))
        self._observation_space = Box(-np.inf, np.inf, (self._sim.getObservationSpaceSize(), ))
        self._config = config
        print("TerrainRLSim Config: ", self._config)

    def render(self):
        if (self._render):
            self._sim.display()

    def updateAction(self, action):
        self._sim.updateAction(action)
        self._sim.handleUpdatedAction()

    def update(self):
        self._sim.update()
        self._done = self._done or self._sim.agentHasFallen() or self.hasStumbled()

    def getObservation(self):
        ob = self._sim.getState()
        ob = np.array(ob)
        print(ob)
        ob = (ob - self._obs_scale.low) / (self._obs_scale.high - self._obs_scale.low) - 0.5
        print(ob)
        print('')
        return ob

    def step(self, action):
        action = np.array(action, dtype="float64")
        self.updateAction(action)

        if ("control_return" in self._config and (self._config["control_return"] is True)):
            i = 0
            while ((not self._sim.needUpdatedAction()) and (i < 50)):
                self._sim.update()
                self.render()
                i = i + 1
        else:
            self._sim.update()
            self.render()

        ob = self.getObservation()
        reward = self.calcReward()

        self._done = self._sim.agentHasFallen() or self._done or self.hasStumbled()
        return ob, reward, self._done, {}

    def hasStumbled(self):
        return self._sim.hasStumbled()

    def calcReward(self):
        return self._sim.calcReward()

    def jointTorque(self):
        return self._sim.jointTorque()

    def calcVelocity(self):
        return self._sim.calcVelocity()

    def getActionMin(self):
        return self._sim.getActionMin()

    def getActionMax(self):
        return self._sim.getActionMax()

    def reset(self):
        self._sim.initEpoch()
        self._done = False
        ob = self.getObservation()
        return ob

    def initEpoch(self):
        self.reset()

    def close(self):
        """
            Unload simulation, free memory.
        """
        self._sim.finish()

    @property
    def action_space(self):
        return self._action_space

    @property
    def observation_space(self):
        return self._observation_space

    def init(self):
        self._sim.init()

    def getEnv(self):
        return self._sim

    def onKeyEvent(self, c, x, y):
        self.getEnv().onKeyEvent(c, x, y)

    def seed(self, seed=None):
        """
            Set the random seed for the simulator
            This is helpful if you are running many simulations in parallel you don't
            want them to be producing the same results if they all init their random number
            generator the same.
        """
        if seed:
            self.getEnv().setRandomSeed(seed)


def getEnvsList():
    terrainRL_PATH = os.environ['TERRAINRL_PATH']
    file = open(terrainRL_PATH + "/args/envs.json")
    env_data = json.load(file)
    file.close()

    return env_data


def getEnv(env_name, render=False):

    terrainRL_PATH = os.environ['TERRAINRL_PATH']
    print("terrainRL_PATH: ", terrainRL_PATH)
    sys.path.append(terrainRL_PATH + '/lib')
    from pyterrain import terrainRLAdapter

    env_data = getEnvsList()

    if (env_name in env_data):
        config_file = env_data[env_name]['config_file']
    else:
        print("Env: ", env_name, " not found. Check that you have the correct env name.")
        return None

    ## place holder
    sim = terrainRLAdapter.cSimAdapter(
        ['train', '-arg_file=', terrainRL_PATH + '/' + config_file, '-relative_file_path=', terrainRL_PATH + '/'])
    sim.setRender(render)
    sim.init()

    sim_ = TerrainRLSimWrapper(sim, render=render, config=env_data[env_name])

    return sim_
