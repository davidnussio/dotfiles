function git-tag-version --wraps git --description 'git-tag-version'
  set -l git_tag_version (git-last-version)
  set -l tag_version (git-increment-version $git_tag_version $argv[1])

  if test (string sub -l 1 "$tag_version") != "v"
    echo "Usage: git-version [<patch | minor | major> for semver]"
    echo "Error tagging version: $tag_version"
    return 1
  end

  echo "- Current version: $git_tag_version"
  echo "- New version:     $tag_version"
  git tag -a $tag_version -m "Version $tag_version"
end
