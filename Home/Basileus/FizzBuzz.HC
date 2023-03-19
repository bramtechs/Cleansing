#define MAX_COUNT 30

U64 c;
for (c=1; c <= MAX_COUNT; c++){
    if (c % 15 == 0){
        "FizzBuzz";
    }
    else if (c % 3 == 0){
        "Fizz";
    }
    else if (c % 5 == 0){
        "Buzz";
    }
    else {
        "%d", c;
    }
    "\n";
}
