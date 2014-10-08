#include <EXTERN.h>
#include <perl.h>

static PerlInterpreter *my_perl;

#define DUMMY_ARGS 3
#define DUMMY_OPTS { "", "-e", "0"}

void init_perl()
{
    int argc = 1;
    char *dummyopts[DUMMY_ARGS] = DUMMY_OPTS;
    char *ary[1];
    char **argv = (char **) &ary;
    char **env = (char **) &ary;
    ary[0] = "perl";
    ary[1] = 0;
    PERL_SYS_INIT3(&argc,&argv,&env);
    my_perl = perl_alloc();
    perl_construct(my_perl);
    PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
    perl_parse(my_perl, NULL, DUMMY_ARGS, dummyopts, (char **)NULL);
    perl_run(my_perl);
}

const char * eval_perl(char *expr)
{
    SV *val = eval_pv(expr, TRUE);
    return SvPV_nolen(val);
}

int get_int_val(char *valname)
{
    return SvIV(get_sv(valname, 0));
}

char *get_string_val(char *valname)
{
    return SvPV_nolen(get_sv(valname, 0));
}

void free_perl()
{
    perl_destruct(my_perl);
    perl_free(my_perl);
    PERL_SYS_TERM();
}
