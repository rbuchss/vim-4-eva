function! vim_4_eva#hub#BrowseFile() abort
  let l:branch = fugitive#head(7)
  if empty(l:branch)
    echo 'ERROR file not in a git repo'
  else
    let l:github_sub_url = 'blob/' . l:branch
    let l:repo_top = vim_4_eva#util#Chomp(system('git rev-parse --show-toplevel'))
    let l:file_path = expand('%:p')
    let l:line=line('.')
    let l:repo_path = substitute(l:file_path, l:repo_top, l:github_sub_url, "") . "#L" . l:line
    " We need to quote the file repo_path to avoid issues with spaces in the path.
    let l:hub_command = g:hub_executable . ' browse -- ' . "'" . l:repo_path . "'"
    echo l:hub_command
    let l:browse = system(l:hub_command)
  endif
endfunction
