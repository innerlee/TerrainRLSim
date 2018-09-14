--
-- premake4 file to build TerrainRL_Optimizer
-- Copyright (c) 2009-2015 Glen Berseth
-- See license.txt for complete license.
--

local linuxLibraryLoc = "../external/"
local windowsLibraryLoc = "../../library/"

project "TerrainRL_Optimizer2"
	language "C++"
	kind "WindowedApp"

	files {
		-- Source files for this project
		-- "../scenarios/*.cpp",
		-- "../sim/*.cpp",
		-- "../util/*.cpp",
		-- "../anim/*.cpp",
		"./opt/*.cpp",
		"./opt/*.c",
		"./opt/*.h",
		"./scenarios/*.cpp",
		"Main.cpp",


	}
	excludes {
		"../scenarios/Draw*.h",
		"../scenarios/Draw*.cpp",
		"../sim/CharTracer.cpp",
		"**- Copy**.cpp",
		"./opt/QL.c",
		"./opt/QuadProg.cpp",
	}

	includedirs {
		"./",
		"../",
		"opt",
		"../anim",
		"../sim",
		"../render",
		"../scenarios",
		"../util"
	}
	links {
		"terrainrlScenarios",
		"terrainrlAnim",
		"terrainrlSim",
		"terrainrlUtil",
		"terrainrlRender",
	}


	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	targetdir "../"
	buildoptions("-std=c++0x -ggdb -g" )

	-- linux library cflags and libs
	configuration { "linux", "gmake" }

		linkoptions {
			"-Wl,-rpath," .. path.getabsolute("lib") ,
		}
		libdirs {
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
		}

		includedirs {
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "CMA-ESpp/cma-es",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}

		configuration { "linux", "Debug*", "gmake"}
			defines {
				"_DEBUG",
				"ENABLE_DEBUG_PRINT",
				"ENABLE_DEBUG_VISUALIZATION"
			}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"f2c",
			}

	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"f2c",
			}

	-- windows library cflags and libs
	configuration { "windows" }
		-- libdirs { "lib" }
		linkoptions  {
			"libopenblas.dll.a",
			-- "`pkg-config --cflags glu`"
		}
		includedirs {
			windowsLibraryLoc .. "Bullet/include",
			windowsLibraryLoc,
			windowsLibraryLoc .. "Json_cpp",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			"C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v7.5/include/",
			windowsLibraryLoc .. "boost_lib",
		}

		libdirs {
			windowsLibraryLoc .. "lib",
			windowsLibraryLoc .. "boost_lib",
			windowsLibraryLoc .. "Bullet/Debug/x64",
			windowsLibraryLoc .. "Json_cpp/x64",
			"C:/Program Files (x86)/boost/boost_1_58_0/stage/lib",
			"C:/Program Files (x86)/boost/boost_1_58_0/libs",
			"C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v7.5/lib/x64",
		}
		links {
			"opengl32",
			"glu32",
			-- Just a few dependancies....
			"BulletDynamics_Debug",
			"BulletCollision_Debug",
			"LinearMath_Debug",
			"jsoncpp_Debug",
			"libjpegd",
			"libjasperd",
			"libpngd",
			"IlmImfd",
			"libtiffd",
			"libwebpd",
			-- "cudart",
			-- "cuda",
			-- "nppi",
			-- "cufft",
			-- "cublas",
			-- "curand",
			"gflagsd",
			"libglogd",
			"libprotobufd",
			"libprotocd",
			"leveldbd",
			"lmdbd",
			"libhdf5_D",
			"libhdf5_hl_D",
			"Shlwapi",
			"zlibd",
			-- "libopenblas"
			-- "libopenblas.dll.a",
			"glew32",
		}

	-- mac includes and libs
	configuration { "macosx" }
		kind "ConsoleApp" -- xcode4 failes to run the project if using WindowedApp
		-- includedirs { "/Library/Frameworks/SDL.framework/Headers" }
		buildoptions { "-Wunused-value -Wshadow -Wreorder -Wsign-compare -Wall" }
		linkoptions {
			"-Wl,-rpath," .. path.getabsolute("lib") ,
		}
		links {
			"Cocoa.framework",
			"dl",
			"pthread"
		}
