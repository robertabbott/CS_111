#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <inttypes.h>
#include "ospfs-fsck.h"

void initialize()
{
	int i = 0;
	int nblocks, ninodes, firstinoblock;
	uint8_t *ptr;
	int fd = open("fs.img", O_RDONLY);

	lseek(fd, OSPFS_BLKSIZE + 4, SEEK_SET);

	read(fd, &nblocks, 4);
	read(fd, &ninodes, 4);
	read(fd, &firstinoblock, 4);

	printf ("nblocks = %d, "\
		"ninodes = %d, "\
		"firstinoblock = %d\n",
		nblocks, ninodes, firstinoblock);

	ospfs_length = nblocks * OSPFS_BLKSIZE;
	ospfs_data = calloc(ospfs_length, sizeof(uint8_t));
	if (ospfs_data == NULL) {
		fprintf(stderr, "memory allocation failed\n");
		exit(-1);
	}

	ptr = ospfs_data;
	i = 0;
	while (i < nblocks) {
		lseek(fd, i * OSPFS_BLKSIZE, SEEK_SET);
		if (read(fd, ptr, OSPFS_BLKSIZE) != OSPFS_BLKSIZE) {
			fprintf(stderr, "read error\n");
			exit(-1);
		}
		ptr += OSPFS_BLKSIZE;;
		i++;
	}

	ospfs_fill_super();
}

int
main ()
{
	int pos = 0;
	ospfs_direntry_t *od;

	initialize();

	while(ospfs_dir_readdir(1, &pos, &od) != -1) {
		printf ("%d: %s\n", od->od_ino, od->od_name);
	}
	return 0;
}
