

CC  = gcc -g

OBJ = database.o contace.o main.o network.o
OBJ_H = database.h contace.h network.h eTalk.h


main: $(OBJ) $(OBJ_H)
	$(CC) $(OBJ) -o server -lsqlite3
	
cc:cline.o
	gcc cline.o -o cc
	
clean:
	rm -rf $(OBJ)
	
db :
	rm -rf eTalk.db
	
	
