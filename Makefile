
.PHONY: all clean
CC=gcc
CXX=g++
CFLAGS=-std=c99
INCLUDE=-Idescriptor -Isrc -Itests -I.
CPPFLAGS=-O3 -fomit-frame-pointer -Wall -Wextra -g -DUPB_UNALIGNED_READS_OK -DNDEBUG $(INCLUDE)
OBJ=src/upb_parse.o src/upb_table.o src/upb_msg.o src/upb_enum.o src/upb_context.o \
    src/upb_string.o src/upb_text.o descriptor/descriptor.o
SRC=src/*.c src/*.h descriptor/*.c descriptor/*.h tests/*.c tests/*.h tools/*.c
ALL=$(OBJ) src/libupb.a tests/test_table tests/tests tools/upbc benchmark/benchmark
all: $(ALL)
clean:
	rm -f $(ALL) benchmark/google_messages.proto.pb benchmark/google_messages.pb.*

src/libupb.a: $(OBJ)
	ar rcs src/libupb.a $(OBJ)
tests/test_table: src/libupb.a
tools/upbc: src/libupb.a
benchmark/benchmark: src/libupb.a benchmark/google_messages.pb.h benchmark/google_messages.pb.o benchmark/benchmark.o
	$(CXX) $(CPPFLAGS) -o benchmark/benchmark benchmark/google_messages.pb.o benchmark/benchmark.cc src/libupb.a -lm -lprotobuf -lpthread
benchmark/google_messages.pb.cc benchmark/google_messages.pb.h benchmark/google_messages.pb: benchmark/google_messages.proto
	protoc benchmark/google_messages.proto --cpp_out=. -obenchmark/google_messages.proto.pb
