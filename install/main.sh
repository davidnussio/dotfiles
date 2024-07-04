

case $1 in
  install)
    echo
    echo "📦 Install $PACKAGE_NAME"
    install
    ;;
  update)
    echo "🌀 Updating $PACKAGE_NAME"
    update
    ;;
  uninstall)
    echo "🚮 Uninstalling $PACKAGE_NAME"
    uninstall
    ;;
  *)
    echo "Usage: $0 {install|update|uninstall}"
    exit 1
    ;;
esac
