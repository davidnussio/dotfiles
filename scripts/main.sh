

case $1 in
  install)
    install
    ;;
  update)
    update
    ;;
  uninstall)
    uninstall
    ;;
  *)
    echo "Usage: $0 {install|update|uninstall}"
    exit 1
    ;;
esac
