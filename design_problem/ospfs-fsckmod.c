#include "ospfs-fsck.h"
#include <inttypes.h>
/****************************************************************************
 * ospfsmod
 *
 *   This is the OSPFS module!  It contains both library code for your use,
 *   and exercises where you must add code.
 *
 ****************************************************************************/

/* Define eprintk() to be a version of printk(), which prints messages to
 * the console.
 * (If working on a real Linux machine, change KERN_NOTICE to KERN_ALERT or
 * KERN_EMERG so that you are sure to see the messages.  By default, the
 * kernel does not print all messages to the console.  Levels like KERN_ALERT
 * and KERN_EMERG will make sure that you will see messages.) */
#define eprintk(format, ...) fprintf(stderr, format, ## __VA_ARGS__)
#define DEBUG 1
#define my_eprintk(format, ...) do {					\
		if (DEBUG) {						\
			eprintk(format, ## __VA_ARGS__);	\
		}							\
	} while(0);

// The actual disk data is just an array of raw memory.
// The initial array is defined in fsimg.c, based on your 'base' directory.
//extern uint8_t ospfs_data[];
//extern uint32_t ospfs_length;

// A pointer to the superblock; see ospfs.h for details on the struct.
static ospfs_super_t *ospfs_super;

static int change_size(ospfs_inode_t *oi, uint32_t want_size);
static ospfs_direntry_t *find_direntry(ospfs_inode_t *dir_oi, const char *name, int namelen);


/*****************************************************************************
 * FILE SYSTEM OPERATIONS STRUCTURES
 *
 *   Linux filesystems are based around three interrelated structures.
 *
 *   These are:
 *
 *   1. THE LINUX SUPERBLOCK.  This structure represents the whole file system.
 *      Example members include the root directory and the number of blocks
 *      on the disk.
 *   2. LINUX INODES.  Each file and directory in the file system corresponds
 *      to an inode.  Inode operations include "mkdir" and "create" (add to
 *      directory).
 *   3. LINUX FILES.  Corresponds to an open file or directory.  Operations
 *      include "read", "write", and "readdir".
 *
 *   When Linux wants to perform some file system operation,
 *   it calls a function pointer provided by the file system type.
 *   (Thus, Linux file systems are object oriented!)
 *
 *   These function pointers are grouped into structures called "operations"
 *   structures.
 *
 *   The initial portion of the file declares all the operations structures we
 *   need to support ospfsmod: one for the superblock, several for different
 *   kinds of inodes and files.  There are separate inode_operations and
 *   file_operations structures for OSPFS directories and for regular OSPFS
 *   files.  The structures are actually defined near the bottom of this file.
 */



/*****************************************************************************
 * BITVECTOR OPERATIONS
 *
 *   OSPFS uses a free bitmap to keep track of free blocks.
 *   These bitvector operations, which set, clear, and test individual bits
 *   in a bitmap, may be useful.
 */

// bitvector_set -- Set 'i'th bit of 'vector' to 1.
static inline void
bitvector_set(void *vector, int i)
{
	((uint32_t *) vector) [i / 32] |= (1 << (i % 32));
}

// bitvector_clear -- Set 'i'th bit of 'vector' to 0.
static inline void
bitvector_clear(void *vector, int i)
{
	((uint32_t *) vector) [i / 32] &= ~(1 << (i % 32));
}

// bitvector_test -- Return the value of the 'i'th bit of 'vector'.
static inline int
bitvector_test(const void *vector, int i)
{
	return (((const uint32_t *) vector) [i / 32] & (1 << (i % 32))) != 0;
}



/*****************************************************************************
 * OSPFS HELPER FUNCTIONS
 */

// ospfs_size2nblocks(size)
//	Returns the number of blocks required to hold 'size' bytes of data.
//
//   Input:   size -- file size
//   Returns: a number of blocks

uint32_t
ospfs_size2nblocks(uint32_t size)
{
	return (size + OSPFS_BLKSIZE - 1) / OSPFS_BLKSIZE;
}


// ospfs_block(blockno)
//	Use this function to load a block's contents from "disk".
//
//   Input:   blockno -- block number
//   Returns: a pointer to that block's data

