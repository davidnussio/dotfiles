# Profili Spring presi da application-<profilo>.{yml,yaml,properties}
function __sbr_profiles
    for f in src/main/resources/application-*.{yml,yaml,properties} */src/main/resources/application-*.{yml,yaml,properties}
        string replace -r '.*/application-(.+)\.(yml|yaml|properties)$' '$1' -- $f
    end | sort -u
end

complete -c sbr -f
complete -c sbr -a '(__sbr_profiles)' -d 'Profilo Spring'
complete -c sbr -s h -l help -d 'Mostra aiuto'
complete -c sbr -s e -l env -x -d 'Variabile d\'ambiente K=V'
complete -c sbr -s f -l env-file -r -F -d 'File .env da caricare'
complete -c sbr -s p -l prop -x -d 'Proprietà Spring k=v'
complete -c sbr -s d -l debug -d 'Debugger JDWP (porta opzionale, default 5005)'
complete -c sbr -s m -l module -x -d 'Modulo Maven'
complete -c sbr -s c -l clean -d 'Esegui clean prima'
complete -c sbr -s s -l skip-tests -d 'Salta i test'
complete -c sbr -s n -l dry-run -d 'Stampa il comando senza eseguirlo'
