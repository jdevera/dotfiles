# Copyright (c) 2009 Ryan Bates
# Copyright (c) 2010 Jacobo de Vera

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# N.B.: This license notice applies only to the current file.

require 'rake'
require 'erb'

desc "Install all configuration files"
task :install => [ :install_home, :install_config ] do
end

desc "Install the dot files into user's home directory"
task :install_home do
    dest_dir = ENV['HOME']
    replace_all = false
    Dir['*'].each do |file|
        next if %w[Rakefile README.mkd LICENSE TODO.mkd config].include? file
        dest_file_path = File.join(dest_dir, ".#{file.sub('.erb', '')}") 
        replace_all = install_file(file, dest_file_path, replace_all)
    end
    
end

# Don't link the config directory, process all contents individually
desc "Install configuration files in the config directory"
task :install_config do
    if File.exist? "config"
        Dir.chdir "config"
        dest_dir = File.join(ENV['HOME'], '.config')
        if not File.exist? dest_dir
        puts "Creating .config directory at #{dest_dir}"
            system %Q{mkdir -p "#{dest_dir}"}
        end
        replace_all = false
        Dir['*'].each do |file|
            dest_file_path = File.join(dest_dir, file.sub('.erb', ''))
            replace_all = install_file(file, dest_file_path, replace_all)
        end
    end
end

def install_file(file, dest_file_path, replace_all)
    if File.exist? dest_file_path
        if File.identical? file, dest_file_path
            puts "identical #{dest_file_path}"
        elsif replace_all
            replace_file(file, dest_file_path)
        else
            print "overwrite #{dest_file_path}? [ynaq] "
            case $stdin.gets.chomp
            when 'a'
                replace_all = true
                replace_file(file, dest_file_path)
            when 'y'
                replace_file(file, dest_file_path)
            when 'q'
                exit
            else
                puts "skipping #{dest_file_path}"
            end
        end
    else
        link_file(file, dest_file_path)
    end
    return replace_all
end

def replace_file(file, dest_file_path)
    system %Q{rm -rf "#{dest_file_path}"}
    link_file(file, dest_file_path)
end

def link_file(file, dest_file_path)
    if file =~ /.erb$/
        puts "generating #{dest_file_path}"
        File.open(dest_file_path, 'w') do |new_file|
            new_file.write ERB.new(File.read(file)).result(binding)
        end
    else
        puts "linking #{dest_file_path}"
        system %Q{ln -s "$PWD/#{file}" "#{dest_file_path}"}
    end
end