static void *
ospfs_block(uint32_t blockno)
{
	return &ospfs_data[blockno * OSPFS_BLKSIZE];
}


// ospfs_inode(ino)
//	Use this function to load a 'ospfs_inode' structure from "disk".
//
//   Input:   ino -- inode number
//   Returns: a pointer to the corresponding ospfs_inode structure

static inline ospfs_inode_t *
ospfs_inode(uint32_t ino)
{
	ospfs_inode_t *oi;
	if (ino >= ospfs_super->os_ninodes)
		return 0;
	oi = ospfs_block(ospfs_super->os_firstinob);
	return &oi[ino];
}


// Returns a currently free ino number
static uint32_t
ospfs_find_free_ino()
{
	uint32_t entry;
	uint32_t ino_count = 0;
	uint32_t counter;
	uint32_t blockno = ospfs_super->os_firstinob;

	while (ino_count < ospfs_super->os_ninodes) {
		ospfs_inode_t *ino_ptr = ospfs_block(blockno);
		for (counter = 0; counter < OSPFS_BLKINODES;
		     ino_count++, counter++) {
			if (ino_ptr[counter].oi_nlink == 0) {
				return ino_count;
			}
		}
		blockno += 1;
	}
	return 0;
}

// ospfs_inode_blockno(oi, offset)
//	Use this function to look up the blocks that are part of a file's
//	contents.
//
//   Inputs:  oi     -- pointer to a OSPFS inode
//	      offset -- byte offset into that inode
//   Returns: the block number of the block that contains the 'offset'th byte
//	      of the file

static inline uint32_t
ospfs_inode_blockno(ospfs_inode_t *oi, uint32_t offset)
{
	uint32_t blockno = offset / OSPFS_BLKSIZE;
	if (offset >= oi->oi_size || oi->oi_ftype == OSPFS_FTYPE_SYMLINK)
		return 0;
	else if (blockno >= OSPFS_NDIRECT + OSPFS_NINDIRECT) {
		uint32_t blockoff = blockno - (OSPFS_NDIRECT + OSPFS_NINDIRECT);
		uint32_t *indirect2_block = ospfs_block(oi->oi_indirect2);
		uint32_t *indirect_block = ospfs_block(indirect2_block[blockoff / OSPFS_NINDIRECT]);
		return indirect_block[blockoff % OSPFS_NINDIRECT];
	} else if (blockno >= OSPFS_NDIRECT) {
		uint32_t *indirect_block = ospfs_block(oi->oi_indirect);
		return indirect_block[blockno - OSPFS_NDIRECT];
	} else
		return oi->oi_direct[blockno];
}


// ospfs_inode_data(oi, offset)
//	Use this function to load part of inode's data from "disk",
//	where 'offset' is relative to the first byte of inode data.
//
//   Inputs:  oi     -- pointer to a OSPFS inode
//	      offset -- byte offset into 'oi's data contents
//   Returns: a pointer to the 'offset'th byte of 'oi's data contents
//
//	Be careful: the returned pointer is only valid within a single block.
//	This function is a simple combination of 'ospfs_inode_blockno'
//	and 'ospfs_block'.

static inline void *
ospfs_inode_data(ospfs_inode_t *oi, uint32_t offset)
{
	uint32_t blockno = ospfs_inode_blockno(oi, offset);
	return (uint8_t *) ospfs_block(blockno) + (offset % OSPFS_BLKSIZE);
}


// ospfs_dir_readdir(filp, dirent, filldir)
//   This function is called when the kernel reads the contents of a directory
//   (i.e. when file_operations.readdir is called for the inode).
//
//   Inputs:  filp	-- The 'struct file' structure correspoding to
//			   the open directory.
//			   The most important member is 'filp->f_pos', the
//			   File POSition.  This remembers how far into the
//			   directory we are, so if the user calls 'readdir'
//			   twice, we don't forget our position.
//			   This function must update 'filp->f_pos'.
//	      dirent	-- Used to pass to 'filldir'.
//	      filldir	-- A pointer to a callback function.
//			   This function should call 'filldir' once for each
//			   directory entry, passing it six arguments:
//		  (1) 'dirent'.
//		  (2) The directory entry's name.
//		  (3) The length of the directory entry's name.
//		  (4) The 'f_pos' value corresponding to the directory entry.
//		  (5) The directory entry's inode number.
//		  (6) DT_REG, for regular files; DT_DIR, for subdirectories;
//		      or DT_LNK, for symbolic links.
//			   This function should stop returning directory
//			   entries either when the directory is complete, or
//			   when 'filldir' returns < 0, whichever comes first.
//
//   Returns: 1 at end of directory, 0 if filldir returns < 0 before the end
//     of the directory, and -(error number) on error.
//
//   EXERCISE: Finish implementing this function.

