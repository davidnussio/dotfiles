function git-increment-version --description 'alias git-version=git describe --tags --abbrev=0 | cut -d. -f1,2,3'
  set -l git_tag_version $argv[1]
  set -l tag_version (string split '.' (string sub -s 2 $git_tag_version))

  if test (count $tag_version) -eq 1
    set tag_version (math $tag_version + 1)
    echo "v$tag_version"
    return 1
  end

  set -l tag_major $tag_version[1]
  set -l tag_minor $tag_version[2]
  set -l tag_patch $tag_version[3]
  set -l tag_rc_beta_alpha ""
  set -l tag_rc_beta_alpha_ver ""

  if test (count $tag_version) -gt 3
    set -l tmp (string split -r - $tag_patch)
    set tag_patch $tmp[1]
    set tag_rc_beta_alpha "-$tmp[2]."
    set tag_rc_beta_alpha_ver $tag_version[4]
  end


  if test "$argv[2]" = "patch"
    set tag_patch (math $tag_patch + 1)
  else if test "$argv[2]" = "minor"
    set tag_minor (math $tag_minor + 1)
    set tag_patch 0
  else if test "$argv[2]" = "major"
    set tag_major (math $tag_major + 1)
    set tag_minor 0
    set tag_patch 0
  else if test "$argv[2]" = "rc"; or test "$argv[2]" = "beta"; or test "$argv[2]" = "alpha"
    set tag_rc_beta_alpha_ver (math $tag_rc_beta_alpha_ver + 1)
  else
    echo $git_tag_version
    return 1
  end

  echo "v$tag_major.$tag_minor.$tag_patch$tag_rc_beta_alpha$tag_rc_beta_alpha_ver"
end
