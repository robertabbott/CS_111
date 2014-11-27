#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <inttypes.h>
#include <errno.h>
#include <string.h>

#define BLOCK_SIZE 1024

void usage(char *progname)
{
	fprintf(stderr,
		"usage: %s <r/w> <offset> [<value>/<length>] <img-file>\n",
		progname);

	exit(0);
}

void
read_data(int fd, int offset, int length)
{
	uint8_t buffer[BLOCK_SIZE];
	int i;

	lseek(fd, offset, SEEK_SET);
	read(fd, buffer, length);

	for (i = 0; i < length; i++) {
		if (i % 20 == 0) {
			fprintf(stdout, "\n%0x :", i);
		}
		fprintf(stdout, "0x%02x ", buffer[i]);
	}
	fprintf(stdout, "\n");
}

void
write_data(int fd, int offset, uint8_t data)
{
	fprintf(stdout, "writing 0x%0x at %d\n", data, offset);
	lseek(fd, offset, SEEK_SET);
	write(fd, &data, sizeof(uint8_t));
}

int
main (int argc, char *argv[])
{
	int fd;
	int offset, length;
	uint8_t data;

	if (argc != 5) {
		usage(argv[0]);
		return -1;
	}

	fd = open(argv[4], O_RDWR);
	if (fd < 0) {
		fprintf(stderr, "open: %s\n", strerror(errno));
		exit(-1);
	}

	switch(argv[1][0]) {
	case 'r':
		sscanf(argv[2], "%d", &offset);
		sscanf(argv[3], "%d", &length);
		read_data(fd, offset, length);
		break;
	case 'w':
		sscanf(argv[2], "%d", &offset);
		sscanf(argv[3], "%"SCNd8"", &data);
		write_data(fd, offset, data);
		break;
	default:
		usage(argv[0]);
	}
}