int
ospfs_dir_readdir(uint32_t i_ino, int *pos, ospfs_direntry_t **_od)
{
	ospfs_inode_t *dir_oi = ospfs_inode(i_ino);
	uint32_t f_pos = *pos;
	int r = -1;
	int entry_off;

	entry_off = f_pos * OSPFS_DIRENTRY_SIZE;
	if (f_pos >= 0 && entry_off < dir_oi->oi_size) {
		ospfs_direntry_t *od = ospfs_inode_data(dir_oi, entry_off);
		ospfs_inode_t *oi;

		/* If at the end of the directory, set 'r' to 1 and exit
		 * the loop.  For now we do this all the time.
		 */
		if (od->od_ino <= 0) {
			r = -1;
			*_od = NULL;
		} else {
			r = 0;
			f_pos++;
			*_od = od;
		}
	}

	// Save the file position and return!
	*pos = f_pos;
	return r;
}


// ospfs_unlink(dirino, dentry)
//   This function is called to remove a file.
//
//   Inputs: dirino  -- You may ignore this.
//           dentry  -- The 'struct dentry' structure, which contains the inode
//                      the directory entry points to and the directory entry's
//                      directory.
//
//   Returns: 0 if success and -ENOENT on entry not found.
//
//   EXERCISE: Make sure that deleting symbolic links works correctly.

static int
ospfs_unlink(uint32_t i_ino, char *d_name)
{
	ospfs_inode_t *oi = ospfs_inode(i_ino); // figure this out???
	ospfs_inode_t *dir_oi = ospfs_inode(i_ino);
	int entry_off;
	ospfs_direntry_t *od;

	od = NULL; // silence compiler warning; entry_off indicates when !od
	for (entry_off = 0; entry_off < dir_oi->oi_size;
	     entry_off += OSPFS_DIRENTRY_SIZE) {
		od = ospfs_inode_data(dir_oi, entry_off);
		if (od->od_ino > 0
		    && strlen(od->od_name) == strlen(d_name)
		    && memcmp(od->od_name, d_name, strlen(d_name)) == 0)
			break;
	}

	if (entry_off == dir_oi->oi_size) {
		return -ENOENT;
	}

	od->od_ino = 0;
	oi->oi_nlink--;
	return 0;
}



/*****************************************************************************
 * FREE-BLOCK BITMAP OPERATIONS
 *
 * EXERCISE: Implement these functions.
 */

// allocate_block()
//	Use this function to allocate a block.
//
//   Inputs:  none
//   Returns: block number of the allocated block,
//	      or 0 if the disk is full
//
//   This function searches the free-block bitmap, which starts at Block 2, for
//   a free block, allocates it (by marking it non-free), and returns the block
//   number to the caller.  The block itself is not touched.
//
//   Note:  A value of 0 for a bit indicates the corresponding block is
//      allocated; a value of 1 indicates the corresponding block is free.
//
//   You can use the functions bitvector_set(), bitvector_clear(), and
//   bitvector_test() to do bit operations on the map.

static uint32_t
allocate_block(void)
{
	int i;
	/* EXERCISE: Your code here */
	void *free_map = ospfs_block(OSPFS_FREEMAP_BLK);

	for (i = OSPFS_FREEMAP_BLK; i < ospfs_super->os_nblocks; i++) {
		if (bitvector_test(free_map, i)) {
			bitvector_clear(free_map, i);
			break;
		}
	}

	return (i == ospfs_super->os_nblocks) ? 0 : i;
}


