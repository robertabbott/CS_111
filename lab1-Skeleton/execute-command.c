// UCLA CS 111 Lab 1 command execution

// Copyright 2012-2014 Paul Eggert.

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include "command.h"
#include "command-internals.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <error.h>
#include <time.h>
#include <sys/resource.h>


#define GET_SYS_TIME(start, end, res)					\
	do {								\
	if ((end.tv_nsec - start.tv_nsec) < 0) {			\
		res.tv_sec = end.tv_sec-start.tv_sec-1;			\
		res.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;	\
	} else {							\
		res.tv_sec = end.tv_sec-start.tv_sec;			\
		res.tv_nsec = end.tv_nsec-start.tv_nsec;		\
	}								\
	} while(0);

char buf[BUFSIZE];

static int
command_switch(command_t c, int profiling);

int
prepare_profiling (char const *name)
{
	return open(name, O_WRONLY | O_CREAT | O_TRUNC, 0644);
}

int
command_status (command_t c)
{
  return c->status;
}


void
log_command(command_t c, int profiling,
	    struct timespec start, struct timespec end)
{
	int  len;
	double localtime, realtime, usertime, systime;
	char timeBuf[BUFSIZE];
	struct rusage self, children;
	struct timespec realtv, localts;

	getrusage(RUSAGE_CHILDREN, &children);
	getrusage(RUSAGE_SELF, &self);

	GET_SYS_TIME(start, end, realtv);
	clock_gettime(CLOCK_REALTIME, &localts);

	localtime = localts.tv_sec + (localts.tv_nsec / GIGA);
	realtime = realtv.tv_sec + (realtv.tv_nsec / GIGA);
	usertime = self.ru_utime.tv_sec + (self.ru_utime.tv_usec / MEGA) +
		children.ru_utime.tv_sec + (children.ru_utime.tv_usec / MEGA);
        systime = self.ru_stime.tv_sec + (self.ru_stime.tv_usec / MEGA) +
		children.ru_stime.tv_sec + (children.ru_stime.tv_usec / MEGA);

	len = snprintf(timeBuf, BUFSIZE, "%f %f %f %f ",
		       localtime, realtime, usertime, systime);

	// acquire lock
	write(profiling, timeBuf, len);
	construct_command(c, timeBuf);
	write(profiling, timeBuf, strlen(timeBuf));
	write(profiling, "\n", 1);
	printf("%s\n", timeBuf);
}

char**
tokenize_command(char *tokenArrOrig)
{
        int i = 0, len = strlen(tokenArrOrig);
        int wdcount = 1;
        char **tokenArrPtr;
	char tokenArr[1024];
	char *ptr = tokenArr;

	strncpy(tokenArr, tokenArrOrig, len+1);
        while (i < len) {
                if (tokenArr[i] == ' ') {
                        wdcount++;
                }
                i++;
        }

        tokenArrPtr = malloc(sizeof(char *) * (wdcount + 1));
        for (i = 0; i <= wdcount; i++) {
                char *token = strtok(ptr, " ");
                if (token) {
                        tokenArrPtr[i] = malloc(strlen(token) + 1);
                        strcpy(tokenArrPtr[i], token);
                } else {
                        tokenArrPtr[i] = NULL;
                        break;
                }
                ptr = NULL;
        }
	return tokenArrPtr;
}

void
execute_simple_command(command_t c, int profiling)
{
	char **tokenArrptr = tokenize_command(*(c->u.word));
	struct timespec start, end;
	int pid;

	clock_gettime(CLOCK_MONOTONIC, &start);

	pid = fork();
	if (pid == 0) {
		if (c->input) {
			int inFD;
			inFD = open(c->input, O_RDONLY);
			if (inFD == -1) {
				perror("open input file: ");
			} else {
				dup2(inFD, STDIN_FILENO);
				close(inFD);
			}
		}
		if (c->output) {
			int outFD;
			outFD = open(c->output, O_WRONLY | O_CREAT | O_TRUNC, 0644);
			if (outFD == -1) {
				perror("open output file: ");
			} else {
				dup2(outFD, STDOUT_FILENO);
				close(outFD);
			}
		}
		execvp(tokenArrptr[0], tokenArrptr);
	} else {
		int status;
		waitpid(pid, &status, 0);
		clock_gettime(CLOCK_MONOTONIC, &end);
		log_command(c, profiling, start, end);
		_exit(status ? 1 : 0);
	}
}

int
execute_subshell(command_t c, int profiling)
{
 	struct timespec start, end;
	int pid;

	clock_gettime(CLOCK_MONOTONIC, &start);

	pid = fork();
	if (!pid) {
		command_switch(c->u.command[0], profiling);
	} else {
		int status;
		waitpid(pid, &status, 0);
		clock_gettime(CLOCK_MONOTONIC, &end);
		log_command(c, profiling, start, end);
		_exit(status);
	}
}

