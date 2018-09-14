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
		"sim",
		"render",
		"scenarios",
		"util",
		"../"
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
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
            "/rcg/software/Linux/Ubuntu/16.04/amd64/LANG/PYTHON/3.5.2-SYSTEM/lib",
		}

		includedirs {
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			"/usr/include/hdf5/serial/",
			-- "/usr/include/python2.7",
            "/usr/include/python3.5m",
            "/usr/include/python3.6m",
            "/rcg/software/Linux/Ubuntu/16.04/amd64/LANG/PYTHON/3.5.2-SYSTEM/include/python3.5m" -- for cluster env at sfu
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			if file_exists("/usr/include/python3.6m/Python.h") then
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
					-- "python2.7",
					"python3.6m",
				}
			else
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
					-- "python2.7",
					"python3.5m",
				}
			end

	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			if file_exists("/usr/include/python3.6m/Python.h") then
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
					-- "python2.7",
						"python3.6m",
				}
			else
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
					-- "python2.7",
					"python3.5m",
				}
			end

	-- windows library cflags and libs
	configuration { "windows" }
		-- libdirs { "lib" }
		linkoptions  {
			"libopenblas.dll.a",
			-- "`pkg-config --cflags glu`"
		}
		defines {
			"_USE_MATH_DEFINES"
		}
		includedirs {
			windowsLibraryLoc .. "Bullet/include",
			windowsLibraryLoc,
			windowsLibraryLoc .. "Json_cpp",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			"C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v7.5/include/",
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

		-- release configs
		configuration { "windows", "Debug*"}
			defines { "DEBUG" }
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

		-- release configs
		configuration { "windows", "Release*"}
			defines { "NDEBUG" }
			links {
				"opengl32",
				"glu32",
				-- Just a few dependancies....
				"BulletDynamics",
				"BulletCollision",
				"LinearMath",
				"jsoncpp",
				"libjpeg",
				"libjasper",
				"libpng",
				"IlmImf",
				"libtiff",
				"libwebp",
				-- "cudart",
				-- "cuda",
				-- "nppi",
				-- "cufft",
				-- "cublas",
				-- "curand",
				"gflags",
				"libglog",
				"libprotobuf",
				"libprotoc",
				"leveldb",
				"lmdb",
				"libhdf5",
				"libhdf5_hl",
				"Shlwapi",
				"zlib",
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
			"OpenGL.framework",
			"Cocoa.framework",
			"dl",
			"pthread"
		}
