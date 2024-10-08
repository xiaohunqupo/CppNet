detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')

SRCS = $(wildcard ./common/alloter/*.cpp       \
                  ./common/buffer/*.cpp        \
                  ./common/log/*.cpp           \
                  ./common/timer/*.cpp         \
                  ./common/network/*.cpp       \
                  ./common/network/posix/*.cpp \
                  ./common/structure/*.cpp     \
                  ./common/thread/*.cpp        \
                  ./common/util/*.cpp          \
                  ./common/os/*.cpp            \
                  ./common/os/posix/*.cpp      \
                  ./common/util/*.cpp          \
                  ./cppnet/event/*.cpp         \
                  ./cppnet/socket/*.cpp        \
                  ./cppnet/*.cpp               \
                  )

ifeq ($(detected_OS),Linux)   #linux
    SRCS += $(wildcard ./cppnet/event/epoll/*.cpp)
endif

ifeq ($(detected_OS),Darwin)  # Mac OS X
    SRCS += $(wildcard ./cppnet/event/kqueue/*.cpp)
endif

ifeq ($(detected_OS),FreeBSD)  # FreeBSD
    SRCS += $(wildcard ./cppnet/event/kqueue/*.cpp)
endif

OBJS = $(patsubst %.cpp, %.o, $(SRCS))


CC = g++

INCLUDES = -I. 

#debug

#CCFLAGS = -lpthread -fPIC -m64 -g -std=c++11 -lstdc++ -pipe -Wall

CCFLAGS = -lpthread -fPIC -m64 -O2 -std=c++11 -lstdc++ -pipe

TARGET = libcppnet.a

all:$(TARGET)

$(TARGET):$(OBJS)
	ar rcs $@ $^

%.o : %.cpp
	$(CC) -c $< -o $@ $(CCFLAGS) $(INCLUDES) 

clean:
	rm -rf $(OBJS) $(TARGET) $(SERBIN) $(CLIBIN)
