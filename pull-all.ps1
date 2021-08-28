# This script updates every git repository in a single folder.
# Working properly
# for example: cd github; .\pull-all.ps1

$dirs = Get-ChildItem -Directory | select Name

foreach ($dir in $dirs)
{
  $dirok = $dir | foreach { $_.Name }
  cd $dirok
  git pull
  cd ..
}