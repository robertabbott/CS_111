#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <inttypes.h>
#include "ospfs-fsck.h"

static int ninodeblklength;
static uint8_t *bitmap;
static uint8_t *inodeTable;
int nblocks, ninodes, firstinoblock;

void initialize(char *imgfile)
{
	int i = 0;
	uint8_t *ptr;
	int fd = open(imgfile, O_RDONLY);

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

	ninodeblklength = ninodes * OSPFS_INODESIZE;
	bitmap = calloc(OSPFS_BLKSIZE, sizeof(uint8_t));
	inodeTable = calloc(ninodeblklength, sizeof(uint8_t));

	// mark reserved blocks in bitmap
	for (i = 0; i < OSPFS_BLKSIZE; i++) {
		bitmap[i] = -1;
	}

	for (i = 0; i < (3 + ninodeblklength / OSPFS_BLKSIZE); i++) {
		bitvector_clear(bitmap, i);
	}

	ospfs_fill_super();
}


int
traverse(uint32_t i_ino)
{
	int pos = 0;
	ospfs_direntry_t *od;

	copy_inode(i_ino, bitmap, inodeTable);

	if (!is_dir(i_ino)) {
		return 0;
	} else {
		fprintf(stdout, "Traversing %d\n", i_ino);
	}

	while(ospfs_dir_readdir(i_ino, &pos, &od) != -1) {
		printf ("%d: %s\n", od->od_ino, od->od_name);
		traverse(od->od_ino);
	}
}

void
build_information()
{
	int i, err = 0;
	uint8_t *ptr = (uint8_t *) ospfs_block(OSPFS_FREEMAP_BLK);
	ospfs_inode_t *oi = (ospfs_inode_t *) inodeTable;

	memcpy(&oi[0], ospfs_inode(0), sizeof(*oi));
	traverse(1);
	for (i = 0; i < ninodes; i++) {
		if (memcmp(&oi[i], ospfs_inode(i), sizeof(*oi))) {
			fprintf(stderr, "inode cmp failed for %d ino\n", i);
		}
	}

	for (i = 0; i < nblocks / 8; i++) {
		int j, k = 1;
		if (bitmap[i] == ptr[i]) {
			continue;
		}
		for (j = 0; j < 8; j++, k <<= 1) {
			if ((bitmap[i] & k) == (ptr[i] &k)) {
				continue;
			} else if (bitmap[i] & k) {
				fprintf(stdout, "i = %d is marked used "
					"but no inode is using it\n",
					i * 8 + k);
			} else {
				fprintf(stdout, "i = %d is marked free "
					"but it is used by one of the inodes\n",
					i * 8 + k);
			}
		}
	}
}

int
main (int argc, char *argv[])
{
	if (argv != 2) {
		fprintf(stderr, "usage: %s [img file]\n", argv[0]);
		return 0;
	}
	initialize(argv[1]);

	build_information();

	return 0;
}
