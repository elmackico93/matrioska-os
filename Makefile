# Makefile base per MatriOSka OS
TARGET = matrioska.bin
CC = gcc
CFLAGS = -Wall -Wextra -ffreestanding -nostdlib
LDFLAGS = -T linker.ld

SRCS = $(wildcard kernel/*.c drivers/*.c networking/*.c gui/*.c storage/*.c)
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	@echo "🔧 Compilazione di MatriOSka OS..."
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