// free_block(blockno)
//	Use this function to free an allocated block.
//
//   Inputs:  blockno -- the block number to be freed
//   Returns: none
//
//   This function should mark the named block as free in the free-block
//   bitmap.  (You might want to program defensively and make sure the block
//   number isn't obviously bogus: the boot sector, superblock, free-block
//   bitmap, and inode blocks must never be freed.  But this is not required.)

static void
free_block(uint32_t blockno)
{
	/* EXERCISE: Your code here */
	bitvector_set(ospfs_block(OSPFS_FREEMAP_BLK), blockno);
}



// add_block(ospfs_inode_t *oi)
//   Adds a single data block to a file, adding indirect and
//   doubly-indirect blocks if necessary. (Helper function for
//   change_size).
//
// Inputs: oi -- pointer to the file we want to grow
// Returns: 0 if successful, < 0 on error.  Specifically:
//          -ENOSPC if you are unable to allocate a block
//          due to the disk being full or
//          -EIO for any other error.
//          If the function is successful, then oi->oi_size
//          should be set to the maximum file size in bytes that could
//          fit in oi's data blocks.  If the function returns an error,
//          then oi->oi_size should remain unchanged. Any newly
//          allocated blocks should be erased (set to zero).
//
// EXERCISE: Finish off this function.
//
// Remember that allocating a new data block may require allocating
// as many as three disk blocks, depending on whether a new indirect
// block and/or a new indirect^2 block is required. If the function
// fails with -ENOSPC or -EIO, then you need to make sure that you
// free any indirect (or indirect^2) blocks you may have allocated!
//
// Also, make sure you:
//  1) zero out any new blocks that you allocate
//  2) store the disk block number of any newly allocated block
//     in the appropriate place in the inode or one of the
//     indirect blocks.
//  3) update the oi->oi_size field

/* Return Newly allocated block number */
static uint32_t
_add_block(int *ptr)
{
	uint32_t block_no = allocate_block();

	if (block_no) {
		*ptr = block_no;
		memset(ospfs_block(block_no), 0, OSPFS_BLKSIZE);
	}
	return block_no;
}

static int
add_block(ospfs_inode_t *oi)
{
	// current number of blocks in file
	uint32_t n = ospfs_size2nblocks(oi->oi_size);
	int32_t next_block = n + 1;
	int32_t retval = -ENOSPC;
	uint32_t block_no = 0;
	uint32_t *ptr;

	// keep track of allocations to free in case of -ENOSPC
	uint32_t allocated[2] = { 0, 0 };

	/* EXERCISE: Your code here */
	if (0 < next_block && next_block <= OSPFS_NDIRECT) {
		if (_add_block(&oi->oi_direct[next_block - 1])) {
			retval = 0;
		}
		goto out;
	}

	// The block to be allocated has to be in indirect or indirect2
	next_block -= OSPFS_NDIRECT;
	if (0 < next_block && next_block <= OSPFS_NINDIRECT) {
		if (!oi->oi_indirect) {
			if (!(allocated[0] = _add_block(&oi->oi_indirect))) {
				goto out;
			}
		}

		ptr = ospfs_block(oi->oi_indirect);
		if (!_add_block(&ptr[next_block - 1])) {
			if (allocated[0]) {
				free_block(allocated[0]);
				oi->oi_indirect = 0;
			}
			goto out;
		}
		retval = 0;
		goto out;
	}

	// next block must lie in indirect2
	next_block -= OSPFS_NINDIRECT;
	if (0 < next_block && next_block <= (OSPFS_NINDIRECT * OSPFS_NINDIRECT)) {
		uint32_t *ptrl1, *ptrl2;
		uint32_t level1 = (next_block - 1) / OSPFS_NINDIRECT;
		uint32_t level2 = (next_block - 1) % OSPFS_NINDIRECT;
		if (!oi->oi_indirect2) {
			if (!(allocated[0] = _add_block(&oi->oi_indirect2))) {
				goto out;
			}
		}

		ptrl1 = ospfs_block(oi->oi_indirect2);
		if (!ptrl1[level1]) {
			if (!(allocated[1] = _add_block(&ptrl1[level1]))) {
				if (allocated[0]) {
					free_block(allocated[0]);
					oi->oi_indirect2 = 0;
				}
				goto out;
			}
		}

		ptrl2 = ospfs_block(ptrl1[level1]);
		if (!ptr[level2]) {
			if (!_add_block(&ptr[level2])) {
				if (allocated[0]) {
					free_block(allocated[0]);
					oi->oi_indirect2 = 0;
				}
				if (allocated[1]) {
					free_block(allocated[1]);
					((uint32_t *) ospfs_block(allocated[1]))
						[level1] = 0;
				}
				goto out;
			}
			retval = 0;
			goto out;
		}	
	}
 out:
	return retval;
}


