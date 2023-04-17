function git-increment-version --description 'alias git-version=git describe --tags --abbrev=0 | cut -d. -f1,2,3'
  set -l git_tag_version $argv[1]
  set -l tag_version (string split '.' (string sub -s 2 $git_tag_version))

  if test (count $tag_version) -ne 3
    set tag_version (math $tag_version + 1)
    echo "v$tag_version"
    return 1
  end

  set -l tag_major $tag_version[1]
  set -l tag_minor $tag_version[2]
  set -l tag_patch $tag_version[3]

  if test "$argv[2]" = "patch"
    set tag_patch (math $tag_patch + 1)
  else if test "$argv[2]" = "minor"
    set tag_minor (math $tag_minor + 1)
    set tag_patch 0
  else if test "$argv[2]" = "major"
    set tag_major (math $tag_major + 1)
    set tag_minor 0
    set tag_patch 0
  else
    echo $git_tag_version
    return 1
  end

  echo "v$tag_major.$tag_minor.$tag_patch"
end
