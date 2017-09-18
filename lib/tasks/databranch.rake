namespace :databranch do
  desc 'Creates git hooks to change database based on branch'
  task :install do
    app_name = Rails.application.class.parent_name.underscore

    # a .git repo in another location can be used with the $GIT_DIR or $GIT_OBJECT_DIRECTORY env vars, so check for this (https://git-scm.com/docs/git-init)
    if !File.exists?('.git')
      print "No Git repo exists, would you like to initiate one? (Y/n): "
      git_confirmation = STDIN.gets.chomp.downcase
      if git_confirmation.match(/y(?:es)?/)
        puts "Initiating Git repo now"
        `git init`
        `git add .; git commit -m 'Initiate git repo'`
      else
        fail "A Git repo is required for Databranch to work.  Please initiate one and then install Databranch."
      end
    end

    `createdb #{app_name}_development_master` unless db_exists?("#{app_name}_development_master")
    `createdb #{app_name}_test_master` unless db_exists?("#{app_name}_test_master")

    if db_exists? "#{app_name}_development"
       puts "Cloning the existing development database for master"
      `pg_dump #{app_name}_development | psql #{app_name}_development_master`
    end

    if db_exists? "#{app_name}_test"
       puts "Cloning the existing test database for master"
      `pg_dump -s #{app_name}_test | psql #{app_name}_test_master`
    end

    File.open('./config/initializers/databranch.rb', 'w') do |file|
      branch = '#{`git rev-parse --abbrev-ref HEAD`.chomp.underscore}'
      file << %Q{ENV["DATABRANCH_DEVELOPMENT"] = "#{app_name}_development_#{branch}"\n}
      file << %Q{ENV["DATABRANCH_TEST"] = "#{app_name}_test_#{branch}"}
    end

    current_file_path = File.expand_path(File.dirname(__FILE__))
    post_checkout_code = File.read("#{current_file_path}/../hooks/post_checkout/post-checkout")
    post_checkout_path = "./.git/hooks/post-checkout"

    if File.exists? post_checkout_path
      puts "A post-checkout hook already exists.  Please add a line to your post-checkout hook file that executes the file 'databranch-post-checkout'"
    else
      File.open post_checkout_path, "w" do |file| 
        file << "#!/bin/bash\n\n"
        file << post_checkout_code
      end
    end 
    FileUtils.copy("#{current_file_path}/../hooks/post_checkout/databranch-post-checkout", "./.git/hooks/databranch-post-checkout")
    `chmod +x ./.git/hooks/post-checkout`
    `chmod +x ./.git/hooks/databranch-post-checkout`


    post_commit_code = File.read("#{current_file_path}/../hooks/post_commit/post-commit")
    post_commit_path = "./.git/hooks/post-commit"

    if File.exists? post_commit_path
      puts "A post-commit hook already exists.  Please add a line to your post-commit hook file that executes the file 'databranch-post-commit'"
    else
      File.open post_commit_path, "w" do |file| 
        file << "#!/bin/bash\n\n"
        file << post_commit_code
      end
    end 
    FileUtils.copy("#{current_file_path}/../hooks/post_commit/databranch-post-commit", "./.git/hooks/databranch-post-commit")
    `chmod +x ./.git/hooks/post-commit`
    `chmod +x ./.git/hooks/databranch-post-commit`
  end

  def db_exists?(name)
    true if PG.connect dbname: name
  rescue PG::ConnectionBad => e
    false
  end
end