// remove_block(ospfs_inode_t *oi)
//   Removes a single data block from the end of a file, freeing
//   any indirect and indirect^2 blocks that are no
//   longer needed. (Helper function for change_size)
//
// Inputs: oi -- pointer to the file we want to shrink
// Returns: 0 if successful, < 0 on error.
//          If the function is successful, then oi->oi_size
//          should be set to the maximum file size that could
//          fit in oi's blocks.  If the function returns -EIO (for
//          instance if an indirect block that should be there isn't),
//          then oi->oi_size should remain unchanged.
//
// EXERCISE: Finish off this function.
//
// Remember that you must free any indirect and doubly-indirect blocks
// that are no longer necessary after shrinking the file.  Removing a
// single data block could result in as many as 3 disk blocks being
// deallocated.  Also, if you free a block, make sure that
// you set the block pointer to 0.  Don't leave pointers to
// deallocated blocks laying around!

static int
remove_block(ospfs_inode_t *oi)
{
	// current number of blocks in file
	uint32_t n = ospfs_size2nblocks(oi->oi_size);
	uint32_t block_no = 0;
	uint32_t *ptr;

	// keep track of allocations to free in case of -ENOSPC
	uint32_t allocated[2] = { 0, 0 };

	/* EXERCISE: Your code here */
	if (0 < n && n <= OSPFS_NDIRECT) {
		oi->oi_direct[n - 1] = 0;
		free_block(n - 1);
		goto out;
	}

	// The block to be allocated has to be in indirect or indirect2
	n -= OSPFS_NDIRECT;
	if (0 < n && n <= OSPFS_NINDIRECT) {
		if (oi->oi_indirect) {
			ptr = ospfs_block(oi->oi_indirect);
			free_block(ptr[n - 1]);
			ptr[n - 1] = 0;
			if ((n - 1) == 0) {
				free_block(oi->oi_indirect);
				oi->oi_indirect = 0;
			}
		}
		goto out;
	}

	// next block must lie in indirect2
	n -= OSPFS_NINDIRECT;
	if (0 < n && n <= (OSPFS_NINDIRECT * OSPFS_NINDIRECT)) {
		uint32_t *ptrl1, *ptrl2;
		uint32_t level1 = (n - 1) / OSPFS_NINDIRECT;
		uint32_t level2 = (n - 1) % OSPFS_NINDIRECT;

		ptrl1 = ospfs_block(oi->oi_indirect2);
		ptrl2 = ospfs_block(ptrl1[level1]);
		if (ptrl2[level2]) {
			free_block(ptrl2[level2]);
			ptrl2[level2] = 0;
		}
		if (level2 == 0) {
			free_block(ptrl1[level1]);
			ptrl1[level1] = 0;
			if (level1 == 0) {
				free_block(oi->oi_indirect2);
				oi->oi_indirect2 = 0;
			}
		}
	}
 out:
	return 0;
}


