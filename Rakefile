require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'rake/testtask'

RDoc::Task.new do |rdoc|
   files =['README.md', 'app/**/*.rb', 'app/**/*.rbw', 'app/*.rb', 'app/*.rbw']
   rdoc.rdoc_files.add(files)
   rdoc.main = 'README.md'
   rdoc.title = "Twitter Clone Source Documentation"
   rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
   rdoc.options << '--line-numbers'
   rdoc.options << '--all'
   rdoc.options << '--promiscuous'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end
