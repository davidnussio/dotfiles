function sbr --description 'Avvia un\'app Spring Boot con Maven (profili, env, props)'
    # Separa gli argomenti extra per Maven (dopo --)
    set -l mvn_extra
    set -l idx (contains -i -- -- $argv)
    if test -n "$idx"
        set mvn_extra $argv[(math $idx + 1)..-1]
        set argv $argv[1..(math $idx - 1)]
    end

    argparse h/help 'e/env=+' 'p/prop=+' 'f/env-file=+' 'd/debug=?' 'm/module=' c/clean s/skip-tests n/dry-run -- $argv
    or return

    if set -q _flag_help
        echo "Uso: sbr [profili...] [opzioni] [-- argomenti maven]"
        echo
        echo "  profili              es. 'sbr dev' o 'sbr dev local' → dev,local"
        echo "  -e, --env K=V        variabile d'ambiente (ripetibile)"
        echo "  -f, --env-file FILE  carica variabili da file .env (ripetibile)"
        echo "  -p, --prop k=v       proprietà Spring, es. -p server.port=8081 (ripetibile)"
        echo "  -d, --debug[=PORTA]  abilita debugger JDWP (default 5005)"
        echo "  -m, --module MOD     modulo Maven da avviare (multi-module)"
        echo "  -c, --clean          esegue 'clean' prima dell'avvio"
        echo "  -s, --skip-tests     salta compilazione ed esecuzione dei test"
        echo "  -n, --dry-run        stampa il comando senza eseguirlo"
        echo
        echo "Esempi:"
        echo "  sbr dev"
        echo "  sbr dev -p server.port=8081 -e DB_PASSWORD=secret"
        echo "  sbr local -f .env.local -d"
        echo "  sbr dev -cs -d5006      # clean, no test, debug su 5006"
        echo "  sbr dev -- -o           # argomenti extra per Maven"
        return 0
    end

    # Maven wrapper se presente
    set -l mvn mvn
    test -x ./mvnw; and set mvn ./mvnw

    set -l mvn_args
    set -q _flag_module; and set -a mvn_args -pl $_flag_module
    set -q _flag_clean; and set -a mvn_args clean
    set -a mvn_args spring-boot:run
    set -q _flag_skip_tests; and set -a mvn_args -Dmaven.test.skip=true

    # Profili
    if test (count $argv) -gt 0
        set -a mvn_args -Dspring-boot.run.profiles=(string join , $argv)
    end

    # Proprietà Spring → argomenti dell'applicazione
    if set -q _flag_prop
        set -a mvn_args -Dspring-boot.run.arguments=(string join ' ' -- --$_flag_prop)
    end

    # Debugger remoto
    if set -q _flag_debug
        set -l port 5005
        test -n "$_flag_debug"; and set port $_flag_debug
        set -a mvn_args -Dspring-boot.run.jvmArguments=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=\*:$port
    end

    set -a mvn_args $mvn_extra

    # Variabili d'ambiente: prima i file, poi -e (che ha la precedenza)
    set -l envs
    for file in $_flag_env_file
        if not test -f $file
            echo "sbr: file non trovato: $file" >&2
            return 1
        end
        for line in (string match -rv '^\s*(#|$)' < $file)
            set line (string replace -r '^\s*export\s+' '' -- $line)
            string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' -- $line; or continue
            set -l kv (string split -m 1 = -- $line)
            set -a envs $kv[1]=(string trim -c '"\'' -- $kv[2])
        end
    end
    set -a envs $_flag_env

    if set -q _flag_dry_run
        echo env (string escape -- $envs) $mvn (string escape -- $mvn_args)
        return 0
    end

    env $envs $mvn $mvn_args
end
