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

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

static int
command_switch(command_t c, int profiling);

int
prepare_profiling (char const *name)
{
  /* FIXME: Replace this with your implementation.  You may need to
     add auxiliary functions and otherwise modify the source code.
     You can also use external functions defined in the GNU C Library.  */
  error (0, 0, "warning: profiling not yet implemented %s", name);
  return -1;
}

int
command_status (command_t c)
{
  return c->status;
}

char**
tokenize_command(char *tokenArr)
{
        int i = 0, len = strlen(tokenArr);
        int wdcount = 1;
        char **tokenArrPtr;

        while (i < len) {
                if (tokenArr[i] == ' ') {
                        wdcount++;
                }
                i++;
        }

        tokenArrPtr = malloc(sizeof(char *) * (wdcount + 1));
        for (i = 0; i <= wdcount; i++) {
                char *token = strtok(tokenArr, " ");
                if (token) {
                        tokenArrPtr[i] = malloc(strlen(token) + 1);
                        strcpy(tokenArrPtr[i], token);
                } else {
                        tokenArrPtr[i] = NULL;
                        break;
                }
                tokenArr = NULL;
        }
	return tokenArrPtr;
}

void
execute_simple_command(command_t c, int profiling)
{
	char **tokenArrptr = tokenize_command(*(c->u.word));
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
			perror("open output file: %s", c->output);
		} else {
			dup2(outFD, STDOUT_FILENO);
			close(outFD);
		}
	}
	execvp(tokenArrptr[0], tokenArrptr);
}

int
execute_subshell(command_t c, int profiling)
{
	command_switch(c->u.command[0], profiling);
}

int
execute_pipe(command_t c, int profiling)
{
	pid_t pid;

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
		command_switch(c->u.command[1], profiling);
	}
}

int execute_sequence(command_t c, int profiling)
{
	pid_t pid = fork();

	if (pid < 0) {
		return -1;
	} else if (!pid) {
		command_switch(c->u.command[0], profiling);
	} else {
		waitpid(pid, NULL, 0);
		command_switch(c->u.command[1], profiling);
	}
}

static int
execute_if_command(command_t c, int profiling)
{
	pid_t pid = fork();
	if (!pid) {
		command_switch(c->u.command[0], profiling);
	} else {
		int status;
		waitpid(pid, &status, 0);
		if (!status) {
			command_switch(c->u.command[1], profiling);
		} else if (c->u.command[2]) {
			command_switch(c->u.command[2], profiling);
		}
	}
	_exit(c->status);
}

execute_until_command(command_t c, int profiling) {
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
			waitpid(pid, &status, 0);
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
	pid = fork();
	if (pid < 0) {
		return;
	} else if (pid == 0) {
		command_switch(c, profiling);
	} else {
		waitpid(pid, NULL, 0);
	}
}
