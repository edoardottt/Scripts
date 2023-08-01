# cd github; .\pull-rebase-all.ps1

$dirs = Get-ChildItem -Directory | select Name

foreach ($dir in $dirs)
{
  $dirok = $dir | foreach { $_.Name }
  cd $dirok
  echo $dirok
  git config pull.rebase false
  cd ..
  echo "============="
}
