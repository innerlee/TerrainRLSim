import os
import sys
import json
import numpy as np
from dill.source import indent


class ActionSpace(object):
    """
        Wrapper for the action space of an env
    """

    def __init__(self, action_space):
        self._minimum = np.array(action_space[0])
        self._maximum = np.array(action_space[1])

    def getMinimum(self):
        return self._minimum

    def getMaximum(self):
        return self._maximum

    @property
    def low(self):
        return self._minimum

    @property
    def high(self):
        return self._maximum


class TerrainRLSimWrapper(object):
    """
        Wrapper for the TerrainRLSim env to make function calls more simple
    """

    def __init__(self, sim, render=False, config=None):

        self._sim = sim
        self._render = render
        self._done = None

        act_low = [-1] * self.getEnv().getActionSpaceSize()
        act_high = [1] * self.getEnv().getActionSpaceSize()
        action_space = [act_low, act_high]
        self._action_space = ActionSpace(action_space)
        ob_low = [-1] * self.getEnv().getObservationSpaceSize()
        ob_high = [1] * self.getEnv().getObservationSpaceSize()
        observation_space = [ob_low, ob_high]
        self._observation_space = ActionSpace(observation_space)
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
        ob = np.reshape(np.array(ob), (-1, len(ob)))
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
        reward = self.calcRewards()

        self._done = self._sim.agentHasFallen() or self._done or self.hasStumbled()
        return ob, reward, self._done, None

    def hasStumbled(self):
        return self._sim.hasStumbled()

    def calcRewards(self):

        reward = self._sim.calcReward()

        return reward

    def reset(self):
        self._sim.initEpoch()
        self._done = False
        ob = self.getObservation()
        return ob

    def initEpoch(self):
        self.reset()

    def finish(self):
        """
            Unload simulation, free memory.
        """
        self._sim.finish()

    def getActionSpace(self):
        return self._action_space

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
