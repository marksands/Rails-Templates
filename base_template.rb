run "echo '&copy;2009 mark sands' > README.md"

generate :nifty_layout

gem 'authlogic', :lib => 'authlogic'
gem 'declarative_authorization', :source => 'http://gemcutter.org'
rake "gems:install"

if yes?("Do you want to use cucumber?")  
  plugin 'rspec', :git => "git://github.com/dchelimsky/rspec.git"
  plugin 'rspec-rails', :git => "git://github.com/dchelimsky/rspec-rails.git"
  plugin 'webrat', :git => "git://github.com/brynary/webrat.git" 
  plugin 'cucumber', :git => "git://github.com/aslakhellesoy/cucumber.git" 
  
  gem "rspec", :lib => false, :version => ">=1.2.2"
  gem "rspec-rails", :lib => false, :version => ">=1.2.2"
  gem "webrat", :lib => false, :version => ">=0.4.3"
  gem "cucumber", :lib => false, :version => ">=0.3.0"
  
  generate :cucumber
elsif yes?("Would you rather just use RSpec?")
  plugin 'rspec', :git => "git://github.com/dchelimsky/rspec.git"
  plugin 'rspec-rails', :git => "git://github.com/dchelimsky/rspec-rails.git"
  
  gem "rspec", :lib => false, :version => ">=1.2.2"
  gem "rspec-rails", :lib => false, :version => ">=1.2.2"
  
  generate :rspec
end
 
git :init

file ".gitignore", <<-END
  .DS_Store
  log/*.log
  tmp/**/*
  config/database.yml
  db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore config/authorization_rules.rb"
run "cp config/database.yml config/example_database.yml"

git :add => ".", :commit => "-m 'initial commit'" 

generate :controller, "home index"
route "map.root :controller => 'home'"
git :rm => "public/index.html"
git :rm => "README"

git :add => ".", :commit => "-m 'adding home controller'"

if yes?("Do you want user integration?")  
  generate :nifty_scaffold, 'user username:string email:string password:string new edit'
  generate :session, 'user_session'
  generate :nifty_scaffold, 'user_session --skip-model username:string password:string new destroy'
  route "map.login 'login', :controller => 'user_sessions', :action => 'new'"
  route "map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'"
  route "map.signup 'signup', :controller => 'users', :action => 'new'"
  git :add => ".", :commit => "-m 'adding authlogic'"
end