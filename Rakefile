require 'rake/clean'
require 'rspec/core/rake_task'
require 'zippy'
require 'rexml/document'

$:.push File.expand_path("../src", __FILE__)

pom_file = File.new( "pom.xml" )
doc = REXML::Document.new pom_file
root = doc.root
artifactId = root.elements["artifactId"].text
version = root.elements["version"].text

zip_file = "#{artifactId}-#{version}.zip"
puts "ZIP file: #{zip_file}"

CLEAN.include(zip_file,"vendor","package")

task :default => [:bundle, :spec, :package]

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  t.rspec_opts = "--fail-fast --format p --color"
  # Put spec opts in a file named .rspec in root
end

desc "Get dependencies with Bundler"
task :bundle do
  system "bundle package"
end

def add_file( zippyfile, dst_dir, f )
  puts "Writing #{f} at #{dst_dir}"
  zippyfile["#{dst_dir}/#{f}"] = File.open(f)
end

def add_dir( zippyfile, dst_dir, d )
  glob = "#{d}/**/*"
  FileList.new( glob ).each { |f|
    if (File.file?(f))
      add_file zippyfile, dst_dir, f
    end
  }
end

desc "Package plugin zip"
task :package do
  Zippy.create zip_file do |z|
    add_dir z, '.', 'vendor'
    add_file z, '.', 'manifest.json'
    add_file z, '.', 'README.md'
    add_file z, '.', 'src/puppet_worker.rb'
    add_file z, '.', 'src/puppet_forge_worker.rb'
  end
end
