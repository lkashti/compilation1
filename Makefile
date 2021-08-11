all:
	flex mylex.l
	gcc	-o mylex.exe lex.yy.c
run:
	./mylex.exe mytext.txt
clean:
	rm -f mylex.exe lex.yy.c