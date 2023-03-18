"Enter your name! (Press SPACEto confirm)\n";

#define MAX_LEN 32

I64 name[MAX_LEN];

U64 i=0;
I64 ascii = 0;
while (ascii != CH_SPACE &&i < MAX_LEN){
	ascii = GetKey();
	name[i++] = ascii;
	"%c",ascii;
}

"\nGreetings, ";
U64 j;

for (j=0; j<i; j++){
	"%c", name[j];
}
"!"