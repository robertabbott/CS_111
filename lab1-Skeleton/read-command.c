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
// #include <error.h>
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

typedef struct KeyWords {
  char *keyword;
  STATE state;
} KeyWords;

KeyWords keywords[] = {
  {"if", IF},
  {"then", THEN},
  {"else", ELSE},
  {"fi", FI},
  {"while", WHILE},
  {"do", DO},
  {"done", DONE},
  {"until", UNTIL},
  {"(", OPEN_PAR},
  {")", CLOSE_PAR},
  {NULL, INVALID},
};

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

void appendChar(char *s, char c)
{
  int len = strlen(s);

  s[len++] = c;
  s[len] = '\0';
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

command_t
makeSimpleCommand(command_t command, char **s)
{
  if (!command) {
    command = AllocateCommand();
  }

  command->type = SIMPLE_COMMAND;
  command->u.word = s;

  return command;
}

command_t
makeCommand(command_t command, char **tokenPTR, command_type type)
{
  if (!command) {
    command = AllocateCommand();
  }

  command->type = type;
  if (tokenPTR) {
    command->u.command[0] = makeSimpleCommand(NULL, tokenPTR);
  }

  return command;
}

command_t
convertToSimple(command_t command)
{
  command_t simpleCommand;

  if (!command) {
    return NULL;
  }
  simpleCommand = command->u.command[0];

  free(command);

  return simpleCommand;
}

int
strrcmp(char *s1, char *s2)
{
  int len1 = strlen(s1);
  int len2 = strlen(s2);

  while(len1 && len2 && s1[len1 - 1] == s2[len2 - 1]) {
    len1--;
    len2--;
  }
  if (len2) {
    return 1; // not equal
  } else {
    return 0; // equal
  }
}

int
isKeyWordUpdate(char *token, STATE *state)
{
  int flag = 0;
  int i = 0;

  while (keywords[i].keyword) {
    if (!strrcmp(token, keywords[i].keyword)) {
      token[strlen(token) - strlen(keywords[i].keyword)] = '\0';
      *state = keywords[i].state;
      flag = 1;
      break;
    }
  i++;
  }
  return flag;
}

void removeWhiteSpace(char *token)
{
  int len = strlen(token);
  while (token[len - 1] == ' ' ||
	 token[len - 1] == '\n') {
    len--;
  }
  token[len] = '\0';
}


command_t
makeCommandStreamUtil(int (*get_next_byte) (void *),
		      void *get_next_byte_argument,
		      STATE *state, int *CScount)
{
  char **tokenPTR = checked_malloc(sizeof(char**));
  char *token = NULL;
  char *nextToken;
  int len = 0;
  TOKENTYPE type;
  command_t command = NULL;

  type = readNextToken(tokenPTR, &len, get_next_byte, get_next_byte_argument);
  if (type == NOT_DEFINED) {
    free(tokenPTR);
    return NULL;
  }

  command = AllocateCommand();
  if (!command) {
    return NULL;
  }

  token = *tokenPTR;

  if (!strncmp(token, "then", 4)) {
    *state = THEN;
    goto ret_null;
  } else if (!strncmp(token, "done", 4)) {
    *state = DONE;
    (*CScount)--;
    goto ret_null;
  } else if (!strncmp(token, "do", 4)) {
    *state = DO;
    goto ret_null;
  } else if (!strncmp(token, "else", 4)) {
    *state = ELSE;
    goto ret_null;
  } else if (!strncmp(token, "fi", 4)) {
    (*CScount)--;
    *state = FI;
    goto ret_null;
  } else if (!strncmp(token, ")", 1)) {
    (*CScount) --;
    *state = CLOSE_PAR;
    goto ret_null;
  } else if (!strncmp(token, "if", 2)) {
    (*CScount)++;
    command = makeCommand(command, NULL, IF_COMMAND);
    free(tokenPTR);
    command->u.command[0] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state, CScount);
    while (*state != THEN) {
      makeCommandStreamUtil(get_next_byte,
			    get_next_byte_argument,
			    state, CScount);
    }
    command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state, CScount);
    if (*state != ELSE && *state != FI) {
      // HANDLE error;
      ;
    } else if (*state == ELSE || (*state == FI && *CScount)) {
	command->u.command[2] = makeCommandStreamUtil(get_next_byte,
						      get_next_byte_argument,
						      state, CScount);
    } else {
      command->u.command[2] = NULL;
    }
  } else if (!strncmp(token, "while", 5)) {
    (*CScount)++;
    command = makeCommand(command, NULL, WHILE_COMMAND);
    free(tokenPTR);
    command->u.command[0] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state, CScount);
    if (*state != DO) {
      // Handle Error
      ;
    }
    command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state, CScount);
    if (*state != DONE) {
      // HANDLE error;
      ;
    } else if (*state == DONE && *CScount) {
      command->u.command[2] = makeCommandStreamUtil(get_next_byte,
						    get_next_byte_argument,
						    state, CScount);
    } else {
      command->u.command[2] = NULL;
    }    
  } else if (!strncmp(token, "until", 5)) {
    (*CScount)++;
    command = makeCommand(command, NULL, UNTIL_COMMAND);
    free(tokenPTR);
    command->u.command[0] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state, CScount);
    if (*state != DO) {
      // Handle Error
      ;
    }
    command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state, CScount);
    if (*state != DONE) {
      // HANDLE error;
      ;
    } else if (*state == DONE && *CScount) {
      command->u.command[2] = makeCommandStreamUtil(get_next_byte,
						    get_next_byte_argument,
						    state, CScount);
    } else {
      command->u.command[2] = NULL;
    }    

  } else if (!strncmp(token, "(", 1)) {
    (*CScount)++;
    command = makeCommand(command, NULL, SUBSHELL_COMMAND);
    free(tokenPTR);
    command->u.command[0] =  makeCommandStreamUtil(get_next_byte,
              get_next_byte_argument,
              state, CScount);
    if (*state != CLOSE_PAR) {
      // Handle Error
    } else if (*state == CLOSE_PAR && *CScount) {
      command->u.command[0] = makeCommandStreamUtil(get_next_byte,
                get_next_byte_argument,
                state, CScount);
    }

  } else {
    // SIMPLE_COMMAND
    while (1) {
      STATE prevState = *state;
      if (isKeyWordUpdate(token, state) && (prevState == COMMAND)) {
         	removeWhiteSpace(token);
        	command = makeSimpleCommand(command, tokenPTR);
        	break;
      }
      if (type == SPACE) {
	appendChar(token, ' ');
	type = readNextToken(tokenPTR, &len, get_next_byte, get_next_byte_argument);
      } else if (type == NEWLINE && !(*CScount)) {
      	command = makeSimpleCommand(command, tokenPTR);
      	break;
      } else if (type == PIPE || type == SEMICOLON || type == NEWLINE) {
	command = makeCommand(command, tokenPTR, 
			      type == PIPE ? PIPE_COMMAND : SEQUENCE_COMMAND);
	command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						      get_next_byte_argument,
						      state, CScount);
	if (!command->u.command[1]) {
	  command = convertToSimple(command);
	}
	break;
      }
      *state = COMMAND;
    }
  }

  return command;
ret_null:
  free(command);
  free(tokenPTR);
  return NULL;
}


command_stream_t
make_command_stream (int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  command_stream_t head = NULL;
  command_stream_t prev = NULL;
  command_stream_t cur  = NULL;
  STATE state;
  int CScount = 0; // Control Statement count

  while (1) {
    state = INVALID;
    CScount = 0;
    command_t command = makeCommandStreamUtil(get_next_byte,
					      get_next_byte_argument,
					      &state, &CScount);
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
