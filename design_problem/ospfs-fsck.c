#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <inttypes.h>
#include "ospfs-fsck.h"

uint8_t *ospfs_data;
uint32_t ospfs_length;

int
main ()
{
	int i = 0;
	int nblocks, ninodes, firstinoblock;

	int fd = open("fs.img", O_RDONLY);

	lseek(fd, OSPFS_BLKSIZE + 4, SEEK_SET);

	read(fd, &nblocks, 4);
	read(fd, &ninodes, 4);
	read(fd, &firstinoblock, 4);


	printf ("nblocks = %d, "\
		"ninodes = %d, "\
		"firstinoblock = %d\n",
		nblocks, ninodes, firstinoblock);

	lseek(fd, 0, SEEK_SET);
	ospfs_length = nblocks * OSPFS_BLKSIZE;
	ospfs_data = calloc(ospfs_length, sizeof(uint8_t));
	if (ospfs_data == NULL) {
		fprintf(stderr, "memory allocation failed\n");
		return -1;
	}
	while (i++ < nblocks) {
		read(fd, ospfs_data + (i * OSPFS_BLKSIZE), OSPFS_BLKSIZE);
	}

	return 0;
}
