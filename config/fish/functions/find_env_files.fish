function find_env_files
    find . \( -name "node_modules" -o -name "dist" -o -name "build" -o -name ".next" \) \
      -prune -o \( -name ".env" -o -name ".env.*" \) \
      ! -name ".env.example" \
      -print
end
