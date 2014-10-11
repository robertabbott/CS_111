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
#include "alloc.h"

#include <string.h>
#include <error.h>
#include <stdio.h>
#define BUF_SIZE 256

typedef enum TOKENTYPE TOKENTYPE;

enum TOKENTYPE {
  NOT_DEFINED,
  SEMICOLON,
  PIPE,
  SPACE,
  NEWLINE,
  ALPHANUM,
};

static const char *string[] = {"NOT_DEFINED", "SEMICOLON", "PIPE", "SPACE",
			       "NEWLINE", "ALPHANUM"};

TOKENTYPE getTokenType(char c)
{
  TOKENTYPE type = NOT_DEFINED;

  switch (c) {
  case ';':
    type = SEMICOLON;
    break;
  case ' ':
    type = SPACE;
    break;
  case '|':
    type = PIPE;
    break;
  case '\n':
    type = NEWLINE;
    break;
    //  case '(':
  default:
    type = ALPHANUM;
    break;
  }
  return type;
}

void ignoreWhiteSpace(int (*get_next_byte) (void *),
		      void *get_next_byte_argument)
{
  char c;

  while ((c = get_next_byte(get_next_byte_argument)) != EOF &&
	 (c == ' ' || c == '\n')) {
    ;
  }
  if (c != EOF) {
    fseek(get_next_byte_argument, -1, SEEK_CUR);
  }
}

int
readNextToken(char **t, int *tlen, int (*get_next_byte) (void *),
              void *get_next_byte_argument)
{
  char c;
  char *token;
  int len = 0;
  int maxLen = BUF_SIZE;
  TOKENTYPE type = NOT_DEFINED;

  if (*tlen) {
    len = strlen(*t);
    token = *t;
    maxLen = *tlen;
  } else {
    token = malloc(BUF_SIZE);
    len = 0;
    maxLen = BUF_SIZE;
  }

  ignoreWhiteSpace(get_next_byte, get_next_byte_argument);

  while ((c = get_next_byte(get_next_byte_argument)) != EOF) {
    type = getTokenType(c);
    if (type == ALPHANUM) {
      token[len++] = c;
      if (len + 1 == maxLen) {
	maxLen *= 2;
	token = realloc(token, maxLen);
      }
    } else if (type == SPACE) {
      while ((c = get_next_byte(get_next_byte_argument)) != EOF && c == ' ') {
	;
      }
      if (getTokenType(c) == ALPHANUM) {
	fseek(get_next_byte_argument, -1, SEEK_CUR);
      } else {
	type = getTokenType(c);
      }
      break;
    } else {
      break;
    }
  }

  if (len == 0) {
    *t = NULL;
    free(token);
  } else {
    token[len] = '\0';
    *t = token;
    *tlen = maxLen;
  }
  return type;
}

command_stream_t
AllocateCommandStream()
{
  command_stream_t node = NULL;

  node = checked_malloc(sizeof(struct command_stream));
  node->command = NULL;
  node->next = NULL;

  return node;
}

command_t
AllocateCommand()
{
  command_t command = NULL;

  command = checked_malloc(sizeof(struct command));
  memset(command, 0, sizeof(struct command));
  return command;
}

/*
command_t
parse_pipeline_command (char *get_char, File *fp, char *s) {
  // parse into A | B format
  int arg1_index;
  commant_t pipe_comm;

  command_t pipe_comm;
  pipe_comm->type = PIPE_COMMAND;

  arg1_index = strstr(s, "|");
  strncpy (pipe_comm->command[0], s, arg1_index-1);
  s = ReadNextToken ();

  if (strstr (s, "|") != NULL) {
    pipe_comm->command[1] = parse_pipeline_command (get_char, fp, s);
  }
  else if (strstr (s, "(") != NULL) {
    pipe_comm->command[1] = parse_subshell_command (get_char, fp, s);
  }
  else {
    pipe_comm->command[1] = s;
  }

  return pipe_comm;
}

command_t
parse_subshell_command (char *get_char, File *fp, char *s) {
  command_t subshell_command;
  subshell_command->command[0] = make_command_stream_util (get_char, fp);
  s = ReadNextToken ();

  if (strstr(s, ")") == NULL) {
    // error
  }
  else {
    return subshell_command;
  }
}

command_t
make_simple_command (char *s) {
  command_t c;
  c->type = SIMPLE_COMMAND;
  c->word = s;

  return c;
}
*/

