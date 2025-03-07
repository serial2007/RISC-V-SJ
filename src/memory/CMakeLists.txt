cmake_minimum_required(VERSION 3.10)
project(memsim)
set(CMAKE_INSTALL_RPATH "/usr/local/lib")
set(CMAKE_BUILD_RPATH "/usr/local/lib")



find_package( Boost REQUIRED COMPONENTS program_options regex )
include_directories( ${Boost_INCLUDE_DIRS} )
find_package(serial REQUIRED)

add_executable(memsim
	adapter.cpp  
	adapter.h  
	env_iface.h  
	environment.cpp  
	environment.h  
	main.cpp  
	simulator.cpp  
	simulator.h
)

target_link_libraries( memsim PUBLIC
	${Boost_PROGRAM_OPTIONS_LIBRARY} 
	${Boost_REGEX_LIBRARY} 
	${serial_LIBRARY}
	serial
)