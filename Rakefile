task :default do
  ENV['DB']='test'
  Rake::Task['db:schema:load'].invoke
  Rake::Task['spec'].invoke
end

task :spec do
  sh "bundle exec rspec spec"
end

begin
  require 'tasks/standalone_migrations'
rescue LoadError
  puts "gem install standalone_migrations to get db:migrate:* tasks! (#{$!})"
end
