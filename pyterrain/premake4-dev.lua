local linuxLibraryLoc = "../external/"
local windowsLibraryLoc = "../../library/"

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

project "terrainRLAdapter"
	language "C++"
	kind "SharedLib"

	targetdir ( "../lib" )
	targetname ("_terrainRLAdapter")
	targetprefix ("")
	files {
		-- Source files for this project
		-- "render/*.cpp",
		-- "util/*.cpp",
		-- "sim/*.cpp",
		-- "anim/*.cpp",
		-- "learning/*.cpp",
		-- "scenarios/*.cpp",
		"../external/LodePNG/*.cpp",
		"./*.cpp",
		-- "Main.cpp"
	}
	excludes
	{
		"Main.cpp",
	}
	includedirs {
		"./",
		"anim",
		"learning",
		"sim",
		"render",
		"scenarios",
		"util",
		"../"
	}
	links {
		"terrainrlScenarios",
		"terrainrlLearning",
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
        "__Python_Export__"
	}

	-- targetdir "./"
	buildoptions("-std=c++0x -ggdb -fPIC" )

	-- linux library cflags and libs
	configuration { "linux", "gmake" }
		buildoptions {
			" -fPIC",
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`"
		}
		linkoptions {
			"-Wl,-rpath," .. path.getabsolute("../lib") ,
			" -fPIC",
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`"
		}
		libdirs {
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
            "/rcg/software/Linux/Ubuntu/16.04/amd64/LANG/PYTHON/3.5.2-SYSTEM/lib",
		}

		includedirs {
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
            "/usr/include/python3.6m",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"boost_system",
				"glog",
				"python3.6m",
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
				"boost_system",
				"glog",
				"python3.6m",
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
			"OpenGL.framework",
			"Cocoa.framework",
			"dl",
			"pthread"
		}
