#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

struct args {
    int argc;
    char **argv;
};

enum subcom {
    ALL, NEG, ADD, MUL, SUM, PRD, PWR, LBD, RPT, MAX, AVG, CSV, RNG, GEN
};

int get_subcmd(int argc, char *cname, enum subcom *out_cmd)
{
    if (!strcmp(cname, "neg")) {
        *out_cmd = NEG;
        return argc == 2;
    } else if (!strcmp(cname, "add")) {
        *out_cmd = ADD;
        return argc == 3;
    } else if (!strcmp(cname, "mul")) {
        *out_cmd = MUL;
        return argc == 3;
    } else if (!strcmp(cname, "sum")) {
        *out_cmd = SUM;
        return argc == 2;
    } else if (!strcmp(cname, "prd")) {
        *out_cmd = PRD;
        return argc == 2;
    } else if (!strcmp(cname, "pwr")) {
        *out_cmd = PWR;
        return argc == 3;
    } else if (!strcmp(cname, "lbd")) {
        *out_cmd = LBD;
        return argc == 3;
    } else if (!strcmp(cname, "rpt")) {
        *out_cmd = RPT;
        return argc == 3;
    } else if (!strcmp(cname, "max")) {
        *out_cmd = MAX;
        return argc == 2;
    } else if (!strcmp(cname, "avg")) {
        *out_cmd = AVG;
        return argc == 2;
    } else if (!strcmp(cname, "csv")) {
        *out_cmd = CSV;
        return argc == 3;
    } else if (!strcmp(cname, "rng")) {
        *out_cmd = RNG;
        return argc == 4;
    } else if (!strcmp(cname, "gen")) {
        *out_cmd = GEN;
        return argc > 2;
    }
    *out_cmd = ALL;
    return 0;
}

void usage(char *exec, enum subcom cmd)
{
    switch (cmd) {
        case ALL:
            fprintf(stderr, "Usage: %s [subcommand] [args...]\n", exec);
            fprintf(stderr, "Valid subcommands:\n");
            fprintf(stderr, "neg\nadd [n]\nmul [n]\nsum\nprd\npwr [n]\n");
            fprintf(stderr, "lbd [n]\nrpt [n]\nmax\navg\ncsv [n]\n");
            fprintf(stderr, "rng [n1] [n2]\ngen [n1] [n2] ...\n");
            break;
        case NEG:
            fprintf(stderr, "Usage: %s neg\n", exec);
            fprintf(stderr, "\tnegates all numbers.\n");
            break;
        default:
            break;
    }
}

void destroy_trailing_newline(char *line)
{
    while (line) {
        if (*line == '\n') {
            *line = '\0';
            return;
        }
        line++;
    }
}

int numstring(char *line) {
    
    if(line[0] != '-' && !isdigit(line[0]))
        return 0;
    
    int len = strlen(line);
    for (int i = 1; i < len; i++) {
        if(!isdigit(line[i]) && line[i] != ',') {
            return 0;
        }
    }
    return 1;
}

void num_transform(int (*f)(int, struct args*), struct args *args)
{
    char line[64];
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            int m = atoi(line);
            printf("%d\n", f(m, args));
        }
    }
}

int neg(int n, struct args *args) {
    return -n;
}

int add(int n, struct args *args)
{
    int m = atoi(args->argv[2]);
    return n + m;
}

int mul(int n, struct args *args)
{
    int m = atoi(args->argv[2]); 
    return n * m;
}

int pwr(int n, struct args *args)
{
    int p = atoi(args->argv[2]);
    return (int)pow(n, p);
}

void sum(void)
{
    char line[64];
    int total = 0;
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            total += atoi(line);
        }
    }
    printf("%d\n", total);
}

void prd(void)
{
    char line[64];
    int total = 1;
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            total *= atoi(line);
        }
    }
    printf("%d\n", total);

}

