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
  REDIRECTION1,
  REDIRECTION2,
  O_PAR,
  C_PAR
};

int lineNumber = 0;
int CScount;
int backquote;

/* static const char *string[] = {"NOT_DEFINED", "SEMICOLON", "PIPE", "SPACE", */
/* 			       "NEWLINE", "ALPHANUM"}; */

typedef struct KeyWords {
  char *keyword;
  STATE state;
  int CSContribution;
} KeyWords;

KeyWords keywords[] = {
  {"if", IF, 1},
  {"then", THEN, 0},
  {"else", ELSE, 0},
  {"fi", FI, -1},
  {"while", WHILE, 1},
  {"do", DO, 0},
  {"done", DONE, -1},
  {"until", UNTIL, 1},
  {"(", OPEN_PAR, 1},
  {")", CLOSE_PAR, -1},
  {NULL, INVALID, 0},
};

void printErr()
{
  fprintf (stderr, "Syntax err at line %d\n", lineNumber);
  exit(-1);
}

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
  case '(':
    type = O_PAR;
    break;
  case '>':
    type = REDIRECTION2;
    break;
  case '<':
    type = REDIRECTION1;
    break;
  case ')':
    type = C_PAR;
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

int
_rewind(void *get_next_byte_argument, int offset)
{
  return fseek(get_next_byte_argument, offset, SEEK_CUR);
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
    _rewind(get_next_byte_argument, -1);
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
      if (c == '`') {
	backquote = !backquote;
      }
      token[len++] = c;
      if (len + 1 == maxLen) {
      	maxLen *= 2;
      	token = realloc(token, maxLen);
      }
    } else if (type == SPACE) {
      int val;
      while ((c = get_next_byte(get_next_byte_argument)) != EOF && c == ' ') {
	;
      }
      val = getTokenType(c);
      if (val == ALPHANUM || val == O_PAR || val == PIPE) {
	_rewind(get_next_byte_argument, -1);
      } else if (val == REDIRECTION1 || val == REDIRECTION2) {
	_rewind(get_next_byte_argument, -1);
	type = val;
      } else {
	type = val;
      }
      break;
    } else if (type == O_PAR) {
        *t = token;
        *tlen += 1;
        return type;
    } else if (type == REDIRECTION1 || type == REDIRECTION2) {
      _rewind(get_next_byte_argument, -1);
      break;
    } else {
      break;
    }
  }
  /* if (len == 0) { */
  /*   *t = NULL; */
  /*   free(token); */
  /* } else { */
    token[len] = '\0';
    *t = token;
    *tlen = maxLen;
    //  }
  return type;
}


int
fillRedirectionOperands(char **input, char **output,
			int (*get_next_byte) (void *),
			void *get_next_byte_argument)
{
  int len = 0;
  TOKENTYPE type = 0;

  while (1) {
    len = 0;
    type = getTokenType(get_next_byte(get_next_byte_argument));
    switch (type) {
    case REDIRECTION1:
      type = readNextToken(input, &len, get_next_byte,
			   get_next_byte_argument);
      if (!(*input) || !strlen(*input)) {
	goto err;
      }
      break;
    case REDIRECTION2:
      type = readNextToken(output, &len, get_next_byte,
			   get_next_byte_argument);
      if (!(*output) || !strlen(*output)) {
	goto err;
      }
      break;
    default:
      _rewind(get_next_byte_argument, -1);
      goto out;
    }
    if (type == REDIRECTION2 || type == REDIRECTION1) {
      continue;
    } else {
      break;
    }
  }
 out:
  return type;
 err:
  printErr();
  return -1;
}

