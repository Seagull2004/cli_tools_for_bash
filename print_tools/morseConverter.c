#include <stdio.h>
#include <string.h>
#define MAX_DIGIT_LEN 6 // la lunghezza massima che può avere un carattere scritta in codice morse
char convertCharacterFromMorseToAlphanumeric(char* morseChar);
char* convertCharacterToMorse(char character);
void printMorseToAlphanumeric(char* morseString);
void printAlphanumericToMorse(char** argv, int argc);
void resetString(char* str, int len);
void printfUsage();

int main(int argc, char *argv[]) {
    // controllo degli input
    if (argc > 1 && strcmp(argv[1], "--help") == 0) {
        printfUsage(); 
        return 0;
    }
    if (argc < 3) {
        printf("error: this program require 2 or more parameter \n");
        printf("If you don't know how the program work type: morseConverter --help\n");
        return 1;
    }
    if (strcmp(argv[1], "-ma") && strcmp(argv[1], "-am")) {
        printf("error: bad option (you can only use -ma or -am)\n");
        printf("If you don't know how the program work type run: morseConverter --help\n");
        return 1;
    }
    // esecuzione traduzione
    if (strcmp(argv[1], "-ma") == 0) {
        if (argv[2][strlen(argv[2]) - 1] == '/' && argv[2][strlen(argv[2]) - 2] == '/') {
            printMorseToAlphanumeric(argv[2]);
            printf("\n");
        } else {
            printf("error: the text to convert shoule end with a '//'\n");
            printf("If you don't know how the program work type run: morseConverter --help\n");
        }
    } else if (strcmp(argv[1], "-am") == 0) {
        printAlphanumericToMorse(argv, argc);
        printf("\n");
    }
    return 0;
}

void printAlphanumericToMorse(char** argv, int argc) {
    for (int i = 2; i < argc; i++) {
        char* word = argv[i];
        for (int j = 0; j < strlen(word); j++) {
            if (word[j] == ' ') {
                printf("/");
                continue;
            }
            printf("%s/", convertCharacterToMorse(word[j]));
        }
        printf("/");
    }
}

void resetString(char* str, int len) {
    for (int i = 0; i < len; i++) {
        str[i] = 0;
    }
}

void printMorseToAlphanumeric(char* morseString) {
    char buffer[MAX_DIGIT_LEN] = ""; 
    int bufferCount = 0;
    for (int i = 0; i < strlen(morseString); i++) {
        if (morseString[i] == '/') {
            printf("%c", convertCharacterFromMorseToAlphanumeric(buffer));
            resetString(buffer, bufferCount);
            bufferCount = 0;
            if (morseString[i + 1] == '/') {
                printf(" ");
                i++;
            }
            continue;
        }
        buffer[strlen(buffer)] = morseString[i];
        bufferCount++;
    }
}

char convertCharacterFromMorseToAlphanumeric(char* morseChar) {
    switch (strlen(morseChar)) {
        case 1:
            if (strcmp(morseChar, "-") == 0) {
                return 'T';
            } else if (strcmp(morseChar, ".") == 0) {
                return 'E';
            }
            break;
        case 2:
            if (strcmp(morseChar, ".-") == 0) {
                return 'A';
            } else if (strcmp(morseChar, "-.") == 0) {
                return 'N';
            } else if (strcmp(morseChar, "--") == 0) {
                return 'M';
            } else if (strcmp(morseChar, "..") == 0) {
                return 'I';
            }
            break;
        case 3:
            if (strcmp(morseChar, "---") == 0) {
                return 'O';
            } else if (strcmp(morseChar, "--.") == 0) {
                return 'G';
            } else if (strcmp(morseChar, "-.-") == 0) {
                return 'K';
            } else if (strcmp(morseChar, "-..") == 0) {
                return 'D';
            } else if (strcmp(morseChar, ".--") == 0) {
                return 'W';
            } else if (strcmp(morseChar, ".-.") == 0) {
                return 'R';
            } else if (strcmp(morseChar, "..-") == 0) {
                return 'U';
            } else if (strcmp(morseChar, "...") == 0) {
                return 'S';
            }
            break;
        case 4:
            if (strcmp(morseChar, "--.-") == 0) {
                return 'Q';
            } else if (strcmp(morseChar, "--..") == 0) {
                return 'Z';
            } else if (strcmp(morseChar, "-.--") == 0) {
                return 'Y';
            } else if (strcmp(morseChar, "-.-.") == 0) {
                return 'C';
            } else if (strcmp(morseChar, "-..-") == 0) {
                return 'X';
            } else if (strcmp(morseChar, "-...") == 0) {
                return 'B';
            } else if (strcmp(morseChar, ".---") == 0) {
                return 'J';
            } else if (strcmp(morseChar, ".--.") == 0) {
                return 'P';
            } else if (strcmp(morseChar, ".-..") == 0) {
                return 'L';
            } else if (strcmp(morseChar, "..-.") == 0) {
                return 'F';
            } else if (strcmp(morseChar, "...-") == 0) {
                return 'V';
            } else if (strcmp(morseChar, "....") == 0) {
                return 'H';
            }
            break;
        case 5:
            if (strcmp(morseChar, "-----") == 0) {
                return '0';
            } else if (strcmp(morseChar, ".----") == 0) {
                return '1';
            } else if (strcmp(morseChar, "..---") == 0) {
                return '2';
            } else if (strcmp(morseChar, "...--") == 0) {
                return '3';
            } else if (strcmp(morseChar, "....-") == 0) {
                return '4';
            } else if (strcmp(morseChar, ".....") == 0) {
                return '5';
            } else if (strcmp(morseChar, "----.") == 0) {
                return '6';
            } else if (strcmp(morseChar, "---..") == 0) {
                return '7';
            } else if (strcmp(morseChar, "--...") == 0) {
                return '8';
            } else if (strcmp(morseChar, "-....") == 0) {
                return '9';
            } else if (strcmp(morseChar, "-..-.") == 0) {
                return '/';
            }
            break;
        case 6:
            if (strcmp(morseChar, ".-.-.-") == 0) {
                return '.';
            } else if (strcmp(morseChar, "--..--") == 0) {
                return ',';
            } else if (strcmp(morseChar, "..--..") == 0) {
                return '?';
            }
            break;
    }
    //printf("Codifica '%s' non riconosciuta!\n", morseChar);
    return '#';
}