// change_size(oi, want_size)
//	Use this function to change a file's size, allocating and freeing
//	blocks as necessary.
//
//   Inputs:  oi	-- pointer to the file whose size we're changing
//	      want_size -- the requested size in bytes
//   Returns: 0 on success, < 0 on error.  In particular:
//		-ENOSPC: if there are no free blocks available
//		-EIO:    an I/O error -- for example an indirect block should
//			 exist, but doesn't
//	      If the function succeeds, the file's oi_size member should be
//	      changed to want_size, with blocks allocated as appropriate.
//	      Any newly-allocated blocks should be erased (set to 0).
//	      If there is an -ENOSPC error when growing a file,
//	      the file size and allocated blocks should not change from their
//	      original values!!!
//            (However, if there is an -EIO error, do not worry too much about
//	      restoring the file.)
//
//   If want_size has the same number of blocks as the current file, life
//   is good -- the function is pretty easy.  But the function might have
//   to add or remove blocks.
//
//   If you need to grow the file, then do so by adding one block at a time
//   using the add_block function you coded above. If one of these additions
//   fails with -ENOSPC, you must shrink the file back to its original size!
//
//   If you need to shrink the file, remove blocks from the end of
//   the file one at a time using the remove_block function you coded above.
//
//   Also: Don't forget to change the size field in the metadata of the file.
//         (The value that the final add_block or remove_block set it to
//          is probably not correct).
//
//   EXERCISE: Finish off this function.

static int
change_size(ospfs_inode_t *oi, uint32_t new_size)
{
	uint32_t old_size = oi->oi_size;
	int r = 0;

	/* EXERCISE: Your code here */
	if (ospfs_size2nblocks(old_size) < ospfs_size2nblocks(new_size)) {
		while (ospfs_size2nblocks(oi->oi_size) <
		       ospfs_size2nblocks(new_size)) {
			if ((r = add_block(oi))) {
				break;
			}
			oi->oi_size = (ospfs_size2nblocks(oi->oi_size) + 1) *
				OSPFS_BLKSIZE;
		}
		if (ospfs_size2nblocks(oi->oi_size) ==
		    ospfs_size2nblocks(new_size)) {
			oi->oi_size = new_size;
			goto out;
		}
		while (ospfs_size2nblocks(old_size) !=
		       ospfs_size2nblocks(oi->oi_size)) {
			remove_block(oi);
			oi->oi_size = (ospfs_size2nblocks(oi->oi_size) - 1) *
				OSPFS_BLKSIZE;
		}
		oi->oi_size = old_size;
	} else if (ospfs_size2nblocks(old_size) > ospfs_size2nblocks(new_size)) {
		while (ospfs_size2nblocks(oi->oi_size) >
		       ospfs_size2nblocks(new_size)) {
			/* EXERCISE: Your code here */
			remove_block(oi);
			oi->oi_size = (ospfs_size2nblocks(oi->oi_size) - 1) *
				OSPFS_BLKSIZE;
		}
		oi->oi_size = new_size;
	} else {
		oi->oi_size = new_size;
	}
 out:
	return r;
}

// find_direntry(dir_oi, name, namelen)
//	Looks through the directory to find an entry with name 'name' (length
//	in characters 'namelen').  Returns a pointer to the directory entry,
//	if one exists, or NULL if one does not.
//
//   Inputs:  dir_oi  -- the OSP inode for the directory
//	      name    -- name to search for
//	      namelen -- length of 'name'.  (If -1, then use strlen(name).)
//
//	We have written this function for you.

static ospfs_direntry_t *
find_direntry(ospfs_inode_t *dir_oi, const char *name, int namelen)
{
	int off;
	if (namelen < 0)
		namelen = strlen(name);
	for (off = 0; off < dir_oi->oi_size; off += OSPFS_DIRENTRY_SIZE) {
		ospfs_direntry_t *od = ospfs_inode_data(dir_oi, off);
		if (od->od_ino
		    && strlen(od->od_name) == namelen
		    && memcmp(od->od_name, name, namelen) == 0)
			return od;
	}
	return 0;
}


// create_blank_direntry(dir_oi)
//	'dir_oi' is an OSP inode for a directory.
//	Return a blank directory entry in that directory.  This might require
//	adding a new block to the directory.  Returns an error pointer (see
//	below) on failure.
//
// ERROR POINTERS: The Linux kernel uses a special convention for returning
// error values in the form of pointers.  Here's how it works.
//	- ERR_PTR(errno): Creates a pointer value corresponding to an error.
//	- IS_ERR(ptr): Returns true iff 'ptr' is an error value.
//	- PTR_ERR(ptr): Returns the error value for an error pointer.
//	For example:
//
//	static ospfs_direntry_t *create_blank_direntry(...) {
//		return ERR_PTR(-ENOSPC);
//	}
//	static int ospfs_create(...) {
//		...
//		ospfs_direntry_t *od = create_blank_direntry(...);
//		if (IS_ERR(od))
//			return PTR_ERR(od);
//		...
//	}
//
//	The create_blank_direntry function should use this convention.
//
// EXERCISE: Write this function.

