#include <stdio.h>
#include <string.h>
#include <inttypes.h>

#include <iostream>

using namespace std;

extern "C"
{
    int lvt_strcpy(const char* dest, const char* src, unsigned long long int len);
}

int main()
{
    string src, dst;
    unsigned long long int len;

    cout << "Input your string: ";
    getline(cin, src);

    __asm__(".intel_syntax noprefix     \n\t"
            "xor  rax, rax              \n\t"

            "cld                        \n\t"

            "xor  rcx, rcx              \n\t"
            "dec  rcx                   \n\t"

            "repne   scasb              \n\t"
            "not     rcx                \n\t"
            "dec     rcx                \n\t"
        :"=c"(len)
        :"D"(src.c_str())
        :"rax");

    cout << "Length of " << src << " is " << len << endl;

    dst.resize(src.length());
    lvt_strcpy(&dst[0], &src[0], 4);

    cout << "Source string: " << src << endl;
    cout << "Destination string: " << dst << endl;

    return 0;
}
