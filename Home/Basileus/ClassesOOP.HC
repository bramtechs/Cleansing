// Your typical high-school OOP programming 'problem'.

class Animal {
    U8 name[64];
    U8 isMale;
    U8 age;
    U32 weightInKg;
};

class Lion:Animal {
    U8 isRoyalty;
};

U0 PrintAnimal(Animal* ani) {
    "\n\n==============================\n";
    "Name: %s\n", ani->name;
    if (ani->isMale){
        "Male\n";
    } else {
        "Female\n";
    }
    "Age: %d\n", ani->age;
    "Weight in Kg: %d\n", ani->weightInKg;
}

U0 PrintLion(Lion* lion){
    PrintAnimal(lion);
    if (lion->isRoyalty) {
        if (lion->isMale){
            "He is our king!\n";
        } else {
            "She is our queen!\n";
        }
    } else {
        "Not a member of the royal family...\n";
    }
}

// NOTE: Haven't watched Lion King,
// so this might be incorrect.

Lion l;
StrCpy(l.name, "Simba");
l.isMale = 1;
l.age = 18;
l.weightInKg = 90;
l.isRoyalty = 1;

PrintLion(&l);

Lion l2;
StrCpy(l2.name, "Nala");
l2.isMale = 0;
l2.age = 20;
l2.weightInKg = 70;
l2.isRoyalty = 1;

PrintLion(&l2);

Lion l3;
StrCpy(l3.name, "Scar");
l3.isMale = 1;
l3.age = 30;
l3.weightInKg = 120;
l3.isRoyalty = 0;

PrintLion(&l3);

"\n\n";