static ospfs_direntry_t *
create_blank_direntry(ospfs_inode_t *dir_oi)
{
	uint32_t blockno;
	uint32_t off = 1;
	int ret;
	uint32_t entry_off;

	// Outline:
	// 1. Check the existing directory data for an empty entry.  Return one
	//    if you find it.
	// 2. If there's no empty entries, add a block to the directory.
	//    Use ERR_PTR if this fails; otherwise, clear out all the directory
	//    entries and return one of them.

	/* EXERCISE: Your code here. */
	// Search through the directory block
	for (entry_off = 0; entry_off < dir_oi->oi_size;
	     entry_off += OSPFS_DIRENTRY_SIZE) {
		// Find the OSPFS inode for the entry
		ospfs_direntry_t *od = ospfs_inode_data(dir_oi, entry_off);

		// Set 'entry_inode' if we find the file we are looking for
		if (od->od_ino == 0) {
			return od;
		}
	}
	if ((ret = change_size(dir_oi, dir_oi->oi_size + OSPFS_DIRENTRY_SIZE))) {
		return NULL;
	}
	return create_blank_direntry(dir_oi);
}


// ospfs_create
//   Linux calls this function to create a regular file.
//   It is the ospfs_dir_inode_ops.create callback.
//
//   Inputs:  dir	-- a pointer to the containing directory's inode
//            dentry    -- the name of the file that should be created
//                         The only important elements are:
//                         dentry->d_name.name: filename (char array, not null
//                            terminated)
//                         dentry->d_name.len: length of filename
//            mode	-- the permissions mode for the file (set the new
//			   inode's oi_mode field to this value)
//	      nd	-- ignore this
//   Returns: 0 on success, -(error code) on error.  In particular:
//               -ENAMETOOLONG if dentry->d_name.len is too large;
//               -EEXIST       if a file named the same as 'dentry' already
//                             exists in the given 'dir';
//               -ENOSPC       if the disk is full & the file can't be created;
//               -EIO          on I/O error.
//
//   We have provided strictly less skeleton code for this function than for
//   the others.  Here's a brief outline of what you need to do:
//   1. Check for the -EEXIST error and find an empty directory entry using the
//	helper functions above.
//   2. Find an empty inode.  Set the 'entry_ino' variable to its inode number.
//   3. Initialize the directory entry and inode.
//
//   EXERCISE: Complete this function.

static int
ospfs_create(int i_ino, char *d_name, int mode)
{
	ospfs_inode_t *dir_oi = ospfs_inode(i_ino);
	ospfs_direntry_t *file_od;
	ospfs_inode_t *file_oi = NULL;
	uint32_t entry_ino = 0;

	if (strlen(d_name) >= OSPFS_MAXNAMELEN) {
		return -ENAMETOOLONG;
	} else if (find_direntry(dir_oi, d_name, strlen(d_name))) {
		return -EEXIST;
	}

	entry_ino = ospfs_find_free_ino();
	if (entry_ino == 0) {
		return -ENOSPC;
	}

	file_od = create_blank_direntry(dir_oi);
	if (file_od == NULL) {
		return -ENOSPC;
	}

	file_od->od_ino = entry_ino;
	memcpy(file_od->od_name, d_name, strlen(d_name));

	file_oi = ospfs_inode(entry_ino);
	file_oi->oi_size = 0;
	file_oi->oi_ftype = OSPFS_FTYPE_REG;
	file_oi->oi_nlink = 1;
	file_oi->oi_mode = mode;
}

int ospfs_fill_super()
{
	ospfs_super = (ospfs_super_t *) &ospfs_data[OSPFS_BLKSIZE];
        return 0;
}