int
checkRedirection(int (*get_next_byte) (void *),
		 void *get_next_byte_argument)
{
  char c;
  int flag = 0;

  while ((c = get_next_byte(get_next_byte_argument)) != EOF && c == ' ') {
    ;
  }
  switch (getTokenType(c)) {
  case REDIRECTION1:
  case REDIRECTION2:
    flag = 1;
    break;
  default:
    flag = 0;
    break;
  }
  _rewind(get_next_byte_argument, -1);

  return flag;
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
makeBaseCommand(command_t command, char *input, char *output)
{
  if (!command) {
    command = AllocateCommand();
  }

  command->input = input;
  command->output = output;

  return command;
}

command_t
makeSimpleCommand(command_t command, char **s, char *input, char *output)
{
  command = makeBaseCommand(command, input, output);

  command->type = SIMPLE_COMMAND;
  command->u.word = s;

  return command;
}

command_t
makeCommand(command_t command, char **tokenPTR, command_type type,
	    char *input, char *output)
{
  command = makeBaseCommand(command, NULL, NULL);

  command->type = type;
  if (tokenPTR) {
    command->u.command[0] = makeSimpleCommand(NULL, tokenPTR, input, output);
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
      CScount += keywords[i].CSContribution;
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
		      STATE *state)
{
  char **tokenPTR = checked_malloc(sizeof(char**));
  char *token = NULL;
  int len = 0;
  TOKENTYPE type;
  command_t command = NULL;
  char *input = NULL, *output = NULL;

  type = readNextToken(tokenPTR, &len, get_next_byte, get_next_byte_argument);
  if (type == NOT_DEFINED) {
    free(tokenPTR);
    return NULL;
  } else if (type == O_PAR) {
    token = "(";
  } else {
    token = *tokenPTR;
  }

  command = AllocateCommand();
  if (!command) {
    return NULL;
  }


  if (!strncmp(token, "then", 4)) {
    *state = THEN;
    goto ret_null;
  } else if (!strncmp(token, "done", 4)) {
    *state = DONE;
    CScount--;
    goto ret_null;
  } else if (!strncmp(token, "do", 4)) {
    *state = DO;
    goto ret_null;
  } else if (!strncmp(token, "else", 4)) {
    *state = ELSE;
    goto ret_null;
  } else if (!strncmp(token, "fi", 4)) {
    CScount--;
    *state = FI;
    goto ret_null;
  } else if (!strncmp(token, ")", 1)) {
    CScount--;
    *state = CLOSE_PAR;
    goto ret_null;
  } else if (!strncmp(token, "if", 2)) {
    CScount++;
    command = makeCommand(command, NULL, IF_COMMAND, input, output);
    free(tokenPTR);
    command->u.command[0] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state);
    while (*state != THEN) {
      if (!makeCommandStreamUtil(get_next_byte,
				 get_next_byte_argument,
				 state)) {
	type = NOT_DEFINED;
	break;
      }
    }

    if (type == NOT_DEFINED && *state != THEN) {
      return NULL;
    }
    command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state);
    if (*state != ELSE && *state != FI) {
      // HANDLE error;
      ;
    } else if (*state == ELSE || (*state == FI && CScount)) {
	command->u.command[2] = makeCommandStreamUtil(get_next_byte,
						      get_next_byte_argument,
						      state);
    } else {
      command->u.command[2] = NULL;
    }
  } else if (!strncmp(token, "while", 5)) {
    (CScount)++;
    command = makeCommand(command, NULL, WHILE_COMMAND, input, output);
    free(tokenPTR);
    command->u.command[0] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state);
    if (*state != DO) {
      // Handle Error
      ;
    }
    command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state);
    if (*state != DONE) {
      // HANDLE error;
      ;
    } else if (*state == DONE) {
      if (checkRedirection(get_next_byte, get_next_byte_argument)) {
	fillRedirectionOperands(&command->input, &command->output,
				get_next_byte, get_next_byte_argument);
      }

      command->u.command[2] = makeCommandStreamUtil(get_next_byte,
      						    get_next_byte_argument,
      						    state);
      /* if (command->u.command[2]) { */
      /* 	command_t newCommand = makeCommand(NULL, NULL, SEQUENCE_COMMAND, */
      /* 					   NULL, NULL); */
      /* 	newCommand->u.command[0] = command->u.command[1]; */
      /* 	newCommand->u.command[1] = command->u.command[2]; */
      /* 	command->u.command[1] = newCommand; */
      /* 	command->u.command[2] = NULL; */
      /* } */

    } else {
      command->u.command[2] = NULL;
    }    
  } else if (!strncmp(token, "until", 5)) {
    (CScount)++;
    command = makeCommand(command, NULL, UNTIL_COMMAND, input, output);
    free(tokenPTR);
    command->u.command[0] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state);
    if (*state != DO) {
      // Handle Error
      ;
    }
    command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						  get_next_byte_argument,
						  state);
    if (*state != DONE) {
      // HANDLE error;
      ;
    } else if (*state == DONE) {
      if (checkRedirection(get_next_byte, get_next_byte_argument)) {
	fillRedirectionOperands(&command->input, &command->output,
				get_next_byte, get_next_byte_argument);
      }
      command->u.command[2] = makeCommandStreamUtil(get_next_byte,
      						    get_next_byte_argument,
      						    state);
      /* if (command->u.command[2]) { */
      /* 	command_t newCommand = makeCommand(NULL, NULL, SEQUENCE_COMMAND, */
      /* 					   NULL, NULL); */
      /* 	newCommand->u.command[0] = command->u.command[1]; */
      /* 	newCommand->u.command[1] = command->u.command[2]; */
      /* 	command->u.command[1] = newCommand; */
      /* 	command->u.command[2] = NULL; */
      /* } */
    } else {
      command->u.command[2] = NULL;
    }    

  } else if (!strncmp(token, "(", 1)) {
    CScount++;
    command = makeCommand(command, NULL, SUBSHELL_COMMAND, input, output);
    free(tokenPTR);
    command->u.command[0] =  makeCommandStreamUtil(get_next_byte,
              get_next_byte_argument,
              state);
    if (*state != CLOSE_PAR) {
      // Handle Error
    } else if (*state == CLOSE_PAR && CScount) {
      command->u.command[0] = makeCommandStreamUtil(get_next_byte,
                get_next_byte_argument,
                state);
    } 
  } else {
    // SIMPLE_COMMAND
    while (1) {
      STATE prevState = *state;
      if (isKeyWordUpdate(token, state) && (prevState == COMMAND)) {
         	removeWhiteSpace(token);
        	command = makeSimpleCommand(command, tokenPTR, input, output);
        	break;
      }
      if (type == REDIRECTION1 || type == REDIRECTION2) {
	type = fillRedirectionOperands(&input,
				       &output,
				       get_next_byte,
				       get_next_byte_argument);

	//	command = makeSimpleCommand(command, tokenPTR, input, output);
	//        break;
	//	type = readNextToken(tokenPTR, &len, get_next_byte, get_next_byte_argument);
      } else if (type == SPACE) {
	appendChar(token, ' ');
	type = readNextToken(tokenPTR, &len, get_next_byte, get_next_byte_argument);
      } else if (type == NEWLINE && !CScount) {
      	command = makeSimpleCommand(command, tokenPTR, input, output);
      	break;
      } else if (type == PIPE || type == SEMICOLON || type == NEWLINE) {
	removeWhiteSpace(token);
	command = makeCommand(command, tokenPTR, 
			      type == PIPE ? PIPE_COMMAND : SEQUENCE_COMMAND,
			      input, output);
	command->u.command[1] = makeCommandStreamUtil(get_next_byte,
						      get_next_byte_argument,
						      state);
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

  while (1) {
    state = INVALID;
    CScount = 0;
    lineNumber++;
    command_t command = makeCommandStreamUtil(get_next_byte,
					      get_next_byte_argument,
					      &state);
    if (command) {
      if (!CScount && !backquote) {
	cur = AllocateCommandStream();
	cur->command = command;
	if (head) {
	  prev->next = cur;
	  prev = cur;
	} else { // This is the first node
	  head = prev = cur;
	}
      } else {
	printErr();
      }
    } else if (CScount) {
      printErr();
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
