// UCLA CS 111 Lab 1 command reading

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

#include <string.h>
#include <error.h>

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/* FIXME: Define the type 'struct command_stream' here.  This should
   complete the incomplete type declaration in command.h.  */

command_stream_t *
AllocateCommandStream()
{
  command_stream_t *node = NULL;

  node = checked_malloc(sizeof cmd_stream_node);
  node->command = node->node = NULL;

  return node;
}

int
ReadNextToken(char **t, int (*get_next_byte) (void *),
	      void *get_next_byte_argument)
{
  char c;
  char *token = ;

  if (!t) {
    return -1; // Replace with error code
  }

  while ((c = get_next_byte(get_next_byte_argument)) != EOF) {
    switch (c) {
    case ' ':
      break;
    case ';':
      break;
    case '|':
      break;
    default:
      break;
    }
  }
  return ;
}

command_t
parse_pipeline_command (char *get_char, File *fp, char *s) {
  // parse into A | B format
  int arg1_index;
  commant_t pipe_comm;

  command_t pipe_comm;
  pipe_comm->type = PIPE_COMMAND;

  arg1_index = strstr(s, "|");
  pipe_comm[0] = s[0:arg1_index]
  pipe_comm[1] = ReadNextToken ();


  return pipe_comm;
}

command_t
parse_subshell_command (char *get_char, File *fp, char *s) {

}

command_t
make_command_stream_util (char *get_char, File *fp) {
  char *s = ReadNextToken ();
  char *nextToken;
  command_t comm;

  if (strstr (s, "|") != NULL) {
    // PIPE_COMMAND should call util again
    comm->command[0] = make_command_stream_util (get_char, fp, s);
  }

  else if (strstr (s, "(") != NULL) {
    // create subshell

  }

  else if (strcmp(s, "IF", 2)) {
    // continue until fi statement
    nextToken = ReadNextToken ();
    while (!strcmp(nextToken, "FI", 2)) {
      // if pipe command call parse_pipe
      if (strstr (nextToken, "|") != NULL) {
        comm->command[0] = parse_pipeline_command (get_char, fp, nextToken);
      }
      else if (strstr (nextToken, "(") != NULL) {
        // create sub-shell command
      }
      // otherwise add token to if command
      else {
        comm->command[0] = nextToken;
      }
    }

  }
  else if (strcmp(s, "WHILE", 5)) {
    // continue until done statement

  }
  else if (strcmp(s, "UNTIL", 5)) {
    // continue until done statement

  }

  return comm;
}

command_stream_t
make_command_stream (int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  command_stream_t *head = NULL;
  command_stream_t *prev = NULL;
  command_stream_t *cur  = NULL;

  while (1) {
    command_stream_t *cmd_stream_node = NULL;
    command_t command = make_command_stream_util(get_next_byte,
						 get_next_byte_argument);
    if (command) {
      cur = AllocateCommandStream();
      cur->command = command;
      if (head) {
	prev->next = cur;
	prev = cur;
      } else { // This is the first node
	head = prev = cur;
      }
    } else {
      break;
    }
  }

  return cmd_stream_node;
}

command_t
read_command_stream (command_stream_t **s)
{
  command_t *command;

  if (!s || !*s) {
    return NULL;
  }

  command = (*s)->command;

  *s = (*s)->next;

  // Free *s

  return command;
}