int
execute_pipe(command_t c, int profiling)
{
 	struct timespec start, end;
	int pid;

	clock_gettime(CLOCK_MONOTONIC, &start);

	int pipefd[2];
	if (pipe(pipefd)) {
		// error
		return -1;
	}
	pid = fork();
	if (pid < 0) {
		return -1;
	} else if (pid == 0) {
		dup2(pipefd[1], STDOUT_FILENO);
		close(pipefd[0]);
		close(pipefd[1]);	
		command_switch(c->u.command[0], profiling);
	} else {
		dup2(pipefd[0], STDIN_FILENO);
		close(pipefd[0]);
		close(pipefd[1]);

		pid = fork();
		if (pid == -1) {
			return -1;
		} else if (pid == 0) {
			command_switch(c->u.command[1], profiling);
		} else {
			int status;
			waitpid(pid, &status, 0);
			clock_gettime(CLOCK_MONOTONIC, &end);
			log_command(c, profiling, start, end);
			_exit(status);
		}
	}
}

static int
_execute_command(command_t c, int profiling)
{
	pid_t pid = fork();

	if (pid < 0) {
		return -1;
	} else if (!pid) {
		command_switch(c, profiling);
	} else {
		int status;
		waitpid(pid, &status, 0);
		return status;
	}
}

int
execute_sequence(command_t c, int profiling)
{
	int status;
	struct timespec start, end;

	clock_gettime(CLOCK_MONOTONIC, &start);

	_execute_command(c->u.command[0], profiling);
	status = _execute_command(c->u.command[1], profiling);

	clock_gettime(CLOCK_MONOTONIC, &end);
	log_command(c, profiling, start, end);

	_exit(status);
}

static int
execute_if_command(command_t c, int profiling)
{
	int status;
	struct timespec start, end;

	clock_gettime(CLOCK_MONOTONIC, &start);

	pid_t pid = fork();
	if (!pid) {
		command_switch(c->u.command[0], profiling);
	} else {
		int status;
		waitpid(pid, &status, 0);
		if (!status) {
			c->status = _execute_command(c->u.command[1], profiling);
		} else if (c->u.command[2]) {
			c->status = _execute_command(c->u.command[2], profiling);
		}
	}

	clock_gettime(CLOCK_MONOTONIC, &end);
	log_command(c, profiling, start, end);
	_exit(c->status);
}

execute_until_command(command_t c, int profiling)
{
	int status;
	struct timespec start, end;

	while (1) {
		pid_t pid = fork();
		if (!pid) {
			command_switch(c->u.command[0], profiling);
		} else {
			int status;
			waitpid(pid, &status, 0);
			if (!status) {
				break;
			} else {
				pid = fork();
				if (!pid) {
					command_switch(c->u.command[1], profiling);
				} else {
					waitpid(pid, &c->status, 0);
				}
			}
		}
	}
	log_command(c, profiling, start, end);

	if (c->u.command[2]) {
		command_switch(c->u.command[2], profiling);
	}

	_exit(c->status);
}

static int
execute_while_command(command_t c, int profiling)
{
	while (1) {
		pid_t pid = fork();
		if (!pid) {
			command_switch(c->u.command[0], profiling);
		} else {
			int status;
			if (waitpid(pid, &status, 0) != pid) {
				waitpid(pid, &status, 0);
			}
			if (status) {
				break;
			} else {
				pid = fork();
				if (!pid) {
					command_switch(c->u.command[1], profiling);
				} else {
					waitpid(pid, &c->status, 0);
				}
			}
		}
	}
	if (c->u.command[2]) {
		command_switch(c->u.command[2], profiling);
	}

	_exit(c->status);
}

static int
command_switch(command_t c, int profiling)
{
	if (!c) {
		return -1;
	}
	switch(c->type) {
	case IF_COMMAND:
		execute_if_command(c, profiling);
		break;
	case PIPE_COMMAND:
		execute_pipe(c, profiling);
		break;
	case SEQUENCE_COMMAND:
		execute_sequence(c, profiling);
		break;
	case SIMPLE_COMMAND:
		execute_simple_command(c, profiling);
		break;
	case SUBSHELL_COMMAND:
		execute_subshell(c, profiling);
		break;
	case UNTIL_COMMAND:
		execute_until_command(c, profiling);
		break;
	case WHILE_COMMAND:
		execute_while_command(c, profiling);
		break;
	default:
		error(0, 0, "Invalid command type %d\n", c->type);
	}
}

void
execute_command (command_t c, int profiling)
{
	pid_t pid;

	if (!c) {
		return;
	}

	construct_command(c, buf);
	fprintf(stdout, "buf: %s\n", buf);

	pid = fork();
	if (pid < 0) {
		return;
	} else if (pid == 0) {
		command_switch(c, profiling);
	} else {
		waitpid(pid, NULL, 0);
	}
}