char* convertCharacterToMorse(char character) {
    switch (character) {
        case 'A': return ".-";
        case 'a': return ".-";
        case 'B': return "-...";
        case 'b': return "-...";
        case 'C': return "-.-.";
        case 'c': return "-.-.";
        case 'D': return "-..";
        case 'd': return "-..";
        case 'E': return ".";
        case 'e': return ".";
        case 'F': return "..-.";
        case 'f': return "..-.";
        case 'G': return "--.";
        case 'g': return "--.";
        case 'H': return "....";
        case 'h': return "....";
        case 'I': return "..";
        case 'i': return "..";
        case 'J': return ".---";
        case 'j': return ".---";
        case 'K': return "-.-";
        case 'k': return "-.-";
        case 'L': return ".-..";
        case 'l': return ".-..";
        case 'M': return "--";
        case 'm': return "--";
        case 'N': return "-.";
        case 'n': return "-.";
        case 'O': return "---";
        case 'o': return "---";
        case 'P': return ".--.";
        case 'p': return ".--.";
        case 'Q': return "--.-";
        case 'q': return "--.-";
        case 'R': return ".-.";
        case 'r': return ".-.";
        case 'S': return "...";
        case 's': return "...";
        case 'T': return "-";
        case 't': return "-";
        case 'U': return "..-";
        case 'u': return "..-";
        case 'V': return "...-";
        case 'v': return "...-";
        case 'W': return ".--";
        case 'w': return ".--";
        case 'X': return "-..-";
        case 'x': return "-..-";
        case 'Y': return "-.--";
        case 'y': return "-.--";
        case 'Z': return "--..";
        case 'z': return "--..";
        case '0': return "-----";
        case '1': return ".----";
        case '2': return "..---";
        case '3': return "...--";
        case '4': return "....-";
        case '5': return ".....";
        case '6': return "----.";
        case '7': return "---..";
        case '8': return "--...";
        case '9': return "-....";
        case '.': return ".-.-.-";
        case ',': return "--..--";
        case '?': return "..--..";
        case '/': return "-..-.";
    } 
    //printf("Carattere '%c' non codificato!\n", character);
    return "######";
}

void printfUsage() { 
    printf("===============================================================\n");
    printf("| Usage: morseConverter [OPTION] [TEXT TO CONVERT]             |\n");
    printf("|                                                              |\n");
    printf("|          ------------------------------------------          |\n");
    printf("|                                                              |\n");
    printf("| [OPTION]:                                                    |\n");
    printf("|  -am: convert from alphabetic (a) to morse (m)               |\n");
    printf("|  -ma: convert from morse (m) to alphabetic (a)               |\n");
    printf("|                                                              |\n");
    printf("|          ------------------------------------------          |\n");
    printf("|                                                              |\n");
    printf("| [TEXT TO CONVERT]:                                           |\n");
    printf("|  alpha -> morse                                              |\n");
    printf("|  If the converter is set from alphabetic to                  |\n");
    printf("|  morse you can type simply the text to convert.              |\n");
    printf("|  Just make sure that you are tiping existing                 |\n");
    printf("|  character in the morse alphabet.                            |\n");
    printf("|  You cane either write you text within \"\".                   |\n");
    printf("|                                                              |\n");
    printf("|  morse -> alpha                                              |\n");
    printf("|  The morse string should be as follow:                       |\n");
    printf("|  the only charcter should be: '/', '.', '-'.                 |\n");
    printf("|  Every letter should be separeted with a '/'.                |\n");
    printf("|  Every end word should be represent with '//'.               |\n");
    printf("|  The phrase should end with '//'.                            |\n");
    printf("|                                                              |\n");
    printf("|          ------------------------------------------          |\n");
    printf("|                                                              |\n");
    printf("|  [E.G.]                                                      |\n");
    printf("|   morseConverter -am ciao mondo                              |\n");
    printf("|   >>> -.-./../.-/---//--/---/-./-../---//                    |\n");
    printf("|                                                              |\n");
    printf("|   morseConverter -am \"ciao mondo\"                            |\n");
    printf("|   >>> -.-./../.-/---//--/---/-./-../---//                    |\n");
    printf("|                                                              |\n");
    printf("|   morseConverter -ma -.-./../.-/---//--/---/-./-../---//     |\n");
    printf("|   >>> CIAO MONDO                                             |\n");
    printf("|                                                              |\n");
    printf("================================================================\n");
}