command_t
make_command_stream_util(int (*get_next_byte) (void *),
			 void *get_next_byte_argument)
{
  char *s;
  char *nextToken;
  int len = 0;
  TOKENTYPE type;
  command_t command;

  type = readNextToken(&s, &len, get_next_byte, get_next_byte_argument);
  if (!s) {
    return NULL;
  }
  command = AllocateCommand();
  if (!command) {
    return NULL;
  }

  /*
  if (strstr (s, "|") != NULL) {
    // PIPE_COMMAND should call util again
    if (comm->command[0] == NULL) {
      comm->command[0] = parse_pipeline_command (get_char, fp, s);
    }
    else if (comm->command[1] == NULL) {
      comm->command[1] = parse_pipeline_command (get_char, fp, s);
    }
    else {
      comm->command[2] = parse_pipeline_command (get_char, fp, s);
    }
  }

  else if (strstr (s, "(") != NULL) {
    // create subshell
    return parse_subshell_command (get_char, fp, s);
  }

  else if (strcmp(s, "IF", 2)) {
  */
  if (!strncmp(s, "if", 2)) {
    // continue until fi statement
    /*    nextToken = ReadNextToken ();

    while (!strcmp(nextToken, "THEN", 2)) {
      s = strcat (s, nextToken);
      // if pipe command call parse_pipe
      if (strstr (s, "|") != NULL) {
        comm->command[0] = parse_pipeline_command (get_char, fp, nextToken);
      }
      else if (strstr (s, "(") != NULL) {
        // create sub-shell command
        comm->command[0] = parse_subshell_command (get_char, fp, nextToken);
      }

      nextToken = ReadNextToken ();
    }

    if (comm->command[0] == NULL) {
      comm->command[0] = make_simple_command(s);
    }

    // first token after "THEN"
    nextToken = ReadNextToken ();
    s = NULL;

    while (!strcmp(nextToken, "FI", 2) && !strcmp(nextToken, "ELSE", 4)) {
      s = strcat (s, nextToken);
      // if pipe command, call parse_pipe
      if (strstr (s, "|") != NULL) {
        comm->command[1] = parse_pipeline_command (get_char, fp, nextToken);
      }
      else if (strstr (s, "(") != NULL) {
        // create sub-shell command
        comm->command[1] = parse_subshell_command (get_char, fp, nextToken);
      }

      nextToken = ReadNextToken ();
    }

    if (comm->command[1] == NULL) {
      comm->command[1] = make_simple_command(s);
    }

    if (strcmp(nextToken, "ELSE", 4)) {
      nextToken = ReadNextToken ();
      s = NULL;
      while (!strcmp(nextToken, "FI", 2)) {
        s = strcat (s, nextToken);
        // if pipe command, call parse_pipe
        if (strstr (s, "|") != NULL) {
          comm->command[2] = parse_pipeline_command (get_char, fp, nextToken);
        }
        else if (strstr (s, "(") != NULL) {
          // create sub-shell command
          comm->command[2] = parse_subshell_command (get_char, fp, nextToken);
        }

        nextToken = ReadNextToken ();
      }

      if (comm->command[2] != NULL) {
        comm->command[2] = make_simple_command (s);
      }
    }

    return comm;
    */
  } else if (!strncmp(s, "while", 5)) {
    // continue until done statement

  } else if (!strncmp(s, "until", 5)) {
    // continue until done statement
  } else {
    // SIMPLE_COMMAND
    
  }

  return command;
}


command_stream_t
make_command_stream (int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  command_stream_t head = NULL;
  command_stream_t prev = NULL;
  command_stream_t cur  = NULL;

  while (1) {
    command_t command = NULL; //make_command_stream_util(get_next_byte,
    //		 get_next_byte_argument);
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

  return head;
}

command_t
read_command_stream (command_stream_t *s)
{
  command_t command;
  command_stream_t cur  = NULL;

  if (!s || !*s) {
    return NULL;
  }

  cur = *s;

  command = cur->command;

  *s = cur->next;

  // Free *s

  return command;
}
