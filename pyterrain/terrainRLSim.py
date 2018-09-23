import os
import sys
import json
import numpy as np
from dill.source import indent
from gym.spaces import Box
from gym import Env

class TerrainRLSimWrapper(Env):
    """
        Wrapper for the TerrainRLSim env to make function calls more simple
    """

    def __init__(self, sim, render=False, config=None):

        self._sim = sim
        self._render = render
        self._done = None
        self._action_space = Box(-1, 1, self._sim.getActionSpaceSize())
        self._observation_space = Box(-np.inf, np.inf, self._sim.getObservationSpaceSize())
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

    def endOfEpoch(self):
        return self._done

    def init(self):
        self._sim.init()

    def getEnv(self):
        return self._sim

    def onKeyEvent(self, c, x, y):
        self.getEnv().onKeyEvent(c, x, y)

    def seed(self, seed):
        """
            Set the random seed for the simulator
            This is helpful if you are running many simulations in parallel you don't
            want them to be producing the same results if they all init their random number
            generator the same.
        """
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
