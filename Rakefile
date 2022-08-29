desc "Preview _site/"
task :preview do
  puts "\n## Opening _site/ in browser"
  status = system("open http://0.0.0.0:4000/")
  puts status ? "Success" : "Failed"
end

desc "Commit _site/"
task :commit do
  puts "\n## Staging modified files"
  status = system("git add -A")
  puts status ? "Success" : "Failed"
  puts "\n## Committing a site build at #{Time.now.utc}"
  message = "Build site at #{Time.now.utc}"
  status = system("git commit -m \"#{message}\"")
  puts status ? "Success" : "Failed"
  puts "\n## Pushing commits to remote"
  status = system("git push -f origin source")
  puts status ? "Success" : "Failed"
end

desc "Deploy _site/ to main branch"
task :deploy do
  puts "\n## Deleting main branch"
  status = system("git branch -D main")
  puts status ? "Success" : "Failed"
  puts "\n## Creating new main branch and switching to it"
  status = system("git checkout -b main")
  puts status ? "Success" : "Failed"
  puts "\n## Forcing the _site subdirectory to be project root"
  status = system("git filter-branch --subdirectory-filter _site/ -f")
  puts status ? "Success" : "Failed"
  puts "\n## Switching back to source branch"
  status = system("git checkout source")
  puts status ? "Success" : "Failed"
  puts "\n## Pushing all branches to origin"
  status = system("git push -f --all origin")
  puts status ? "Success" : "Failed"
end

desc "Commit and deploy _site/"
task :commit_deploy => [:commit, :deploy] do
end