void lbd(int bound)
{
    char line[64];
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            int m = atoi(line);
            if (m > bound)
                printf("%d\n", m);
        }
    }
}

void rpt(int repeats)
{
    char line[64];
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            int m = atoi(line);
            for (int i = 0; i < repeats; i++)
                printf("%d\n", m);
        }
    }
}

void max_num(void)
{
    int count = 0;
    int big;
    char line[64];
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            int m = atoi(line);
            if (!count || m > big)
                big = m;
            count++;
        }
    }
    if (count)
        printf("%d\n", big);
}

void avg(void)
{
    long long total = 0;
    int count = 0;
    char line[64];
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            int m = atoi(line);
            total += m;
            count++;
        }
    }
    if (count)
        printf("%lld\n", total / count);
}

void rng(int low, int high)
{
    for (int i = low; i <= high; i++)
        printf("%d\n", i);
}

/* Count all instances of c in the given string str. */
int count_char(char c, char *str)
{
    int count = 0;
    int len = strlen(str);
    for (int i = 0; i < len; i++) {
        count += str[i] == c ? 1 : 0;
    }
    return count;
}

char **split_at(char sep, char *string, unsigned int *len)
// consume a string, split the string at every "sep"
// the result is an array of strings, with len pointing to its length
// len is an "out parameter"
{
    char *mstr = strdup(string); //strdup the input to modify in place
    int num_tokens = count_char(sep, mstr) + 1; // how many ptrs we expect
    char **ptrs = (char **)calloc(num_tokens, sizeof(char *));

    int orig_len = strlen(mstr);

    /* Replace all instances of sep with NUL */
    for (int i = 0; i < orig_len; i++) {
        if (mstr[i] == sep) {
            mstr[i] = '\0';
        }
    }

    /* Fill the ptrs array with */
    for (int i = 0; i < num_tokens; i++) {
        ptrs[i] = mstr;
        mstr+= strlen(mstr)+1;
    }
    
    *len = num_tokens;
    return ptrs;
}

void csv(int index)
{
    char line[64];
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            unsigned int num_ptrs;
            char **vals = split_at(',', line, &num_ptrs);
            if (num_ptrs > index) {
                printf("%d\n", atoi(vals[index]));
            }
            for (int i = 0; i < num_ptrs; i++)
                free(vals[i]);
            free(vals);
        }
    }
}

void gen(int argc, char *argv[])
{
    char line[64];
    while (fgets(line, 64, stdin)) {
        destroy_trailing_newline(line); 
        if (numstring(line)) {
            int m = atoi(line);
            printf("%d\n", m);
        }
    }
    for (int i = 2; i < argc; i++)
        printf("%d\n", atoi(argv[i]));
}


int main (int argc, char *argv[])
{
    if (argc < 2) {
        usage(argv[0], ALL);
        exit(0);
    }

    enum subcom cmd;
    if (!get_subcmd(argc, argv[1], &cmd)) {
        usage(argv[0], cmd);
        exit(0);
    }

    struct args args;
    args.argc = argc;
    args.argv = argv;

    switch (cmd) {
        case NEG:
            num_transform(neg, NULL);
            break;
        case ADD:
            num_transform(add, &args);
            break;
        case MUL:
            num_transform(mul, &args);
            break;
        case SUM:
            sum();
            break;
        case PRD:
            prd();
            break;
        case PWR:
            num_transform(pwr, &args);
            break;
        case LBD:
            lbd(atoi(argv[2]));
            break;
        case RPT:
            rpt(atoi(argv[2]));
            break;
        case MAX:
            max_num();
            break;
        case AVG:
            avg();
            break;
        case CSV:
            csv(atoi(argv[2]));
            break;
        case RNG:
            rng(atoi(argv[2]), atoi(argv[3]));
            break;
        case GEN:
            gen(argc, argv);
            break;
        default:
            fprintf(stderr, "this shouldn't happen\n");
            break;
    }
    return 0;
}
